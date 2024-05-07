import UIKit
import RxSwift
import KhenshinProtocol

class RadioGroupField: BaseField {

    private var value: String
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
                
        if let options = self.formItem!.options {
            for choice in options {
                let sheet = createSheet(choice: choice)
                radio.addArrangedSubview(sheet)
            }
        }
        
        addSubview(radio)
        
        translatesAutoresizingMaskIntoConstraints = false
        radio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            radio.topAnchor.constraint(equalTo: topAnchor),
            radio.leadingAnchor.constraint(equalTo: leadingAnchor),
            radio.trailingAnchor.constraint(equalTo: trailingAnchor),
            radio.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func createSheet(choice: ListOption) -> UIView {
        let sheet = UIView()
        sheet.backgroundColor = .white
        sheet.layer.cornerRadius = 8
        sheet.layer.shadowColor = UIColor.black.cgColor
        sheet.layer.shadowOffset = CGSize(width: 0, height: 2)
        sheet.layer.shadowOpacity = 0.2
        sheet.layer.shadowRadius = 4

        let radio = createRadio(choice: choice)
        
        sheet.addSubview(radio)
        let tapGesture = UITapGestureRecognizer()
        radio.addGestureRecognizer(tapGesture)
        /*tapGesture
            .rx
            .event
            .bind(onNext:{ indexPath in
                self.value = (self.formItem?.options?.filter{$0.value == (indexPath.view as! UIButton).currentTitle}.first!.value!)!
                self.updateRadioColors()
            })
            .disposed(by: disposeBag)*/

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
        radio.contentHorizontalAlignment = .center
        radio.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        radio.titleLabel?.adjustsFontSizeToFitWidth = true
        radio.titleLabel?.minimumScaleFactor = 0.5
        return radio
    }

    private func updateRadioColors() {
        for (index, subview) in radio.arrangedSubviews.enumerated() {
            guard let sheet = subview as? UIView,
                  let radio = sheet.subviews.first as? UIButton else {
                continue
            }

            let isSelected = radio.currentTitle == value
            sheet.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.lightGray.cgColor
            sheet.layer.backgroundColor = isSelected ? UIColor(red: 0.592, green: 0.764, blue: 0.941, alpha: 1.0).cgColor : UIColor.white.cgColor
        }
    }
    
    override func getValue() -> String {
        return self.value
    }

    override func validate() -> Bool {
        return !self.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
