import QtQuick 2.6;

Item {
    id: base;
    width: 480;
    height: 800;

    property bool shown : false;

    property string currentGroup : "";

    property color accentColor    : Qt.lighter ("steelblue");
    property color primaryColor   : "white";
    property color secondaryColor : Qt.rgba(1,1,1,0.5);

    property string fontName : "Ubuntu";

    property int headerSize : 80;

    property int fontSizeBig    : 24;
    property int fontSizeNormal : 18;
    property int fontSizeSmall  : 16;

    property size iconSizeBig    : Qt.size (84, 84);
    property size iconSizeNormal : Qt.size (48, 48);
    property size iconSizeSmall  : Qt.size (20, 20);

    property real itemSize : (width / Math.floor (width / 135));

    property QtObject tmp : null;

    function launchApp (label, icon) {
        tmp = compoLaunchAnim.createObject (overlay, { "icon" : icon });
        currentGroup = "";
        shown = false;
    }

    Item {
        id: statusbar;
        z: 99999;
        implicitHeight: (row.height + row.anchors.margins * 2);
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
        }

        Row {
            id: row;
            spacing: 8;
            anchors {
                left: parent.left;
                margins: 16;
                verticalCenter: parent.verticalCenter;
            }

            Image {
                source: "qrc:///symbols/icon-system-battery.png";
                sourceSize: iconSizeSmall;
                anchors.verticalCenter: parent.verticalCenter;
            }
            Text {
                text: "42%";
                color: secondaryColor;
                font {
                    family: fontName;
                    weight: Font.Light;
                    pixelSize: fontSizeNormal;
                }
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
        Text {
            text: "13:37";
            color: primaryColor;
            font {
                family: fontName;
                pixelSize: fontSizeBig;
                weight: Font.Light;
            }
            anchors.centerIn: parent;
        }
        Row {
            spacing: 8;
            anchors {
                right: parent.right;
                margins: 16;
                verticalCenter: parent.verticalCenter;
            }

            Image {
                source: (flag ? "qrc:///symbols/icon-status-data-download.png" : "qrc:///symbols/icon-status-data-upload.png");
                sourceSize: iconSizeSmall;
                anchors.verticalCenter: parent.verticalCenter;

                property bool flag : false;

                Timer {
                    repeat: true;
                    running: true;
                    interval: 850;
                    onTriggered: { parent.flag = !parent.flag; }
                }
            }
            Text {
                text: "4G+";
                color: secondaryColor;
                font {
                    family: fontName;
                    weight: Font.Light;
                    pixelSize: fontSizeNormal;
                }
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image {
                source: "qrc:///symbols/icon-status-cellular-4.png";
                sourceSize: iconSizeSmall;
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
    }
    MouseArea {
        anchors.fill: parent;
        onPressed: { old = mouseY; }
        onPositionChanged: {
            var delta = (old - mouseY);
            if (delta > 100) {
                shown = true;
            }
        }

        property real old : 0.0;

        Item {
            height: parent.height;
            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                bottomMargin: (shown ? 0 : -height);
            }

            Behavior on anchors.bottomMargin { NumberAnimation { duration: 280; } }
            Rectangle {
                color: "black";
                opacity: 0.85;
                anchors.fill: parent;
            }
            Flickable {
                clip: true;
                contentHeight: layout.height;
                flickableDirection: Flickable.VerticalFlick;
                anchors {
                    topMargin: statusbar.height;
                    fill: parent;
                }
                onContentYChanged: {
                    if (contentY < -280) {
                        shown = false;
                    }
                }

                Column {
                    id: layout;
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }

                    Repeater {
                        model: [
                            {
                                "group" : "",
                                "apps": [
                                    { "icon" : "icon-launcher-browser", "label" : "Web Browser" },
                                    { "icon" : "icon-launcher-people",  "label" : "Contacts" },
                                    { "icon" : "icon-launcher-map",     "label" : "Maps" },
                                    { "icon" : "icon-launcher-weather", "label" : "Weather" },
                                ]
                            },
                            {
                                "group" : "Communication",
                                "apps": [
                                    { "icon" : "icon-launcher-phone",          "label" : "Phone" },
                                    { "icon" : "icon-launcher-messaging",      "label" : "Messages" },
                                    { "icon" : "icon-launcher-email",          "label" : "Email" },
                                    { "icon" : "telegram",                     "label" : "Telegram" },
                                    { "icon" : "whatsapp",                     "label" : "Whatsapp" },
                                    { "icon" : "snapchat",                     "label" : "Snapchat" },
                                    { "icon" : "facebook",                     "label" : "Facebook" },
                                    { "icon" : "messenger",                    "label" : "Messenger" },
                                    { "icon" : "twitter",                      "label" : "Twitter" },
                                    { "icon" : "instagram",                    "label" : "Instagram" },
                                    { "icon" : "discord",                      "label" : "Discord" },
                                ]
                            },
                            {
                                "group" : "Multimedia",
                                "apps": [
                                    { "icon" : "icon-launcher-camera",      "label" : "Camera" },
                                    { "icon" : "icon-launcher-gallery",     "label" : "Gallery" },
                                    { "icon" : "icon-launcher-mediaplayer", "label" : "Music" },
                                    { "icon" : "youtube",                   "label" : "Youtube" },
                                    { "icon" : "netflix",                   "label" : "Netflix" },
                                    { "icon" : "spotify",                   "label" : "Spotify" },
                                ]
                            },
                            {
                                "group" : "Productivity",
                                "apps": [
                                    { "icon" : "icon-launcher-notes",      "label" : "Notes" },
                                    { "icon" : "icon-launcher-office",     "label" : "Office" },
                                    { "icon" : "icon-launcher-qtodo",      "label" : "Todo" },
                                    { "icon" : "icon-launcher-calendar",   "label" : "Calendar" },
                                    { "icon" : "icon-launcher-calculator", "label" : "Calculator" },
                                ]
                            },
                            {
                                "group" : "System Tools",
                                "apps": [
                                    { "icon" : "icon-launcher-jollashop",    "label" : "Store" },
                                    { "icon" : "icon-launcher-file-manager", "label" : "Files" },
                                    { "icon" : "icon-launcher-settings",     "label" : "Settings" },
                                    { "icon" : "icon-launcher-search",       "label" : "Search" },
                                    { "icon" : "icon-launcher-lock",         "label" : "Secure Vault" },
                                    { "icon" : "icon-launcher-sat",          "label" : "SIM Tools" },
                                    { "icon" : "icon-launcher-shell",        "label" : "Terminal" },
                                ]
                            },
                            {
                                "group" : "Games",
                                "apps": [
                                    { "icon" : "kibitiles", "label" : "Kibitiles" },
                                    { "icon" : "numaze",    "label" : "Numaze" },
                                ]
                            },
                        ];
                        delegate: Column {
                            id: group;
                            anchors {
                                left: parent.left;
                                right: parent.right;
                            }

                            readonly property bool isDefault : (modelData ["group"] === "");
                            readonly property bool isCurrent : (currentGroup === modelData ["group"] || isDefault);

                            MouseArea {
                                id: header;
                                visible: !group.isDefault;
                                implicitHeight: headerSize;
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }
                                onClicked: { currentGroup = (group.isCurrent ? "" : modelData ["group"]); }

                                Rectangle {
                                    color: accentColor;
                                    opacity: (parent.pressed || group.isCurrent ? 0.35 : 0.0);
                                    visible: (opacity > 0.0);
                                    anchors.fill: parent;

                                    Behavior on opacity { NumberAnimation { duration: 280; } }
                                }
                                Row {
                                    spacing: 24;
                                    anchors {
                                        left: parent.left;
                                        margins: 16;
                                        verticalCenter: parent.verticalCenter;
                                    }

                                    Image {
                                        source: "qrc:///symbols/chevron.png";
                                        opacity: 0.65;
                                        rotation: (!group.isCurrent ? -90 : 0);
                                        anchors.verticalCenter: parent.verticalCenter;

                                        Behavior on rotation { NumberAnimation { duration: 280; } }
                                    }
                                    Row {
                                        opacity: (!group.isCurrent ? 1.0 : 0.0);
                                        visible: (opacity > 0.0);
                                        spacing: 16;
                                        anchors.verticalCenter: parent.verticalCenter;

                                        Behavior on opacity { NumberAnimation { duration: 280; } }
                                        Repeater {
                                            model: modelData ["apps"].slice (0, 3);
                                            delegate: Image {
                                                scale: opacity;
                                                source: "qrc:///logos/%1.png".arg (modelData ["icon"]);
                                                smooth: true;
                                                mipmap: true;
                                                sourceSize: iconSizeNormal;
                                                antialiasing: true;
                                                anchors.verticalCenter: parent.verticalCenter;

                                                MouseArea {
                                                    anchors.fill: parent;
                                                    onClicked: { launchApp (modelData ["label"], modelData ["icon"]); }
                                                }
                                            }
                                        }
                                        Text {
                                            text: (modelData ["apps"].length > 3 ? "+%1".arg (modelData ["apps"].length -3) : "");
                                            color: secondaryColor;
                                            font {
                                                family: fontName;
                                                weight: Font.Light;
                                                pixelSize: fontSizeNormal;
                                            }
                                            anchors.bottom: parent.bottom;
                                        }
                                    }
                                }
                                Text {
                                    id: lbl;
                                    text: modelData ["group"];
                                    color: accentColor;
                                    font {
                                        family: fontName;
                                        pixelSize: fontSizeBig;
                                        weight: Font.Light;
                                    }
                                    anchors {
                                        right: parent.right;
                                        margins: 20;
                                        verticalCenter: parent.verticalCenter;
                                    }
                                }
                            }
                            Item {
                                clip: true;
                                height: (flow.visible ? flow.height : 0);
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }

                                Rectangle {
                                    color: (group.isDefault ? primaryColor : accentColor);
                                    opacity: (group.isDefault ? 0.10 : 0.15);
                                    anchors.fill: parent;
                                }
                                Behavior on height { NumberAnimation { easing.type: Easing.InOutCirc; duration: 280; } }
                                Flow {
                                    id: flow;
                                    visible: group.isCurrent;
                                    spacing: 0;
                                    anchors {
                                        left: parent.left;
                                        right: parent.right;
                                    }

                                    Repeater {
                                        model: modelData ["apps"];
                                        delegate: MouseArea {
                                            opacity: (group.isCurrent ? 1.0 : 0.0);
                                            visible: (opacity > 0.0);
                                            implicitWidth: itemSize;
                                            implicitHeight: itemSize;
                                            onClicked: { launchApp (modelData ["label"], modelData ["icon"]); }

                                            Behavior on opacity { NumberAnimation { duration: 280; } }
                                            Column {
                                                spacing: 4;
                                                anchors.centerIn: parent;

                                                Image {
                                                    width: iconSizeBig.width;
                                                    height: iconSizeBig.height;
                                                    source: "qrc:///logos/%1.png".arg (modelData ["icon"]);
                                                    smooth: true;
                                                    mipmap: true;
                                                    fillMode: Image.Stretch;
                                                    sourceSize: iconSizeBig;
                                                    antialiasing: true;
                                                    anchors.horizontalCenter: parent.horizontalCenter;
                                                }
                                                Text {
                                                    text: modelData ["label"];
                                                    color: secondaryColor;
                                                    font {
                                                        family: fontName;
                                                        pixelSize: fontSizeSmall;
                                                        weight: Font.Light;
                                                    }
                                                    anchors.horizontalCenter: parent.horizontalCenter;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Item {
        id: overlay;
        anchors.fill: parent;
    }
    Component {
        id: compoLaunchAnim;

        Image {
            id: throbber;
            source: "qrc:///logos/%1.png".arg (icon);
            width: iconSizeBig.width;
            height: iconSizeBig.height;
            smooth: true;
            mipmap: true;
            fillMode: Image.Stretch;
            sourceSize: iconSizeBig;
            antialiasing: true;
            anchors.centerIn: parent;

            property string icon : "";

            Image {
                id: circle;
                source: "qrc:///symbols/graphic-busyindicator-large.png";
                anchors.centerIn: parent;
            }
            SequentialAnimation {
                loops: 1;
                running: true;
                alwaysRunToEnd: true;

                NumberAnimation {
                    target: circle;
                    property: "rotation";
                    duration: 1285;
                    from: 0;
                    to: 359;
                }
                ScriptAction {
                    script: { throbber.destroy (); }
                }
            }
        }
    }
}
