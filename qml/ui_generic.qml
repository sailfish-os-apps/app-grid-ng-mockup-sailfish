import QtQuick 2.9;
import QtQuick.Window 2.1;
import "components";

Window {
    id: window;
    width: minimumWidth;
    height: minimumHeight;
    minimumWidth: 540;
    maximumWidth: minimumWidth;
    minimumHeight: 960;
    maximumHeight: minimumHeight;
    visible: true;

    Image {
        source: "qrc:///images/wallpaper.jpg";
        fillMode: Image.PreserveAspectCrop;
        verticalAlignment: Image.AlignVCenter;
        horizontalAlignment: Image.AlignHCenter;
        anchors.fill: parent;
    }
    AppGridNgMockup {
        anchors.fill: parent;
    }
}
