//
//  FontsLoader.swift
//  Thermostat
//
//  Created by Eugene Klyuenkov on 27.06.2022.
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
        let bundle: Bundle
        let podBundle = Bundle(for: ThermostatViewController.self)
        if let actualBundleURL = podBundle.url(forResource: "Thermostat", withExtension: "bundle"),
           let actualBundle = Bundle(url: actualBundleURL) {
            bundle = actualBundle
        } else {
            bundle = Bundle.main
        }
        for font in fonts {
            _ = UIFont.registerFont(bundle: bundle, fontName: font.name, fontExtension: font.fontExtension)
        }

    }

}
