import UIKit

public enum HumidistatStylesheet {

    // MARK: - Screen

    public enum Screen {
        static let screenSize: CGSize = UIScreen.main.bounds.size
        static let screenScale: CGFloat = UIScreen.main.scale
        static let singlePixelSize: CGFloat = 1.0 / screenScale
    }

    // MARK: - Colors

    public enum Color {
        static let darkBlue: UIColor = UIColor(red: 4.0 / 255.0, green: 10.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0) // #040A24
        static let yellow: UIColor = UIColor(red: 255.0 / 255.0, green: 216.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0) // #FFD80C
        static let blueBrand: UIColor = UIColor(red: 2.0 / 255.0, green: 170.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0) // #02AADE
        static let titleBlue: UIColor = UIColor(red: 60.0 / 255.0, green: 71.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0) // #3C4760
    }

    // MARK: - Fonts

    public enum FontFace: String {
        case montserratRegular = "Montserrat-Regular"
        case montserratBold = "Montserrat-Bold"
        case ageoRegular = "Ageo-Regular"
        case ageoExtraBold = "Ageo-ExtraBold"
    }
}

// MARK: - Helpers

public extension HumidistatStylesheet.FontFace {

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
