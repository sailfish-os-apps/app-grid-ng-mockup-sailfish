import QtQuick 2.6;

Item {
    id: base;
    height: (flickable.contentY < 0 ? -flickable.contentY : 0);
    anchors {
        left: parent.left;
        right: parent.right;
        bottom: parent.top;
    }

    property list<MenuItem> items;

    default property alias content : base.items;

    readonly property Flickable flickable : parent.parent;

    Item {
        clip: true;
        anchors.fill: parent;

        Rectangle {
            opacity: 0.65;
            gradient: Gradient {
                GradientStop { position: 0; color: "transparent"; }
                GradientStop { position: 1; color: accentColor; }
            }
            anchors.fill: parent;
        }
        Column {
            spacing: 16;
            children: items;
            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                margins: 20;
            }

            property alias flickable : base.flickable;
        }
    }
    Rectangle {
        color: accentColor;
        opacity: 0.85;
        implicitHeight: 3;
        anchors {
            top: parent.bottom;
            left: parent.left;
            right: parent.right;
        }
    }
}
