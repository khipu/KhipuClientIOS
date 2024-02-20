import UIKit

class ProgressInfo: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Progress Info"
        label.textColor = UIColor.black
        return label
    }()

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

    init(frame: CGRect, message: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
        updateUI(with: message)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(progressLabel)
        addSubview(progressImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressImageView.heightAnchor.constraint(equalToConstant: 80),
            progressImageView.widthAnchor.constraint(equalToConstant: 80),

            progressLabel.topAnchor.constraint(equalTo: progressImageView.bottomAnchor, constant: 20),
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    private func updateUI(with message: String) {
        progressLabel.text = message
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
