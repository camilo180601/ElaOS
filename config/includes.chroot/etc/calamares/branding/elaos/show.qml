import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 6000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#16161E"
            Text {
                anchors.centerIn: parent
                text: "Bienvenido a ElaOS"
                color: "#FFFFFF"
                font.pixelSize: 30
                font.bold: true
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#16161E"
            Text {
                anchors.centerIn: parent
                text: "Look macOS · Arsenal de seguridad · Gaming"
                color: "#B92DA1"
                font.pixelSize: 24
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#16161E"
            Text {
                anchors.centerIn: parent
                text: "Tres modos, un solo sistema.\nNormal · Gaming · Hacking"
                horizontalAlignment: Text.AlignHCenter
                color: "#F16E62"
                font.pixelSize: 24
            }
        }
    }

    function onActivate() {}
    function onLeave() {}
}
