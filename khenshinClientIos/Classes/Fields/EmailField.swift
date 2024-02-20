import UIKit

class EmailField: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.red
        return label
    }()

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        setupViews(title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews(title: "")
    }

    private func setupViews(title: String) {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(errorLabel)
        titleLabel.text = title

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

}
