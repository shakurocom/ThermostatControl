//
//  ThermostatBundleHelper.swift
//

import Foundation
import UIKit

class ThermostatBundleHelper {

    static let bundle: Bundle = findThermostatBundle()

    /**
     Downloads the necessary fonts for demo from the pod build.
     */
    static func loadFonts(_ fonts: [(fontName: String, fontExtension: String)]) {
        // TODO: - let fonts: [(name: String, fontExtension: String)] = [(name: "Montserrat-Bold", fontExtension: "ttf")]
        for font in fonts {
            loadFont(name: font.fontName, fontExtension: font.fontExtension)
        }
    }

    static func loadFont(name: String, fontExtension: String) {
        _ = UIFont.registerFont(fontName: name, fontExtension: fontExtension, bundle: bundle)
    }

    static func loadImage(named: String) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }

    static func loadColor(named: String) -> UIColor? {
        return UIColor(named: named, in: bundle, compatibleWith: nil)
    }

    // MARK: - Private

    private static func findThermostatBundle() -> Bundle {
        let thermostatBundle = Bundle(for: ThermostatViewController.self)
        if let thermostatBundleURL = thermostatBundle.url(forResource: "Thermostat", withExtension: "bundle"),
           let bundleThermostatBundle = Bundle(url: thermostatBundleURL) {
            return bundleThermostatBundle
        } else {
            return thermostatBundle
        }
    }

}
