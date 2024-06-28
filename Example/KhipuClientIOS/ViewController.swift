//
//  ViewController.swift
//  khenshinClientIos
//
//  Created by mauriciocastillo on 02/19/2024.
//  Copyright (c) 2024 mauriciocastillo. All rights reserved.
//

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
        sampleTextField.text = "eyJtIjoiZkovZDNYeUdyUkRVVDZzb1ptcktBN2tQNlNLSGkrMUU3eTZCeC9hUTNLS096Z09JTjRONithOWVjeXV2ZklpTG5Qd0VuOHE5dTJFaVRtL1pKZTVmbG1jM0FZc0V6aDZ5L2lFRm1vVkNJOFpPVjlaWlBMOCtWWWY0MUhtQitUM0RML3dRVmx1NEhPTzdjcFBmakN2MlJtK1d5Q2FFcjVobk90d0ZGVUNhWUV3Vk9Lby8xR1ZMQTUzbzRIM1hYZ2N6OGQ4amYrMHpGN2V3NnRKd2wwbm9BYWx1WldLK05BZ3hQNGFMa3NpRjZiU1VzUk9XV2FmbWtIV08xbXhBcWZLVXBwZlZua09ybEE5UUZCdnN4L2NaaHVCdUQ5bklrSUw5N0tIZ1pvVDVML1k5WGl5VDRRZFZVRXRhTThWdklmTS9IVkk1SVNjTkRHR1FkQW9tSTVBRUtWVXR3R3VWcUZ2c2UzL1BVbGs0N0pxZFh4R1ZKVnJuMTMwcEYyWnhaMW9qeVBtQS9RSGxUUWtNVFFIMzhUYVVTUVhwWlh0KzBpZ1VVVktXS04zTUNhUERRc3RlNVV4ZWttbjZEdkFuVitXV0w3NnNaZFJBWksvQ3FYUHhyRXlvanRIR3dTS2ErYXdQbnhxeUZvRmJ6amxyUWZxNksyNGxtZ0dHcTZYQjRWUE01SzF0WU4rTS96MzBncmVsMGFSWTcwaU5zY0t3Zk9COHI4VjZHZXNFWG1ORUFFMnVvVDhpc2ZiVXhuZmg4MXdxamtjd1hqTE1WaVpaUUlxZVlOTWUzeC85QUttZU4rQ3hMZU1GMzZlbWI2Y0wxWkkzM3N6Qi9xUFhrUEo0bjBQZEdNbEJ0UTJobVBPSnZsNkhoaTdPeWN6RUQ5YWR6cWN2Mm1yR2J2RE5IR0tCS1JmeW5XZlFXS2xSamYvNXBjb3lJYTFrcjdmK0gxRmpJS3BwSjFkL3JMUFFxdWFrUnB1VVVSUGtlZUE1K0F6c0VISm5qcFJtMFBoZ1ZxTkN4N0RKalFrbXNpWXJ6NHNmR2pNPS5MR2dKb3JCMkd3ZFlyVXFQMFpBUmV5cXU4eFJSaHdhT2YrcndMOWd0MjVXNjE3VitVVDJ0cm1hdlZFdEQwenR5dW9VTVB3ZnZENDVsWW1rNHdKVEpjdWxlYlJVL2x0NER3cFlnS3lnWnlncTROVGhqQXdVTFZOdmVIYmY0d0E9PSIsImsiOiI0cUlHdExyaXJUV0MyVTUrTXNIOW14S0pVQVpoKzYwK3J5ODJJM3p5V1Q0PSJ9"



        sampleTextField.text = "lwhallcputoj"
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
                .topBarImageUrl("https://s3.amazonaws.com/static.khipu.com/buttons/2024/200x75-purple.png")
                .build()
                ) { result in
                    print("Operation result \(result.asJson())")
                }

    }

    lazy private var spacer: UIView = {
        let spacer = UIView()
        // maximum width constraint
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

