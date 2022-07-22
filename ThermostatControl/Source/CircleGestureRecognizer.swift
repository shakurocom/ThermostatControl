import UIKit
import Shakuro_CommonTypes

public class CircleGestureRecognizer: UIPanGestureRecognizer {

    /// Angle in the interval [-pi,+pi] radians
    private(set) var angle: CGFloat = 0 {
        didSet {
            previousAngle = oldValue
        }
    }
    private(set) var previousAngle: CGFloat = 0

    /// Returns a value specifying the angular velocity of the gesture.
    public var angularVelocity: CGFloat {
        guard let actualView = view, let location = touchLocation() else {
            return 0
        }
        let touchVelocity = velocity(in: actualView)
        let magnitude = sqrt((touchVelocity.x * touchVelocity.x) + (touchVelocity.y * touchVelocity.y)) // The Pythagorean Theorem
        let radius = location.distance(to: .zero)
        return magnitude / radius // relationship between angular velocity and linear ω=v/r.
    }

    /// Returns a boolean value specifying the direction of the gesture.
    public var clockwise: Bool {
        return velocity(in: view).y < 0.0
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let location = touchLocation() else {
            state = .failed
            return
        }
        angle = angleBetweenXAsisForPoint(point: location)
        previousAngle = angle
        state = .began
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let location = touchLocation() else {
            state = .failed
            return
        }
        switch state {
        case .began, .changed:
            angle = angleBetweenXAsisForPoint(point: location)
            state = .changed
        default:
            break
        }
    }

}

// MARK: - Private

private extension CircleGestureRecognizer {

    func touchLocation() -> CGPoint? {
        guard let actualView = view else {
            return nil
        }
        let touchLocation = location(in: actualView)
        let viewSize = actualView.bounds.size
        return CGPoint(x: touchLocation.x - viewSize.width * 0.5, y: viewSize.height * 0.5 - touchLocation.y)
    }

    func angleBetweenXAsisForPoint(point: CGPoint) -> CGFloat {
        return atan2(point.y, point.x)
    }

}
