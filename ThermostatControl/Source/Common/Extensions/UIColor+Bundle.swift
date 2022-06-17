//
//  UIColor+Bundle.swift
//  Thermostat
//
//  Created by Eugene Klyuenkov on 17.06.2022.
//

import UIKit

extension UIColor {

    static func loadColorFromBundle(name: String) -> UIColor? {
        let podBundle = Bundle(for: ThermostatViewController.self)
        if let url = podBundle.url(forResource: "Thermostat", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIColor(named: name, in: bundle, compatibleWith: nil)
        } else {
            return UIColor(named: name)
        }
    }

}
