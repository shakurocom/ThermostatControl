import UIKit

extension UIView {

    func rotate(by angle: CGFloat) {
        transform = transform.rotated(by: angle)
    }

}
