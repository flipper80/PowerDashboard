/////TO BE USED AS A SIGNAL GENARATOR DURING TEST PHASE (Later replaced by J1939 SPN received from Canbus)////
import QtQuick 2.15
//QtObject {
Item {
    property real value: 0.001  // initial non-zero value
    property real frequency: 1.0 // Hz
    property real step: 0.01     // adjusted internally
    property bool increasing: true

    Timer {
        id: updateTimer
        interval: 16 // ~60Hz
        running: true
        repeat: true
        onTriggered: {
            const period = 1000 / frequency;
            const halfPeriod = period / 2;
            step = 16 / halfPeriod; // normalize to 0-1 range over half a period

            if (increasing) {
                value += step;
                if (value >= 1.0) {
                    value = 1.0;
                    increasing = false;
                }
            } else {
                value -= step;
                if (value <= 0.001) {
                    value = 0.001;
                    increasing = true;
                }
            }
        }
    }

    function setFrequency(hz) {
        frequency = hz;
    }

    function getValue() {
        return value;
    }
}
