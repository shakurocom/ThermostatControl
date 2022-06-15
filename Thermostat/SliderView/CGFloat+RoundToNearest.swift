import UIKit

extension CGFloat {
    func roundToNearest(_ threshold: CGFloat) -> CGFloat {
        let denominator = 1.0 / threshold
        return (self * denominator).rounded() / denominator
    }
}
