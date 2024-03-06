import KhenshinProtocol

class BaseField: UIView, FormField {
    var formItem: FormItem?

    required init?(formItem: FormItem) {
        super.init(frame: .zero)
        self.formItem = formItem
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        fatalError("setupUI() must be implemented by subclasses")
    }

    func getFormItem() -> FormItem {
        return self.formItem!
    }

    func getValue() -> String {
        fatalError("getValue() must be implemented by subclasses")
    }
    
    func setValue(value: String) -> Void {
        fatalError("getValue() must be implemented by subclasses")
    }

    func validate() -> Bool {
        fatalError("validate() must be implemented by subclasses")
    }
    
}
