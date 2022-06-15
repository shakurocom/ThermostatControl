//
//  TermostatViewController.swift
//  ShakuroApp
//
//  Created by Andrey on 06.07.2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

protocol TemperatureInfo {
    var value: CGFloat { get }
    /// unit - unit of TemperatureInfo.value, it will be used to convert value in case of TemperatureInfo.unit != AirConditionerViewController.currentUnit
    var unit: TemperatureUnit { get }
}

public class ThermostatViewController: UIViewController {

    enum Constant {
        static let screenHeight: CGFloat = 926.0
        static let screenWidtht: CGFloat = 428.0
    }

    @IBOutlet private var containerView: UIView!

    @IBOutlet private var drumView: DrumView!

    @IBOutlet private var temperatureUnitTitleLabel: UILabel!
    @IBOutlet private var temperatureTitleLabel: UILabel!
    @IBOutlet private var temperatureValueLabel: UILabel!

    @IBOutlet private var sheduleTitleLabel: UILabel!

    @IBOutlet private var powerContainerView: UIView!
    @IBOutlet private var powerLabel: UILabel!

    @IBOutlet private var heatingButton: TintAlphaButton!
    @IBOutlet private var wateringButton: TintAlphaButton!
    @IBOutlet private var coolingButton: TintAlphaButton!

    @IBOutlet private var customSliderView: CustomSliderView!
    @IBOutlet private var theSlider: UISlider!
    @IBOutlet private var coolerImage: UIImageView!

    private(set) var currentUnit: TemperatureUnit = .fahrenheit

    private var currentTemperatureInfo: TemperatureInfo?
    private var conditionerIsOn: Bool = false
    private var powerGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer() // Change .minimumPressDuration, to adjust delay for power button (0.5 by default)
    private var powerPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer() // used to highlight power view

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#1A1A1A") ?? .clear
        // set left- and right-side "track" images to empty images
        theSlider.setMinimumTrackImage(UIImage(), for: .normal)
        theSlider.setMaximumTrackImage(UIImage(), for: .normal)

        // add target for the slider
        theSlider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: .valueChanged)

        // set intitial values
        theSlider.value = 0.5
        customSliderView.value = 0.5

        powerGestureRecognizer.delegate = self
        powerPressGestureRecognizer.delegate = self
        powerContainerView.addGestureRecognizer(powerGestureRecognizer)
        powerContainerView.addGestureRecognizer(powerPressGestureRecognizer)
        powerGestureRecognizer.addTarget(self, action: #selector(handlePowerLongPress(_:)))

        powerPressGestureRecognizer.minimumPressDuration = TimeInterval.ulpOfOne
        powerPressGestureRecognizer.addTarget(self, action: #selector(handlePowerPress(_:)))

        let selectedImage: UIImage? = UIImage(named: "buttonSelected")
        let normalImage: UIImage? = UIImage(named: "normalButton")
        let normalTint = UIColor(named: "DarkThermostat")
        let selectedTint = UIColor.white
        [heatingButton, wateringButton, coolingButton].forEach { (button: TintAlphaButton) in
            button.isExclusiveTouch = true
            button.setBackgroundImage(normalImage, for: .normal)
            button.setBackgroundImage(normalImage, for: [.normal, .highlighted])
            button.setBackgroundImage(selectedImage, for: .selected)
            button.setBackgroundImage(selectedImage, for: [.selected, .highlighted])
            button.setTitleColor(normalTint, for: .normal)
            button.setTitleColor(normalTint, for: [.normal, .highlighted])
            button.setTitleColor(selectedTint, for: .selected)
            button.setTitleColor(selectedTint, for: [.selected, .highlighted])
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = UIColor.clear
            button.selectedTintColor = selectedTint
            button.normalTintColor = normalTint
        }
        heatingButton.setImage(UIImage(named: "sun"), for: .normal)
        wateringButton.setImage(UIImage(named: "water"), for: .normal)
        coolingButton.setImage(UIImage(named: "snow"), for: .normal)

        // TODO: Initital value
        let selectedValue: CGFloat
        switch currentUnit {
        case .fahrenheit:
            selectedValue = 70
        case .celsius:
            selectedValue = TemperatureUnit.fahrenheit.convertValue(70, toUnit: .celsius) // how to convert example
        }
        setUnit(currentUnit, selectedValue: selectedValue)

        drumView.valueChanged = { [weak self] (_) in
            guard let actualSelf = self else {
                return
            }
            // TODO: handle value changes
            // let unit = actualSelf.currentUnit
          /*  switch unit {
            case .fahrenheit:
                let fahrenheit = slider.value
                // let celsius = unit.convertValue(fahrenheit, toUnit: .celsius)
//                debugPrint("fahrenheit slider value changed: fahrenheit \(fahrenheit) celsius \(celsius)")
            case .celsius:
                let celsius = slider.value
                // let fahrenheit = unit.convertValue(celsius, toUnit: .fahrenheit)
//                debugPrint("celsius slider value changed: celsius \(celsius) fahrenheit \(fahrenheit)")
            }*/
            actualSelf.temperatureValueLabel.text = actualSelf.drumView.value.string
        }

        selectModeButton(heatingButton)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentViewSize: CGSize = view.bounds.size
        if Constant.screenHeight > currentViewSize.height || Constant.screenWidtht > currentViewSize.width {
            let scale = min(currentViewSize.height / Constant.screenHeight, currentViewSize.width / Constant.screenWidtht)
            containerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func switchToUnit(_ unit: TemperatureUnit) {
        let oldUnit = currentUnit
        guard isViewLoaded else {
            currentUnit = unit
            return
        }
        setUnit(unit, selectedValue: oldUnit.convertValue(drumView.value.transformed, toUnit: unit))
    }

    func setUnit(_ unit: TemperatureUnit, selectedValue: CGFloat) {
        currentUnit = unit
        temperatureUnitTitleLabel.text = currentUnit.string
        setSliderUnit(currentUnit, selectedValue: selectedValue)
    }

    func setSliderUnit(_ unit: TemperatureUnit, selectedValue: CGFloat) {
        let valueTransformer: SliderValueTransformer
        let maxUnitValue: CGFloat
        let minUnitValue: CGFloat
        let fontSize: CGFloat

        switch unit {
        case .fahrenheit:
            valueTransformer = DefaultSliderValueTransformer.fahrenheitValueTransformer()
            fontSize = 140
            maxUnitValue = 99
            minUnitValue = 45
        case .celsius:
            valueTransformer = DefaultSliderValueTransformer.celsiusValueTransformer()
            fontSize = 80
            maxUnitValue = 37
            minUnitValue = 7
        }
        drumView.setValueTransformer(valueTransformer, selectedValue: selectedValue, maxValue: maxUnitValue, minValue: minUnitValue)
        temperatureValueLabel.text = drumView.valueTransformer.transformed(rawValue: selectedValue).string
        temperatureValueLabel.font = HumidistatStylesheet.FontFace.montserratBold.fontWithSize(fontSize)
    }

    // MARK: - Actions

    @IBAction private func modeButtonPressed(_ sender: UIButton) {
        selectModeButton(sender)
    }

    // TODO: - To remove, debug only
    @IBAction private func unitSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            switchToUnit(.celsius)
        } else {
            switchToUnit(.fahrenheit)
        }
    }

    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
            customSliderView.value = slider.value

            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .ended:
                    animateCooler()
                default:
                    break
                }
            }
    }

    func setOn(_ isOn: Bool) {
        conditionerIsOn = isOn
        powerLabel.text = isOn ? NSLocalizedString("Hold to turn AC off", comment: "") : NSLocalizedString("Hold to turn AC on", comment: "")
    }

    func selectModeButton(_ button: UIButton) {
        guard !button.isSelected else {
            return
        }
        button.isSelected = true
        switch button {
        case heatingButton:
            wateringButton.isSelected = false
            coolingButton.isSelected = false

        case wateringButton:
            heatingButton.isSelected = false
            coolingButton.isSelected = false

        case coolingButton:
            heatingButton.isSelected = false
            wateringButton.isSelected = false

        default:
            break
        }
    }

}

// MARK: - UIGestureRecognizerDelegate

extension ThermostatViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === powerGestureRecognizer || gestureRecognizer === powerPressGestureRecognizer
    }
}

// MARK: - Private

private extension ThermostatViewController {

    @objc func handlePowerPress(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .possible, .changed:
            break
        case .began:
            powerContainerView.alpha = 0.7
        case .cancelled, .failed, .ended:
            powerContainerView.alpha = 1.0
        @unknown default:
            break
        }
    }

    @objc func handlePowerLongPress(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .possible, .changed, .ended, .cancelled, .failed:
            break
        case .began:
            powerPressGestureRecognizer.isEnabled = false
            powerPressGestureRecognizer.isEnabled = true
            setOn(!conditionerIsOn)
        @unknown default:
            break
        }
    }

    func animateCooler() {
        UIView.animate(withDuration: 0.5) {
            self.coolerImage.transform = CGAffineTransform(scaleX: 6, y: 6)
            self.coolerImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.coolerImage.transform = .identity
        }
    }

}
