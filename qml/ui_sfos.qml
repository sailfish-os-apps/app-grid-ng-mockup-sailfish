import QtQuick 2.6;
import Sailfish.Silica 1.0;
import "components";

ApplicationWindow {
    allowedOrientations: defaultAllowedOrientations;
    initialPage: Component {
        Page {
            Image {
                source: "qrc:///images/wallpaper.jpg";
                fillMode: Image.PreserveAspectCrop;
                verticalAlignment: Image.AlignVCenter;
                horizontalAlignment: Image.AlignHCenter;
                anchors.fill: parent;
            }
            AppGridNgMockup {
                itemSize: (Screen.width / 4);
                headerSize: Theme.itemSizeLarge;
                fontName: Theme.fontFamilyHeading;
                fontSizeBig: Theme.fontSizeMedium;
                fontSizeNormal: Theme.fontSizeSmall;
                fontSizeSmall: Theme.fontSizeExtraSmall;
                iconSizeBig: Qt.size (Theme.iconSizeLauncher, Theme.iconSizeLauncher);
                iconSizeNormal: Qt.size (Theme.iconSizeMedium, Theme.iconSizeMedium);
                iconSizeSmall: Qt.size (Theme.iconSizeSmall, Theme.iconSizeSmall);
                accentColor: Theme.highlightColor;
                primaryColor: Theme.primaryColor;
                secondaryColor: Theme.secondaryColor;
                anchors.fill: parent;
            }
        }
    }
}
