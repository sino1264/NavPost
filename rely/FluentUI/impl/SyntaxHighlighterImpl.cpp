#include "SyntaxHighlighterImpl.h"

#include "TextCharFormat.h"

SyntaxHighlighterImpl::SyntaxHighlighterImpl(QObject *parent)
    : QSyntaxHighlighter(parent), m_textDocument(nullptr) {
}

void SyntaxHighlighterImpl::highlightBlock(const QString &text) {
    emit highlightBlockChanged(QVariant(text));
}

QQuickTextDocument *SyntaxHighlighterImpl::textDocument() const {
    return m_textDocument;
}

void SyntaxHighlighterImpl::setTextDocument(QQuickTextDocument *textDocument) {
    if (textDocument == m_textDocument) {
        return;
    }
    m_textDocument = textDocument;
    if (m_textDocument == nullptr) {
        setDocument(nullptr);
    } else {
        QTextDocument *doc = m_textDocument->textDocument();
        setDocument(doc);
    }
    emit textDocumentChanged();
}

void SyntaxHighlighterImpl::setFormat(int start, int count, const QVariant &format) {
    TextCharFormat *charFormat = qvariant_cast<TextCharFormat *>(format);
    if (charFormat) {
        QSyntaxHighlighter::setFormat(start, count, *charFormat);
        return;
    }
    if (format.canConvert(QMetaType::fromType<QColor>())) {
        QSyntaxHighlighter::setFormat(start, count, format.value<QColor>());
        return;
    }
    if (format.canConvert(QMetaType::fromType<QFont>())) {
        QSyntaxHighlighter::setFormat(start, count, format.value<QFont>());
        return;
    }
}
