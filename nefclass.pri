
!isEmpty(INCLUDE_NFC_PRI):error("Nefclass pri file already included")
INCLUDE_NFC_PRI = 1


# Compare Qt5 version

isEqual(QT_MAJOR_VERSION, 5) {

    defineReplace(cleanPath) {
        return($$clean_path($$1))
    }

    defineReplace(targetPath) {
        return($$shell_path($$1))
    }

} else { # Qt5

    defineReplace(cleanPath) {
        win32:1 ~= s|\\\\|/|g
        contains(1, ^/.*):pfx = /
        else:pfx =
        segs = $$split(1, /)
        out =
        for(seg, segs) {
            equals(seg, ..):out = $$member(out, 0, -2)
            else:!equals(seg, .):out += $$seg
        }
        return($$join(out, /, $$pfx))
    }

    defineReplace(targetPath) {
        return($$replace(1, /, $$QMAKE_DIR_SEP))
    }

} # Qt5

# The function minQtVersion() verify the actual Qt version

defineTest(minQtVersion) {
    maj = $$1
    min = $$2
    patch = $$3

    isEqual(QT_MAJOR_VERSION, $$maj) {
        isEqual(QT_MINOR_VERSION, $$min) {
            isEqual(QT_PATCH_VERSION, $$patch) {
                return(true)
            }

            greaterThan(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
        }

        greaterThan(QT_MINOR_VERSION, $$min) {
            return(true)
        }
    }

    greaterThan(QT_MAJOR_VERSION, $$maj) {
        return(true)
    }

    return(false)
}


# Define Library base name

isEmpty(NFC_LIBRARY_BASENAME) {
    NFC_LIBRARY_BASENAME = lib
}


# Define build directory

isEmpty(NFC_BUILD_TREE) {
    sub_dir         = $$_PRO_FILE_PWD_
    sub_dir        ~= s,^$$re_escape($$PWD),,
    NFC_BUILD_TREE  = $$cleanPath($$OUT_PWD)
    NFC_BUILD_TREE ~= s,$$re_escape($$sub_dir)$,,
}

NFC_VERSION     = 2.0.0
NFC_SOURCE_TREE = $$PWD
NFC_APP_PATH    = $$NFC_BUILD_TREE/bin

macx {
    # TODO:
} else {
    NFC_APP_TARGET   = NefClass-Q
    NFC_LIBRARY_PATH = $$NFC_BUILD_TREE/$$NFC_LIBRARY_BASENAME
    NFC_PLUGIN_PATH  = $$IDE_LIBRARY_PATH/plugins
    NFC_DATA_PATH    = $$IDE_BUILD_TREE/share/nefclass-q
    NFC_DOC_PATH     = $$IDE_BUILD_TREE/share/doc/nefclass-q
    NFC_BIN_PATH     = $$IDE_APP_PATH
    !isEqual(NFC_SOURCE_TREE, $$NFC_BUILD_TREE):copydata = 1
}

INCLUDEPATH += \
    $$NFC_BUILD_TREE/src \ # for <app/app_version.h>
    $$NFC_SOURCE_TREE/src/libs \
    $$NFC_SOURCE_TREE/tools \
    $$NFC_SOURCE_TREE/src/plugins

CONFIG += depend_includepath

LIBS += -L$$IDE_LIBRARY_PATH


# Use fast concatenation
# If you need more information please see:
# http://qt-project.org/doc/qt-4.8/qstring.html#more-efficient-string-construction
# http://blog.qt.digia.com/2011/06/13/string-concatenation-with-qstringbuilder/

#DEFINES += QT_NO_CAST_FROM_ASCII
#DEFINES += QT_NO_CAST_TO_ASCII
!macx:DEFINES *= QT_USE_QSTRINGBUILDER


unix {
    CONFIG(debug, debug|release):OBJECTS_DIR = $${OUT_PWD}/.obj/debug
    CONFIG(release, debug|release):OBJECTS_DIR = $${OUT_PWD}/.obj/release

    CONFIG(debug, debug|release):MOC_DIR = $${OUT_PWD}/.moc/debug
    CONFIG(release, debug|release):MOC_DIR = $${OUT_PWD}/.moc/release

    RCC_DIR = $${OUT_PWD}/.rcc
    UI_DIR = $${OUT_PWD}/.uic
}


qt:greaterThan(QT_MAJOR_VERSION, 4) {
    contains(QT, core): QT += concurrent
    contains(QT, gui): QT  += widgets
#    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x040900
}
