//
//  UIImage+Bundle.swift
//

import UIKit

extension UIImage {

    static func loadImageFromBundle(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.findBundleIfNeeded(for: ThermostatViewController.self), compatibleWith: nil)
    }

}
