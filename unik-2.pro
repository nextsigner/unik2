# It is a QtQuick Project created by @nextsigner
# More info
# E-mail: nextsigner@gmail.com
# Whatsapps: +54 11 3802 4370
# GitHub: https://github.com/nextsigner/unik

QT += qml quick sql websockets svg serialport

QT += texttospeech
requires(qtHaveModule(gui))
#qtHaveModule(gui): requires(qtConfig(combobox))


#Widget for Qt.labs.platform 1.0
QT += widgets

!contains(QMAKE_HOST.arch, arm.*):{
    message(NO Desarrollando para RPI)
    QT += multimedia
}else{
    message(Desarrollando para RPI)
}
QT +=  websockets webchannel
CONFIG += c++11
CONFIG -= qmlcache

LOCATION = $$PWD
DEFINES += UNIK_PROJECT_LOCATION=\\\"$$LOCATION\\\"

include(version.pri)
linux:!android{
    include(linux.pri)
}
windows{
    include(windows.pri)
}

mac{
    include(macos.pri)
}
message(DestDir: $$DESTDIR)
android{
    include(android.pri)
}

!android{
    message(DestDir: $$DESTDIR)
}


# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    audiorecorder.cpp \
    uk.cpp \
    row.cpp \
    unikargsproc.cpp \
    chatserver.cpp \
    unikimageprovider.cpp \
    unikqprocess.cpp \
    websocketclientwrapper.cpp \
    websockettransport.cpp \
    uniklogobject.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    audiorecorder.h \
    uk.h \
    qmlclipboardadapter.h \
    row.h \
    unikargsproc.h \
    chatserver.h \
    unikimageprovider.h \
    unikqprocess.h \
    websocketclientwrapper.h \
    websockettransport.h \
    uniklogobject.h


DISTFILES += \
    android.pri \
    android/AndroidManifest.xml \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    #linux.pri \
    version.pri \
    #windows.pri \
    #macos.pri \
    #android/res/xml/network_security_config.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android


android: include(/home/ns/Android/Sdk/android_openssl/openssl.pri)


TRANSLATIONS += \
    unik-2_es_AR.ts


