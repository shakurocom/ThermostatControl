import UIKit

struct ScaleStepRange {
    let range: ClosedRange<CGFloat> // from 0 to 100
    let animationProgressRange: ClosedRange<CGFloat> // from 0 to 1
    let passedSteps: CGFloat
    let stepsInRange: CGFloat
    let stepSize: CGFloat

    init(range: ClosedRange<CGFloat>,
         passedSteps: CGFloat,
         stepsInRange: CGFloat,
         stepSize: CGFloat) {
        self.range = range
        self.passedSteps = passedSteps
        self.stepsInRange = stepsInRange
        self.stepSize = stepSize
        let lowerBound: CGFloat = ScaleStepRange.convertToAnimationProgress(range.upperBound,
                                                                            range: range,
                                                                            passedSteps: passedSteps,
                                                                            stepsInRange: stepsInRange,
                                                                            stepSize: stepSize)
        let upperBound: CGFloat = ScaleStepRange.convertToAnimationProgress(range.lowerBound,
                                                                            range: range,
                                                                            passedSteps: passedSteps,
                                                                            stepsInRange: stepsInRange,
                                                                            stepSize: stepSize)
        animationProgressRange = lowerBound...upperBound
    }

    func animationProgressFrom(scaleValue: CGFloat) -> CGFloat {
        return ScaleStepRange.convertToAnimationProgress(scaleValue,
                                                         range: range,
                                                         passedSteps: passedSteps,
                                                         stepsInRange: stepsInRange,
                                                         stepSize: stepSize)
    }

    func scaleValueFrom(progress: CGFloat) -> CGFloat {
        let rangeScale = 1.0 - (progress - animationProgressRange.lowerBound) / (animationProgressRange.upperBound - animationProgressRange.lowerBound)
        let result = (range.lowerBound + (range.upperBound - range.lowerBound ) * rangeScale)
        return result
    }

    // MARK: - Private

    private static func convertToAnimationProgress(_ value: CGFloat,
                                                   range: ClosedRange<CGFloat>,
                                                   passedSteps: CGFloat,
                                                   stepsInRange: CGFloat,
                                                   stepSize: CGFloat) -> CGFloat {
        let rangeScale = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        let animationProgress = 1.0 - (passedSteps + rangeScale * stepsInRange) * stepSize
        return animationProgress
    }
}
