//
//  ViewController.swift
//  khenshinClientIos
//
//  Created by mauriciocastillo on 02/19/2024.
//  Copyright (c) 2024 mauriciocastillo. All rights reserved.
//

import UIKit
import khenshinClientIos

class ViewController: UIViewController {



    lazy private var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Khipu's Client for iOS Example App"
        return label
    }()

    lazy private var sampleInput: UITextField = {
        let sampleTextField =  UITextField()
        sampleTextField.text = "9cl3gb4o5qsb"
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
            navigationController: self.navigationController!,
            operationId: sampleInput.text!,
            options: KhipuOptions.Builder()
                .topBarTitle("Mi Khipu")
                .topBarImageResourceName("merchant_logo")
                .locale("es_CL")
                .theme(.system)
                .colors(KhipuColors.Builder()
//                    .darkPrimary("#00FF00")
//                    .lightPrimary("#0000FF")
//                    .lightBackground("#FF0000")
//                    .darkBackground("#FF00FF")
//                    .lightTopBarContainer("#ff0000")
//                    .lightOnTopBarContainer("#00ff00")
//                    .darkTopBarContainer("#00ff00")
//                    .darkOnTopBarContainer("#0000ff")
                    .build())
                .build()) { result in
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

