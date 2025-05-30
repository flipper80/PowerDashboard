import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "components" as Components   //
import "data" as Data               //
import "utils" as Utils

Window {
    width: 800; height: 480 //CCPilot V700
    visible: true
    title: "Harvester Power Dashboard V0.1"

    //Set origins of Power graphs: and hydraulic (left),mechanical (right)
    property real mecOriginX: width * 0.3       // mechanical power XY coordinate and arcs center
    property real mecOriginY: height * 0.9      // mechanical power XY coordinate and arcs center
    property real hydOriginX: mecOriginX-200    //Hydraulic power X coordinate
    property real hydOriginY: mecOriginY        //Hydraulic power Y coordinate

    property real minAngle: 5 * (-Math.PI/180)  //5 Angle in degree arc starting (converted in radian)
    property real maxAngle: 50 * (-Math.PI/180) //50 Angle in degree arc ending (converted in radian)
    property real maxPower: 70                  //70 Max Power (kW)
    property real maxPowerFactor: 7.5           //7.5 Max Power scaling factor

/// TEST



//// Testing Triangular Animation
    Components.Animation {
                id: triWave
                userMin: 0.01  // Test with different values
                userMax: 0.55
                stepSize: 0.001//0.02
            }

            // Visual Debugger - Shows real-time values
            Column {
                anchors {
                        top: parent.top
                        topMargin: 20  // Space from top edge
                        horizontalCenter: parent.horizontalCenter
                    }
                spacing: 10

                // Raw value display
                Text {
                    text: "Raw Wave: " + triWave.rawValue.toFixed(3)
                    font.pixelSize: 16
                }

                // Constrained value display
                Text {
                    text: "Constrained: " + triWave.constrainedValue.toFixed(3)
                    font.pixelSize: 16
                    color: "blue"
                }

                // Heartbeat output
                Text {
                    text: "Heartbeat: " + triWave.heartBeat.toFixed(3)
                    font.pixelSize: 16
                    color: "green"
                }
               }

/////////////////////// LAUNCH ANIMATION GENERATOR /////////////////////////////////
    property bool treshingEngaged:true                                                  // Dislay will be different depending on treshing engaged
                                                                                        //to create If treshingEngaged...
    property real animationFactor: triWave.heartBeat//0.65+0.35=1 as base
// Temporary Animation factor: width, height of power rectangles grow / shrink 0.65 to 1.2 (second 0.35 should be replaced by value returned by Animation


//////INPUTS (ultimately provided by J1939  (All initial variable values are set at "nominal" (pressure in bar, speed RPM)////////
//////To be altered by TriangularSignal during test phase//////////////////////////////////////////////////////////////////////

    property real engineRPM: 1428                                                        //1428 Engine RPM (0-2000 rpm)
    property real beaterRPM: (210 /animationFactor ) -85                                //210 Beater RPM (0-300 rpm)
    property real stripperRPM: 225 /animationFactor                                      //225 Stripper RPM (0-300 rpm)
    property real drumRPM: 44 / animationFactor                                          //44 Drum RPM (0-80 rpm)
    property real chargePressure: 24                                                     //24 Charge pressure (0-30 bar)
    property real beaterDeltaP: 166 * animationFactor                                    //166 beater DeltaP Pressure (0-250 bar) DeltaP
    property real stripperDeltaP: 83 * animationFactor                                   //83 Stripper DeltaP Pressure(0-150 bar) DeltaP
    property real drumDeltaP: 49 * animationFactor                                       //49 Drum DeltaP Pressure (0-100 bar) DeltaP
    property real treshingPumpCommand: 0.65                                              //0.65-->123 l/mn flow at nominal variable treshing pump command (0-1)
    property real stripperMotorBypass: 0.5                                               //0.5 Stripper hydraulic motor swash plate (1 is full flow)
    property real beaterMotorBypass: 0.5                                                 //0.5 Beater hydraulic motor swash plate (1 is full flow)
    property real treshingFlow: ((engineRPM * engineReduction *treshingPumpCC) /1000)*treshingPumpCommand /(animationFactor+0)//123 Treshing system flow (all components in serie) (0-200 l/mn)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //Speed reductions
    property real engineReduction: 1/0.595  //Stiebel gearbox increasing speed
    property real beaterReduction: 8.6      //RR810 planetary reduction gear
    property real stripperReduction: 12.84  //RR310 planetary reduction gear
    property real drumReduction: 4.42       //Hydraulic wheel to drum reduction
    //Pumps displacements
    property real treshingPumpCC: 78        //Treshing pump displacement (cc)
    property real chargeCC: 17              //charge pump displacement (cc)

    ////// Calculated datas
    //Basically powers(drum, beater, stripper) are calculated throuh hydraulics pressure and flow (HydPowers)
    //reading components speeds we can calculate mechanical powers (mecPowers) from HydPower
    //Hydraulics
 //   property real treshingFlow: ((engineRPM * engineReduction *treshingPumpCC) /1000)*treshingPumpCommand /heartBeat     //123 Treshing system flow (all components in serie) (0-200 l/mn)
    property real chargeFlow: (engineRPM * engineReduction * chargeCC) /1000            //Charge pump flow (gear pump)
    property real beaterHydPower:(beaterDeltaP  * treshingFlow)/600
    property real stripperHydPower: (stripperDeltaP  * treshingFlow)/600
    property real drumHydPower: (drumDeltaP * treshingFlow)/600
    property real chargePower: (chargePressure * chargeFlow) /600                       //Charge pump power (kW)
    property real treshingHydPower: beaterHydPower + stripperHydPower + drumHydPower    //Treshing system total power (kW)

    //Mechanical
    property real beaterSpeed: ((beaterRPM * beaterReduction)/60)* 2 * Math.PI          //Speed in Radian/s
    property real stripperSpeed: ((stripperRPM * stripperReduction)/60)* 2 * Math.PI    //Speed in Radian/s
    property real drumSpeed: ((drumRPM * drumReduction)/60)* 2 * Math.PI                //Speed in Radian/s
    property real beaterTorque: beaterHydPower*1000 / beaterSpeed                       //Torque in Nm
    property real stripperTorque: stripperHydPower*1000 / stripperSpeed                 //Torque in Nm
    property real drumTorque: drumHydPower*1000 /drumSpeed                              //Torque in Nm
    property real drumRectWidth:drumRPM * drumRectangleXfactor                          //treshingFlow * treshingFlowXfactor
    property real drumRectHeight:drumTorque/drumRectangleYfactor

    property real treshingTorque: beaterTorque+stripperTorque+drumTorque                //Sum of beater, stripper, drum Torque in Nm
    property real pseudoMecSpeed: treshingHydPower*1000 /treshingTorque                 //Used for point on Power Arc calculation
    property real treshingHWratio: treshingTorque/pseudoMecSpeed                        // will be used to drive movingAngle


    //Loading background
    Components.AxisSystem {}

    //Loading powerArc
    Components.PowerArc{}

    //Calling Hydraulic power rectangles (Left)
    property real chargeXfactor:1.3
    property real chargeYfactor:1
    property real treshingFlowXfactor:1
    property real treshingPressureYfactor:1
    property real drumYOrigin: hydOriginY-drumDeltaP-chargePressure
    property real stripperYOrigin: drumYOrigin-stripperDeltaP
    property real beaterYOrigin: stripperYOrigin-beaterDeltaP
        //Charge pump
        Components.HydRectangle
        {
            rectWidth: chargeFlow * chargeXfactor
            rectHeight: chargePressure * chargeYfactor
            bottomLeftX: hydOriginX +5
            bottomLeftY: hydOriginY - (chargePressure*chargeYfactor)
            fillColor: "orange"
            myOpacity: 1
           labelText: "CHARGE"
            pressure: chargePressure
            fontSize: 12
        }
        //Drum
       Components.HydRectangle
        {
            rectWidth: treshingFlow * treshingFlowXfactor
            rectHeight: drumDeltaP *treshingPressureYfactor
            bottomLeftX: hydOriginX +5
            bottomLeftY:drumYOrigin
            fillColor: "yellow"
            myOpacity:1
            labelText: "DRUM"
            pressure: drumDeltaP
            fontSize: 12
        }
        //Stripper
        Components.HydRectangle
        {
            rectWidth: treshingFlow * treshingFlowXfactor
            rectHeight:stripperDeltaP * treshingPressureYfactor
            bottomLeftX: hydOriginX +5
            bottomLeftY:stripperYOrigin
            fillColor: "red"
            myOpacity: 0.9
            labelText: "STRIPPER"
            pressure: stripperDeltaP
            fontSize: 12
        }
        //Beater
        Components.HydRectangle
        {
            rectWidth: treshingFlow * treshingFlowXfactor
            rectHeight:beaterDeltaP*treshingPressureYfactor
            bottomLeftX: hydOriginX +5
            bottomLeftY: beaterYOrigin
            fillColor: "blue"
            myOpacity:0.5
            labelText: "BEATER"
            pressure: beaterDeltaP
            fontSize: 12
        }
    //Calling Parametric (mechanical) rectangles by their top right corner (DRUM, STRIPPER, BEATER)
    //Drum rectangle is the base for 2 other rectangles size calculation
    //Uses initial (nominal) variable values
    //X and Y factors are used to start with a square (Width=Height)
    //Initial rectangles (square) sizes are proportional to powers (vs drum power)
    property real drumRectangleXfactor:2.25
    property real drumRectangleYfactor: 5
    property real stripperRectangleXfactor:1.75
    property real stripperRectangleYfactor:2.28
    property real beaterRectangleXfactor:1.1
    property real beaterRectangleYfactor:1

    Components.ParametricRect
        {
            rectWidth: drumRectWidth//drumRPM * drumRectangleXfactor
            rectHeight:drumRectHeight//drumTorque/drumRectangleYfactor
            topRightX: 580    //580 800 is full right
            topRightY: 100    // 0 is top right
            fillColor: "yellow"
            labelText: "DRUM"
            rpm: drumRPM.toFixed(0)
            power: drumHydPower.toFixed(0)
            fontSize: 12
            visible: true
        }

    Components.ParametricRect
        {
            rectWidth: stripperRPM /stripperRectangleXfactor
            rectHeight:stripperTorque * stripperRectangleYfactor
            topRightX: 500                  //500 800 is full right
            topRightY: 150                  //150 0 is top right
            fillColor: "red"
            opacity:0.7
            labelText: "STRIPPER"
            rpm: stripperRPM.toFixed(0)
            power: stripperHydPower.toFixed(0)
            fontSize: 12
            visible: true
        }
    Components.ParametricRect
        {
            rectWidth: beaterRPM /beaterRectangleXfactor
            rectHeight:beaterTorque * beaterRectangleYfactor
            topRightX: 450                  //450 800 is full right
            topRightY: 200                  // 0 is top right
            fillColor: "blue"
            opacity:0.5
            labelText: "BEATER"
            rpm: beaterRPM.toFixed(0)
            power: beaterHydPower.toFixed(0)
            fontSize: 12
            visible:true
        }
    }
/////////////TEMPORARY TESTS (to be uncommented///////////////
 //   Column {
 //           anchors.left: parent.left
 //           anchors.margins: 30  // Optional, remove margins if needed
 //           spacing: 8
 //           Text {
 //               text: mecOriginX
 //               font.pixelSize: 14            }
 //           Text {
 //               text: mecOriginY
 //               font.pixelSize: 14            }
 //           Text {
 //               text: "Treshing Power: " + treshingHydPower.toFixed(2) +" kW"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "Drum Power " + drumHydPower+ " kW"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "charge power " + chargePower + " kW"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "drum speed " + drumSpeed.toFixed(2) +"Rd/s "+ drumRPM + " RPM"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "pseudo mechanical speed" +" "+ pseudoMecSpeed.toFixed(2)  + " ??"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "Total treshing torque" +" "+treshingTorque.toFixed(2)  + " Nm"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "Beater torque" +" "+beaterTorque.toFixed(2)  + " Nm"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "drum RPM" +" "+ drumRPM  + " RPM"
//                font.pixelSize: 14           }
 //           Text {
 //               text: "drum Torque" +" "+ drumTorque.toFixed(2)  + " Torque"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "stripper RPM" +" "+ stripperRPM.toFixed(2)  + " Torque"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "stripper Torque" +" "+ stripperTorque.toFixed(2)  + " Torque"
 //               font.pixelSize: 14           }
 //           Text {
 //               text: "treshing flow" +" "+ treshingFlow.toFixed(2)  + " l/mn"
 //               font.pixelSize: 14           }
//
 //   }



