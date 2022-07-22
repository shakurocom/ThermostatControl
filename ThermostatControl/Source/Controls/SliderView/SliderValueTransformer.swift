import UIKit

public struct SliderValue {
    let raw: CGFloat
    let transformed: CGFloat
    let string: String

    static func zero() -> SliderValue {
        return SliderValue(raw: 0, transformed: 0, string: "")
    }
}

public protocol SliderValueTransformer {
    func transformed(rawValue: CGFloat) -> SliderValue
}

public class DefaultSliderValueTransformer: SliderValueTransformer {

    let suffix: String
    let prefix: String
    let roundingThreshold: CGFloat

    private let formatter: NumberFormatter

    /**
     - parameter suffix: suffix to use when converting to string
     - parameter prefix: prefix to use when converting to string
     - parameter roundingThreshold: CGFLoat.rounded() method is used to transform value, but it returns integral values (i.e roundingThreshold == 1), to change this behavior use roundingThreshold parameter (for example threshold==0.5 will allow to round near 0.5 instead of 1)
     - parameter minimumFractionDigits: minimum fraction digits to use when converting to string
     - parameter maximumFractionDigits: maximum fraction digits to use when converting to string
     **/
    init(suffix: String = "",
         prefix: String = "",
         roundingThreshold: CGFloat = 1,
         minimumFractionDigits: Int = 0,
         maximumFractionDigits: Int = 0) {
        formatter = NumberFormatter()
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        self.roundingThreshold = roundingThreshold
        self.suffix = suffix
        self.prefix = prefix
    }

    public func transformed(rawValue: CGFloat) -> SliderValue {
        let rounded = rawValue.roundToNearest(roundingThreshold)
        return SliderValue(raw: rawValue,
                           transformed: rounded,
                           string: string(value: rounded))

    }

    public func string(value: CGFloat) -> String {
        let strValue = formatter.string(for: value) ?? String(format: "%.0f", value)
        return String(format: "%@%@%@", prefix, strValue, suffix)
    }

}
