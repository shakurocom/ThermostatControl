import UIKit

public enum Stylesheet {

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
