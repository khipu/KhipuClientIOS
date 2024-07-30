import UIKit
import KhipuClientIOS

class ViewController: UIViewController {



    lazy private var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Khipu's Client for iOS Example App"
        return label
    }()

    lazy private var sampleInput: UITextField = {
        let sampleTextField =  UITextField()
        sampleTextField.text = "eyJtIjoiWUtrY2RVQzNuVnJLWVFhTVB0Q3Qzc0o4ZWMzSFMzbFVsS052TGJyVndNc3g5azBrSGZobXgxV3pUQzBGVENRRjRhaWo1ZWJXSDlxZ1A5OE1ZV1pwWlVWajJzTWxzMjVzQ29vd0RmRW9vYlA2WklZUE10VnJPclF0dVdOa1AzV2VIY1JwczYzNXZ0akg5YUVxclJzSERUeGFTRHhFNzRMS2MxTzd6RFFGcWxjTVBvcmYxeUF5SHlUbjU4WlQzVGJVUVU1UTNOTzIzM3VTQ2g2UlErYzYySGxOK3kxZFMzejdJWXpjOFJ1anZZTG5ZZnFaTzlrQm9XOG12eS9DZ0dBVG1vUlRpcmV4TUppb0hOUGhOSXE1RU9mWUlLL3ozdnNDeGZSZkVhTElGUlVtdG5QOTEyNkdOMkhBcWlzcVBnck4yUEpVWHRTNGl2MFQ0Z0JLeW9pZmpjamdFRXFzZWs5NVV1WUV3d2RLVitmek4zTzNVc0tYa09RNlpFUnF1akt1bHV6ZUphM3UyTndHalNMQVBaWkN2SkVha0pIWjU1Q1ByTkVNVHdhTy9KcTJvQTM1SlNrL2xGTThjbTA2dlNYRzdTU0dIdlVHVG5OeVpVdmNGNXU0Zytrb3RRaFdDcmZibzEwYmY5dmF4S0FPWmZPa1N3Z1A3TUQ0by92L1kxczFLdVpnT1U2allVSGxKdmVNeHFBaEsxYVRLdWtHb1RpTjk3MUtFcmlGdFVDTUZhTUwwWVFBVFpSQy96ZkppdWZMenlSYk1leGpKM29DVk5aZ2hLdDNUejRrcGt1WXI2Q28zZUZ0emVCZ0ovVGh1cHAvSDJJRDNRdUtkemxoM3RLcitsbkp3WkxkNkg5K3hDL1JwYXlFMzBQbXdWYXJvWk9sQVB3RUNUWG1EMkdkRmxvNC5vMVBnVTF1cEtkT3paSXNJSjhTemhDZmVTV2c4WjhCb1dOU3d4YmhvdE9ndHY2eURma05sY05wTlhuWDhibmRWNld2R2ZwaUdjVUcwdzkvZVAyckxPZUpzTGRsTWFxZktnN09vSmpWaFNXdkZrVTJyUUFSNWY3VVpTU1hBeHc9PSIsImsiOiJ2cml0Ymo0U0ZTbzNPb2NUekt6SVVTblRNZmVMV3ROMTRPYkg0ekhOUWs4PSJ9"



        //sampleTextField.text = "i7jmbvaeuldr"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.borderStyle = .roundedRect
        return sampleTextField
    }()

    lazy private var sampleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Start payment", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button

    }()

    @objc func buttonAction(sender: UIButton!) {
        KhipuLauncher.launch(
            presenter: self,
            operationId: sampleInput.text!,
            options: KhipuOptions.Builder()
                //.topBarImageUrl("https://s3.amazonaws.com/static.khipu.com/buttons/2024/200x75-purple.png")
                .topBarTitle("Demo App")
                .theme(.light)
                //.colors(KhipuColors.Builder().lightPrimary("#0000ff").build())
                .build()
        ) { result in
            print("Operation result \(result.asJson())")
        }

    }

    lazy private var spacer: UIView = {
        let spacer = UIView()
        let spacerWidthConstraint = spacer.heightAnchor.constraint(equalToConstant: .greatestFiniteMagnitude) // or some very high constant
        spacerWidthConstraint.priority = .defaultLow
        spacerWidthConstraint.isActive = true
        return spacer

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16

        stackView.addArrangedSubview(sampleLabel)
        stackView.addArrangedSubview(sampleInput)
        stackView.addArrangedSubview(sampleButton)
        stackView.addArrangedSubview(spacer)

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: guide.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

