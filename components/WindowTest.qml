import QtQuick 2.15
Item {
    id: root
    property int rectWidth: 100
    property int rectHeight: 50
    property int bottomLeftX: 300
    property int bottomLeftY: 100
    property color fillColor: "skyblue"
 //   property color opacity:1
    property string labelText: "Label"          // Label
    property int fontSize: 12                   //
    property real flow:50                       //Flow (Width)
    property real pressure:100                  //Pressure (Height)


    Rectangle {
        width: rectWidth
        height:rectHeight
        color: fillColor
        border.color: "blue"
        opacity:1
        x: bottomLeftX
        y: bottomLeftY
    Column {
        anchors.bottom: parent.bottom
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
            text: pressure + " bar"
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
    }
}

