import UIKit

class FooterView: UIView {
    
    lazy private var label = ComponentBuilder.buildLabel(withText: "Impulsado por", textColor: .black, fontSize: 10, backgroundColor: .white)
    lazy private var imageView = ComponentBuilder.buildImageView(fromURL:  URL(string: "https://s3.amazonaws.com/static.khipu.com/buttons/2015/50x25-white.png")!)
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        let internalStackView = UIStackView(arrangedSubviews: [label, imageView])
        internalStackView.axis = .horizontal
        internalStackView.alignment = .center
        internalStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [internalStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill 
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
