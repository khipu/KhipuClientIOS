import UIKit
import RxSwift
import KhenshinProtocol

class RadioGroupField: BaseField {

    private var value: String
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    private lazy var radio = ComponentBuilder.buildStackView(axis: .vertical, spacing: 3, distribution: .fill)
    private let disposeBag = DisposeBag()

    required init?(formItem: FormItem) {
        self.value = ""
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        addSubview(error)
                
        if let options = self.formItem!.options {
            for choice in options {
                let sheet = createSheet(choice: choice)
                radio.addArrangedSubview(sheet)
            }
        }
        
        addSubview(radio)
        
        translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        radio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            error.topAnchor.constraint(equalTo: topAnchor),
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            error.trailingAnchor.constraint(equalTo: trailingAnchor),
            radio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            radio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            radio.topAnchor.constraint(equalTo: error.bottomAnchor),
            radio.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
        let tapGesture = UITapGestureRecognizer()
        radio.addGestureRecognizer(tapGesture)
        tapGesture
            .rx
            .event
            .bind(onNext:{ indexPath in
                self.value = (self.formItem?.options?.filter{$0.value == (indexPath.view as! UIButton).currentTitle}.first!.value!)!
                print("Elemento seleccionado \(self.value)")
                }).disposed(by: disposeBag)

        radio.translatesAutoresizingMaskIntoConstraints = false
        sheet.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheet.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            radio.leadingAnchor.constraint(equalTo: sheet.leadingAnchor),
            radio.trailingAnchor.constraint(equalTo: sheet.trailingAnchor),
            radio.topAnchor.constraint(equalTo: sheet.topAnchor),
            radio.bottomAnchor.constraint(equalTo: sheet.bottomAnchor)
        ])

        return sheet
    }

    private func createRadio(choice: ListOption) -> UIButton {
        let radio = UIButton()
        radio.setTitle(choice.value, for: .normal)
        radio.setTitleColor(UIColor(red: 0.07, green: 0.38, blue: 0.87, alpha: 1.00), for: .normal)
        radio.contentHorizontalAlignment = .left
        radio.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        radio.titleLabel?.adjustsFontSizeToFitWidth = true
        radio.titleLabel?.minimumScaleFactor = 0.5
        return radio
    }
    
    override func getValue() -> String {
        return self.value
    }

    override func validate() -> Bool {

        if self.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = "Campo obligatorio"
            return false
        } else {
            error.text = ""
            return true
        }
    }
    
}
