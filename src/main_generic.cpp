
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main (int argc, char * argv []) {
    QGuiApplication app (argc, argv);
    QQmlApplicationEngine engine;
    engine.load (QUrl ("qrc:///qml/ui_generic.qml"));
    return (!engine.rootObjects ().isEmpty () ? app.exec () : -1);
}
