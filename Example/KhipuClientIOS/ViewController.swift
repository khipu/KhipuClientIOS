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
        sampleTextField.text = "eyJtIjoicjkrWjZNNlFOeld4K3hHa3dNRC9VWmI5RWwwRURPSksvdzZUMTBDQy9JWkJESHBhTnBBcUNxZERaZ0R0bWZSeXJPOHUxTlQrcEVVaE80allCVzJablJHOVM0YkJScXYwUXdTVWdyUjJ3ZFhFUGFNU2pUdHlIWEdWTkhrbXlOSGJ5VEtzeFVGclVXcTZ4Vms5bytjUktBK0NDVVNEY0N0ZnllZCsrK3RxeUNHbTMyWEREeUpMQytXU2t5eVVTNTNwUFMzTE1XVlM1cTJ2bDhMUGJXc3pDdDZ4SXlvaFRwVTZxSU1rbmx5Rm5kRWx3T2tjS0hpd1FZMzJYczFxczR1MXozcGNvZ2xwQ284bzRDMGtlSC9BL2JVVDBjd2x4QUE5YVI5YzJoVTdGbDhDaWJ0NXRXTkdlcDlVTW1ybldpVlgrYlRWdUE5QkRZU2tITE1UUHJFNkxnQmFxa2Z1cmJJL3g3Z0JzVEw3VXpHeit6Q0xlUTNqQTdPbjRDVkZJaUE0K0J0KzNvTDRsQ05jc0xuckNldkVIZXJSNE42Z2hTTGlnNlg3ektRcU56R3M1RS92MFZFVTBzUmxPUjJyenBtRUZOS1I3RVJ0VnFZOUhvUUxDcXBsdFUwSGRpL0QvNkJJcmdPdW5IQnB2dnhBbG1sMVlVZkRpN1Y3aFQ0K25UaG5wZGRPSUtVZ0Znb0RLbldXT2xyeDVacHNiN0N6akRjak1xT1Z1eHZJREQzVC9haUhRblprQkF1UnJPenBzTng3MDdud1NYVlNwYTRYMWZnS0hEYmZWSUJOMG83RmxEUFRhTWk5TmM3d3BSTXN6dVpGL0k0QjI3TWNSYlZoZm9MYXVneDl3d0w0d1J2dWlibG5uQ3pGSjZvQ1dKYUpvODdnaVFtRjMrS0ZsbkxJY0hrPS5tbWw0RDNJbGg4M2hYZHhQNTV4MS91ZSsyR24yM2k1dzNtQmpvbDMzMFZuVVRFK0gvNGwzZzJDems5ZnNSQlFkTHJ2citUOGFwWVB1bGx2M3lDUXIvZytOeW10QmprM2l2VG8wdlA1cTYrcXpxTXlvRFFMcFFsd0ZhYzRmNlE9PSIsImsiOiJ2cml0Ymo0U0ZTbzNPb2NUekt6SVVTblRNZmVMV3ROMTRPYkg0ekhOUWs4PSJ9"

        sampleTextField.text = "kixsi0d3er3z"
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
                //.theme(.dark)
                //.topBarImageResourceName("header_image")
                //.topBarImageUrl("https://s3.amazonaws.com/static.khipu.com/buttons/2024/200x75-purple.png")
                //.topBarImageScale(0.9)
                //.topBarTitle("Demo App")
                //.showFooter(false)
                //.showMerchantLogo(false)
                //.showPaymentDetails(false)
                //.header(KhipuHeader.Builder().headerUIView(CustomHeaderUIVIew()).height(200).build())
                //.colors(KhipuColors.Builder().lightPrimary("#0000ff").lightTopBarContainer("#00ff00").build())
                //.skipExitPage(true)
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

