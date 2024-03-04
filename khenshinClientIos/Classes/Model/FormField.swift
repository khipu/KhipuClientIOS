import KhenshinProtocol

protocol FormField {
    init?(formItem: FormItem)
    func setupUI()
    func getFormItem() -> FormItem
    func getValue() -> String
    func validate() -> Bool
}
