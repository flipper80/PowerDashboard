import QtQuick 2.15

Item {
    id: root
    property int rectWidth: 100
    property int rectHeight: 50
    property int topRightX: 300
    property int topRightY: 100
    property color fillColor: "skyblue"
    property string labelText: "Label"          // Label
    property int fontSize: 12                   //
    property real rpm:100                       //Speed (Width)
    property real power


    Rectangle {
        width: rectWidth
        height: rectHeight
        color: fillColor
        border.color: "blue"
        x: topRightX - rectWidth
        y: topRightY
    Column{

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 5  // margins
        spacing:3
        width: parent.width * 0.9  // 90% of rectangle width
        Text { 
                    text: labelText
                    color: "black"
                    font {
                    pixelSize: Math.min(parent.width * 0.15, 14)
                    bold: true
                    capitalization: Font.AllUppercase
                    }
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                }

        Text {

            text: power + " kW"
            font.pixelSize: fontSize
            color: "black"
            font {
            pixelSize: Math.min(parent.width * 0.15, 14)
            bold: true                      }
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
        }
        }
    Text {
            text: "RPM "+rpm
            font.pixelSize: fontSize
            color: "black"
            font {
            pixelSize: Math.min(parent.width * 0.15, 14)
            bold: true                      }
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 5
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            wrapMode: Text.WordWrap
        }
    }
    }

