// Animation.qml (Triangular Wave with 4-Limit System)
import QtQuick 2.15

Item {
    id: root

    // 1. PARAMETRIC LIMITS (set from Main.qml)
    property real minAbsolute: 0.001      // Hard minimum (anti-zero)
    property real userMin: 0.4            // Custom minimum (>= minAbsolute)
    property real userMax: 0.6            // Custom maximum (<= maxAbsolute)
    property real maxAbsolute: 1.0        // Hard maximum

    // 2. TRIANGULAR WAVE CORE
    property real rawValue: 0
    property bool increasing: true
    property real stepSize: 0.01          // Adjust for smoothness

    // 3. PROCESSED OUTPUT
    property real constrainedValue: calculateConstrainedValue()
    property real heartBeat: 0.65 + (1 * constrainedValue) // Your formula

    // Triangular wave generator
    Timer {
        interval: 16 // ~60fps
        running: true
        repeat: true
        onTriggered: {
            if (increasing) {
                rawValue += stepSize;
                if (rawValue >= maxAbsolute) {
                    rawValue = maxAbsolute;
                    increasing = false;
                }
            } else {
                rawValue -= stepSize;
                if (rawValue <= minAbsolute) {
                    rawValue = minAbsolute;
                    increasing = true;
                }
            }
        }
    }

    // 4. LIMIT APPLICATION
    function calculateConstrainedValue() {
        // Properly map rawValue [0..1] to [userMin..userMax]
        return userMin + (rawValue * (userMax - userMin));
    }

    // 5. PARAMETER VALIDATION
    onUserMinChanged: {
        userMin = Math.max(minAbsolute, Math.min(userMax, userMin));
    }
    onUserMaxChanged: {
        userMax = Math.min(maxAbsolute, Math.max(userMin, userMax));
    }
}
