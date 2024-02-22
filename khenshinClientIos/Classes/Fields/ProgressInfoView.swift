import UIKit
<<<<<<<< HEAD:khenshinClientIos/Classes/Fields/ProgressInfoField.swift
import APNGKit
import KhenshinProtocol

class ProgressInfoField: UIView {
========
import KhenshinProtocol

class ProgressInfoView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Progress Info"
        label.textColor = UIColor.black
        return label
    }()
>>>>>>>> 19c7790 (primera aproximacion de codigo reactivo):khenshinClientIos/Classes/Fields/ProgressInfoView.swift

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()

    private let progressImageView: APNGImageView = {
        let imageView = APNGImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

<<<<<<<< HEAD:khenshinClientIos/Classes/Fields/ProgressInfoField.swift
    init(frame: CGRect, progressInfo: ProgressInfo) {
========
    init(frame: CGRect, message: ProgressInfo) {
>>>>>>>> 19c7790 (primera aproximacion de codigo reactivo):khenshinClientIos/Classes/Fields/ProgressInfoView.swift
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
        updateUI(with: progressInfo)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor.white
        addSubview(progressLabel)
        addSubview(progressImageView)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressImageView.heightAnchor.constraint(equalToConstant: 80),
            progressImageView.widthAnchor.constraint(equalToConstant: 80),

            progressLabel.topAnchor.constraint(equalTo: progressImageView.bottomAnchor, constant: 20),
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

<<<<<<<< HEAD:khenshinClientIos/Classes/Fields/ProgressInfoField.swift
    private func updateUI(with progressInfo: ProgressInfo) {
        progressLabel.text = progressInfo.message
========
    private func updateUI(with message: ProgressInfo) {
        progressLabel.text = message.message
>>>>>>>> 19c7790 (primera aproximacion de codigo reactivo):khenshinClientIos/Classes/Fields/ProgressInfoView.swift
        if let url = URL(string: "https://khenshin-web.s3.amazonaws.com/img/spin.apng") {
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let self = self else { return }

                do {
                    if let data = data {
                        let image = try APNGImage(data: data)
                        DispatchQueue.main.async {
                            self.progressImageView.image = image
                            self.layoutIfNeeded()
                        }
                    } else {
                        print("Image data is nil.")
                    }
                } catch {
                    print("Failed to load APNG image: \(error)")
                }
            }.resume()
        }
    }


}
