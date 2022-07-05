import UIKit

public class StateAlphaButton: UIButton {

    /// Alpha for selected state
    var selectedAlpha: CGFloat?

    override public var isHighlighted: Bool {
        didSet {
            updateAlpha()
        }
    }

    override public var isEnabled: Bool {
        didSet {
            updateAlpha()
        }
    }

    override public var isSelected: Bool {
        didSet {
            updateAlpha()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Private

    private func setup() {
        isExclusiveTouch = true
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }

    private func updateAlpha() {
        if !isEnabled {
            alpha = 0.3
        } else if isHighlighted {
            alpha = 0.6
        } else if let actualSelectedAlpha = selectedAlpha, isSelected {
            alpha = actualSelectedAlpha
        } else {
            alpha = 1.0
        }
    }
}
