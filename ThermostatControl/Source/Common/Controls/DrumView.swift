//
//  DrumView.swift
//  ShakuroApp

import UIKit
import Shakuro_CommonTypes

class DrumView: UIView {

    private enum Constant {
        static let maxValue: CGFloat = 1
        static let minValue: CGFloat = 0
        static let fullСycleAngle: CGFloat = .pi
        static let minimumDecelerationVelocity: CGFloat = (.pi / 180) * 4
        static let decelerationFactor: CGFloat = 0.92
    }

    var valueChanged: ((_ slider: DrumView) -> Void)?
    private(set) var value: SliderValue = SliderValue.zero()
    private(set) var valueTransformer: SliderValueTransformer = DefaultSliderValueTransformer()
    private(set) var unit: TemperatureUnit = .fahrenheit
    private(set) var maxValue: CGFloat = Constant.maxValue
    private(set) var minValue: CGFloat = Constant.minValue
    private(set) var angleToValueFactor: CGFloat = (Constant.maxValue - Constant.minValue) / Constant.fullСycleAngle

    private let spinnerImageView: UIImageView = UIImageView()
    private let shadowLayer = CAShapeLayer()

    private var circleGestureRecognizer: CircleGestureRecognizer!
    private var feedbackGenerator: UISelectionFeedbackGenerator?

    private let decelerationBehaviour = DecelerationBehaviour()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        decelerationBehaviour.stop()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = spinnerImageView.frame
        shadowLayer.shadowPath = UIBezierPath(roundedRect: spinnerImageView.bounds, cornerRadius: spinnerImageView.bounds.width * 0.5).cgPath
    }

    func setValueTransformer(_ valueTransformer: SliderValueTransformer,
                             selectedValue: CGFloat,
                             maxValue: CGFloat,
                             minValue: CGFloat,
                             fullСycleAngle: CGFloat = Constant.fullСycleAngle) {
        self.valueTransformer = valueTransformer
        self.maxValue = maxValue
        self.minValue = minValue
        angleToValueFactor = (maxValue - minValue) / fullСycleAngle
        setValue(selectedValue)
    }

    func setValue(_ newValue: CGFloat) {
        value = valueTransformer.transformed(rawValue: min(max(newValue, minValue), maxValue))
    }

}

// MARK: - Private

private extension DrumView {

    private func setup() {
        addSubview(spinnerImageView)
        spinnerImageView.contentMode = .center
        spinnerImageView.backgroundColor = UIColor.clear
        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        spinnerImageView.isUserInteractionEnabled = true

        spinnerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinnerImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        spinnerImageView.image = UIImage.loadImageFromBundle(name: "spinner")
        spinnerImageView.layoutIfNeeded()

        circleGestureRecognizer = CircleGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(circleGestureRecognizer)

        shadowLayer.shadowRadius = 80.0
        shadowLayer.shadowOffset = CGSize(width: -20.0, height: 0.0)
        shadowLayer.shadowColor = (UIColor(hex: "#99153B") ?? UIColor.clear).cgColor
        shadowLayer.shadowOpacity = 0.3

        layer.insertSublayer(shadowLayer, at: 0)

        decelerationBehaviour.minVelocity = Constant.minimumDecelerationVelocity
        decelerationBehaviour.decelerationFactor = Constant.decelerationFactor
    }

    private func update(by angle: CGFloat, clockwise: Bool) {
        let valueOffset = angle * angleToValueFactor
        let oldValue = value.transformed
        if clockwise {
            spinnerImageView.rotate(by: angle)
            setValue(value.raw + valueOffset)
        } else {
            spinnerImageView.rotate(by: -angle)
            setValue(value.raw - valueOffset)
        }
        if abs(oldValue - value.transformed) > CGFloat.ulpOfOne {
            valueChanged?(self)
            feedbackGenerator?.selectionChanged()
            feedbackGenerator?.prepare()
        }
    }

    private func decelerate(_ velocity: CGFloat, clockwise: Bool) -> Bool {
        decelerationBehaviour.stop()
        guard velocity >= Constant.minimumDecelerationVelocity else {
            return false
        }
        decelerationBehaviour.decelerate(velocity: velocity,
                                         update: { [weak self] (distance) in self?.update(by: distance, clockwise: clockwise) },
                                         completion: { [weak self] in self?.feedbackGenerator = nil })
        return true
    }

    @objc private func handlePanGesture(_ panGesture: CircleGestureRecognizer) {
        switch panGesture.state {
        case .possible:
            break
        case .began:
            decelerationBehaviour.stop()
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        case .changed:
            let angleOffset = abs(abs(panGesture.previousAngle) - abs(panGesture.angle))
            update(by: angleOffset, clockwise: panGesture.clockwise)
        case .cancelled, .failed:
            decelerationBehaviour.stop()
            feedbackGenerator = nil
        case .ended:
            if !decelerate(panGesture.angularVelocity, clockwise: panGesture.clockwise) {
                feedbackGenerator = nil
            }
        @unknown default:
            break
        }
    }

}
