import QtQuick 2.15
Item {
    id: root
    property int rectWidth: 100
    property int rectHeight: 50
    property int bottomLeftX: 300
    property int bottomLeftY: 100
    property color fillColor: "skyblue"
    property real myOpacity:0.5
    property string labelText: "Label"          // Label
    property int fontSize: 12                   //
    property real flow:50                       //Flow (Width)
    property real pressure:100                  //Pressure (Height)


    Rectangle {
        width: rectWidth
        height:rectHeight
        color: fillColor
        border.color: "blue"
        opacity:myOpacity
        x: bottomLeftX
        y: bottomLeftY

        Text {
                    text: labelText
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 5
                    color: "black"
                    font {
                    pixelSize: Math.min(parent.width * 0.15, 14)
                    bold: true
                    capitalization: Font.AllUppercase
                    }
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.WordWrap
                }
        Text {
            text: pressure.toFixed(0) + " bar"
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
