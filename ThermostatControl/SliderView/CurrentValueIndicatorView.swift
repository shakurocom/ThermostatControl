import UIKit
import Rswift

final class CurrentValueIndicatorView: UIView {

    private enum Constant {
        static let labelOffset: CGFloat = 17.0
    }

    private let label: UILabel = UILabel()
    private let bgImageView: UIImageView = UIImageView(image: R.image.humidistatShadow())
    private var gradient: UIImage?
    private var lastProgress: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setGradientImage(_ image: UIImage?) {
        gradient = image
        label.textColor = getColor(progress: lastProgress)
    }

    func setTitle(title: String,
                  progress: CGFloat,
                  animated: Bool) {
        lastProgress = progress
        if title != label.text {
            if animated {
                label.layer.addTransitionAnimation(duration: 0.2)
            }
            label.textColor = getColor(progress: progress)
            label.text = title
        }
    }
}

// MARK: - Private

private extension CurrentValueIndicatorView {

    func setup() {
        bgImageView.contentMode = .scaleToFill
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImageView.frame = bounds
        addSubview(bgImageView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = HumidistatStylesheet.FontFace.montserratBold.fontWithSize(24)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func getColor(progress: CGFloat) -> UIColor {
        guard let actualGradient = gradient,
            let cgImage = actualGradient.cgImage,
            let pixelData = cgImage.dataProvider?.data  else {
                return UIColor.white
        }
        let imageSize = actualGradient.size
        let originX: Int = 0
        let originY: Int = Int((imageSize.height - 1) * progress)

        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let pixelInfo: Int = ((Int(imageSize.width) * originY) + originX) * bytesPerPixel
        let red = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let green = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let blue = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
