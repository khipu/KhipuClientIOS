import UIKit
import KhenshinProtocol

class CoordinatesField: UIView {

    var formItem: FormItem
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let label3 = UILabel()


    private let coord1TextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private let coord2TextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private let coord3TextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        configureLabel(label1, text: (self.formItem.labels?[0])!)
        configureLabel(label2, text: (self.formItem.labels?[1])!)
        configureLabel(label3, text: (self.formItem.labels?[2])!)
        
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        addSubview(coord1TextField)
        addSubview(coord2TextField)
        addSubview(coord3TextField)

        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        coord1TextField.translatesAutoresizingMaskIntoConstraints = false
        coord2TextField.translatesAutoresizingMaskIntoConstraints = false
        coord3TextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            coord1TextField.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8),
            coord1TextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            label2.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 16),
            coord2TextField.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 8),
            coord2TextField.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 16),

            label3.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label3.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 16),
            coord3TextField.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 8),
            coord3TextField.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 16),
        ])
    }
         
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
    }
        
}


