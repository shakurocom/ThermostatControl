import UIKit

public class TintAlphaButton: StateAlphaButton {

    /// Button tint color when pressed.
    var selectedTintColor: UIColor?

    /// Normal button tint color.
    var normalTintColor: UIColor?

    override public var isSelected: Bool {
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
