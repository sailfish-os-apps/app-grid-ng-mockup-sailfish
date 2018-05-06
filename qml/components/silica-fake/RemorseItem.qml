import QtQuick 2.6;

QtObject {
    id: base;

    signal canceled  ();
    signal triggered ();

    function execute (item, title, callback, timeout) {
        if (!pending) {
            priv.pending = true;
            factory.createObject (item, {
                                      "title"    : title,
                                      "timeout"  : timeout,
                                      "callback" : callback,
                                  });
        }
    }

    readonly property bool pending : priv.pending;

    readonly property QtObject _priv : QtObject {
        id: priv;

        property bool pending : false;
    }

    readonly property Component _factory : Component {
        id: factory;

        MouseArea {
            id: remorse;
            anchors.fill: parent;
            onClicked: {
                base.canceled ();
                priv.pending = false;
                timer.stop ();
                remorse.destroy ();
            }

            property var    callback : function () { };
            property int    timeout  : 5;
            property string title    : "";

            Timer {
                id: timer;
                repeat: false;
                running: true;
                interval: remorse.timeout;
                onTriggered: {
                    base.triggered ();
                    priv.pending = false;
                    remorse.callback ();
                    remorse.destroy ();
                }
            }
            Rectangle {
                width: parent.width;
                color: accentColor;
                opacity: 0.35;
                anchors {
                    top: parent.top;
                    left: parent.left;
                    bottom: parent.bottom;
                }

                NumberAnimation on width {
                    to: 0;
                    duration: remorse.timeout;
                }
            }
            Text {
                text: remorse.title;
                color: primaryColor;
                elide: Text.ElideRight;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                textFormat: Text.PlainText;
                maximumLineCount: 2;
                font {
                    family: fontName;
                    weight: Font.Light;
                    pixelSize: fontSizeSmall;
                }
                anchors {
                    left: parent.left;
                    right: parent.right;
                    margins: 16;
                    verticalCenter: parent.verticalCenter;
                }
            }
        }
    }
}
