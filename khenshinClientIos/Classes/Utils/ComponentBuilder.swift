import UIKit
import APNGKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class ComponentBuilder {

    static func buildImageView(fromURL url: URL) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error al cargar la imagen desde la URL: \(url), Error: \(error)")
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                print("Error al cargar la imagen desde la URL: \(url)")
            }
        }.resume()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    static func buildLabel(withText text: String? = nil, textColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor, fontName: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    static func buildTextField(
        delegate: UITextFieldDelegate? = nil
    ) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont(name: Styles.DEFAULT_FONT, size: Styles.Input.TITLE_SIZE)
        textField.borderStyle = Styles.Input.BORDER_STYLE
        textField.delegate = delegate
        textField.isUserInteractionEnabled = true
        return textField
    }

    static func buildSpacingView( spacingHeight: CGFloat )-> UIView{
        let spacingView = UIView()
        spacingView.heightAnchor.constraint(equalToConstant: spacingHeight).isActive = true
        return spacingView
    }

    static func buildButton(withTitle title: String? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(hexString: Styles.Buttons.ACTIVE_BUTTON_COLOR_HEX)
        button.layer.cornerRadius = Styles.Buttons.CORNER_RADIUS
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: Styles.DEFAULT_FONT, size: Styles.Buttons.TITLE_SIZE)
        button.setTitleColor(UIColor(hexString: Styles.Buttons.TEXT_COLOR_INACTIVE_BUTTON), for: .disabled)
        button.setTitleColor(UIColor(hexString: Styles.Buttons.TEXT_COLOR_ACTIVE_BUTTON), for: .normal)
        button.isEnabled = true
        return button
    }

    static func buildStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 5.0, distribution: UIStackView.Distribution = .fillEqually) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }

    static func buildAPNGImageView(fromURL url: URL) -> APNGImageView {
       let apngImageView = APNGImageView()
       apngImageView.contentMode = .scaleAspectFit
       apngImageView.translatesAutoresizingMaskIntoConstraints = false

       URLSession.shared.dataTask(with: url) { data, _, error in
           DispatchQueue.main.async {
               if let error = error {
                   print("Failed to load APNG image: \(error)")
               } else if let data = data, let image = try? APNGImage(data: data) {
                   apngImageView.image = image
               } else {
                   print("Failed to load APNG image: Data is nil.")
               }
           }
       }.resume()

       return apngImageView
    }

    static func buildCheckbox(withLabel labelText: String) -> UIView {
        let container = UIView()
        let checkbox = CheckBox.init()
        let label = buildLabel(textColor: Styles.Error.TEXT_COLOR, fontSize: Styles.Error.FONT_SIZE, backgroundColor: Styles.Error.BACKGROUND_COLOR, fontName: Styles.DEFAULT_FONT)
        label.text = labelText
        checkbox.frame = CGRect(x: 15, y: 15, width: 10, height: 10)
        checkbox.style = .tick
        checkbox.borderStyle = .roundedSquare(radius: 5)
        container.addSubview(checkbox)
        container.addSubview(label)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkbox.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkbox.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            checkbox.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -4),
            checkbox.heightAnchor.constraint(equalToConstant: 15),
            checkbox.widthAnchor.constraint(equalToConstant: 15),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        return container
    }
}

