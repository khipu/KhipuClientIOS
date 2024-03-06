import KhenshinProtocol

protocol FormField {
    init?(formItem: FormItem)
    func setupUI()
    func getFormItem() -> FormItem
    func getValue() -> String
    func setValue(value: String) -> Void
    func validate() -> Bool
}
