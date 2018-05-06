import QtQuick 2.6;
import "silica-proxy";
import "silica-fake";

Item {
    id: base;
    width: 480;
    height: 800;

    property bool shown : false;
    property bool edit  : false;

    property QtObject currentGroup      : null;
    property QtObject currentMovingIcon : null;

    property color accentColor    : Qt.lighter ("steelblue");
    property color primaryColor   : "white";
    property color secondaryColor : Qt.rgba (1, 1, 1, 0.5);

    property string fontName : "Ubuntu";

    property string wallpaper : "qrc:///images/wallpaper.jpg";

    property int headerSize : 80;

    property int fontSizeBig    : 24;
    property int fontSizeNormal : 18;
    property int fontSizeSmall  : 16;

    property size iconSizeBig    : Qt.size (84, 84);
    property size iconSizeNormal : Qt.size (48, 48);
    property size iconSizeSmall  : Qt.size (20, 20);

    property real itemSize : (width / divisions);

    property int divisions : 4;

    function launchApp (label, icon) {
        compoLaunchAnim.createObject (overlay, { icon: icon });
        currentGroup = null;
        shown = false;
    }

    function enterEditMode () {
        edit = true;
        currentGroup = null;
    }

    function leaveEditMode () {
        edit = false;
    }

    function createFolder () {
        foldersModel.append ({
                                 "group" : qsTr ("New folder"),
                                 "apps"  : []
                             });
    }

    function removeFolder (folderIdx) {
        var folderAppsModel = foldersModel.get (folderIdx) ["apps"];
        var unfolderedAppsModel = foldersModel.get (0) ["apps"];
        for (var idx = 0; idx < folderAppsModel.count; ++idx) {
            unfolderedAppsModel.append (folderAppsModel.get (idx));
        }
        folderAppsModel.clear ();
        foldersModel.remove (folderIdx);
    }

    function renameFolder (folderIdx, name) {
        var tmp = name.trim ();
        if (tmp === "") {
            tmp = qsTr ("Untitled");
        }
        focus = false;
        foldersModel.setProperty (folderIdx, "group", tmp);
    }

    function moveFolderUp (folderIdx) {
        foldersModel.move (folderIdx, (folderIdx -1), 1);
    }

    function moveFolderDown (folderIdx) {
        foldersModel.move (folderIdx, (folderIdx +1), 1);
    }

    function reorderIcons (srcFolderModel, srcPos, dstFolderModel, dstPos) {
        currentMovingIcon = null;
        if (srcFolderModel === dstFolderModel) {
            dstFolderModel.move (srcPos, dstPos, 1);
        }
        else {
            dstFolderModel.insert (dstPos, srcFolderModel.get (srcPos));
            srcFolderModel.remove (srcPos);
        }
    }

    Image {
        source: wallpaper;
        fillMode: Image.PreserveAspectCrop;
        verticalAlignment: Image.AlignVCenter;
        horizontalAlignment: Image.AlignHCenter;
        anchors.fill: parent;
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
                source: "qrc:///symbols/icon-status-data-download.png";
                sourceSize: iconSizeSmall;
                anchors.verticalCenter: parent.verticalCenter;
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
            visible: false;
            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                bottomMargin: (shown ? 0 : -height);
            }

            Behavior on anchors.bottomMargin { NumberAnimation { duration: 280; } }
            Timer {
                repeat: false;
                running: true;
                interval: 850;
                onTriggered: { parent.visible = true; }
            }
            Rectangle {
                color: "black";
                opacity: 0.65;
                anchors.fill: parent;
            }
            Rectangle {
                color: secondaryColor;
                radius: (implicitHeight * 0.5);
                antialiasing: true;
                implicitWidth: (parent.width / 5);
                implicitHeight: 6;
                anchors {
                    verticalCenter: parent.top;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
            Flickable {
                id: flicker;
                clip: true;
                contentHeight: layout.height;
                flickableDirection: Flickable.VerticalFlick;
                anchors {
                    fill: parent;
                    topMargin: statusbar.height;
                    bottomMargin: (edit ? toolbar.height : 0);
                }
                onContentYChanged: {
                    if (contentY < -280 && !edit) {
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
                        model: ListModel {
                            id: foldersModel;

                            ListElement {
                                group: "";
                                apps: [
                                    ListElement { icon: "icon-launcher-browser"; label: "Web Browser" },
                                    ListElement { icon: "icon-launcher-people";  label: "Contacts"    },
                                    ListElement { icon: "icon-launcher-map";     label: "Maps"        },
                                    ListElement { icon: "icon-launcher-weather"; label: "Weather"     }
                                ]
                            }
                            ListElement {
                                group: "Communication";
                                apps: [
                                    ListElement { icon: "icon-launcher-phone";          label: "Phone"     },
                                    ListElement { icon: "icon-launcher-messaging";      label: "Messages"  },
                                    ListElement { icon: "icon-launcher-email";          label: "Email"     },
                                    ListElement { icon: "telegram";                     label: "Telegram"  },
                                    ListElement { icon: "whatsapp";                     label: "Whatsapp"  },
                                    ListElement { icon: "snapchat";                     label: "Snapchat"  },
                                    ListElement { icon: "facebook";                     label: "Facebook"  },
                                    ListElement { icon: "messenger";                    label: "Messenger" },
                                    ListElement { icon: "twitter";                      label: "Twitter"   },
                                    ListElement { icon: "instagram";                    label: "Instagram" },
                                    ListElement { icon: "discord";                      label: "Discord"   }
                                ]
                            }
                            ListElement {
                                group: "Multimedia";
                                apps: [
                                    ListElement { icon: "icon-launcher-camera";      label: "Camera"  },
                                    ListElement { icon: "icon-launcher-gallery";     label: "Gallery" },
                                    ListElement { icon: "icon-launcher-mediaplayer"; label: "Music"   },
                                    ListElement { icon: "youtube";                   label: "Youtube" },
                                    ListElement { icon: "netflix";                   label: "Netflix" },
                                    ListElement { icon: "spotify";                   label: "Spotify" }
                                ]
                            }
                            ListElement {
                                group: "Productivity";
                                apps: [
                                    ListElement { icon: "icon-launcher-notes";      label: "Notes"      },
                                    ListElement { icon: "icon-launcher-office";     label: "Office"     },
                                    ListElement { icon: "icon-launcher-qtodo";      label: "Todo"       },
                                    ListElement { icon: "icon-launcher-calendar";   label: "Calendar"   },
                                    ListElement { icon: "icon-launcher-calculator"; label: "Calculator" }
                                ]
                            }
                            ListElement {
                                group: "System Tools";
                                apps: [
                                    ListElement { icon: "icon-launcher-jollashop";    label: "Store"        },
                                    ListElement { icon: "icon-launcher-file-manager"; label: "Files"        },
                                    ListElement { icon: "icon-launcher-settings";     label: "Settings"     },
                                    ListElement { icon: "icon-launcher-search";       label: "Search"       },
                                    ListElement { icon: "icon-launcher-lock";         label: "Secure Vault" },
                                    ListElement { icon: "icon-launcher-sat";          label: "SIM Tools"    },
                                    ListElement { icon: "icon-launcher-shell";        label: "Terminal"     }
                                ]
                            }
                            ListElement {
                                group: "Games";
                                apps: [
                                    ListElement { icon: "kibitiles"; label: "Kibitiles" },
                                    ListElement { icon: "numaze";    label: "Numaze"    }
                                ]
                            }
                        }
                        delegate: Column {
                            id: group;
                            anchors {
                                left: parent.left;
                                right: parent.right;
                            }

                            readonly property string    groupLabel : model ["group"];
                            readonly property ListModel appsModel  : model ["apps"];

                            readonly property bool isDefault : (groupLabel === "");
                            readonly property bool isCurrent : (currentGroup === group);
                            readonly property bool isOpened  : ((edit ? forceOpened : isCurrent) || isDefault);

                            property bool forceOpened : false;

                            Connections {
                                target: base;
                                onEditChanged: {
                                    if (edit) {
                                        group.forceOpened = group.isCurrent;
                                    }
                                    else {
                                        group.forceOpened = false;
                                    }
                                }
                            }
                            MouseArea {
                                id: header;
                                visible: !group.isDefault;
                                implicitHeight: headerSize;
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }
                                onClicked: {
                                    if (edit) {
                                        group.forceOpened = !group.forceOpened;
                                    }
                                    else {
                                        currentGroup = (group.isCurrent ? null : group);
                                    }
                                }
                                onPressAndHold: { enterEditMode (); }

                                Rectangle {
                                    color: accentColor;
                                    opacity: (parent.pressed || group.isOpened ? 0.35 : 0.0);
                                    visible: (!edit && opacity > 0.0);
                                    anchors.fill: parent;

                                    Behavior on opacity { NumberAnimation { duration: 280; } }
                                }
                                Row {
                                    id: list;
                                    spacing: 24;
                                    anchors {
                                        left: parent.left;
                                        margins: 16;
                                        verticalCenter: parent.verticalCenter;
                                    }

                                    Image {
                                        id: chevron;
                                        source: "qrc:///symbols/chevron.png";
                                        opacity: 0.65;
                                        rotation: (!group.isOpened ? -90 : 0);
                                        anchors.verticalCenter: parent.verticalCenter;

                                        Behavior on rotation { NumberAnimation { duration: 280; } }
                                    }
                                    Row {
                                        opacity: (!group.isOpened ? 1.0 : 0.0);
                                        visible: !edit;
                                        spacing: 16;
                                        enabled: !edit;
                                        anchors.verticalCenter: parent.verticalCenter;

                                        Behavior on opacity { NumberAnimation { duration: 280; } }
                                        Repeater {
                                            model: group.appsModel;
                                            delegate: Image {
                                                id: itemMini;
                                                scale: (clicker.pressed ? 0.85 : 1.0);
                                                source: "qrc:///logos/%1.png".arg (icon);
                                                smooth: true;
                                                mipmap: true;
                                                visible: (model.index < 3);
                                                opacity: (edit ? 0.35 : 1.0);
                                                sourceSize: iconSizeNormal;
                                                antialiasing: true;
                                                anchors.verticalCenter: parent.verticalCenter;

                                                readonly property string icon  : model ["icon"];
                                                readonly property string label : model ["label"];

                                                Behavior on scale { NumberAnimation { duration: 150; } }
                                                MouseArea {
                                                    id: clicker;
                                                    anchors.fill: parent;
                                                    onClicked: { launchApp (itemMini.label, itemMini.icon); }
                                                    onPressAndHold: { enterEditMode (); }
                                                }
                                            }
                                        }
                                        Text {
                                            text: (group.appsModel && group.appsModel.count > 3
                                                   ? "+%1".arg (group.appsModel.count -3)
                                                   : "");
                                            color: secondaryColor;
                                            opacity: (edit ? 0.35 : 1.0);
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
                                    text: group.groupLabel;
                                    color: accentColor;
                                    elide: Text.ElideRight;
                                    visible: !edit;
                                    opacity: (edit ? 0.35 : 1.0);
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                                    maximumLineCount: 2;
                                    verticalAlignment: Text.AlignVCenter;
                                    horizontalAlignment: Text.AlignRight;
                                    font {
                                        family: fontName;
                                        weight: Font.Light;
                                        pixelSize: (group.isOpened ? fontSizeBig : fontSizeNormal);
                                    }
                                    anchors {
                                        left: (group.isOpened ? parent.left : list.right);
                                        right: parent.right;
                                        margins: 20;
                                        verticalCenter: parent.verticalCenter;
                                    }
                                }
                                TextInput {
                                    color: accentColor;
                                    visible: edit;
                                    selectionColor: primaryColor;
                                    selectedTextColor: accentColor;
                                    verticalAlignment: Text.AlignVCenter;
                                    activeFocusOnPress: true;
                                    horizontalAlignment: Text.AlignHCenter;
                                    font {
                                        family: fontName;
                                        weight: Font.Light;
                                        pixelSize: fontSizeNormal;
                                    }
                                    anchors {
                                        left: list.right;
                                        right: buttons.left;
                                        margins: 16;
                                        verticalCenter: parent.verticalCenter;
                                    }
                                    onEditingFinished: {
                                        renameFolder (model.index, text);
                                        focus = false;
                                    }

                                    Binding on text { value: group.groupLabel; }
                                    Rectangle {
                                        color: accentColor;
                                        implicitHeight: 1;
                                        anchors {
                                            top: parent.bottom;
                                            left: parent.left;
                                            right: parent.right;
                                        }
                                    }
                                }
                                Row {
                                    id: buttons;
                                    visible: edit;
                                    spacing: 8;
                                    anchors {
                                        right: parent.right;
                                        margins: 16;
                                        verticalCenter: parent.verticalCenter;
                                    }

                                    MouseArea {
                                        enabled: (model.index > 1);
                                        opacity: (enabled ? 1.0 : 0.15);
                                        implicitWidth: iconSizeNormal.width;
                                        implicitHeight: iconSizeNormal.height;
                                        onClicked: { moveFolderUp (model.index); }

                                        Rectangle {
                                            color: "black";
                                            radius: 7;
                                            opacity: (parent.pressed ? 0.15 : 0.35);
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                        Image {
                                            source: "qrc:///symbols/icon-m-page-up.png";
                                            smooth: true;
                                            mipmap: true;
                                            fillMode: Image.Stretch;
                                            sourceSize: iconSizeNormal;
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                    }
                                    MouseArea {
                                        enabled: (model.index < foldersModel.count -1);
                                        opacity: (enabled ? 1.0 : 0.15);
                                        implicitWidth: iconSizeNormal.width;
                                        implicitHeight: iconSizeNormal.height;
                                        onClicked: { moveFolderDown (model.index); }

                                        Rectangle {
                                            color: "black";
                                            radius: 7;
                                            opacity: (parent.pressed ? 0.15 : 0.35);
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                        Image {
                                            source: "qrc:///symbols/icon-m-page-down.png";
                                            smooth: true;
                                            mipmap: true;
                                            fillMode: Image.Stretch;
                                            sourceSize: iconSizeNormal;
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                    }
                                    MouseArea {
                                        opacity: (enabled ? 1.0 : 0.15);
                                        implicitWidth: iconSizeNormal.width;
                                        implicitHeight: iconSizeNormal.height;
                                        onClicked: {
                                            remorse.execute (placeholder,
                                                             qsTr ("Removing folder...\n(icons inside will be set out)"),
                                                             (function () { removeFolder (model.index); }),
                                                             3000);
                                        }

                                        Rectangle {
                                            color: "red";
                                            radius: 7;
                                            opacity: (parent.pressed ? 0.15 : 0.35);
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                        Image {
                                            source: "qrc:///symbols/icon-m-delete.png";
                                            smooth: true;
                                            mipmap: true;
                                            fillMode: Image.Stretch;
                                            sourceSize: iconSizeNormal;
                                            antialiasing: true;
                                            anchors.fill: parent;
                                        }
                                    }
                                }
                                Rectangle {
                                    id: dimmer;
                                    color: "black";
                                    opacity: (remorse.pending ? 0.85 : 0.0);
                                    anchors.fill: parent;
                                }
                                Item {
                                    id: placeholder;
                                    anchors.fill: parent;

                                    RemorseItem { id: remorse; }
                                }
                            }
                            Item {
                                clip: (height < flow.height);
                                height: (flow.visible ? flow.height : 0);
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }

                                Rectangle {
                                    color: (group.isDefault ? primaryColor : accentColor);
                                    opacity: (group.isDefault ? 0.10 : 0.15);
                                    visible: !edit;
                                    anchors.fill: parent;
                                }
                                Behavior on height { NumberAnimation { easing.type: Easing.InOutCirc; duration: 280; } }
                                Flow {
                                    id: flow;
                                    visible: group.isOpened;
                                    spacing: 0;
                                    anchors {
                                        left: parent.left;
                                        right: parent.right;
                                    }

                                    Repeater {
                                        model: group.appsModel;
                                        delegate: MouseArea {
                                            id: item;
                                            opacity: (group.isOpened ? 1.0 : 0.0);
                                            visible: (opacity > 0.0);
                                            implicitWidth: itemSize;
                                            implicitHeight: itemSize;
                                            drag.target: (currentMovingIcon === item ? col : null);
                                            onClicked: {
                                                if (!edit) {
                                                    launchApp (item.label, item.icon);
                                                }
                                            }
                                            onPressAndHold: {
                                                if (!edit) {
                                                    enterEditMode ();
                                                }
                                                else {
                                                    currentMovingIcon = item;
                                                }
                                            }
                                            onReleased: {
                                                if (edit) {
                                                    if (col.Drag.target) {
                                                        col.Drag.drop ();
                                                    }
                                                    else {
                                                        if (currentMovingIcon === item) {
                                                            currentMovingIcon = null;
                                                        }
                                                    }
                                                }
                                            }

                                            readonly property int       position : model.index;
                                            readonly property string    icon     : model ["icon"];
                                            readonly property string    label    : model ["label"];
                                            readonly property ListModel folder   : group.appsModel;

                                            Behavior on opacity { NumberAnimation { duration: 280; } }
                                            Column {
                                                id: col;
                                                spacing: 4;
                                                anchors.centerIn: (currentMovingIcon === item ? null : parent);
                                                Drag.keys: ["LAUNCHER_ICON"];
                                                Drag.source: item;
                                                Drag.active: item.drag.active;
                                                Drag.hotSpot: Qt.point (width * 0.5, height * 0.5);
                                                Drag.dragType: Drag.Internal;

                                                Image {
                                                    scale: (item.pressed ? 0.85 : 1.0);
                                                    width: iconSizeBig.width;
                                                    height: iconSizeBig.height;
                                                    source: "qrc:///logos/%1.png".arg (item.icon);
                                                    smooth: true;
                                                    mipmap: true;
                                                    opacity: (edit && currentMovingIcon !== null && currentMovingIcon !== item ? 0.35 : 1.0);
                                                    fillMode: Image.Stretch;
                                                    sourceSize: iconSizeBig;
                                                    antialiasing: true;
                                                    anchors.horizontalCenter: parent.horizontalCenter;

                                                    Behavior on scale { NumberAnimation { duration: 150; } }
                                                }
                                                Text {
                                                    text: item.label;
                                                    color: secondaryColor;
                                                    font {
                                                        family: fontName;
                                                        weight: Font.Light;
                                                        pixelSize: fontSizeSmall;
                                                    }
                                                    anchors.horizontalCenter: parent.horizontalCenter;
                                                }
                                            }
                                            DropArea {
                                                id: dropper;
                                                keys: ["LAUNCHER_ICON"];
                                                enabled: (currentMovingIcon !== item);
                                                visible: (edit && currentMovingIcon !== null);
                                                anchors.fill: parent;
                                                onDropped: {
                                                    reorderIcons (drop.source.folder,
                                                                  drop.source.position,
                                                                  item.folder,
                                                                  item.position);
                                                }

                                                Rectangle {
                                                    color: "transparent";
                                                    opacity: 0.35;
                                                    border {
                                                        width: 1;
                                                        color: secondaryColor;
                                                    }
                                                    anchors.fill: parent;
                                                    anchors.margins: 2;
                                                }
                                            }
                                        }
                                    }
                                    Item {
                                        visible: edit;
                                        implicitWidth: itemSize;
                                        implicitHeight: itemSize;

                                        DropArea {
                                            id: dropperLast;
                                            keys: ["LAUNCHER_ICON"];
                                            visible: (currentMovingIcon !== null);
                                            anchors.fill: parent;
                                            onDropped: {
                                                reorderIcons (drop.source.folder,
                                                              drop.source.position,
                                                              group.appsModel,
                                                              (group.appsModel !== drop.source.folder
                                                               ? group.appsModel.count
                                                               : group.appsModel.count -1));
                                            }

                                            Rectangle {
                                                color: "transparent";
                                                opacity: 0.35;
                                                border {
                                                    width: 1;
                                                    color: secondaryColor;
                                                }
                                                anchors.fill: parent;
                                                anchors.margins: 2;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    MouseArea {
                        visible: edit;
                        opacity: (currentMovingIcon !== null ? 0.35 : 1.0);
                        implicitHeight: headerSize;
                        anchors {
                            left: parent.left;
                            right: parent.right;
                        }
                        onClicked: { createFolder (); }

                        Row {
                            spacing: 16;
                            anchors {
                                left: parent.left;
                                margins: 20;
                                verticalCenter: parent.verticalCenter;
                            }

                            Image {
                                width: iconSizeNormal.width;
                                height: iconSizeNormal.height;
                                source: "qrc:///symbols/icon-m-new.png";
                                smooth: true;
                                mipmap: true;
                                fillMode: Image.Stretch;
                                sourceSize: iconSizeNormal;
                                antialiasing: true;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            Text {
                                text: qsTr ("New folder...");
                                color: primaryColor;
                                font {
                                    family: fontName;
                                    weight: Font.Light;
                                    pixelSize: fontSizeNormal;
                                }
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                        }
                    }
                }
            }
            Item {
                id: toolbar;
                visible: edit;
                implicitHeight: headerSize;
                anchors {
                    left: parent.left;
                    right: parent.right;
                    bottom: parent.bottom;
                }

                Rectangle {
                    color: primaryColor;
                    opacity: 0.15;
                    anchors.fill: parent;
                }
                MouseArea {
                    implicitWidth: (parent.width * 0.35);
                    implicitHeight: (headerSize * 0.85);
                    anchors.centerIn: parent;
                    onClicked: { leaveEditMode (); }

                    Rectangle {
                        color: "black";
                        radius: 7;
                        opacity: 0.35;
                        antialiasing: true;
                        anchors.fill: parent;
                    }
                    Text {
                        text: qsTr ("Exit edit mode");
                        color: primaryColor;
                        font {
                            family: fontName;
                            weight: Font.Light;
                            pixelSize: fontSizeNormal;
                        }
                        anchors.centerIn: parent;
                    }
                }
            }
            Item {
                width: 6;
                visible: (flicker.height < flicker.contentHeight);
                anchors {
                    top: parent.top;
                    right: parent.right;
                    bottom: parent.bottom;
                }

                Rectangle {
                    y: ((parent.height - height) * flicker.contentY / (flicker.contentHeight - flicker.height));
                    color: accentColor;
                    height: (parent.height * flicker.height / flicker.contentHeight);
                    opacity: 0.65;
                    anchors {
                        left: parent.left;
                        right: parent.right;
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
