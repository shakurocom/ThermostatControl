//
//  FontsLoader.swift
//

import Foundation
import UIKit

private extension UIFont {

    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }
        return true
    }

}

public class FontsLoader {

    /**
     Downloads the necessary fonts for demo from the pod build.
     */
    public static func loadFonts() {
        let fonts: [(name: String, fontExtension: String)] = [(name: "Montserrat-Bold", fontExtension: "ttf")]
        for font in fonts {
            _ = UIFont.registerFont(bundle: Bundle.findBundleIfNeeded(for: FontsLoader.self), fontName: font.name, fontExtension: font.fontExtension)
        }

    }

}
