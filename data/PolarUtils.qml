// PolarUtils.qml
pragma Singleton
import QtQuick 2.15

QtObject {
    // Conversion polaire -> cartésien
    function polarToCartesian(centerX, centerY, radius, angleDeg) {
        var angleRad = angleDeg * Math.PI / 180;
        return {
            x: centerX + radius * Math.cos(angleRad),
            y: centerY + radius * Math.sin(angleRad)
        }
    }

    // Conversion cartésien -> polaire
    function cartesianToPolar(centerX, centerY, x, y) {
        var dx = x - centerX;
        var dy = y - centerY;
        var radius = Math.sqrt(dx*dx + dy*dy);
        var angleRad = Math.atan2(dy, dx);
        var angleDeg = angleRad * 180 / Math.PI;
        return {
            radius: radius,
            angleDeg: angleDeg
        }
    }
}

