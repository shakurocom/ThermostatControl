//
//  SliderView.swift
//  ShakuroApp
//  Copyright © 2020 Shakuro. All rights reserved.

import Foundation
import UIKit

public class CustomSliderView: UIView {

    public enum Orientation {
        case vertical
        case horizontal
    }

    /// Track view's left radius. Default = 1.0
    public var leftRadius: CGFloat = 1.0

    /// Track view's left radius. Default = 8.0
    public var rightRadius: CGFloat = 8.0

    /// Defines the color of the tracker in the minimum side
    public var minimumTrackColor: UIColor? = UIColor.loadColorFromBundle(name: "RedThermostat") {
        didSet {
            updateColors()
        }
    }

    /// Defines the color of the tracker in the maximum side
    public var maximumTrackColor: UIColor? = UIColor.loadColorFromBundle(name: "DarkThermostat") {
        didSet {
            updateColors()
        }
    }

    // mask shape
    private var cMask = CAShapeLayer()

    /// Slider position value to update gradient layer
    public var value: Float = 0.0 {
        didSet {
            updateGradientLocations()
        }
    }

    /// View slider orientation
    public var orientation: Orientation = .horizontal {
        didSet {
            updateGradientPoints()
            updateMask()
        }
    }

    // allows layer to be a CAGradientLayer
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        updateColors()
        updateGradientPoints()
        updateGradientLocations()
        // mask self's layer
        updateMask()
        layer.mask = cMask

    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

}

// MARK: - Private

private extension CustomSliderView {

    private func updateColors() {
        let colors = [
            minimumTrackColor?.cgColor,
            minimumTrackColor?.cgColor,
            maximumTrackColor?.cgColor,
            maximumTrackColor?.cgColor
        ]
        gradientLayer?.colors = colors as [Any]
    }

    private func updateGradientLocations() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        gradientLayer?.locations = [
            0.0, value as NSNumber, value as NSNumber, 1.0
        ]
        CATransaction.commit()
    }

    private func updateGradientPoints() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        switch orientation {
        case .vertical:
            gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
        case .horizontal:
            gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        CATransaction.commit()

    }

    private func updateMask() {
        let bez = UIBezierPath()
        switch orientation {

        case .vertical:
            // define the "Rounded Wedge" shape
            let topCenter = CGPoint(x: bounds.midX, y: bounds.minY + leftRadius)
            let bottomCenter = CGPoint(x: bounds.midX, y: bounds.maxY - rightRadius)

            bez.addArc(withCenter: topCenter, radius: leftRadius, startAngle: .pi, endAngle: .pi * 2, clockwise: true)
            bez.addArc(withCenter: bottomCenter, radius: rightRadius, startAngle: .pi * 2, endAngle: .pi, clockwise: true)
            bez.close()
        case .horizontal:
            // define the "Rounded Wedge" shape
            let leftCenter = CGPoint(x: bounds.minX + leftRadius, y: bounds.midY)
            let rightCenter = CGPoint(x: bounds.maxX - rightRadius, y: bounds.midY)

            bez.addArc(withCenter: leftCenter, radius: leftRadius, startAngle: .pi * 0.5, endAngle: .pi * 1.5, clockwise: true)
            bez.addArc(withCenter: rightCenter, radius: rightRadius, startAngle: .pi * 1.5, endAngle: .pi * 0.5, clockwise: true)
            bez.close()
        }
        cMask.path = bez.cgPath

    }

}
