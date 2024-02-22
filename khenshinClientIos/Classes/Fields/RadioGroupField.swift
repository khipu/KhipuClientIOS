import UIKit
import KhenshinProtocol

class RadioGroupField: UIView {

    var formItem: FormItem

    private lazy var radioGroup: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()

    init(frame: CGRect, formItem: FormItem) {
        self.formItem = formItem
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(radioGroup)

        radioGroup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioGroup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            radioGroup.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            radioGroup.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            radioGroup.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])

        if let options = formItem.options {
            for choice in options {
                let sheet = createSheet(choice: choice)
                radioGroup.addArrangedSubview(sheet)
            }
        }
    }

    private func createSheet(choice: ListOption) -> UIView {
        let sheet = UIView()
        sheet.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.00)
        sheet.layer.cornerRadius = 8
        sheet.layer.shadowColor = UIColor.black.cgColor
        sheet.layer.shadowOffset = CGSize(width: 0, height: 2)
        sheet.layer.shadowOpacity = 0.2
        sheet.layer.shadowRadius = 4

        let radio = createRadio(choice: choice)
        sheet.addSubview(radio)

        radio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radio.leadingAnchor.constraint(equalTo: sheet.leadingAnchor, constant: 16),
            radio.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -16),
            radio.topAnchor.constraint(equalTo: sheet.topAnchor, constant: 16),
            radio.bottomAnchor.constraint(equalTo: sheet.bottomAnchor, constant: -16)
        ])

        return sheet
    }

    private func createRadio(choice: ListOption) -> UIButton {
        let radio = UIButton()
        radio.setTitle(choice.value, for: .normal)
        radio.setTitleColor(UIColor(red: 0.07, green: 0.38, blue: 0.87, alpha: 1.00), for: .normal)
        radio.contentHorizontalAlignment = .left
        return radio
    }
}
