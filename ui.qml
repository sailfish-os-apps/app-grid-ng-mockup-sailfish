import QtQuick 2.9;
import QtQuick.Window 2.1;

Window {
    id: window;
    width: 540;
    height: 960;
    visible: true;

    property bool shown : false;

    property string currentGroup : "";

    readonly property color accentColor    : Qt.lighter ("steelblue");
    readonly property color primaryColor   : "white";
    readonly property color secondaryColor : Qt.rgba(1,1,1,0.5);

    readonly property real itemSize : (width / Math.floor (width / 120));

    Image {
        source: "images/wallpaper.jpg";
        asynchronous: true;
        fillMode: Image.PreserveAspectCrop;
        verticalAlignment: Image.AlignVCenter;
        horizontalAlignment: Image.AlignHCenter;
        anchors.fill: parent;
    }
    Item {
        id: statusbar;
        z: 99999;
        implicitHeight: 50;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
        }

        Row {
            spacing: 8;
            anchors {
                left: parent.left;
                margins: 16;
                verticalCenter: parent.verticalCenter;
            }

            Image {
                source: "symbols/icon-system-battery.png";
                sourceSize: Qt.size (20, 20);
                anchors.verticalCenter: parent.verticalCenter;
            }
            Text {
                text: "42%";
                color: secondaryColor;
                font {
                    family: "Ubuntu";
                    weight: Font.Light;
                    pixelSize: 18;
                }
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
        Text {
            text: "13:37";
            color: primaryColor;
            font {
                family: "Ubuntu";
                pixelSize: 24;
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
                source: (flag ? "symbols/icon-status-data-download.png" : "symbols/icon-status-data-upload.png");
                sourceSize: Qt.size (20, 20);
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
                    family: "Ubuntu";
                    weight: Font.Light;
                    pixelSize: 18;
                }
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image {
                source: "symbols/icon-status-cellular-4.png";
                sourceSize: Qt.size (20, 20);
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
                                implicitHeight: 80;
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
                                    id: row;
                                    spacing: 24;
                                    anchors {
                                        left: parent.left;
                                        margins: 16;
                                        verticalCenter: parent.verticalCenter;
                                    }

                                    Image {
                                        source: "symbols/chevron.png";
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
                                                source: "icons/%1.png".arg (modelData ["icon"]);
                                                smooth: true;
                                                mipmap: true;
                                                sourceSize: Qt.size (48, 48);
                                                antialiasing: true;
                                                anchors.verticalCenter: parent.verticalCenter;

                                                MouseArea {
                                                    anchors.fill: parent;
                                                    onClicked: {
                                                        currentGroup = "";
                                                        shown = false;
                                                    }
                                                }
                                            }
                                        }
                                        Text {
                                            text: (modelData ["apps"].length > 3 ? "+%1".arg (modelData ["apps"].length -3) : "");
                                            color: secondaryColor;
                                            font {
                                                family: "Ubuntu";
                                                weight: Font.Light;
                                                pixelSize: 18;
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
                                        family: "Ubuntu";
                                        pixelSize: 22;
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
                                            onClicked: {
                                                currentGroup = "";
                                                shown = false;
                                            }

                                            Behavior on opacity { NumberAnimation { duration: 280; } }
                                            Column {
                                                spacing: 4;
                                                anchors.centerIn: parent;

                                                Image {
                                                    source: "icons/%1.png".arg (modelData ["icon"]);
                                                    smooth: true;
                                                    mipmap: true;
                                                    sourceSize: Qt.size (84, 84);
                                                    antialiasing: true;
                                                    anchors.horizontalCenter: parent.horizontalCenter;
                                                }
                                                Text {
                                                    text: modelData ["label"];
                                                    color: secondaryColor;
                                                    font {
                                                        family: "Ubuntu";
                                                        pixelSize: 16;
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
}
