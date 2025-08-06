import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0
import "./components"

Item {
    id: root
    property int columnCount: root.width / root.charSize
    property var charset: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#%$?!*&"

    property color bgColor: "#282828"
    property color fgColor: "#ebdbb2"
    property color matrixColor: '#98971a'
    property var fontSize: 24
    property real charSize: 40
    property var headingFontSize: 27
    property var clockSize: 32
    property var clockSubtextSize: 18
    property var welcomeText:
"
                             /$$                 /$$
                            |__/                | $$
 /$$  /$$  /$$ /$$  /$$  /$$ /$$ /$$$$$$$   /$$$$$$$
| $$ | $$ | $$| $$ | $$ | $$| $$| $$__  $$ /$$__  $$
| $$ | $$ | $$| $$ | $$ | $$| $$| $$  \\ $$| $$  | $$
| $$ | $$ | $$| $$ | $$ | $$| $$| $$  | $$| $$  | $$
|  $$$$$/$$$$/|  $$$$$/$$$$/| $$| $$  | $$|  $$$$$$$
 \\_____/\\___/  \\_____/\\___/ |__/|__/  |__/ \\_______/

"
    property var usernamePlaceholderText: "login"
    property var passwordPlaceholderText: "password"
    property var timeFormat: "HH:mm AP"
    property var dateFormat: "dddd, dd MMMM\n yyyy"

    FontLoader {
      id: mainFont
      source: "fonts/departure-mono.otf"
    }


    property bool loggingIn: false
    signal tryLogin(string username, string password)


    Rectangle { anchors.fill: parent; color: root.bgColor }

    // Matrix
    Repeater { //Columns
      model: root.columnCount
      Item {
        property bool started: false

        property int initialDelay: Math.floor(Math.random() * 1500)
        property int timerInterval: 32 + Math.floor(Math.random() * 8)

        property int colIndex: index
        property int tailLength: 0
        property int maxTailLength: root.height / root.charSize + 15

        property var chars: []

        Timer {
          id: starter
          interval: initialDelay
          running: true
          repeat: false
          onTriggered: parent.started = true
        }

        Timer {
          interval: timerInterval
          running: true
          repeat: true
          onTriggered: {
            if (parent.started) {
                if (parent.tailLength < maxTailLength) {
                    parent.tailLength += 1
                    parent.chars.push(root.charset[Math.floor(Math.random() * root.charset.length)])
                } else {
                    // Reset tail and pick a new head character
                    parent.tailLength = 0
                }
            }
          }
        }
        Repeater { //Rows
          id: singleRow
          property var totalTailLength: 15
          model: parent.tailLength
          Text {
            text: parent.chars[index] || ""
            font.pixelSize: root.charSize
            font.family: mainFont.name

            color: Qt.rgba(root.matrixColor.r, root.matrixColor.g, root.matrixColor.b, index >= parent.tailLength - singleRow.totalTailLength
                                    ? 0.7 * ((index - (parent.tailLength - singleRow.totalTailLength)) / (singleRow.totalTailLength - 1))
                                    : 0)
            x: parent.colIndex * root.charSize + (root.width - root.columnCount*root.charSize)/2
            y: (index) * root.charSize
          }
        }
        }
      }

  // Clock Element

    Rectangle {
      id: clockParent
      width: 200
      height: 100
      color: root.bgColor
      // border.color: root.fgColor

      property date value: new Date()
      Column {
        anchors.fill: parent
        Text {
          color: root.fgColor
          font.family: mainFont.name
          font.pixelSize: root.clockSize

          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter



          text: Qt.formatDateTime(clockParent.value, root.timeFormat)
        }
        Text {
          color: root.fgColor
          font.family: mainFont.name
          font.pixelSize: root.clockSubtextSize

          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter



          text: Qt.formatDateTime(clockParent.value, root.dateFormat)
        }
      }
      Timer {
          interval: 100
          running: true
          repeat: true
          onTriggered: clockParent.value = new Date()
      }
    }
  // DEFINE
  // LOGIN BOX
  Rectangle {
    id: loginBoxBG
    width: root.width * 0.7
    height: root.height * 0.85
    color: root.bgColor
    anchors.centerIn: parent

    Rectangle {
      id: loginBoxFGBorder
      border.color: root.fgColor
      border.width: 0.5
      width: loginBoxBG.width - 30
      height: loginBoxBG.height - 30
      color: root.bgColor
      anchors.centerIn: parent

      Column {
            anchors {
                centerIn: parent
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.8
            spacing: 24


            Text { //Could do ascii art here.
                text: root.welcomeText
                color: root.fgColor
                font.pixelSize: root.headingFontSize
                font.family: mainFont.name

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }

            // Buttons
            Row {
              width: parent.width
              height: parent.height * 0.05

              anchors.horizontalCenter: parent.horizontalCenter

              spacing: 16

              property int buttonCount: 4
              property real buttonWidth: (width - (buttonCount - 1) * spacing) / buttonCount

              SpButton {
                id: shutdownButton
                font.family: mainFont.name
                font.pixelSize: root.fontSize
                bgColor: root.bgColor
                borderColor: root.fgColor
                textColor: root.fgColor

                height: parent.height
                width: parent.buttonWidth

                text: "Shut Down"

                onClicked: sddm.powerOff()
              }
              SpButton {
                id: restartButton
                font.family: mainFont.name
                font.pixelSize: root.fontSize
                bgColor: root.bgColor
                borderColor: root.fgColor
                textColor: root.fgColor

                height: parent.height
                width: parent.buttonWidth

                text: "Restart"

                onClicked: sddm.reboot()
              }
              SpButton {
                id: sleepButton
                font.family: mainFont.name
                font.pixelSize: root.fontSize
                bgColor: root.bgColor
                borderColor: root.fgColor
                textColor: root.fgColor

                height: parent.height
                width: parent.buttonWidth

                text: "Sleep"

                onClicked: sddm.suspend()
              }
              SpButton {
                id: hibernateButton
                font.family: mainFont.name
                font.pixelSize: root.fontSize
                bgColor: root.bgColor
                borderColor: root.fgColor
                textColor: root.fgColor

                height: parent.height
                width: parent.buttonWidth

                text: "Hibernate"

                onClicked: sddm.hibernate()
              }
            }
            ComboBox {
              color: root.bgColor
              borderColor: root.fgColor
              textColor: root.fgColor
              focusColor: root.bgColor
              hoverColor: root.bgColor
              menuColor: root.fgColor
              font.family: mainFont.name


              id: session
              model: sessionModel          // SDDM injects sessionModel
              index: sessionModel.lastIndex
              width: parent.width
              anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
              color: root.fgColor
              background: Rectangle { color: root.bgColor; border.color: root.fgColor }
              font.family: mainFont.name

              id: usernameField
              width: parent.width
              placeholderText: root.usernamePlaceholderText
              font.pixelSize: root.fontSize
            }

            TextField {
              color: root.fgColor
              background: Rectangle { color: root.bgColor; border.color: root.fgColor }
              font.family: mainFont.name

              id: passwordField
              width: parent.width
              placeholderText: root.passwordPlaceholderText
              echoMode: TextInput.Password
              font.pixelSize: root.fontSize
              Keys.onReturnPressed: {
                root.tryLogin(usernameField.text, passwordField.text)
              }
            }

            // Prompt/Error
            Row {
              spacing: 12
              anchors.horizontalCenter: parent.horizontalCenter
              height: 32
              width: parent.width


              Text {
                  visible: root.loggingIn

                  text: "Attempting to log in... \nIf you see this, check if your security key is plugged in."
                  font.pixelSize: root.fontSize
                  font.family: mainFont.name
                  color: "#ff5555"
              }
              Text {
                  id: errorElement
                  text: ""
                  color: "#ff5555"
                  font.pixelSize: root.headingFontSize
                  font.family: mainFont.name

                  width: parent.width
                  visible: !root.loggingIn
                  horizontalAlignment: Text.AlignHCenter
              }
          }
    }

    }

  }
  onTryLogin: {
    // When login is triggered:
    sddm.login(usernameField.text, passwordField.text, session.index)
    root.loggingIn = true
  }

  Connections {
    target: sddm

    onLoginFailed: {
      errorElement.text = "Error! Unable to login!"
      root.loggingIn = false
    }
  }


}
