import UIKit

extension UIView {

    /// Rotates the view by the specified angle.
    /// - parameter angle: The angle, in radians, by which to rotate the affine transform.
    func rotate(by angle: CGFloat) {
        transform = transform.rotated(by: angle)
    }

}
