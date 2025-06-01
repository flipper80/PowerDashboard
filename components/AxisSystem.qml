import QtQuick 2.15
Item {
    width: 800; height: 480
    visible: true

    ////////////////////////////////////////////////////////////////////
    // DRAW AXIS SYSTEM AND BACKGROUND
    ////////////////////////////////////////////////////////////////////

    property color axisColor: "black"
    property real axisThickness: 2
    property real axisXLength: 500
    property real axisYLength: 420
    property real hydAxisXLength: 120
    property real hydAxisYLength: 420

 //   property real minAngle: 5 * (-Math.PI/180)//Angle in degree arc starting (converted in radian)
 //   property real maxAngle: 50 * (-Math.PI/180)//Angle in degree arc ending (converted in radian)


    property real maxPowerRadius: maxPower * maxPowerFactor//Max Power Radius

    property real maxPressure: 380// Max pressure in bar
    property real maxPressureLenght: maxPressure * 1//scaling factor

    property string xAxisLabel: "SPEED (RPM)"
    property string yAxisLabel: "TORQUE (Nm)"
    property string xAxisHydLabel: "FLOW (l/mn)"
    property string yAxisHydLabel: "PRESSURE (bar)"
    property string maxPowerLabel: "Max Power "+maxPower+" kW"
    property string maxPressureLabel: "Max Pressure "+maxPressure+" bar"

    property real axisFontSize: 12

    ////////////////////////////////////////////////////////////////////
    // FIXED REFERENCE AXES (Non-interactive background)
    ////////////////////////////////////////////////////////////////////

    // X Axis mechanical power
    Canvas {
        id: xAxis
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = axisColor;
            ctx.lineWidth = axisThickness;

            // Main line
            ctx.beginPath();
            ctx.moveTo(mecOriginX, mecOriginY);
            ctx.lineTo(mecOriginX +axisXLength , mecOriginY);

            // Arrowhead
            ctx.lineTo(mecOriginX +axisXLength  - 10, mecOriginY - 5);
            ctx.moveTo(mecOriginX +axisXLength , mecOriginY);
            ctx.lineTo(mecOriginX + axisXLength - 10, mecOriginY + 5);

            ctx.stroke();

            // Label
            ctx.font = `${axisFontSize}px Sans-Serif`;
            ctx.fillText(xAxisLabel, mecOriginX +axisXLength  -100, mecOriginY + 20);
        }
    }

    // Y Axis mechanical power
    Canvas {
        id: yAxis
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = axisColor;
            ctx.lineWidth = axisThickness;

            // Main line
            ctx.beginPath();
            ctx.moveTo(mecOriginX, mecOriginY);
            ctx.lineTo(mecOriginX, mecOriginY -axisYLength);

            // Arrowhead
            ctx.lineTo(mecOriginX - 5, mecOriginY -axisYLength  + 10);
            ctx.moveTo(mecOriginX, mecOriginY -axisYLength );
            ctx.lineTo(mecOriginX + 5, mecOriginY -axisYLength  + 10);

            ctx.stroke();

            // Label
            ctx.save();
            ctx.translate(mecOriginX - 15, mecOriginY -axisYLength + 150);
            ctx.rotate(-Math.PI/2);
            ctx.font = `${axisFontSize}px Sans-Serif`;
            ctx.fillText(yAxisLabel, 0, 0);
            ctx.restore();
        }
    }

    // Arc Max Power
    Canvas {
        id: maxPowerArc
        anchors.fill: parent

    onPaint: {
       var ctx = getContext("2d");
       ctx.strokeStyle = "red";
       ctx.beginPath();
        ctx.arc(mecOriginX, mecOriginY, maxPowerRadius, minAngle, maxAngle, true);
        ctx.lineWidth = 5;
        ctx.stroke();
        // Label
        ctx.font = `${axisFontSize}px Sans-Serif`;
        ctx.fillText(maxPowerLabel, mecOriginX+450, 100);
        }
    }

    // X Axis Hydraulic power
    Canvas {
        id: xHydAxis
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = axisColor;
            ctx.lineWidth = axisThickness;

            // Main line
            ctx.beginPath();
            ctx.moveTo(hydOriginX, hydOriginY);
            ctx.lineTo(hydOriginX +hydAxisXLength, hydOriginY);

            // Arrowhead
            ctx.lineTo(hydOriginX +hydAxisXLength  - 10, hydOriginY - 5);
            ctx.moveTo(hydOriginX +hydAxisXLength , hydOriginY);
            ctx.lineTo(hydOriginX +hydAxisXLength  - 10, hydOriginY + 5);

            ctx.stroke();

            // Label
           ctx.font = `${axisFontSize}px Sans-Serif`;
           ctx.fillText(xAxisHydLabel, mecOriginX -220, mecOriginY + 20);
        }
    }

    // Y Axis hydraulic power
    Canvas {
        id: yHydAxis
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = axisColor;
            ctx.lineWidth = axisThickness;

            // Main line
            ctx.beginPath();
            ctx.moveTo(hydOriginX, hydOriginY);
            ctx.lineTo(hydOriginX, hydOriginY -hydAxisYLength );

            // Arrowhead
            ctx.lineTo(hydOriginX - 5, hydOriginY -hydAxisYLength  + 10);
            ctx.moveTo(hydOriginX, hydOriginY -hydAxisYLength );
            ctx.lineTo(hydOriginX + 5, hydOriginY -hydAxisYLength  + 10);

            ctx.stroke();

            // Label
            ctx.save();
            ctx.translate(hydOriginX - 15, hydOriginY- 250);
            ctx.rotate(-Math.PI/2);
            ctx.font = `${axisFontSize}px Sans-Serif`;
            ctx.fillText(yAxisHydLabel, 0, 0);
            ctx.restore();
        }
    }

    //Max hydraulic pressure line
    Canvas {
        id: maxHydPressure
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = "red";
            ctx.lineWidth = 5;

            // Main line
            ctx.beginPath();
            ctx.moveTo(hydOriginX, hydOriginY-maxPressureLenght);
            ctx.lineTo(hydOriginX +hydAxisXLength, hydOriginY-maxPressureLenght);


            ctx.stroke();

            // Label
            ctx.font = `${axisFontSize}px Sans-Serif`;
            ctx.fillText(maxPressureLabel,hydOriginX +15, hydOriginY-maxPressureLenght - 10);
        }
    }

    Text {
        text: "Nominal values before starting"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        font.pixelSize: 14
        color: "black"
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        wrapMode: Text.WordWrap
        }
}



