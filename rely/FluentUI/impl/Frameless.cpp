#include "Frameless.h"

#include <QQuickWindow>
#include <QGuiApplication>
#include <QScreen>
#include <QDateTime>
#include <QOperatingSystemVersion>
#include <QTimer>
#include <optional>

#include "Tools.h"
#ifdef Q_OS_MACOS
#  include "OSXHideTitleBar.h"
#endif
#ifdef Q_OS_WIN

#  pragma comment(lib, "user32.lib")
#  pragma comment(lib, "dwmapi.lib")

#  include <windows.h>
#  include <windowsx.h>
#  include <winuser.h>
#  include <dwmapi.h>

static inline QByteArray qtNativeEventType() {
    static const auto result = "windows_generic_MSG";
    return result;
}

template <typename FuncPtrType>
static inline FuncPtrType loadUserFunction(const char *functionName) {
    HMODULE module = LoadLibraryW(L"user32.dll");
    if (module) {
        return reinterpret_cast<FuncPtrType>(GetProcAddress(module, functionName));
    }
    return nullptr;
}

template <typename FuncPtrType>
static inline FuncPtrType loadDwmFunction(const char *functionName) {
    HMODULE module = LoadLibraryW(L"dwmapi.dll");
    if (module) {
        return reinterpret_cast<FuncPtrType>(GetProcAddress(module, functionName));
    }
    return nullptr;
}

static inline UINT getDpiForWindow(HWND hwnd) {
    typedef UINT(WINAPI * GetDpiForWindowPtr)(HWND hWnd);
    GetDpiForWindowPtr get_dpi_for_window = loadUserFunction<GetDpiForWindowPtr>("GetDpiForWindow");
    if (get_dpi_for_window) {
        return get_dpi_for_window(hwnd);
    }
    return 96;
}

static inline int getSystemMetricsForDpi(int nIndex, UINT dpi) {
    typedef int(WINAPI * GetSystemMetricsForDpiPtr)(int nIndex, UINT dpi);
    GetSystemMetricsForDpiPtr get_system_metrics_for_dpi =
        loadUserFunction<GetSystemMetricsForDpiPtr>("GetSystemMetricsForDpi");
    if (get_system_metrics_for_dpi) {
        return get_system_metrics_for_dpi(nIndex, dpi);
    }
    return GetSystemMetrics(nIndex);
}

static inline bool isCompositionEnabled() {
    typedef HRESULT(WINAPI * DwmIsCompositionEnabledPtr)(BOOL * pfEnabled);
    DwmIsCompositionEnabledPtr dwm_is_composition_enabled =
        loadDwmFunction<DwmIsCompositionEnabledPtr>("DwmIsCompositionEnabled");
    if (dwm_is_composition_enabled) {
        BOOL composition_enabled = FALSE;
        dwm_is_composition_enabled(&composition_enabled);
        return composition_enabled;
    }
    return false;
}

static inline bool dwmExtendFrameIntoClientArea(HWND hwnd, MARGINS mragins) {
    typedef HRESULT(WINAPI * DwmExtendFrameIntoClientAreaPtr)(HWND hWnd, const MARGINS *pMarInset);
    DwmExtendFrameIntoClientAreaPtr dwm_extendframe_into_client_area_ =
        loadDwmFunction<DwmExtendFrameIntoClientAreaPtr>("DwmExtendFrameIntoClientArea");
    if (dwm_extendframe_into_client_area_) {
        dwm_extendframe_into_client_area_(hwnd, &mragins);
        return true;
    }
    return false;
}

static inline bool dwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute,
                                         _In_reads_bytes_(cbAttribute) LPCVOID pvAttribute,
                                         DWORD cbAttribute) {
    typedef HRESULT(WINAPI * DwmSetWindowAttributePtr)(
        HWND hwnd, DWORD dwAttribute, _In_reads_bytes_(cbAttribute) LPCVOID pvAttribute,
        DWORD cbAttribute);
    DwmSetWindowAttributePtr dwm_set_window_attribute_ =
        loadDwmFunction<DwmSetWindowAttributePtr>("DwmSetWindowAttribute");
    if (dwm_set_window_attribute_) {
        dwm_set_window_attribute_(hwnd, dwAttribute, pvAttribute, cbAttribute);
        return true;
    }
    return false;
}

static inline std::optional<MONITORINFOEXW> getMonitorForWindow(const HWND hwnd) {
    Q_ASSERT(hwnd);
    if (!hwnd) {
        return std::nullopt;
    }
    const HMONITOR monitor = ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
    if (!monitor) {
        return std::nullopt;
    }
    MONITORINFOEXW monitorInfo;
    ::SecureZeroMemory(&monitorInfo, sizeof(monitorInfo));
    monitorInfo.cbSize = sizeof(monitorInfo);
    if (::GetMonitorInfoW(monitor, &monitorInfo) == FALSE) {
        return std::nullopt;
    }
    return monitorInfo;
};

static inline bool isFullScreen(const HWND hwnd) {
    RECT windowRect = {};
    if (::GetWindowRect(hwnd, &windowRect) == FALSE) {
        return false;
    }
    const std::optional<MONITORINFOEXW> mi = getMonitorForWindow(hwnd);
    if (!mi.has_value()) {
        return false;
    }
    RECT rcMonitor = mi.value().rcMonitor;
    return windowRect.top == rcMonitor.top && windowRect.left == rcMonitor.left &&
           windowRect.right == rcMonitor.right && windowRect.bottom == rcMonitor.bottom;
}

static inline bool isMaximized(const HWND hwnd) {
    WINDOWPLACEMENT wp;
    ::GetWindowPlacement(hwnd, &wp);
    return wp.showCmd == SW_MAXIMIZE;
}

static inline quint32 getDpiForWindow(const HWND hwnd, const bool horizontal) {
    if (const UINT dpi = getDpiForWindow(hwnd)) {
        return dpi;
    }
    if (const HDC hdc = ::GetDC(hwnd)) {
        bool valid = false;
        const int dpiX = ::GetDeviceCaps(hdc, LOGPIXELSX);
        const int dpiY = ::GetDeviceCaps(hdc, LOGPIXELSY);
        if ((dpiX > 0) && (dpiY > 0)) {
            valid = true;
        }
        ::ReleaseDC(hwnd, hdc);
        if (valid) {
            return (horizontal ? dpiX : dpiY);
        }
    }
    return 96;
}

static inline int getSystemMetrics(const HWND hwnd, const int index, const bool horizontal) {
    const UINT dpi = getDpiForWindow(hwnd, horizontal);
    if (const int result = getSystemMetricsForDpi(index, dpi); result > 0) {
        return result;
    }
    return ::GetSystemMetrics(index);
}

static inline quint32 getResizeBorderThickness(const HWND hwnd, const bool horizontal,
                                               const qreal devicePixelRatio) {
    auto frame = horizontal ? SM_CXSIZEFRAME : SM_CYSIZEFRAME;
    auto result =
        getSystemMetrics(hwnd, frame, horizontal) + getSystemMetrics(hwnd, 92, horizontal);
    if (result > 0) {
        return result;
    }
    int thickness = isCompositionEnabled() ? 8 : 4;
    return qRound(thickness * devicePixelRatio);
}

static inline void setWindowEffect(HWND hwnd, int type) {
    MARGINS margins{1, 1, 0, 1};
    if (type == 0x0001) {
        dwmExtendFrameIntoClientArea(hwnd, margins);
        int system_backdrop_type = 2;
        dwmSetWindowAttribute(hwnd, 38, &system_backdrop_type, sizeof(int));
    } else if (type == 0x0002) {
        dwmExtendFrameIntoClientArea(hwnd, margins);
        int system_backdrop_type = 3;
        dwmSetWindowAttribute(hwnd, 38, &system_backdrop_type, sizeof(int));
    } else {
        dwmExtendFrameIntoClientArea(hwnd, margins);
    }
}

#endif

bool containsCursorToItem(QQuickItem *item) {
    if (!item || !item->isVisible()) {
        return false;
    }
    auto point = item->window()->mapFromGlobal(QCursor::pos());
    auto rect = QRectF(item->mapToItem(item->window()->contentItem(), QPointF(0, 0)), item->size());
    if (rect.contains(point)) {
        return true;
    }
    return false;
}

Frameless::Frameless(QQuickItem *parent) : QQuickItem{parent} {
    m_fixSize = false;
    m_appbar = nullptr;
    m_buttonMaximized = nullptr;
    m_topmost = false;
    m_disabled = false;
    m_windowEffect = 0;
    m_isWindows11OrGreater = Tools::getInstance()->isWindows11OrGreater();
}

void Frameless::onDestruction() {
    QGuiApplication::instance()->removeNativeEventFilter(this);
}

void Frameless::componentComplete() {
    if (m_disabled) {
        connect(this, &Frameless::topmostChanged, [this] { setWindowTopmost(topmost()); });
        setWindowTopmost(topmost());
        return;
    }
    int w = window()->width();
    int h = window()->height();
    m_current = window()->winId();
#ifdef Q_OS_MACOS
    OSXHideTitleBar::HideTitleBar(m_current);
    window()->setProperty("__borderWidth", 1);
#endif
#ifdef Q_OS_LINUX
    window()->setFlag(Qt::CustomizeWindowHint, true);
    window()->setFlag(Qt::FramelessWindowHint, true);
    window()->setProperty("__borderWidth", 1);
#endif
    window()->installEventFilter(this);
    QGuiApplication::instance()->installNativeEventFilter(this);
    if (m_buttonMaximized) {
        setHitTestVisible(m_buttonMaximized);
    }
#ifdef Q_OS_WIN
    window()->setFlag(Qt::CustomizeWindowHint, true);
#  if (QT_VERSION == QT_VERSION_CHECK(6, 5, 3))
    qWarning()
        << "Qt's own frameless bug, currently only exist in 6.5.3, please use other versions";
#  endif
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    DWORD style = ::GetWindowLongPtr(hwnd, GWL_STYLE);
    if (m_fixSize) {
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME | WS_CAPTION | WS_MINIMIZEBOX);
    } else {
        ::SetWindowLongPtr(hwnd, GWL_STYLE,
                           style | WS_MAXIMIZEBOX | WS_THICKFRAME | WS_CAPTION | WS_MINIMIZEBOX);
    }
    if (!isCompositionEnabled()) {
        DWORD dwStyle = GetClassLong(hwnd, GCL_STYLE);
        SetClassLong(hwnd, GCL_STYLE, dwStyle | CS_DROPSHADOW | WS_EX_LAYERED);
        window()->setProperty("__borderWidth", 1);
    }
    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                 SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
    connect(window(), &QQuickWindow::screenChanged, this, [hwnd] {
        ::SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                       SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED |
                           SWP_NOOWNERZORDER);
        ::RedrawWindow(hwnd, nullptr, nullptr, RDW_INVALIDATE | RDW_UPDATENOW);
    });
    if (!window()->property("__windowEffectDisabled").toBool()) {
        setWindowEffect(hwnd, this->windowEffect());
    }
    connect(this, &Frameless::darkChanged, this, [this] { setWindowDark(dark()); });
    connect(this, &Frameless::windowEffectChanged, this,
            [this, hwnd] { setWindowEffect(hwnd, this->windowEffect()); });
#endif
    int appBarHeight = 0;
    if (m_appbar) {
        appBarHeight = m_appbar->height();
    }
    h = h + appBarHeight;
    if (m_fixSize) {
        window()->setMaximumSize(QSize(w, h));
        window()->setMinimumSize(QSize(w, h));
    } else {
        window()->setMinimumHeight(window()->minimumHeight() + appBarHeight);
        window()->setMaximumHeight(window()->maximumHeight() + appBarHeight);
    }
    window()->resize(QSize(w, h));
    connect(this, &Frameless::topmostChanged, this, [this] { setWindowTopmost(topmost()); });
    setWindowTopmost(topmost());
    setWindowDark(dark());
#ifdef Q_OS_MACOS
    connect(window(), &QQuickWindow::windowStateChanged, this,
            [this] { OSXHideTitleBar::HideTitleBar(m_current); });
#endif
}

void Frameless::showSystemMenu(QPoint point) {
#ifdef Q_OS_WIN
    QScreen *screen = window()->screen();
    if (!screen) {
        screen = QGuiApplication::primaryScreen();
    }
    if (!screen) {
        return;
    }
    const QPoint origin = screen->geometry().topLeft();
    auto nativePos =
        QPointF(QPointF(point - origin) * window()->devicePixelRatio()).toPoint() + origin;
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    auto hMenu = ::GetSystemMenu(hwnd, FALSE);
    if (isMaximized() || isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_DISABLED);
    }
    if (!m_fixSize && !isMaximized() && !isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_DISABLED);
    }
    ::EnableMenuItem(hMenu, SC_CLOSE, MFS_ENABLED);
    const int result = ::TrackPopupMenu(
        hMenu,
        (TPM_RETURNCMD | (QGuiApplication::isRightToLeft() ? TPM_RIGHTALIGN : TPM_LEFTALIGN)),
        nativePos.x(), nativePos.y(), 0, hwnd, nullptr);
    if (result) {
        ::PostMessageW(hwnd, WM_SYSCOMMAND, result, 0);
    }
#endif
}

bool Frameless::nativeEventFilter(const QByteArray &eventType, void *message,
                                  QT_NATIVE_EVENT_RESULT_TYPE *result) {
#ifdef Q_OS_WIN
    if ((eventType != qtNativeEventType()) || !message) {
        return false;
    }
    const auto msg = static_cast<const MSG *>(message);
    auto hwnd = msg->hwnd;
    if (!hwnd) {
        return false;
    }
    const quint64 wid = reinterpret_cast<qint64>(hwnd);
    if (wid != m_current) {
        return false;
    }
    const auto uMsg = msg->message;
    const auto wParam = msg->wParam;
    const auto lParam = msg->lParam;
    if (uMsg == WM_WINDOWPOSCHANGING) {
        auto *wp = reinterpret_cast<WINDOWPOS *>(lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0) {
            wp->flags |= SWP_NOCOPYBITS;
            *result = static_cast<QT_NATIVE_EVENT_RESULT_TYPE>(
                ::DefWindowProcW(hwnd, uMsg, wParam, lParam));
            return true;
        }
        return false;
    } else if (uMsg == WM_NCCALCSIZE && wParam == TRUE) {
        const auto clientRect =
            ((wParam == FALSE) ? reinterpret_cast<LPRECT>(lParam)
                               : &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(lParam))->rgrc[0]);
        bool isMax = ::isMaximized(hwnd);
        bool isFull = ::isFullScreen(hwnd);
        if (isMax && !isFull) {
            auto ty = getResizeBorderThickness(hwnd, false, window()->devicePixelRatio());
            clientRect->top += ty;
            clientRect->bottom -= ty;
            auto tx = getResizeBorderThickness(hwnd, true, window()->devicePixelRatio());
            clientRect->left += tx;
            clientRect->right -= tx;
        }
        if (isMax || isFull) {
            APPBARDATA abd;
            SecureZeroMemory(&abd, sizeof(abd));
            abd.cbSize = sizeof(abd);
            const UINT taskbarState = ::SHAppBarMessage(ABM_GETSTATE, &abd);
            if (taskbarState & ABS_AUTOHIDE) {
                bool top = false, bottom = false, left = false, right = false;
                int edge = -1;
                APPBARDATA abd2;
                SecureZeroMemory(&abd2, sizeof(abd2));
                abd2.cbSize = sizeof(abd2);
                abd2.hWnd = ::FindWindowW(L"Shell_TrayWnd", nullptr);
                if (abd2.hWnd) {
                    const HMONITOR windowMonitor =
                        ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
                    if (windowMonitor) {
                        const HMONITOR taskbarMonitor =
                            ::MonitorFromWindow(abd2.hWnd, MONITOR_DEFAULTTOPRIMARY);
                        if (taskbarMonitor) {
                            if (taskbarMonitor == windowMonitor) {
                                ::SHAppBarMessage(ABM_GETTASKBARPOS, &abd2);
                                edge = abd2.uEdge;
                            }
                        }
                    }
                }
                top = (edge == ABE_TOP);
                bottom = (edge == ABE_BOTTOM);
                left = (edge == ABE_LEFT);
                right = (edge == ABE_RIGHT);
                if (top) {
                    clientRect->top += 1;
                } else if (bottom) {
                    clientRect->bottom -= 1;
                } else if (left) {
                    clientRect->left += 1;
                } else if (right) {
                    clientRect->right -= 1;
                } else {
                    clientRect->bottom -= 1;
                }
            } else {
                if (isFull && this->m_isWindows11OrGreater) {
                    clientRect->bottom += 1;
                }
            }
        }
        *result = 0;
        return true;
    } else if (uMsg == WM_NCHITTEST) {
        if (m_isWindows11OrGreater) {
            if (hitMaximizeButton()) {
                if (*result == HTNOWHERE) {
                    *result = HTZOOM;
                }
                setMaximizeHovered(true);
                return true;
            }
            setMaximizeHovered(false);
            setMaximizePressed(false);
        }
        POINT nativeGlobalPos{GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam)};
        POINT nativeLocalPos = nativeGlobalPos;
        ::ScreenToClient(hwnd, &nativeLocalPos);
        RECT clientRect{0, 0, 0, 0};
        ::GetClientRect(hwnd, &clientRect);
        auto clientWidth = clientRect.right - clientRect.left;
        auto clientHeight = clientRect.bottom - clientRect.top;
        bool left = nativeLocalPos.x < m_margins;
        bool right = nativeLocalPos.x > clientWidth - m_margins;
        bool top = nativeLocalPos.y < m_margins;
        bool bottom = nativeLocalPos.y > clientHeight - m_margins;
        *result = 0;
        if (!m_fixSize && !isFullScreen() && !isMaximized()) {
            if (left && top) {
                *result = HTTOPLEFT;
            } else if (left && bottom) {
                *result = HTBOTTOMLEFT;
            } else if (right && top) {
                *result = HTTOPRIGHT;
            } else if (right && bottom) {
                *result = HTBOTTOMRIGHT;
            } else if (left) {
                *result = HTLEFT;
            } else if (right) {
                *result = HTRIGHT;
            } else if (top) {
                *result = HTTOP;
            } else if (bottom) {
                *result = HTBOTTOM;
            }
        }
        if (0 != *result) {
            return true;
        }
        if (hitAppBar() && !this->isFullScreen()) {
            *result = HTCAPTION;
            return true;
        }
        *result = HTCLIENT;
        return true;
    } else if (uMsg == WM_NCPAINT) {
        if (isCompositionEnabled() && !this->isFullScreen()) {
            return false;
        }
        *result = FALSE;
        return true;
    } else if (uMsg == WM_NCACTIVATE) {
        if (isCompositionEnabled()) {
            return false;
        }
        *result = true;
        return true;
    } else if (m_isWindows11OrGreater && uMsg == WM_NCMOUSELEAVE) {
        setMaximizePressed(false);
        setMaximizeHovered(false);
    } else if (m_isWindows11OrGreater && (uMsg == WM_NCLBUTTONDBLCLK || uMsg == WM_NCLBUTTONDOWN)) {
        if (hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonPress, QPoint(), QPoint(),
                                            Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(m_buttonMaximized, &event);
            setMaximizePressed(true);
            return true;
        }
    } else if (m_isWindows11OrGreater && (uMsg == WM_NCLBUTTONUP || uMsg == WM_NCRBUTTONUP)) {
        if (hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonRelease, QPoint(), QPoint(),
                                            Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(m_buttonMaximized, &event);
            setMaximizePressed(false);
            return true;
        }
    } else if (uMsg == WM_NCRBUTTONDOWN) {
        if (wParam == HTCAPTION) {
            auto pos = window()->position();
            auto offset = window()->mapFromGlobal(QCursor::pos());
            showSystemMenu(QPoint(pos.x() + offset.x(), pos.y() + offset.y()));
            return true;
        }
    } else if (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN) {
        const bool altPressed = ((wParam == VK_MENU) || (::GetKeyState(VK_MENU) < 0));
        const bool spacePressed = ((wParam == VK_SPACE) || (::GetKeyState(VK_SPACE) < 0));
        if (altPressed && spacePressed) {
            auto pos = window()->position();
            showSystemMenu(QPoint(pos.x(), qRound(pos.y() + m_appbar->height())));
            return true;
        }
    }
    return false;
#else
    return false;
#endif
}
bool Frameless::isMaximized() {
    return window()->visibility() == QWindow::Maximized;
}

bool Frameless::isFullScreen() {
    return window()->visibility() == QWindow::FullScreen;
}

bool Frameless::hitAppBar() {
    for (int i = 0; i <= _hitTestList.size() - 1; ++i) {
        auto item = _hitTestList.at(i);
        if (containsCursorToItem(item)) {
            return false;
        }
    }
    if (containsCursorToItem(m_appbar)) {
        return true;
    }
    return false;
}

bool Frameless::hitMaximizeButton() {
    if (containsCursorToItem(m_buttonMaximized)) {
        return true;
    }
    return false;
}

void Frameless::setMaximizePressed(bool val) {
    if (m_buttonMaximized) {
        m_buttonMaximized->setProperty("down", val);
    }
}

void Frameless::setMaximizeHovered(bool val) {
    if (m_buttonMaximized) {
        m_buttonMaximized->setProperty("hover", val);
    }
}

void Frameless::updateCursor(int edges) {
    switch (edges) {
        case 0:
            window()->setCursor(Qt::ArrowCursor);
            break;
        case Qt::LeftEdge:
        case Qt::RightEdge:
            window()->setCursor(Qt::SizeHorCursor);
            break;
        case Qt::TopEdge:
        case Qt::BottomEdge:
            window()->setCursor(Qt::SizeVerCursor);
            break;
        case Qt::LeftEdge | Qt::TopEdge:
        case Qt::RightEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeFDiagCursor);
            break;
        case Qt::RightEdge | Qt::TopEdge:
        case Qt::LeftEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeBDiagCursor);
            break;
        default:
            break;
    }
}

void Frameless::showFullScreen() {
    if (window()->visibility() == QWindow::Maximized) {
        window()->showNormal();
        QTimer::singleShot(150, this, [this] { window()->showFullScreen(); });
    } else {
        window()->showFullScreen();
    }
}

void Frameless::showMaximized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 3);
#else
    window()->setVisibility(QQuickWindow::Maximized);
#endif
}

void Frameless::showMinimized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 2);
#else
    window()->setVisibility(QQuickWindow::Minimized);
#endif
}

void Frameless::showNormal() {
    window()->setVisibility(QQuickWindow::Windowed);
}

void Frameless::setHitTestVisible(QQuickItem *val) {
    if (!_hitTestList.contains(val)) {
        _hitTestList.append(val);
    }
}

void Frameless::setWindowTopmost(bool topmost) {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    if (topmost) {
        ::SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    } else {
        ::SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }
#else
    window()->setFlag(Qt::WindowStaysOnTopHint, topmost);
#endif
}

bool Frameless::setWindowDark(bool dark) {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    BOOL value = dark;
    return dwmSetWindowAttribute(hwnd, 20, &value, sizeof(BOOL));
#endif
    return false;
}

bool Frameless::eventFilter(QObject *obj, QEvent *ev) {
#ifdef Q_OS_OSX
    switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if (hitAppBar()) {
                qint64 clickTimer = QDateTime::currentMSecsSinceEpoch();
                qint64 offset = clickTimer - this->m_clickTimer;
                this->m_clickTimer = clickTimer;
                if (offset < 300) {
                    if (isMaximized()) {
                        showNormal();
                    } else {
                        showMaximized();
                    }
                } else {
                    window()->startSystemMove();
                }
            }
            break;
        default:
            break;
    }
#endif
#ifdef Q_OS_LINUX
    switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if (m_edges != 0) {
                QMouseEvent *event = static_cast<QMouseEvent *>(ev);
                if (event->button() == Qt::LeftButton) {
                    updateCursor(m_edges);
                    window()->startSystemResize(Qt::Edges(m_edges));
                }
            } else {
                if (hitAppBar() && !isFullScreen()) {
                    qint64 clickTimer = QDateTime::currentMSecsSinceEpoch();
                    qint64 offset = clickTimer - this->m_clickTimer;
                    this->m_clickTimer = clickTimer;
                    if (offset < 300) {
                        if (isMaximized()) {
                            showNormal();
                        } else {
                            showMaximized();
                        }
                    } else {
                        window()->startSystemMove();
                    }
                }
            }
            break;
        case QEvent::MouseButtonRelease:
            m_edges = 0;
            break;
        case QEvent::MouseMove: {
            if (isMaximized() || isFullScreen()) {
                break;
            }
            if (m_fixSize) {
                break;
            }
            QMouseEvent *event = static_cast<QMouseEvent *>(ev);
            QPoint p =
#  if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
                event->pos();
#  else
                event->position().toPoint();
#  endif
            if (p.x() >= m_margins && p.x() <= (window()->width() - m_margins) &&
                p.y() >= m_margins && p.y() <= (window()->height() - m_margins)) {
                if (m_edges != 0) {
                    m_edges = 0;
                    updateCursor(m_edges);
                }
                break;
            }
            m_edges = 0;
            if (p.x() < m_margins) {
                m_edges |= Qt::LeftEdge;
            }
            if (p.x() > (window()->width() - m_margins)) {
                m_edges |= Qt::RightEdge;
            }
            if (p.y() < m_margins) {
                m_edges |= Qt::TopEdge;
            }
            if (p.y() > (window()->height() - m_margins)) {
                m_edges |= Qt::BottomEdge;
            }
            updateCursor(m_edges);
            break;
        }
        default:
            break;
    }
#endif
    return QObject::eventFilter(obj, ev);
}
