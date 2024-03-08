import UIKit
import KhenshinProtocol

extension UIView {
    func center(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

class HeaderView: UIView {
    private var operationInfo: OperationInfo?
    private var headerColor: UIColor?

    init(headerColor: UIColor) {
        self.headerColor = headerColor
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func updateHeaderValue(with operationInfo: OperationInfo) {
        self.operationInfo = operationInfo
        setupUI()
    }

    private func createRectangle(height: CGFloat) -> UIView {
        let rectangle = UIView()
        rectangle.layer.borderWidth = 0.6
        rectangle.layer.borderColor = UIColor.lightGray.cgColor
        rectangle.layer.cornerRadius = 1
        rectangle.heightAnchor.constraint(equalToConstant: height).isActive = true
        return rectangle
    }

    private func createHorizontalStackView(withPercentages percentages: [CGFloat]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for percentage in percentages {
            let square = UIView()
            stackView.addArrangedSubview(square)
            square.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: percentage).isActive = true
        }

        return stackView
    }

    private func createLowerRectangle() -> UIView {
        let rectangle = UIView()
        rectangle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let borderThickness: CGFloat = 0.5
        rectangle.layer.borderWidth = borderThickness
        let borderColor = UIColor.lightGray.cgColor
        rectangle.layer.borderColor = borderColor
        rectangle.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return rectangle
    }

    private func setupUI() {
        subviews.forEach { $0.removeFromSuperview() }

        guard let operationInfo = operationInfo else {
            return
        }

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.backgroundColor = headerColor

        let upperRectangle = createRectangle(height: 30)
        stackView.addArrangedSubview(upperRectangle)

        let percentages: [CGFloat] = [0.3, 0.5, 0.2]
        let horizontalStackView = createHorizontalStackView(withPercentages: percentages)
        upperRectangle.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: upperRectangle.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: upperRectangle.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: upperRectangle.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: upperRectangle.bottomAnchor),
        ])

        for (index, square) in horizontalStackView.arrangedSubviews.enumerated() {
            square.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                square.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
                square.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: percentages[index]),
            ])
        }

        let lowerRectangle = createLowerRectangle()
        stackView.addArrangedSubview(lowerRectangle)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let maxHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 150)
        maxHeightConstraint.priority = .defaultHigh
        maxHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let codeLabelText = "Código: \(operationInfo.operationID ?? "")"
        let codeLabel = ComponentBuilder.buildLabel(withText: codeLabelText, textColor: .black, fontSize: 9, backgroundColor: .clear, fontName: Styles.DEFAULT_FONT)
        lowerRectangle.addSubview(codeLabel)
        codeLabel.center(in: lowerRectangle)

        stackView.setNeedsLayout()

        for (index, subview) in horizontalStackView.arrangedSubviews.enumerated() {
            guard index < 3 else { break }
            switch index {
            case 0:
                let imageView = ComponentBuilder.buildImageView(fromURL: URL(string: operationInfo.merchant?.logo ?? "")!)
                subview.addSubview(imageView)
                imageView.center(in: subview)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 70)
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 70)
                NSLayoutConstraint.activate([widthConstraint, heightConstraint])
                imageView.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
                
            case 1:
                let label = ComponentBuilder.buildLabel(withText: operationInfo.merchant?.name, textColor: .black, fontSize: 10, backgroundColor: .clear, fontName: Styles.DEFAULT_FONT)
                subview.addSubview(label)
                label.center(in: subview)
            case 2:
                let label = ComponentBuilder.buildLabel(withText: operationInfo.amount, textColor: .black, fontSize: 10, backgroundColor: .clear,fontName: Styles.DEFAULT_FONT)
                subview.addSubview(label)
                label.center(in: subview)
            default:
                break
            }
        }
    }
}
