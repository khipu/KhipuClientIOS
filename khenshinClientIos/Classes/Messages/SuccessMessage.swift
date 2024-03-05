import UIKit
import KhenshinProtocol

class SuccessMessage: UIView {

    var operationSuccess: OperationSuccess
    var operationInfo: OperationInfo?


    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        label.text = "¡Listo, transferiste!"
        return label
    }()


    private let body: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    private let monto: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Monto"
        return label
    }()

    private let comercio: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Destinatario"
        return label
    }()

    private let operacion: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Código de operación"
        return label
    }()

    private let montoValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.gray
        return label
    }()

    private let comercioValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.gray
        return label
    }()

    private let operacionValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.gray
        return label
    }()

    private lazy var contentContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var infoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()

    private let resultIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    init(frame: CGRect, operationSuccess: OperationSuccess,operationInfo: OperationInfo?) {
        self.operationSuccess = operationSuccess
        self.operationInfo = operationInfo
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        operacionValue.text = self.operationSuccess.operationID
        body.text = self.operationSuccess.body
        montoValue.text = self.operationInfo?.amount
        comercioValue.text = self.operationInfo?.merchant?.name
        addSubview(contentContainer)
        contentContainer.addArrangedSubview(resultIconImageView)

        let montoStackView = UIStackView(arrangedSubviews: [monto, montoValue])
        montoStackView.axis = .vertical
        montoStackView.spacing = 5
        montoStackView.alignment = .center

        let comercioStackView = UIStackView(arrangedSubviews: [comercio, comercioValue])
        comercioStackView.axis = .horizontal
        comercioStackView.spacing = 5
        comercioStackView.alignment = .center

        let operacionStackView = UIStackView(arrangedSubviews: [operacion, operacionValue])
        operacionStackView.axis = .horizontal
        operacionStackView.spacing = 5
        operacionStackView.alignment = .center

        infoContainer.addArrangedSubview(montoStackView)
        infoContainer.addArrangedSubview(comercioStackView)
        infoContainer.addArrangedSubview(operacionStackView)

        contentContainer.addArrangedSubview(infoContainer)

        contentContainer.backgroundColor = UIColor.white
        infoContainer.backgroundColor = UIColor.white

        addSubview(title)
        addSubview(body)
        addSubview(contentContainer)

        resultIconImageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            resultIconImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            resultIconImageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            resultIconImageView.heightAnchor.constraint(equalToConstant: 50),

            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),


            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            body.centerXAnchor.constraint(equalTo: centerXAnchor),

            contentContainer.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 15),
            contentContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
        ])
    }
}
