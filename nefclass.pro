include(nefclass.pri)

!minQtVersion(4, 8, 0) {
    message("Cannot build NefClass-Q with Qt version $${QT_VERSION}.")
    error("Use at least Qt 4.8.0.")
}

TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += \
    src \

OTHER_FILES += \
    README.md \
    dist/copyright_template.txt
