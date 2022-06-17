import UIKit

public final class ScaleValueView: UIView {

    private enum Constant {
        static let markSize: CGFloat = 4.0
    }

    private let label: UILabel = UILabel()
    private let markView: UIView = UIView()

    convenience init(title: String, markIsHidden: Bool) {
        self.init(frame: CGRect.zero)
        setTitle(title: title, markIsHidden: markIsHidden)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Sets label for scale value view
    /// - Parameters:
    ///  - title: - Sets title for view
    ///  - markIsHidden - Sets mark hidden
    func setTitle(title: String, markIsHidden: Bool) {
        markView.isHidden = markIsHidden
        label.text = title
    }

    private func setup() {
        markView.translatesAutoresizingMaskIntoConstraints = false
        markView.clipsToBounds = true
        markView.backgroundColor = HumidistatStylesheet.Color.yellow
        markView.layer.cornerRadius = Constant.markSize * 0.5
        addSubview(markView)
        markView.widthAnchor.constraint(equalToConstant: Constant.markSize).isActive = true
        markView.heightAnchor.constraint(equalToConstant: Constant.markSize).isActive = true
        markView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9.0).isActive = true
        markView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = HumidistatStylesheet.FontFace.montserratBold.fontWithSize(16)
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: markView.trailingAnchor, constant: 4.0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
