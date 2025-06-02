import QtQuick 2.15

Item {
   id: animatedArc
   width: 800
   height: 480
   visible:true

    // Expose key properties so they can be set from outside
   property real startAngle:5//minAngle           //minAngle in degree //5
   property real endAngle:50//maxAngle             //maxAngle in degree//50
  // property real movingAngle: 40              //moving...
   property real radiusFactor: 0

   property real minRadius: 100
   property real maxRadius:(treshingHydPower/maxPower)*treshingHydPower*10   //Power radius as a function of Max Power
   property real dynamicRadiusBase:treshingHydPower*maxPowerFactor//475  7.86 //minRadius + (maxRadius - minRadius) * (Math.sin(radiusFactor) + 1) / 1.3

   property real drumRectDistance: dynamicRadiusBase //150

  // property real stripperRectDistance
 //  property real beaterRectDistance

   property alias canvas: canvas

   property real drumPowerRadius:maxRadius //Drum top right rectangle will be attached to max power radius
   property real growingSpeed: 0.005//0.005
   property int movingDirection: 1

    Canvas {
        id: canvas
        anchors.fill: parent

        function polarToCartesian(centerX, centerY, radius, angleDegrees) {
            var angleRad = angleDegrees * Math.PI / 180;
            return {
                x: centerX + radius * Math.cos(angleRad),
                y: centerY - radius * Math.sin(angleRad)
            };
        }

        onPaint: {

            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var originX =mecOriginX                 //240 //mecOriwidth / 2;
            var originY =mecOriginY                 //432//height / 2;
            var dynamicRadius = dynamicRadiusBase   //
            var dynamicAngle = treshingHWratio //
///////////////// Old code ////////////////////////////////////////////////////
        //    ctx.beginPath();
        //    ctx.strokeStyle = "green";
         //   ctx.lineWidth = 4;

         //   var point = polarToCartesian(originX, originY, dynamicRadius, startAngle);
         //   var point = polarToCartesian(originX, originY, dynamicRadius, minAngle);
         //   ctx.moveTo(point.x, point.y);
          //  for (var angle = startAngle; angle <= endAngle; angle += 1) {
          //  for (var angle = minAngle; angle <= maxAngle; angle += 1) {
           //     point = polarToCartesian(originX, originY, dynamicRadius, angle);
           //     ctx.lineTo(point.x, point.y);
           // }
          //  ctx.stroke();
/////////////////////New Code//////////////////////////////////////////////////////////////
          //Draw green moving arc
           ctx.strokeStyle = "green";
           ctx.beginPath();
           ctx.arc(mecOriginX, mecOriginY,dynamicRadius, minAngle, maxAngle, true);
           ctx.lineWidth = 5;
           ctx.stroke();

///////////////////////////////////////////////////////////////////////////////////////////


        //Draw the dot
            var dot = polarToCartesian(originX, originY, dynamicRadius, dynamicAngle);
            ctx.beginPath();
            ctx.fillStyle = "red";
            ctx.arc(dot.x, dot.y, 5, 0, 2 * Math.PI);
            ctx.fill();
        //Draw radius
            ctx.beginPath();
            ctx.moveTo(originX, originY);
            ctx.lineTo(dot.x, dot.y);
            ctx.strokeStyle = "black";
            ctx.lineWidth = 2;
            ctx.stroke();
          /////////////// Draw Drum Rectangle (test)/////////////////////////////////
            var rectWidth =50//
            var rectHeight =50//
            var rectPos = polarToCartesian(originX, originY, drumRectDistance, dynamicAngle);
            ctx.beginPath();
            ctx.fillStyle = "yellow";
            ctx.rect(rectPos.x - rectWidth, rectPos.y, rectWidth, rectHeight);
            ctx.fill();
            ///////////Trying to write a centered label centered in a moving rectangle///////////////////////
            // Draw centered text
                       ctx.fillStyle = "black"
                       ctx.font = "12px sans-serif"
                       ctx.textAlign = "center"
                       ctx.textBaseline = "middle"
                       ctx.fillText("DRUM(test)",500,150)// to be modified...

            /////////////////////////////////////
          // Update canvas when values change
             onDynamicAngleChanged: requestPaint()
             onDynamicRadiusChanged: requestPaint()

        }
         /////Timer for simulating variable inputs
        // Timer {
        //   id:animationTimer
        //    interval: 60; running: true; repeat: true   //30
        //    onTriggered: {
        //        movingAngle += 1 * movingDirection;
        //
        //       if (movingAngle >= endAngle || movingAngle <= startAngle)
        //           movingDirection = -movingDirection;
        //
        //
        //        if (radiusFactor > Math.PI || radiusFactor < -Math.PI)
        //             growingSpeed = -growingSpeed;
        //
        //           canvas.requestPaint();
        //       }
        //   }
    }

}
