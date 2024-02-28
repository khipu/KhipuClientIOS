import UIKit
import KhenshinProtocol
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
        stackView.backgroundColor = UIColor.yellow

        let upperRectangle = UIView()
        upperRectangle.backgroundColor = UIColor.white
        stackView.addArrangedSubview(upperRectangle)
        upperRectangle.layer.borderWidth = 0
        upperRectangle.layer.borderColor = UIColor.black.cgColor

        let upperRectangleHeight: CGFloat = 30
        upperRectangle.heightAnchor.constraint(equalToConstant: upperRectangleHeight).isActive = true

        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        
        let percentages: [CGFloat] = [0.2, 0.6, 0.2]

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
        
        lowerRectangle.layer.borderWidth = 1
        lowerRectangle.layer.borderColor = UIColor.black.cgColor
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let maxHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 150) // Aumentar la altura máxima
        maxHeightConstraint.priority = .defaultHigh
        maxHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if let operationInfo = operationInfo {
            
            let codeLabel = UILabel()
            codeLabel.text = "Código: \(operationInfo.operationID)"
            codeLabel.font = UIFont.systemFont(ofSize: 10)
            codeLabel.textColor = .black
            codeLabel.textAlignment = .center
           
            lowerRectangle.addSubview(codeLabel)
            codeLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                codeLabel.centerXAnchor.constraint(equalTo: lowerRectangle.centerXAnchor),
                codeLabel.centerYAnchor.constraint(equalTo: lowerRectangle.centerYAnchor),
            ])

            stackView.setNeedsLayout()
            
            if horizontalStackView.arrangedSubviews.count > 0 {
                let firstSquare = horizontalStackView.arrangedSubviews[0] as? UIView
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                if let logoURLString = operationInfo.merchant?.logo,
                   let logoURL = URL(string: logoURLString),
                   let imageData = try? Data(contentsOf: logoURL),
                   let image = UIImage(data: imageData) {
                    imageView.image = image
                }
                firstSquare?.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: firstSquare!.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: firstSquare!.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: firstSquare!.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: firstSquare!.bottomAnchor)
                ])
                stackView.setNeedsLayout()
            }

            if horizontalStackView.arrangedSubviews.count > 1 {
                let secondSquare = horizontalStackView.arrangedSubviews[1] as? UIView
                let label = UILabel()
                label.text = operationInfo.merchant?.name
                label.textColor = .black
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 10)
                secondSquare?.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: secondSquare!.topAnchor),
                    label.leadingAnchor.constraint(equalTo: secondSquare!.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: secondSquare!.trailingAnchor),
                    label.bottomAnchor.constraint(equalTo: secondSquare!.bottomAnchor)
                ])
                stackView.setNeedsLayout()
            }
            
            if horizontalStackView.arrangedSubviews.count > 2 {
                let thirdSquare = horizontalStackView.arrangedSubviews[2] as? UIView
                let label = UILabel()
                label.text = operationInfo.amount
                label.font = UIFont.systemFont(ofSize: 10)
                label.textColor = .black
                label.textAlignment = .center
                thirdSquare?.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: thirdSquare!.topAnchor),
                    label.leadingAnchor.constraint(equalTo: thirdSquare!.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: thirdSquare!.trailingAnchor),
                    label.bottomAnchor.constraint(equalTo: thirdSquare!.bottomAnchor)
                ])
                stackView.setNeedsLayout()
            }
        }
    }
}
