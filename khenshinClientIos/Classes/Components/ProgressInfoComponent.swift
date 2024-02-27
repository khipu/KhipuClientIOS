import UIKit
import APNGKit
import KhenshinProtocol

class ProgressInfoComponent: UIView {

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
    }

    private func updateUI(with progressInfo: ProgressInfo) {
        progressLabel.text = progressInfo.message
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
