# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application

TARGET = AppGridNgMockup

TEMPLATE     = app

CONFIG      += c++11

QT          += core network gui qml quick

MOC_DIR      = _moc
OBJECTS_DIR  = _obj
RCC_DIR      = _rcc

INCLUDEPATH += /usr/include/sailfishapp

SOURCES += src/main_sfos.cpp

RESOURCES += data.qrc

DISTFILES += \
    rpm/AppGridNgMockup.changes.in \
    rpm/AppGridNgMockup.changes.run.in \
    rpm/AppGridNgMockup.spec \
    rpm/AppGridNgMockup.yaml \
    translations/*.ts \
    AppGridNgMockup.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n

TRANSLATIONS +=

################## PACKAGING ########################

CONFIG       += link_pkgconfig
PKGCONFIG    += sailfishapp

target.files  = $${TARGET}
target.path   = /usr/bin
desktop.files = $$PWD/$${TARGET}.desktop
desktop.path  = /usr/share/applications
icon86.files  = $$PWD/icons/86x86/$${TARGET}.png
icon86.path   = /usr/share/icons/hicolor/86x86/apps
icon108.files = $$PWD/icons/108x108/$${TARGET}.png
icon108.path  = /usr/share/icons/hicolor/108x108/apps
icon128.files = $$PWD/icons/128x128/$${TARGET}.png
icon128.path  = /usr/share/icons/hicolor/128x128/apps
icon172.files = $$PWD/icons/172x172/$${TARGET}.png
icon172.path  = /usr/share/icons/hicolor/172x172/apps
INSTALLS     += target desktop icon86 icon108 icon128 icon172
