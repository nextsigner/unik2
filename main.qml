import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import QtQuick.LocalStorage 2.12
import QtQuick.Particles 2.12

import QtQuick.XmlListModel 2.12
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.15
import QtQuick.Templates 2.12
import QtWebView 1.1
import Qt.labs.calendar 1.0
import Qt.labs.folderlistmodel 2.12
import QtGraphicalEffects 1.0
import QtPositioning 5.12
import QtLocation 5.12
import QtWebSockets 1.1

ApplicationWindow {
    id: app
    objectName: 'unik-main-errors'
    visible: true
    visibility: Qt.platform.os==='android'?"FullScreen":"Maximized"
    //flags: Qt.FramelessWindowHint//Qt.Window | Qt.FramelessWindowHint
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("uniK-status")
    color: app.c2
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.05
    property color c1: "#1fbc05"
    property color c2: "#222222"
    property color c3: "black"
    property color c4: "white"
    property int area: 0
    property string pws: pws
    property var objFocus
    USettings{
        id: unikSettings
        //url: unik.getPath(3)+'/unik/unik.json'
        function refresh(){
            var nc=unikSettings.currentNumColor
            if(unikSettings.defaultColors){
                var cc1=unikSettings.defaultColors.split('|')
                var cc2=cc1[nc].split('-')
                app.c1=cc2[0]
                app.c2=cc2[1]
                app.c3=cc2[2]
                app.c4=cc2[3]
            }
        }
        Component.onCompleted: refresh()
        onDataChanged:  refresh()
    }
    Item{
        id:xApp
        width: parent.width
        height: parent.height
        Timer{
            running: Qt.platform.os!=='android'
            repeat: true
            interval: 500
            onTriggered: {
                xApp.height=xApp.parent.height-Qt.inputMethod.height
            }
        }
        Item{
            id: xTools
            width: app.fs*3
            height: parent.height
            z:99999
            Column{
                id: colTools
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:  Qt.platform.os !=='android'?width*0.5:width*0.25
                anchors.verticalCenter: parent.verticalCenter

                Boton{//Show Debug Panel
                    id:btnShowDP
                    w:parent.width
                    h: w
                    t: '\uf188'
                    d:'Ver panel de la salida estandar de esta y otras instancias de unik para depurar errores y conocer eventos'
                    b:app.c1
                    c: app.c2
                    opacity: app.area===0?1.0:0.75
                    onClicking: {
                        app.area=0
                    }
                }
                Boton{//Config
                    w:parent.width
                    h: w
                    t: '\uf013'
                    d:'Editar cfg.json de unik y unik-tools'
                    b:app.c1
                    c: app.c2
                    opacity: app.area===1?1.0:0.75
                    onClicking: {
                        app.area = 1
                    }
                }
                Boton{//Actualizar Unik-Tools
                    id:btnUpdate
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Actualizar el còdigo fuente de unik-tools desde GitHub.com'
                    b: up ? 'red':app.c2
                    c: up ? app.c2:app.c1
                    property bool up: false
                    onClicking: {
                        if(Qt.platform.os!=='android'){
                            unik.restartApp("-git=https://github.com/nextsigner/unik-tools.git")
                        }else{
                            var gitDownloaded=unik.downloadGit('https://github.com/nextsigner/unik-tools', appsDir+'/unik-tools')
                            if(gitDownloaded){
                                var j=appsDir+'/temp_cfg.json'
                                var c='{"arg0":"-folder='+appsDir+'/unik-tools'+'"}'
                                unik.setFile(j, c)
                                unik.restartApp()
                            }
                        }
                    }
                }
                Boton{//Restart
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Reiniciar unik'
                    b:app.c1
                    c: app.c2
                    onClicking: {
                        if(Qt.platform.os==='android')unik.restartApp()
                        if(Qt.platform.os!=='android')unik.restartApp("")
                    }
                    Text {
                        text: "\uf011"
                        font.family: "FontAwesome"
                        font.pixelSize: parent.height*0.3
                        anchors.centerIn: parent
                        color: app.c2
                    }
                }
                Boton{//Set Colors
                    w:parent.width
                    h: w
                    t: "\uf1fc"
                    d:'Color'
                    b:app.c1
                    c: app.c2
                    opacity: appColorsThemes.visible?1.0:0.65
                    onClicking: {
                        appColorsThemes.visible=!appColorsThemes.visible
                    }
                    AppColorsThemes{
                        id:appColorsThemes;
                        z:parent.z-1;
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: app.fs
                        visible: false
                    }
                }

                Boton{//Quit
                    w:parent.width
                    h: w
                    t: "\uf011"
                    d:'Apagar unik'
                    b:app.c1
                    c: app.c2
                    onClicking: {
                        Qt.quit()
                    }
                }
            }
        }
        Column{
            width: parent.width-xTools.width-app.fs*2
            height: parent.height
            anchors.left: xTools.right
            anchors.leftMargin: app.fs
            Row{
                id: row1
                height: app.fs*4
                spacing: app.fs
                Image {
                    source: "qrc:/resources/logo_unik_500x500.png"
                    width: app.fs*3
                    height: app.fs*3
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: tit
                    text: '<b>Unik Qml Engine</b>'
                    font.pixelSize: app.fs
                    color: app.c1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                id: xTaLog
                width: parent.width
                height: parent.height-app.fs*4
                color: 'transparent'
                visible: app.area===0
                clip: true
                Flickable {
                    id: view
                    width: parent.width
                    height: taLog.focus&&Qt.platform.os==='android'?parent.height*0.5:parent.height
                    contentWidth: xTaLog.width
                    contentHeight: taLog.contentHeight+app.fs*4
                    //visible: Qt.platform.os!=='android'
                    TextArea {
                        id: taLog
                        text: qsTr("Unik Main Qml")
                        width: xTaLog.width
                        height: contentHeight
                        onTextChanged: {
                            //taLog.flickableItem.contentY=taLog.flickableItem.contentHeight
                        }
                        color: app.c1
                        //textFormat: Text.RichText
                        /*backgroundVisible: false
                        textColor: app.c1
                        style: TextAreaStyle{
                            selectedTextColor: app.c2
                            selectionColor: app.c1
                        }*/
                        font.pixelSize: app.fs
                        wrapMode: Text.WordWrap
                    }
                }
                /*Connections{
                    target: unik;
                    onUkStdChanged:{
                        taLog.text+=unik.ukStd.replace(/<br \/>/g, '\n').replace(/\n/g, '\n\n')
                    }
                }*/
            }
            Rectangle{
                id: xEditor
                width: parent.width
                height: parent.height-app.fs*4
                border.width: unikSettings.borderWidth
                border.color: app.c1
                visible: app.area===1
                color: app.c2
                onVisibleChanged: {
                    if(visible){
                        if(unik.fileExist(appsDir+'/cfg.json')){
                            txtEdit.text = unik.getFile(appsDir+'/cfg.json')
                        }
                    }else{
                        txtEdit.focus=false
                    }
                }
                TextEdit {
                    id: txtEdit
                    width: parent.width*0.98
                    height: parent.height/3
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: app.fs*1.5
                    color: app.c1
                    wrapMode: Text.WrapAnywhere
                    Keys.onReturnPressed: {
                        if(!isValidJson())return
                        var p = appsDir+'/cfg.json'
                        console.log("Config Path: "+p)
                        console.log("New Config Data: "+txtEdit.text)
                        unik.setFile(p, txtEdit.text)
                        app.area=0
                    }
                }

                Rectangle{
                    width: labelbtn2.contentWidth*1.2
                    height: app.fs*2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.left: parent.left
                    anchors.leftMargin: app.width*0.005
                    Text {
                        id:labelbtn2
                        text: "Cancel"
                        font.pixelSize: app.fs*0.8
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            app.area=0
                        }
                    }
                }
                Rectangle{
                    width: labelbtnDelete.contentWidth*1.2
                    height: app.fs*2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id:labelbtnDelete
                        text: "Delete Config File"
                        font.pixelSize: app.fs*0.8
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var p = appsDir+'/cfg.json'
                            console.log("Config File Deleted: "+p)
                            console.log("Unik have unik-tools a default app.")
                            unik.deleteFile(p)
                            app.area=0
                        }
                    }
                }
                Rectangle{
                    width: labelbtn3.contentWidth*1.2
                    height: app.fs*2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.right: parent.right
                    anchors.rightMargin: app.width*0.005
                    Text {
                        id:labelbtn3
                        text: "Set Config"
                        font.pixelSize: app.fs*0.8
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(!isValidJson())return
                            var p = appsDir+'/cfg.json'
                            console.log("Config Path: "+p)
                            console.log("New Config Data: "+txtEdit.text)
                            unik.setFile(p, txtEdit.text)
                            app.area=0
                        }
                    }
                }
            }
        }
        /*ULogView{
            id: logView
            width: parent.width-app.fs*3
            anchors.right: parent.right
        }*/
        UWarnings{
            id: uWarnings
            width: parent.width-app.fs*3
            anchors.right: parent.right
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted: {
        /*setColors()
        if(Qt.platform.os==='windows'){
            var a1 = Screen.desktopAvailableHeight
            var altoBarra = a1-unik.frameHeight(app)
            app.height = a1-altoBarra
        }
        var stdinit='Start Unik Init Message:\n'+unik.initStdString+'\nEnd Unik Init Message.'
        var txt =''
        txt += "OS: "+Qt.platform.os+'\n\n'
        txt += 'Doc location: '+appsDir+'\n\n'
        txt += 'WorkSpace location: '+pws+'\n\n'
        txt += 'UAP Arguments:'+uap+'\n\n'
        txt+=""+appStatus+'\n\n'

        txt += "Unik Init Errors:\n\n"
        txt += 'sourcePath: '+sourcePath+'\n\n'
        if(unik.fileExist(appsDir+'/cfg.json')){
            txt += 'cfg.json:\n'+unik.getFile(appsDir+'/cfg.json')+'\n\n'
        }else{
            txt += 'cfg.json:\nNo cfg.json file seted.\n\n'
        }
        txt+="\n\n\n"
        //txt+="!!!!!!"+unik.initStdString
        taLog.text+=stdinit//.replace(/\n/g, '<br />')
        taLog.text+=txt//.replace(/\n/g, '<br />')
        */
    }
    function setColors(){
        var nc=unikSettings.currentNumColor
        if(unikSettings.defaultColors){
            var cc1=unikSettings.defaultColors.split('|')
            var cc2=cc1[nc].split('-')
            app.c1=cc2[0]
            app.c2=cc2[1]
            app.c3=cc2[2]
            app.c4=cc2[3]
        }
    }
    function isValidJson(){
        let msg0=unikSettings.lang==='es'?'Error al crear el archivo JSON de configuración de Unik. Para poder utilizar este archivo debe corregir los error.':'Error when making the JSON setup file for Unik. For use this file you should repair all error.'
        let pfr=unikSettings.lang==='es'?'Formato o sintáxis requerida: ':'Format or syntax required: '
        let fr=pfr+' {"arg0":"-folder=...", "arg1": "-git=..."}'
        var json
        var fc=false
        try {
            json = JSON.parse(txtEdit.text);
            fc=true
        } catch(e) {
            logView.showLog(e)
            logView.showLog('\n\n')
            logView.showLog(msg0+'\n\n')
            logView.showLog(fr+'\n\n')
        }
        return fc;
    }
}
