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

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func updateHeaderValue(with operationInfo: OperationInfo) {
        self.operationInfo = operationInfo
        setupUI()
    }

    private func setupUI() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill

        let upperRectangle = UIView()
        upperRectangle.backgroundColor = UIColor.white
        stackView.addArrangedSubview(upperRectangle)
        upperRectangle.layer.borderWidth = 0.6
        upperRectangle.layer.borderColor = UIColor.lightGray.cgColor
        upperRectangle.layer.cornerRadius = 1 

        let upperRectangleHeight: CGFloat = 30
        upperRectangle.heightAnchor.constraint(equalToConstant: upperRectangleHeight).isActive = true

        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill

        let percentages: [CGFloat] = [0.3, 0.5, 0.2]

        for percentage in percentages {
            let square = UIView()
            square.backgroundColor = .white
            horizontalStackView.addArrangedSubview(square)
            square.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: percentage).isActive = true
        }

        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
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

        let lowerRectangle = UIView()
        lowerRectangle.backgroundColor = UIColor.white
        stackView.addArrangedSubview(lowerRectangle)
        let lowerRectangleHeight: CGFloat = 20
        lowerRectangle.heightAnchor.constraint(equalToConstant: lowerRectangleHeight).isActive = true
        let borderThickness: CGFloat = 0.5
        lowerRectangle.layer.borderWidth = borderThickness

        let borderColor = UIColor.lightGray.cgColor
        lowerRectangle.layer.borderColor = borderColor
        lowerRectangle.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

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

        if let operationInfo = operationInfo {
            let codeLabel = ComponentBuilder.buildLabel(withText: "Código: \(operationInfo.operationID)", textColor: .black, fontSize: 10, backgroundColor: .clear)
            lowerRectangle.addSubview(codeLabel)
            codeLabel.center(in: lowerRectangle)

            stackView.setNeedsLayout()

            if horizontalStackView.arrangedSubviews.count > 0 {
                let firstSquare = horizontalStackView.arrangedSubviews[0] as? UIView
                let imageView = ComponentBuilder.buildImageView(fromURL: URL(string: operationInfo.merchant?.logo ?? "")!)
                firstSquare?.addSubview(imageView)
                imageView.center(in: firstSquare!)
                stackView.setNeedsLayout()
            }

            if horizontalStackView.arrangedSubviews.count > 1 {
                let secondSquare = horizontalStackView.arrangedSubviews[1] as? UIView
                let label = ComponentBuilder.buildLabel(withText: operationInfo.merchant?.name, textColor: .black, fontSize: 10, backgroundColor: .clear)
                secondSquare?.addSubview(label)
                label.center(in: secondSquare!)
                stackView.setNeedsLayout()
            }

            if horizontalStackView.arrangedSubviews.count > 2 {
                let thirdSquare = horizontalStackView.arrangedSubviews[2] as? UIView
                let label = ComponentBuilder.buildLabel(withText: operationInfo.amount, textColor: .black, fontSize: 10, backgroundColor: .clear)
                thirdSquare?.addSubview(label)
                label.center(in: thirdSquare!)
                stackView.setNeedsLayout()
            }
        }
    }
}
