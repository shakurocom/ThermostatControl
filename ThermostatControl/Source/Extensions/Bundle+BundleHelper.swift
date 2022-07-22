//
//  ThermostatBundleHelper.swift
//

import Foundation
import UIKit
import Shakuro_CommonTypes

extension Bundle {

    static let thermostatBundleHelper: BundleHelper = {
        let bundleHelper = BundleHelper(targetClass: ThermostatViewController.self, bundleName: "Thermostat")
        bundleHelper.registerFont(name: "Montserrat-Bold", fontExtension: "ttf")
        return bundleHelper
    }()

}
