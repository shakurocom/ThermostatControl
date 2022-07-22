import UIKit

extension DefaultSliderValueTransformer {

    static func humidityValueTransformer() -> SliderValueTransformer {
        return DefaultSliderValueTransformer(suffix: "%")
    }

    static func celsiusValueTransformer() -> SliderValueTransformer {
        return DefaultSliderValueTransformer(suffix: "",
                                             prefix: "",
                                             roundingThreshold: 0.5,
                                             minimumFractionDigits: 1,
                                             maximumFractionDigits: 1)
    }

    static func fahrenheitValueTransformer() -> SliderValueTransformer {
        return DefaultSliderValueTransformer(suffix: "",
                                             prefix: "",
                                             roundingThreshold: 1.0,
                                             minimumFractionDigits: 0,
                                             maximumFractionDigits: 0)
    }

}
