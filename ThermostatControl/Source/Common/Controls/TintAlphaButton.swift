import UIKit

class TintAlphaButton: StateAlphaButton {

    var selectedTintColor: UIColor?
    var normalTintColor: UIColor?

    override var isSelected: Bool {
        didSet {
            if let selectedTint = selectedTintColor, let normalTint = normalTintColor {
                tintColor = isSelected ? selectedTint : normalTint
            }
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

}
