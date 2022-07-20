import UIKit

enum TemperatureUnit {

    enum Constant {
        static let celsiusToFahrenheitScale: CGFloat = 9.0 / 5.0
        static let freezingPointOffset: CGFloat = 32
    }

    case fahrenheit
    case celsius

    var string: String {
        switch self {
        case .celsius:
            return "°С"
        case .fahrenheit:
            return "°F"
        }
    }

    func convertValue(_ value: CGFloat, toUnit: TemperatureUnit) -> CGFloat {
        let convertedValue: CGFloat
        switch (self, toUnit) {
        case (.fahrenheit, .celsius):
            // (32°F − 32) / 9/5 = 0°C
            convertedValue = (value - Constant.freezingPointOffset) / Constant.celsiusToFahrenheitScale
        case (.celsius, .fahrenheit):
            // (0°C × 9/5) + 32 = 32°F
            convertedValue = (value * Constant.celsiusToFahrenheitScale) + Constant.freezingPointOffset
        default:
            convertedValue = value
        }
        return convertedValue
    }

}
