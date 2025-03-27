#include "OSXHideTitleBar.h"
#include <Cocoa/Cocoa.h>

void OSXHideTitleBar::HideTitleBar(long winid)
{
    NSView *nativeView = reinterpret_cast<NSView *>(winid);
    NSWindow *nativeWindow = [nativeView window];
    [nativeWindow setStyleMask: ([nativeWindow styleMask] | NSFullSizeContentViewWindowMask)];
    [nativeWindow setTitleVisibility:NSWindowTitleHidden];
    [nativeWindow setTitlebarAppearsTransparent:YES];
}
