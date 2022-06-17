import UIKit
import Lottie

final class SliderView: UIView {

    enum ScaleColoring {
        case type1 // red-blue-red
        case type2 // red-blue
    }

    var valueChanged: ((_ slider: SliderView) -> Void)?
    var stickToNearestValue: Bool = false

    var feedbackEnabled: Bool = true {
        didSet {
            if !feedbackEnabled {
                feedbackGenerator = nil
            }
        }
    }

    private(set) var valueTransformer: SliderValueTransformer = DefaultSliderValueTransformer()

    private(set) var sliderValue: SliderValue = SliderValue.zero()
    var value: CGFloat {
        return sliderValue.transformed
    }

    private let sliderView: LOTAnimationView = LOTAnimationView()
    private let indicatorView: CurrentValueIndicatorView = CurrentValueIndicatorView()

    private let scaleContainerView: UIView = UIView()
    private let scaleStackView: UIStackView = UIStackView()

    private var scaleStackViewTop: NSLayoutConstraint!
    private var scaleStackViewBottom: NSLayoutConstraint!
    private var indicatorViewPositionConstraint: NSLayoutConstraint!

    private let panGesturerecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()

    private var startThumbPosition: CGFloat = 0
    private var workAreaHeight: CGFloat = 0

    private var ranges: [ScaleStepRange] = []

    private var feedbackGenerator: UISelectionFeedbackGenerator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    /**
     - parameter coloring: type of gradient on scale
     **/
    func setColoringType(_ coloringType: ScaleColoring) {
        switch coloringType {
        case .type1:
            sliderView.setAnimation(named: "HumidistatSlider")
            indicatorView.setGradientImage(UIImage(named: "gradient"))
        case .type2:
            sliderView.setAnimation(named: "ConditioningSlider")
            indicatorView.setGradientImage(UIImage(named: "gradientConditioning"))
        }
    }

    /**
     - parameter ranges: all ranges of non linear scale
     - parameter valueSuffix: String for example %
     - parameter scaleValues: scale control values, markIsHidden - show or do not show yellow dot near value label
     - parameter selectedValue: currently selected value
     **/
    func setRanges(_ ranges: [ScaleStepRange],
                   valueTransformer: SliderValueTransformer,
                   scaleValues: [(value: CGFloat, markIsHidden: Bool)],
                   selectedValue: CGFloat) {
        var arrangedSubviews = scaleStackView.arrangedSubviews
        while arrangedSubviews.count > scaleValues.count {
            let toRemove = arrangedSubviews.removeLast()
            toRemove.removeFromSuperview()
        }
        for index in 0..<scaleValues.count {
            let scaleValue = scaleValues[index]
            let transformed = valueTransformer.transformed(rawValue: scaleValue.0)
            if index < arrangedSubviews.count,
                let view = arrangedSubviews[index] as? ScaleValueView {
                view.setTitle(title: transformed.string, markIsHidden: scaleValue.1)
            } else {
                let view = ScaleValueView(title: transformed.string, markIsHidden: scaleValue.1)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: Constant.scaleValueViewHeight).isActive = true
                scaleStackView.addArrangedSubview(view)
            }
        }
        self.valueTransformer = valueTransformer
        self.ranges = ranges
        setValue(selectedValue)
        updateLayout()
    }

    /**
     - parameter value: value from any range of ranges: [ScaleStepRange] see setup func
     **/
    func setValue(_ newValue: CGFloat) {
        let newSliderValue = valueTransformer.transformed(rawValue: newValue)
        guard let actualRange = ranges.first(where: { $0.range.contains(newSliderValue.transformed) }) else {
            if !ranges.isEmpty {
                assertionFailure("\(type(of: self)) - \(#function): . wrong value \(newValue)")
            }
            return
        }
        sliderValue = newSliderValue
        sliderView.animationProgress = actualRange.animationProgressFrom(scaleValue: sliderValue.transformed)
        indicatorView.setTitle(title: sliderValue.string,
                               progress: sliderView.animationProgress,
                               animated: window != nil)
        updateIndicatorViewPosition()
    }
}

// MARK: - Private

private extension SliderView {

    enum Constant {
        static let lottieCanvasSize = CGSize(width: 123.0, height: 812.0)
        static let lottieCanvasAspectRatio: CGFloat = lottieCanvasSize.height / lottieCanvasSize.width
        static let shadowOffset: CGFloat = -15.0
        static let scaleViewWidth: CGFloat = 73.0

        static let topScaleViewRelativeOffset: CGFloat = 6.05
        static let bottomScaleViewRelativeOffset: CGFloat = 7.35

        static let scaleValueViewHeight: CGFloat = 24

        static let scaleStepSize: CGFloat = 1.0 / 9.0 // 1.0 / control points count

        static let animationSpeed: CGFloat = 10
        static let sliderWorkAreaHeightFactor: CGFloat = 540.0 / lottieCanvasSize.height

        static let lottieThumbSize: CGFloat = 40.0
        static let thumbHitAreaHeight: CGFloat = 140 // Could be changed to increase/decrease touch area

        // Range in sliderThumb coordinate space where touch should be handled (X axis limited by slider view width)
        static let hitAreaInset: CGFloat = (thumbHitAreaHeight - lottieThumbSize) * 0.5
        static let thumbYAxisHitRange: ClosedRange<CGFloat> = -hitAreaInset...(lottieThumbSize + hitAreaInset)
    }

    func setup() {
        let mainBackgroundColor = HumidistatStylesheet.Color.darkBlue
        backgroundColor = mainBackgroundColor

        addSubview(scaleContainerView)
        addSubview(sliderView)
        scaleContainerView.addSubview(scaleStackView)
        scaleContainerView.addSubview(indicatorView)

        // Setup slider View
        sliderView.contentMode = .scaleAspectFit
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.isUserInteractionEnabled = true

        sliderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sliderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor,
                                           multiplier: Constant.lottieCanvasAspectRatio).isActive = true
        sliderView.animationSpeed = Constant.animationSpeed

        // Setup scale View
        scaleContainerView.backgroundColor = mainBackgroundColor
        scaleContainerView.translatesAutoresizingMaskIntoConstraints = false
        scaleContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scaleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sliderView.leadingAnchor.constraint(equalTo: scaleContainerView.trailingAnchor, constant: Constant.shadowOffset).isActive = true
        scaleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scaleContainerView.widthAnchor.constraint(equalToConstant: Constant.scaleViewWidth).isActive = true

        scaleStackView.translatesAutoresizingMaskIntoConstraints = false
        scaleStackView.axis = .vertical
        scaleStackView.distribution = .equalSpacing
        scaleStackView.alignment = .fill

        scaleStackView.leadingAnchor.constraint(equalTo: scaleContainerView.leadingAnchor).isActive = true
        scaleStackView.trailingAnchor.constraint(equalTo: scaleContainerView.trailingAnchor).isActive = true
        scaleStackViewTop = scaleStackView.topAnchor.constraint(equalTo: scaleContainerView.topAnchor)
        scaleStackViewTop.isActive = true
        scaleStackViewBottom = scaleContainerView.bottomAnchor.constraint(equalTo: scaleStackView.bottomAnchor)
        scaleStackViewBottom.isActive = true

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.widthAnchor.constraint(equalTo: scaleContainerView.widthAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: scaleContainerView.heightAnchor, multiplier: Constant.scaleStepSize * 2.0).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: scaleContainerView.leadingAnchor).isActive = true
        indicatorViewPositionConstraint = indicatorView.centerYAnchor.constraint(equalTo: scaleStackView.topAnchor, constant: Constant.scaleValueViewHeight * 0.5)
        indicatorViewPositionConstraint.isActive = true
        sliderView.addGestureRecognizer(panGesturerecognizer)
        panGesturerecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        setValue(0)
        updateLayout()
    }

    func updateLayout() {
        let totalHeight: CGFloat = bounds.size.height
        scaleStackViewTop.constant = totalHeight / Constant.topScaleViewRelativeOffset
        scaleStackViewBottom.constant = totalHeight / Constant.bottomScaleViewRelativeOffset
        sliderView.layoutIfNeeded()
        workAreaHeight = sliderView.bounds.size.height * Constant.sliderWorkAreaHeightFactor
        updateIndicatorViewPosition()
    }

    @objc func updateIndicatorViewPosition() {
        scaleContainerView.layoutIfNeeded()
        scaleStackView.layoutIfNeeded()
        let progress = sliderView.animationProgress
        let centerOffset = Constant.scaleValueViewHeight * (0.5 - progress)
        let newOffset = scaleStackView.bounds.size.height * progress + centerOffset
        indicatorViewPositionConstraint.constant = newOffset
    }

    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: sliderView)
            let thumbPoint = sliderView.convert(location, toKeypathLayer: LOTKeypath(string: "Slider"))
            if Constant.thumbYAxisHitRange.contains(thumbPoint.y) {
                startThumbPosition = workAreaHeight * sliderView.animationProgress
            } else {
                recognizer.isEnabled = false
                recognizer.isEnabled = true
            }
            if feedbackEnabled {
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                feedbackGenerator = generator
            }
        case .changed:
            guard workAreaHeight > 0 else {
                return
            }
            let progress = max(min((startThumbPosition + recognizer.translation(in: sliderView).y) / workAreaHeight, 1.0), 0.0)
            guard let actualRange = ranges.first(where: { $0.animationProgressRange.contains(progress) }) else {
                if !ranges.isEmpty {
                    assertionFailure("\(type(of: self)) - \(#function): . wrong progress \(progress)")
                }
                return
            }
            sliderView.animationProgress = progress
            let oldValue = sliderValue.transformed
            sliderValue = valueTransformer.transformed(rawValue: actualRange.scaleValueFrom(progress: progress))
            indicatorView.setTitle(title: sliderValue.string,
                                   progress: sliderView.animationProgress,
                                   animated: window != nil)
            updateIndicatorViewPosition()
            if abs(oldValue - sliderValue.transformed) > CGFloat.ulpOfOne {
                feedbackGenerator?.selectionChanged()
                valueChanged?(self)
                feedbackGenerator?.prepare()
            }
        case .ended,
             .cancelled,
             .failed:
            feedbackGenerator = nil
            guard stickToNearestValue else {
                return
            }
            guard let actualRange = ranges.first(where: { $0.range.contains(sliderValue.transformed) }) else {
                if !ranges.isEmpty {
                    assertionFailure("\(type(of: self)) - \(#function): . wrong value \(sliderValue.transformed)")
                }
                return
            }
            let newProgress = actualRange.animationProgressFrom(scaleValue: sliderValue.transformed)
            guard abs(newProgress - sliderView.animationProgress) > CGFloat.ulpOfOne else {
                return
            }
            indicatorView.setTitle(title: sliderValue.string,
                                   progress: newProgress,
                                   animated: false)
            let timer: CADisplayLink = CADisplayLink(target: self, selector: #selector(updateIndicatorViewPosition))
            timer.add(to: RunLoop.main, forMode: .common)
            sliderView.play(fromProgress: sliderView.animationProgress, toProgress: newProgress) { [weak self] (_) in
                timer.invalidate()
                self?.updateIndicatorViewPosition()
            }
        case .possible:
            break
        @unknown default:
            break
        }
    }
}
