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
        let imageData = try? Data(contentsOf: url)
        let image = UIImage(data: imageData!)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    static func buildLabel(withText text: String? = nil, textColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    static func buildCustomTextField(
        font: UIFont? = UIFont.systemFont(ofSize: 16),
        borderStyle: UITextField.BorderStyle? = .roundedRect,
        delegate: UITextFieldDelegate? = nil
    ) -> UITextField {
        let textField = UITextField()
        textField.font = font
        textField.borderStyle = borderStyle ?? .none
        textField.delegate = delegate
        textField.isUserInteractionEnabled = true
        return textField
    }

    static func buildSpacingView( spacingHeight: CGFloat )-> UIView{
        let spacingView = UIView()
        spacingView.heightAnchor.constraint(equalToConstant: spacingHeight).isActive = true
        return spacingView
    }

    static func buildButton(withTitle title: String? = nil, backgroundColorHex: String, titleColor: UIColor, cornerRadius: CGFloat = 8.0) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        if let backgroundColor = UIColor(hexString: backgroundColorHex) {
            button.backgroundColor = backgroundColor
        }
        button.setTitleColor(titleColor, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
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
    
}

