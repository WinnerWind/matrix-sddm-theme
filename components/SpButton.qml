// Button.qml
import QtQuick 2.15

Rectangle {
    id: root
    width: 120
    height: 40

    property color bgColor: "#000000"
    property color borderColor: "#ffffff"    // Default border
    property color textColor: "#00ff00"      // Default text
    property color hoverColor: Qt.darker(bgColor, 1.2)
    property color pressedColor: Qt.darker(bgColor, 1.4)

    // === Customizable properties ===
    property alias text: label.text
    property alias font: label.font
    property bool hovered: false
    property bool pressed: false

    // Theming
    border.color: borderColor
    border.width: 1

    // State-based coloring
    color: pressed ? pressedColor
         : hovered ? hoverColor
         : root.bgColor

    // The button text
    Text {
        id: label
        anchors.centerIn: parent
        color: root.textColor
        font.pixelSize: 18
        font.family: "monospace"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // Mouse interaction
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: {
            root.hovered = false
            root.pressed = false
        }
        onPressed: root.pressed = true
        onReleased: root.pressed = false

        // Support focus by tab + space, optionally
        onClicked: root.clicked()
    }

    signal clicked()
}
