//
//  ThermostatBundleHelper.swift
//

import Foundation
import UIKit

final class ThermostatBundleHelper {

    /// Return the current bundle.
    static let bundle: Bundle = {
        let thermostatBundle = Bundle(for: ThermostatViewController.self)
        if let thermostatBundleURL = thermostatBundle.url(forResource: "Thermostat", withExtension: "bundle"),
           let thermostatBundleInternal = Bundle(url: thermostatBundleURL) {
            return thermostatBundleInternal
        } else {
            return thermostatBundle
        }
    }()

    /// Registers the specified font from the bundle.
    /// - parameter name: font name.
    /// - parameter extension: font extensions.
    static func registerFont(name: String, fontExtension: String) {
        _ = UIFont.registerFont(fontName: name, fontExtension: fontExtension, bundle: bundle)
    }

    /// Registers the specified fonts from the bundle.
    static func registerFonts(_ fonts: [(fontName: String, fontExtension: String)]) {
        for font in fonts {
            registerFont(name: font.fontName, fontExtension: font.fontExtension)
        }
    }

    /// Reads an image with the specified name from the bundle.
    /// - parameter named: image name.
    static func readImage(named: String) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }

    /// Reads a color with the specified name from the bundle.
    /// - parameter named: color name.
    static func readColor(named: String) -> UIColor? {
        return UIColor(named: named, in: bundle, compatibleWith: nil)
    }

}
