import UIKit
import APNGKit
import KhenshinProtocol

class ProgressInfoComponent: UIView {

    private let progressLabel: UILabel = ComponentBuilder.buildLabel(textColor: .black, fontSize: 14, backgroundColor: .clear)

    private let progressImageView: APNGImageView = ComponentBuilder.buildAPNGImageView(fromURL: URL(string: "https://khenshin-web.s3.amazonaws.com/img/spin.apng")!)

    init(frame: CGRect, progressInfo: ProgressInfo) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        updateUI(with: progressInfo)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
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
    }
}
