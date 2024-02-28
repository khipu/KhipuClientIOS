import UIKit

class HeaderView: UIView {

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        //TODO agregar contenido de stackviews, recibir operationinfo
    }

    private func setupUI() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.backgroundColor = UIColor.yellow

        let upperRectangle = UIView()
        upperRectangle.backgroundColor = UIColor.blue
        stackView.addArrangedSubview(upperRectangle)
        
        upperRectangle.layer.borderWidth = 1
        upperRectangle.layer.borderColor = UIColor.black.cgColor
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        
        let squareColors: [UIColor] = [.red, .yellow, .green]
        
        let percentages: [CGFloat] = [0.1, 0.7, 0.2]

        for (percentage, color) in zip(percentages, squareColors) {
            let square = UIView()
            square.backgroundColor = color
            horizontalStackView.addArrangedSubview(square)

            square.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: percentage).isActive = true
        }
        
        upperRectangle.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: upperRectangle.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: upperRectangle.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: upperRectangle.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: upperRectangle.bottomAnchor)
        ])
        
        let lowerRectangle = UIView()
        lowerRectangle.backgroundColor = UIColor.purple
        stackView.addArrangedSubview(lowerRectangle)
        
        lowerRectangle.layer.borderWidth = 1
        lowerRectangle.layer.borderColor = UIColor.black.cgColor
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let maxHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        maxHeightConstraint.priority = .defaultHigh
        maxHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: upperRectangle.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: upperRectangle.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: upperRectangle.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: upperRectangle.bottomAnchor)
        ])
    }
}
