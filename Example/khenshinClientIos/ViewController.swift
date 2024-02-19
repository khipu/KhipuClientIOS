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
    
    let khenshinClient = KhenshinClient(serverUrl: "http://localhost:8000")
    
    lazy private var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Khenshin test!"
        label.textColor = UIColor.white
        return label
    }()
    
    lazy private var sampleInput: UITextField = {
        let sampleTextField =  UITextField()
        sampleTextField.text = "paymentId"
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
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Start payment", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button

    }()
    
    @objc func buttonAction(sender: UIButton!) {
        print("Connecting khenshin")
        khenshinClient.connect()
        print("Khenshin connected")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16

        stackView.addArrangedSubview(sampleLabel)
        stackView.addArrangedSubview(sampleInput)
        stackView.addArrangedSubview(sampleButton)

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

