import UIKit
import APNGKit

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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func buildButton(withTitle title: String? = nil, backgroundColor: UIColor, titleColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
    
    static func buildCustomTextField(font: UIFont? = UIFont.systemFont(ofSize: 16), borderStyle: UITextField.BorderStyle? = .roundedRect) -> UITextField {
        let textField = UITextField()
        textField.font = font
        textField.borderStyle = borderStyle ?? .none
        return textField
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
