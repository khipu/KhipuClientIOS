import UIKit
import khenshinClientIos

class CustomHeaderUIVIew: UIView, KhipuHeaderProtocol {
    
    
    func setMerchantName(_ merchantName: String) {
        merchantNameLabel.text = merchantName
    }
    
    func setPaymentMethod(_ paymentMethod: String) {
        paymentMethodLabel.text = paymentMethod
    }
    
    func setSubject(_ subject: String) {
        subjectLabel.text = subject
    }
    
    func setAmount(_ amount: String) {
        amountLabel.text = amount
    }
    
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let merchantNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .brown
        addSubview(subjectLabel)
        addSubview(amountLabel)
        addSubview(merchantNameLabel)
        addSubview(paymentMethodLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for label1
            subjectLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            subjectLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subjectLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Constraints for label2
            amountLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 10),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            merchantNameLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            merchantNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            merchantNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            paymentMethodLabel.topAnchor.constraint(equalTo: merchantNameLabel.bottomAnchor, constant: 10),
            paymentMethodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            paymentMethodLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            paymentMethodLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
