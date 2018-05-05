
#include <QGuiApplication>
#include <QQuickView>

#include <sailfishapp.h>

int main (int argc, char * argv []) {
    QGuiApplication * app = SailfishApp::application (argc, argv);
    QQuickView * view = SailfishApp::createView ();
    view->setSource (QUrl ("qrc:///qml/ui_sfos.qml"));
    view->show ();
    return app->exec ();
}
