import UIKit
import KhenshinProtocol

class ProgressInfoField: UIView {

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()

    private let progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(frame: CGRect, progressInfo: ProgressInfo) {
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

    private func updateUI(with progressInfo: ProgressInfo) {
        progressLabel.text = progressInfo.message
        if let url = URL(string: "https://khenshin-web.s3.amazonaws.com/img/spin.apng") {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.progressImageView.image = image
                        self.layoutIfNeeded()
                    }
                }
            }.resume()
        }
    }
}
