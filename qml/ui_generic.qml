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

    AppGridNgMockup {
        anchors.fill: parent;
    }
}
