import UIKit

public enum Stylesheet {

    // MARK: - Colors

    public enum Color {
        public static let darkThermostat: UIColor = UIColor(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0) // #5F5F5F
        public static let redThermostat: UIColor = UIColor(red: 237.0/255.0, green: 33.0/255.0, blue: 91.0/255.0, alpha: 1.0) // #EC205B
    }

    // MARK: - Fonts

    public enum FontFace: String {
        case montserratBold = "Montserrat-Bold"
    }

}

// MARK: - Helpers

public extension Stylesheet.FontFace {

    func fontWithSize(_ size: CGFloat) -> UIFont {
        guard let actualFont: UIFont = UIFont(name: self.rawValue, size: size) else {
            debugPrint("Can't load fon with name!!! \(self.rawValue)")
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return actualFont
    }

    static func printAvailableFonts() {
        for name in UIFont.familyNames {
            debugPrint("<<<<<<< Font Family: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name) {
                debugPrint("Font Name: \(fontName)")
            }
        }
    }

}
