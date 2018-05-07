import QtQuick 2.6;

Text {
    id: base;
    color: primaryColor;
    horizontalAlignment: Text.AlignHCenter;
    font {
        family: fontName;
        weight: Font.Light;
        pixelSize: fontSizeNormal;
    }
    anchors {
        left: parent.left;
        right: parent.right;
    }

    signal clicked ();

    readonly property Flickable flickable : parent.flickable;

    readonly property int threshold : 150;

    readonly property int absolutePos : (flickable.contentY < 0 ? (0 - flickable.contentY - parent.height + y) : -1);

    readonly property bool active : (absolutePos <= threshold && (absolutePos + height) >= threshold);

    Connections {
        target: flickable;
        onDraggingChanged: {
            if (!flickable.dragging && active) {
                base.clicked ();
            }
        }
    }
    Rectangle {
        z: -1;
        color: accentColor;
        opacity: (active ? 0.65 : 0.0);
        anchors {
            fill: parent;
            topMargin: -4;
            leftMargin: -20;
            rightMargin: -20;
            bottomMargin: -4;
        }

        Behavior on opacity { NumberAnimation { duration: 150; } }
    }
}
