// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let authorizationRequest = try AuthorizationRequest(json)
//   let cancelOperationComplete = try CancelOperationComplete(json)
//   let formItemTypes = try? JSONDecoder().decode(FormItemTypes.self, from: jsonData)
//   let formRequest = try FormRequest(json)
//   let formResponse = try FormResponse(json)
//   let messageType = try? JSONDecoder().decode(MessageType.self, from: jsonData)
//   let openAuthorizationApp = try OpenAuthorizationApp(json)
//   let operationDescriptorInfo = try OperationDescriptorInfo(json)
//   let operationFailure = try OperationFailure(json)
//   let operationFinish = try OperationFinish(json)
//   let operationInfo = try OperationInfo(json)
//   let operationMustContinue = try OperationMustContinue(json)
//   let operationRequest = try OperationRequest(json)
//   let operationResponse = try OperationResponse(json)
//   let operationSuccess = try OperationSuccess(json)
//   let operationWarning = try OperationWarning(json)
//   let preAuthorizationCanceled = try PreAuthorizationCanceled(json)
//   let preAuthorizationStarted = try PreAuthorizationStarted(json)
//   let progressInfo = try ProgressInfo(json)
//   let siteInfo = try SiteInfo(json)
//   let siteOperationComplete = try SiteOperationComplete(json)
//   let translations = try Translations(json)

import Foundation

// MARK: - AuthorizationRequest
public struct AuthorizationRequest: Codable {
    public let authorizationType: AuthorizationRequestType
    public let imageData: String?
    public let message: String
    public let type: MessageType

    public init(authorizationType: AuthorizationRequestType, imageData: String?, message: String, type: MessageType) {
        self.authorizationType = authorizationType
        self.imageData = imageData
        self.message = message
        self.type = type
    }
}

// MARK: AuthorizationRequest convenience initializers and mutators

public extension AuthorizationRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuthorizationRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        authorizationType: AuthorizationRequestType? = nil,
        imageData: String?? = nil,
        message: String? = nil,
        type: MessageType? = nil
    ) -> AuthorizationRequest {
        return AuthorizationRequest(
            authorizationType: authorizationType ?? self.authorizationType,
            imageData: imageData ?? self.imageData,
            message: message ?? self.message,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum AuthorizationRequestType: String, Codable {
    case custom = "CUSTOM"
    case mobile = "MOBILE"
    case none = "NONE"
    case qr = "QR"
}

public enum MessageType: String, Codable {
    case authorizationRequest = "AUTHORIZATION_REQUEST"
    case cancelOperationComplete = "CANCEL_OPERATION_COMPLETE"
    case formRequest = "FORM_REQUEST"
    case formResponse = "FORM_RESPONSE"
    case openAuthorizationApp = "OPEN_AUTHORIZATION_APP"
    case operationDescriptorInfo = "OPERATION_DESCRIPTOR_INFO"
    case operationFailure = "OPERATION_FAILURE"
    case operationInfo = "OPERATION_INFO"
    case operationMustContinue = "OPERATION_MUST_CONTINUE"
    case operationRequest = "OPERATION_REQUEST"
    case operationResponse = "OPERATION_RESPONSE"
    case operationSuccess = "OPERATION_SUCCESS"
    case operationWarning = "OPERATION_WARNING"
    case preAuthorizationCanceled = "PRE_AUTHORIZATION_CANCELED"
    case preAuthorizationStarted = "PRE_AUTHORIZATION_STARTED"
    case progressInfo = "PROGRESS_INFO"
    case siteInfo = "SITE_INFO"
    case siteOperationComplete = "SITE_OPERATION_COMPLETE"
    case translation = "TRANSLATION"
    case welcomeMessageShown = "WELCOME_MESSAGE_SHOWN"
}

// MARK: - CancelOperationComplete
public struct CancelOperationComplete: Codable {
    public let type: MessageType

    public init(type: MessageType) {
        self.type = type
    }
}

// MARK: CancelOperationComplete convenience initializers and mutators

public extension CancelOperationComplete {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CancelOperationComplete.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil
    ) -> CancelOperationComplete {
        return CancelOperationComplete(
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FormRequest
public struct FormRequest: Codable {
    public let alternativeAction: AlternativeAction?
    public let continueLabel, errorMessage: String?
    public let id: String
    public let info: String?
    public let items: [FormItem]
    public let pageTitle: String?
    public let progress: Progress?
    public let rememberValues: Bool?
    public let termsURL: String?
    public let timeout: Int?
    public let title: String?
    public let type: MessageType

    public enum CodingKeys: String, CodingKey {
        case alternativeAction, continueLabel, errorMessage, id, info, items, pageTitle, progress, rememberValues
        case termsURL = "termsUrl"
        case timeout, title, type
    }

    public init(alternativeAction: AlternativeAction?, continueLabel: String?, errorMessage: String?, id: String, info: String?, items: [FormItem], pageTitle: String?, progress: Progress?, rememberValues: Bool?, termsURL: String?, timeout: Int?, title: String?, type: MessageType) {
        self.alternativeAction = alternativeAction
        self.continueLabel = continueLabel
        self.errorMessage = errorMessage
        self.id = id
        self.info = info
        self.items = items
        self.pageTitle = pageTitle
        self.progress = progress
        self.rememberValues = rememberValues
        self.termsURL = termsURL
        self.timeout = timeout
        self.title = title
        self.type = type
    }
}

// MARK: FormRequest convenience initializers and mutators

public extension FormRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FormRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        alternativeAction: AlternativeAction?? = nil,
        continueLabel: String?? = nil,
        errorMessage: String?? = nil,
        id: String? = nil,
        info: String?? = nil,
        items: [FormItem]? = nil,
        pageTitle: String?? = nil,
        progress: Progress?? = nil,
        rememberValues: Bool?? = nil,
        termsURL: String?? = nil,
        timeout: Int?? = nil,
        title: String?? = nil,
        type: MessageType? = nil
    ) -> FormRequest {
        return FormRequest(
            alternativeAction: alternativeAction ?? self.alternativeAction,
            continueLabel: continueLabel ?? self.continueLabel,
            errorMessage: errorMessage ?? self.errorMessage,
            id: id ?? self.id,
            info: info ?? self.info,
            items: items ?? self.items,
            pageTitle: pageTitle ?? self.pageTitle,
            progress: progress ?? self.progress,
            rememberValues: rememberValues ?? self.rememberValues,
            termsURL: termsURL ?? self.termsURL,
            timeout: timeout ?? self.timeout,
            title: title ?? self.title,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AlternativeAction
public struct AlternativeAction: Codable {
    public let id, label, name: String?

    public enum CodingKeys: String, CodingKey {
        case id = "Id"
        case label = "Label"
        case name = "Name"
    }

    public init(id: String?, label: String?, name: String?) {
        self.id = id
        self.label = label
        self.name = name
    }
}

// MARK: AlternativeAction convenience initializers and mutators

public extension AlternativeAction {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlternativeAction.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        label: String?? = nil,
        name: String?? = nil
    ) -> AlternativeAction {
        return AlternativeAction(
            id: id ?? self.id,
            label: label ?? self.label,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FormItem
public struct FormItem: Codable {
    public let bottomText: String?
    public let checked: Bool?
    public let checkedColor, code, color: String?
    public let dataTable: DataTable?
    public let decimal: Bool?
    public let defaultValue: String?
    public let email, focused: Bool?
    public let format, group: String?
    public let groupedOptions: GroupedOptions?
    public let height: Double?
    public let hint: String?
    public let id: String
    public let image, imageData, items, label: String?
    public let labels: [String]?
    public let length: Double?
    public let mandatory: Bool?
    public let mask: String?
    public let maxLength, maxValue, minLength, minValue: Double?
    public let number: Bool?
    public let options: [ListOption]?
    public let otp: Bool?
    public let pattern, placeHolder, formItemPrefix, replacePattern: String?
    public let replaceValue, requiredState: String?
    public let secure: Bool?
    public let selectorType, title: String?
    public let truncateTo: Double?
    public let type: FormItemTypes

    public enum CodingKeys: String, CodingKey {
        case bottomText, checked, checkedColor, code, color, dataTable, decimal, defaultValue, email, focused, format, group, groupedOptions, height, hint, id, image, imageData, items, label, labels, length, mandatory, mask, maxLength, maxValue, minLength, minValue, number, options, otp, pattern, placeHolder
        case formItemPrefix = "prefix"
        case replacePattern, replaceValue, requiredState, secure, selectorType, title, truncateTo, type
    }

    public init(bottomText: String?, checked: Bool?, checkedColor: String?, code: String?, color: String?, dataTable: DataTable?, decimal: Bool?, defaultValue: String?, email: Bool?, focused: Bool?, format: String?, group: String?, groupedOptions: GroupedOptions?, height: Double?, hint: String?, id: String, image: String?, imageData: String?, items: String?, label: String?, labels: [String]?, length: Double?, mandatory: Bool?, mask: String?, maxLength: Double?, maxValue: Double?, minLength: Double?, minValue: Double?, number: Bool?, options: [ListOption]?, otp: Bool?, pattern: String?, placeHolder: String?, formItemPrefix: String?, replacePattern: String?, replaceValue: String?, requiredState: String?, secure: Bool?, selectorType: String?, title: String?, truncateTo: Double?, type: FormItemTypes) {
        self.bottomText = bottomText
        self.checked = checked
        self.checkedColor = checkedColor
        self.code = code
        self.color = color
        self.dataTable = dataTable
        self.decimal = decimal
        self.defaultValue = defaultValue
        self.email = email
        self.focused = focused
        self.format = format
        self.group = group
        self.groupedOptions = groupedOptions
        self.height = height
        self.hint = hint
        self.id = id
        self.image = image
        self.imageData = imageData
        self.items = items
        self.label = label
        self.labels = labels
        self.length = length
        self.mandatory = mandatory
        self.mask = mask
        self.maxLength = maxLength
        self.maxValue = maxValue
        self.minLength = minLength
        self.minValue = minValue
        self.number = number
        self.options = options
        self.otp = otp
        self.pattern = pattern
        self.placeHolder = placeHolder
        self.formItemPrefix = formItemPrefix
        self.replacePattern = replacePattern
        self.replaceValue = replaceValue
        self.requiredState = requiredState
        self.secure = secure
        self.selectorType = selectorType
        self.title = title
        self.truncateTo = truncateTo
        self.type = type
    }
}

// MARK: FormItem convenience initializers and mutators

public extension FormItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FormItem.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        bottomText: String?? = nil,
        checked: Bool?? = nil,
        checkedColor: String?? = nil,
        code: String?? = nil,
        color: String?? = nil,
        dataTable: DataTable?? = nil,
        decimal: Bool?? = nil,
        defaultValue: String?? = nil,
        email: Bool?? = nil,
        focused: Bool?? = nil,
        format: String?? = nil,
        group: String?? = nil,
        groupedOptions: GroupedOptions?? = nil,
        height: Double?? = nil,
        hint: String?? = nil,
        id: String? = nil,
        image: String?? = nil,
        imageData: String?? = nil,
        items: String?? = nil,
        label: String?? = nil,
        labels: [String]?? = nil,
        length: Double?? = nil,
        mandatory: Bool?? = nil,
        mask: String?? = nil,
        maxLength: Double?? = nil,
        maxValue: Double?? = nil,
        minLength: Double?? = nil,
        minValue: Double?? = nil,
        number: Bool?? = nil,
        options: [ListOption]?? = nil,
        otp: Bool?? = nil,
        pattern: String?? = nil,
        placeHolder: String?? = nil,
        formItemPrefix: String?? = nil,
        replacePattern: String?? = nil,
        replaceValue: String?? = nil,
        requiredState: String?? = nil,
        secure: Bool?? = nil,
        selectorType: String?? = nil,
        title: String?? = nil,
        truncateTo: Double?? = nil,
        type: FormItemTypes? = nil
    ) -> FormItem {
        return FormItem(
            bottomText: bottomText ?? self.bottomText,
            checked: checked ?? self.checked,
            checkedColor: checkedColor ?? self.checkedColor,
            code: code ?? self.code,
            color: color ?? self.color,
            dataTable: dataTable ?? self.dataTable,
            decimal: decimal ?? self.decimal,
            defaultValue: defaultValue ?? self.defaultValue,
            email: email ?? self.email,
            focused: focused ?? self.focused,
            format: format ?? self.format,
            group: group ?? self.group,
            groupedOptions: groupedOptions ?? self.groupedOptions,
            height: height ?? self.height,
            hint: hint ?? self.hint,
            id: id ?? self.id,
            image: image ?? self.image,
            imageData: imageData ?? self.imageData,
            items: items ?? self.items,
            label: label ?? self.label,
            labels: labels ?? self.labels,
            length: length ?? self.length,
            mandatory: mandatory ?? self.mandatory,
            mask: mask ?? self.mask,
            maxLength: maxLength ?? self.maxLength,
            maxValue: maxValue ?? self.maxValue,
            minLength: minLength ?? self.minLength,
            minValue: minValue ?? self.minValue,
            number: number ?? self.number,
            options: options ?? self.options,
            otp: otp ?? self.otp,
            pattern: pattern ?? self.pattern,
            placeHolder: placeHolder ?? self.placeHolder,
            formItemPrefix: formItemPrefix ?? self.formItemPrefix,
            replacePattern: replacePattern ?? self.replacePattern,
            replaceValue: replaceValue ?? self.replaceValue,
            requiredState: requiredState ?? self.requiredState,
            secure: secure ?? self.secure,
            selectorType: selectorType ?? self.selectorType,
            title: title ?? self.title,
            truncateTo: truncateTo ?? self.truncateTo,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataTable
public struct DataTable: Codable {
    public let rows: [DataTableRow]
    public let rowSeparator: RowSeparator?

    public init(rows: [DataTableRow], rowSeparator: RowSeparator?) {
        self.rows = rows
        self.rowSeparator = rowSeparator
    }
}

// MARK: DataTable convenience initializers and mutators

public extension DataTable {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataTable.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        rows: [DataTableRow]? = nil,
        rowSeparator: RowSeparator?? = nil
    ) -> DataTable {
        return DataTable(
            rows: rows ?? self.rows,
            rowSeparator: rowSeparator ?? self.rowSeparator
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RowSeparator
public struct RowSeparator: Codable {
    public let color: String?
    public let height: Double?

    public init(color: String?, height: Double?) {
        self.color = color
        self.height = height
    }
}

// MARK: RowSeparator convenience initializers and mutators

public extension RowSeparator {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RowSeparator.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        color: String?? = nil,
        height: Double?? = nil
    ) -> RowSeparator {
        return RowSeparator(
            color: color ?? self.color,
            height: height ?? self.height
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataTableRow
public struct DataTableRow: Codable {
    public let cells: [DataTableCell]

    public init(cells: [DataTableCell]) {
        self.cells = cells
    }
}

// MARK: DataTableRow convenience initializers and mutators

public extension DataTableRow {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataTableRow.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        cells: [DataTableCell]? = nil
    ) -> DataTableRow {
        return DataTableRow(
            cells: cells ?? self.cells
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataTableCell
public struct DataTableCell: Codable {
    public let backgroundColor: String?
    public let fontSize: FontSize?
    public let fontWeight: FontWeight?
    public let foregroundColor: String?
    public let text: String
    public let url: String?

    public init(backgroundColor: String?, fontSize: FontSize?, fontWeight: FontWeight?, foregroundColor: String?, text: String, url: String?) {
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.foregroundColor = foregroundColor
        self.text = text
        self.url = url
    }
}

// MARK: DataTableCell convenience initializers and mutators

public extension DataTableCell {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataTableCell.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        backgroundColor: String?? = nil,
        fontSize: FontSize?? = nil,
        fontWeight: FontWeight?? = nil,
        foregroundColor: String?? = nil,
        text: String? = nil,
        url: String?? = nil
    ) -> DataTableCell {
        return DataTableCell(
            backgroundColor: backgroundColor ?? self.backgroundColor,
            fontSize: fontSize ?? self.fontSize,
            fontWeight: fontWeight ?? self.fontWeight,
            foregroundColor: foregroundColor ?? self.foregroundColor,
            text: text ?? self.text,
            url: url ?? self.url
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum FontSize: String, Codable {
    case large = "LARGE"
    case normal = "NORMAL"
    case small = "SMALL"
}

public enum FontWeight: String, Codable {
    case bold = "BOLD"
    case normal = "NORMAL"
}

// MARK: - GroupedOptions
public struct GroupedOptions: Codable {
    public let options: [GroupedOption]?
    public let tagsOrder: String?

    public init(options: [GroupedOption]?, tagsOrder: String?) {
        self.options = options
        self.tagsOrder = tagsOrder
    }
}

// MARK: GroupedOptions convenience initializers and mutators

public extension GroupedOptions {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GroupedOptions.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        options: [GroupedOption]?? = nil,
        tagsOrder: String?? = nil
    ) -> GroupedOptions {
        return GroupedOptions(
            options: options ?? self.options,
            tagsOrder: tagsOrder ?? self.tagsOrder
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - GroupedOption
public struct GroupedOption: Codable {
    public let image: String?
    public let name, tag, value: String?

    public init(image: String?, name: String?, tag: String?, value: String?) {
        self.image = image
        self.name = name
        self.tag = tag
        self.value = value
    }
}

// MARK: GroupedOption convenience initializers and mutators

public extension GroupedOption {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GroupedOption.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        image: String?? = nil,
        name: String?? = nil,
        tag: String?? = nil,
        value: String?? = nil
    ) -> GroupedOption {
        return GroupedOption(
            image: image ?? self.image,
            name: name ?? self.name,
            tag: tag ?? self.tag,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ListOption
public struct ListOption: Codable {
    public let dataTable: DataTable?
    public let image: String?
    public let name, value: String?

    public init(dataTable: DataTable?, image: String?, name: String?, value: String?) {
        self.dataTable = dataTable
        self.image = image
        self.name = name
        self.value = value
    }
}

// MARK: ListOption convenience initializers and mutators

public extension ListOption {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ListOption.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        dataTable: DataTable?? = nil,
        image: String?? = nil,
        name: String?? = nil,
        value: String?? = nil
    ) -> ListOption {
        return ListOption(
            dataTable: dataTable ?? self.dataTable,
            image: image ?? self.image,
            name: name ?? self.name,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum FormItemTypes: String, Codable {
    case checkbox = "CHECKBOX"
    case coordinates = "COORDINATES"
    case dataTable = "DATA_TABLE"
    case formItemTypesSWITCH = "SWITCH"
    case groupedList = "GROUPED_LIST"
    case headerCheckbox = "HEADER_CHECKBOX"
    case imageChallenge = "IMAGE_CHALLENGE"
    case list = "LIST"
    case otp = "OTP"
    case rut = "RUT"
    case separator = "SEPARATOR"
    case text = "TEXT"
}

// MARK: - Progress
public struct Progress: Codable {
    public let current, total: Int?

    public init(current: Int?, total: Int?) {
        self.current = current
        self.total = total
    }
}

// MARK: Progress convenience initializers and mutators

public extension Progress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Progress.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        current: Int?? = nil,
        total: Int?? = nil
    ) -> Progress {
        return Progress(
            current: current ?? self.current,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FormResponse
public struct FormResponse: Codable {
    public let answers: [FormItemAnswer]
    public let id: String
    public let type: MessageType

    public init(answers: [FormItemAnswer], id: String, type: MessageType) {
        self.answers = answers
        self.id = id
        self.type = type
    }
}

// MARK: FormResponse convenience initializers and mutators

public extension FormResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FormResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        answers: [FormItemAnswer]? = nil,
        id: String? = nil,
        type: MessageType? = nil
    ) -> FormResponse {
        return FormResponse(
            answers: answers ?? self.answers,
            id: id ?? self.id,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - FormItemAnswer
public struct FormItemAnswer: Codable {
    public let id: String
    public let type: FormItemTypes
    public let value: String

    public init(id: String, type: FormItemTypes, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
}

// MARK: FormItemAnswer convenience initializers and mutators

public extension FormItemAnswer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FormItemAnswer.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String? = nil,
        type: FormItemTypes? = nil,
        value: String? = nil
    ) -> FormItemAnswer {
        return FormItemAnswer(
            id: id ?? self.id,
            type: type ?? self.type,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OpenAuthorizationApp
public struct OpenAuthorizationApp: Codable {
    public let data: OpenAuthorizationAppData
    public let type: MessageType

    public init(data: OpenAuthorizationAppData, type: MessageType) {
        self.data = data
        self.type = type
    }
}

// MARK: OpenAuthorizationApp convenience initializers and mutators

public extension OpenAuthorizationApp {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OpenAuthorizationApp.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: OpenAuthorizationAppData? = nil,
        type: MessageType? = nil
    ) -> OpenAuthorizationApp {
        return OpenAuthorizationApp(
            data: data ?? self.data,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OpenAuthorizationAppData
public struct OpenAuthorizationAppData: Codable {
    public let android: AndroidAppDetails?
    public let ios: IOSAppDetails?

    public init(android: AndroidAppDetails?, ios: IOSAppDetails?) {
        self.android = android
        self.ios = ios
    }
}

// MARK: OpenAuthorizationAppData convenience initializers and mutators

public extension OpenAuthorizationAppData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OpenAuthorizationAppData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        android: AndroidAppDetails?? = nil,
        ios: IOSAppDetails?? = nil
    ) -> OpenAuthorizationAppData {
        return OpenAuthorizationAppData(
            android: android ?? self.android,
            ios: ios ?? self.ios
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AndroidAppDetails
public struct AndroidAppDetails: Codable {
    public let packageName: String

    public init(packageName: String) {
        self.packageName = packageName
    }
}

// MARK: AndroidAppDetails convenience initializers and mutators

public extension AndroidAppDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AndroidAppDetails.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        packageName: String? = nil
    ) -> AndroidAppDetails {
        return AndroidAppDetails(
            packageName: packageName ?? self.packageName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - IOSAppDetails
public struct IOSAppDetails: Codable {
    public let schema, store: String

    public init(schema: String, store: String) {
        self.schema = schema
        self.store = store
    }
}

// MARK: IOSAppDetails convenience initializers and mutators

public extension IOSAppDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IOSAppDetails.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        schema: String? = nil,
        store: String? = nil
    ) -> IOSAppDetails {
        return IOSAppDetails(
            schema: schema ?? self.schema,
            store: store ?? self.store
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationDescriptorInfo
public struct OperationDescriptorInfo: Codable {
    public let data: [String: String]
    public let operationID, operationType: String
    public let type: MessageType

    public enum CodingKeys: String, CodingKey {
        case data
        case operationID = "operationId"
        case operationType, type
    }

    public init(data: [String: String], operationID: String, operationType: String, type: MessageType) {
        self.data = data
        self.operationID = operationID
        self.operationType = operationType
        self.type = type
    }
}

// MARK: OperationDescriptorInfo convenience initializers and mutators

public extension OperationDescriptorInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationDescriptorInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: [String: String]? = nil,
        operationID: String? = nil,
        operationType: String? = nil,
        type: MessageType? = nil
    ) -> OperationDescriptorInfo {
        return OperationDescriptorInfo(
            data: data ?? self.data,
            operationID: operationID ?? self.operationID,
            operationType: operationType ?? self.operationType,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationFailure
public struct OperationFailure: Codable {
    public let type: MessageType
    public let body: String?
    public let events: [OperationEvent]?
    public let exitURL, operationID, resultMessage, title: String?
    public let reason: FailureReasonType?

    public enum CodingKeys: String, CodingKey {
        case type, body, events
        case exitURL = "exitUrl"
        case operationID = "operationId"
        case resultMessage, title, reason
    }

    public init(type: MessageType, body: String?, events: [OperationEvent]?, exitURL: String?, operationID: String?, resultMessage: String?, title: String?, reason: FailureReasonType?) {
        self.type = type
        self.body = body
        self.events = events
        self.exitURL = exitURL
        self.operationID = operationID
        self.resultMessage = resultMessage
        self.title = title
        self.reason = reason
    }
}

// MARK: OperationFailure convenience initializers and mutators

public extension OperationFailure {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationFailure.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil,
        body: String?? = nil,
        events: [OperationEvent]?? = nil,
        exitURL: String?? = nil,
        operationID: String?? = nil,
        resultMessage: String?? = nil,
        title: String?? = nil,
        reason: FailureReasonType?? = nil
    ) -> OperationFailure {
        return OperationFailure(
            type: type ?? self.type,
            body: body ?? self.body,
            events: events ?? self.events,
            exitURL: exitURL ?? self.exitURL,
            operationID: operationID ?? self.operationID,
            resultMessage: resultMessage ?? self.resultMessage,
            title: title ?? self.title,
            reason: reason ?? self.reason
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationEvent
public struct OperationEvent: Codable {
    public let name, timestamp, type: String

    public init(name: String, timestamp: String, type: String) {
        self.name = name
        self.timestamp = timestamp
        self.type = type
    }
}

// MARK: OperationEvent convenience initializers and mutators

public extension OperationEvent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationEvent.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: String? = nil,
        timestamp: String? = nil,
        type: String? = nil
    ) -> OperationEvent {
        return OperationEvent(
            name: name ?? self.name,
            timestamp: timestamp ?? self.timestamp,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum FailureReasonType: String, Codable {
    case acquirePageError = "ACQUIRE_PAGE_ERROR"
    case bankWithoutAutomaton = "BANK_WITHOUT_AUTOMATON"
    case formTimeout = "FORM_TIMEOUT"
    case invalidOperationID = "INVALID_OPERATION_ID"
    case noBackendAvailable = "NO_BACKEND_AVAILABLE"
    case realTimeout = "REAL_TIMEOUT"
    case serverDisconnected = "SERVER_DISCONNECTED"
    case succeededDelayedNotAllowed = "SUCCEEDED_DELAYED_NOT_ALLOWED"
    case taskDownloadError = "TASK_DOWNLOAD_ERROR"
    case taskDumped = "TASK_DUMPED"
    case taskExecutionError = "TASK_EXECUTION_ERROR"
    case taskFinished = "TASK_FINISHED"
    case taskNotificationError = "TASK_NOTIFICATION_ERROR"
    case userCanceled = "USER_CANCELED"
}

// MARK: - OperationFinish
public struct OperationFinish: Codable {
    public let body: String?
    public let events: [OperationEvent]?
    public let exitURL, operationID, resultMessage, title: String?
    public let type: MessageType

    public enum CodingKeys: String, CodingKey {
        case body, events
        case exitURL = "exitUrl"
        case operationID = "operationId"
        case resultMessage, title, type
    }

    public init(body: String?, events: [OperationEvent]?, exitURL: String?, operationID: String?, resultMessage: String?, title: String?, type: MessageType) {
        self.body = body
        self.events = events
        self.exitURL = exitURL
        self.operationID = operationID
        self.resultMessage = resultMessage
        self.title = title
        self.type = type
    }
}

// MARK: OperationFinish convenience initializers and mutators

public extension OperationFinish {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationFinish.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        body: String?? = nil,
        events: [OperationEvent]?? = nil,
        exitURL: String?? = nil,
        operationID: String?? = nil,
        resultMessage: String?? = nil,
        title: String?? = nil,
        type: MessageType? = nil
    ) -> OperationFinish {
        return OperationFinish(
            body: body ?? self.body,
            events: events ?? self.events,
            exitURL: exitURL ?? self.exitURL,
            operationID: operationID ?? self.operationID,
            resultMessage: resultMessage ?? self.resultMessage,
            title: title ?? self.title,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationInfo
public struct OperationInfo: Codable {
    public let acceptManualTransfer: Bool?
    public let amount, body, email: String?
    public let merchant: Merchant?
    public let operationID, subject: String?
    public let type: MessageType
    public let urls: Urls?
    public let welcomeScreen: WelcomeScreen?

    public enum CodingKeys: String, CodingKey {
        case acceptManualTransfer, amount, body, email, merchant
        case operationID = "operationId"
        case subject, type, urls, welcomeScreen
    }

    public init(acceptManualTransfer: Bool?, amount: String?, body: String?, email: String?, merchant: Merchant?, operationID: String?, subject: String?, type: MessageType, urls: Urls?, welcomeScreen: WelcomeScreen?) {
        self.acceptManualTransfer = acceptManualTransfer
        self.amount = amount
        self.body = body
        self.email = email
        self.merchant = merchant
        self.operationID = operationID
        self.subject = subject
        self.type = type
        self.urls = urls
        self.welcomeScreen = welcomeScreen
    }
}

// MARK: OperationInfo convenience initializers and mutators

public extension OperationInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        acceptManualTransfer: Bool?? = nil,
        amount: String?? = nil,
        body: String?? = nil,
        email: String?? = nil,
        merchant: Merchant?? = nil,
        operationID: String?? = nil,
        subject: String?? = nil,
        type: MessageType? = nil,
        urls: Urls?? = nil,
        welcomeScreen: WelcomeScreen?? = nil
    ) -> OperationInfo {
        return OperationInfo(
            acceptManualTransfer: acceptManualTransfer ?? self.acceptManualTransfer,
            amount: amount ?? self.amount,
            body: body ?? self.body,
            email: email ?? self.email,
            merchant: merchant ?? self.merchant,
            operationID: operationID ?? self.operationID,
            subject: subject ?? self.subject,
            type: type ?? self.type,
            urls: urls ?? self.urls,
            welcomeScreen: welcomeScreen ?? self.welcomeScreen
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Merchant
public struct Merchant: Codable {
    public let logo: String?
    public let name: String?

    public init(logo: String?, name: String?) {
        self.logo = logo
        self.name = name
    }
}

// MARK: Merchant convenience initializers and mutators

public extension Merchant {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Merchant.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        logo: String?? = nil,
        name: String?? = nil
    ) -> Merchant {
        return Merchant(
            logo: logo ?? self.logo,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Urls
public struct Urls: Codable {
    public let attachment: [String]?
    public let cancel, changePaymentMethod, fallback: String?
    public let image: String?
    public let info, manualTransfer, urlsReturn: String?

    public enum CodingKeys: String, CodingKey {
        case attachment, cancel, changePaymentMethod, fallback, image, info, manualTransfer
        case urlsReturn = "return"
    }

    public init(attachment: [String]?, cancel: String?, changePaymentMethod: String?, fallback: String?, image: String?, info: String?, manualTransfer: String?, urlsReturn: String?) {
        self.attachment = attachment
        self.cancel = cancel
        self.changePaymentMethod = changePaymentMethod
        self.fallback = fallback
        self.image = image
        self.info = info
        self.manualTransfer = manualTransfer
        self.urlsReturn = urlsReturn
    }
}

// MARK: Urls convenience initializers and mutators

public extension Urls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Urls.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        attachment: [String]?? = nil,
        cancel: String?? = nil,
        changePaymentMethod: String?? = nil,
        fallback: String?? = nil,
        image: String?? = nil,
        info: String?? = nil,
        manualTransfer: String?? = nil,
        urlsReturn: String?? = nil
    ) -> Urls {
        return Urls(
            attachment: attachment ?? self.attachment,
            cancel: cancel ?? self.cancel,
            changePaymentMethod: changePaymentMethod ?? self.changePaymentMethod,
            fallback: fallback ?? self.fallback,
            image: image ?? self.image,
            info: info ?? self.info,
            manualTransfer: manualTransfer ?? self.manualTransfer,
            urlsReturn: urlsReturn ?? self.urlsReturn
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WelcomeScreen
public struct WelcomeScreen: Codable {
    public let enabled: Bool?
    public let ttl: Double?

    public init(enabled: Bool?, ttl: Double?) {
        self.enabled = enabled
        self.ttl = ttl
    }
}

// MARK: WelcomeScreen convenience initializers and mutators

public extension WelcomeScreen {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WelcomeScreen.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        enabled: Bool?? = nil,
        ttl: Double?? = nil
    ) -> WelcomeScreen {
        return WelcomeScreen(
            enabled: enabled ?? self.enabled,
            ttl: ttl ?? self.ttl
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationMustContinue
public struct OperationMustContinue: Codable {
    public let type: MessageType
    public let body: String?
    public let events: [OperationEvent]?
    public let exitURL, operationID, resultMessage, title: String?
    public let reason: FailureReasonType?

    public enum CodingKeys: String, CodingKey {
        case type, body, events
        case exitURL = "exitUrl"
        case operationID = "operationId"
        case resultMessage, title, reason
    }

    public init(type: MessageType, body: String?, events: [OperationEvent]?, exitURL: String?, operationID: String?, resultMessage: String?, title: String?, reason: FailureReasonType?) {
        self.type = type
        self.body = body
        self.events = events
        self.exitURL = exitURL
        self.operationID = operationID
        self.resultMessage = resultMessage
        self.title = title
        self.reason = reason
    }
}

// MARK: OperationMustContinue convenience initializers and mutators

public extension OperationMustContinue {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationMustContinue.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil,
        body: String?? = nil,
        events: [OperationEvent]?? = nil,
        exitURL: String?? = nil,
        operationID: String?? = nil,
        resultMessage: String?? = nil,
        title: String?? = nil,
        reason: FailureReasonType?? = nil
    ) -> OperationMustContinue {
        return OperationMustContinue(
            type: type ?? self.type,
            body: body ?? self.body,
            events: events ?? self.events,
            exitURL: exitURL ?? self.exitURL,
            operationID: operationID ?? self.operationID,
            resultMessage: resultMessage ?? self.resultMessage,
            title: title ?? self.title,
            reason: reason ?? self.reason
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationRequest
public struct OperationRequest: Codable {
    public let message: String?
    public let type: MessageType

    public init(message: String?, type: MessageType) {
        self.message = message
        self.type = type
    }
}

// MARK: OperationRequest convenience initializers and mutators

public extension OperationRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        message: String?? = nil,
        type: MessageType? = nil
    ) -> OperationRequest {
        return OperationRequest(
            message: message ?? self.message,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationResponse
public struct OperationResponse: Codable {
    public let fingerprint, operationDescriptor, operationID: String?
    public let sessionCookie: SessionCookie?
    public let type: MessageType

    public enum CodingKeys: String, CodingKey {
        case fingerprint, operationDescriptor
        case operationID = "operationId"
        case sessionCookie, type
    }

    public init(fingerprint: String?, operationDescriptor: String?, operationID: String?, sessionCookie: SessionCookie?, type: MessageType) {
        self.fingerprint = fingerprint
        self.operationDescriptor = operationDescriptor
        self.operationID = operationID
        self.sessionCookie = sessionCookie
        self.type = type
    }
}

// MARK: OperationResponse convenience initializers and mutators

public extension OperationResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        fingerprint: String?? = nil,
        operationDescriptor: String?? = nil,
        operationID: String?? = nil,
        sessionCookie: SessionCookie?? = nil,
        type: MessageType? = nil
    ) -> OperationResponse {
        return OperationResponse(
            fingerprint: fingerprint ?? self.fingerprint,
            operationDescriptor: operationDescriptor ?? self.operationDescriptor,
            operationID: operationID ?? self.operationID,
            sessionCookie: sessionCookie ?? self.sessionCookie,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SessionCookie
public struct SessionCookie: Codable {
    public let name, value: String?

    public init(name: String?, value: String?) {
        self.name = name
        self.value = value
    }
}

// MARK: SessionCookie convenience initializers and mutators

public extension SessionCookie {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SessionCookie.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: String?? = nil,
        value: String?? = nil
    ) -> SessionCookie {
        return SessionCookie(
            name: name ?? self.name,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationSuccess
public struct OperationSuccess: Codable {
    public let canUpdateEmail: Bool?
    public let type: MessageType
    public let body: String?
    public let events: [OperationEvent]?
    public let exitURL, operationID, resultMessage, title: String?

    public enum CodingKeys: String, CodingKey {
        case canUpdateEmail, type, body, events
        case exitURL = "exitUrl"
        case operationID = "operationId"
        case resultMessage, title
    }

    public init(canUpdateEmail: Bool?, type: MessageType, body: String?, events: [OperationEvent]?, exitURL: String?, operationID: String?, resultMessage: String?, title: String?) {
        self.canUpdateEmail = canUpdateEmail
        self.type = type
        self.body = body
        self.events = events
        self.exitURL = exitURL
        self.operationID = operationID
        self.resultMessage = resultMessage
        self.title = title
    }
}

// MARK: OperationSuccess convenience initializers and mutators

public extension OperationSuccess {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationSuccess.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        canUpdateEmail: Bool?? = nil,
        type: MessageType? = nil,
        body: String?? = nil,
        events: [OperationEvent]?? = nil,
        exitURL: String?? = nil,
        operationID: String?? = nil,
        resultMessage: String?? = nil,
        title: String?? = nil
    ) -> OperationSuccess {
        return OperationSuccess(
            canUpdateEmail: canUpdateEmail ?? self.canUpdateEmail,
            type: type ?? self.type,
            body: body ?? self.body,
            events: events ?? self.events,
            exitURL: exitURL ?? self.exitURL,
            operationID: operationID ?? self.operationID,
            resultMessage: resultMessage ?? self.resultMessage,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OperationWarning
public struct OperationWarning: Codable {
    public let type: MessageType
    public let body: String?
    public let events: [OperationEvent]?
    public let exitURL, operationID, resultMessage, title: String?
    public let reason: FailureReasonType?

    public enum CodingKeys: String, CodingKey {
        case type, body, events
        case exitURL = "exitUrl"
        case operationID = "operationId"
        case resultMessage, title, reason
    }

    public init(type: MessageType, body: String?, events: [OperationEvent]?, exitURL: String?, operationID: String?, resultMessage: String?, title: String?, reason: FailureReasonType?) {
        self.type = type
        self.body = body
        self.events = events
        self.exitURL = exitURL
        self.operationID = operationID
        self.resultMessage = resultMessage
        self.title = title
        self.reason = reason
    }
}

// MARK: OperationWarning convenience initializers and mutators

public extension OperationWarning {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OperationWarning.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil,
        body: String?? = nil,
        events: [OperationEvent]?? = nil,
        exitURL: String?? = nil,
        operationID: String?? = nil,
        resultMessage: String?? = nil,
        title: String?? = nil,
        reason: FailureReasonType?? = nil
    ) -> OperationWarning {
        return OperationWarning(
            type: type ?? self.type,
            body: body ?? self.body,
            events: events ?? self.events,
            exitURL: exitURL ?? self.exitURL,
            operationID: operationID ?? self.operationID,
            resultMessage: resultMessage ?? self.resultMessage,
            title: title ?? self.title,
            reason: reason ?? self.reason
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PreAuthorizationCanceled
public struct PreAuthorizationCanceled: Codable {
    public let type: MessageType

    public init(type: MessageType) {
        self.type = type
    }
}

// MARK: PreAuthorizationCanceled convenience initializers and mutators

public extension PreAuthorizationCanceled {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PreAuthorizationCanceled.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil
    ) -> PreAuthorizationCanceled {
        return PreAuthorizationCanceled(
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PreAuthorizationStarted
public struct PreAuthorizationStarted: Codable {
    public let type: MessageType

    public init(type: MessageType) {
        self.type = type
    }
}

// MARK: PreAuthorizationStarted convenience initializers and mutators

public extension PreAuthorizationStarted {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PreAuthorizationStarted.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: MessageType? = nil
    ) -> PreAuthorizationStarted {
        return PreAuthorizationStarted(
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ProgressInfo
public struct ProgressInfo: Codable {
    public let message: String?
    public let type: MessageType

    public init(message: String?, type: MessageType) {
        self.message = message
        self.type = type
    }
}

// MARK: ProgressInfo convenience initializers and mutators

public extension ProgressInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProgressInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        message: String?? = nil,
        type: MessageType? = nil
    ) -> ProgressInfo {
        return ProgressInfo(
            message: message ?? self.message,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SiteInfo
public struct SiteInfo: Codable {
    public let name: String?
    public let type: MessageType

    public init(name: String?, type: MessageType) {
        self.name = name
        self.type = type
    }
}

// MARK: SiteInfo convenience initializers and mutators

public extension SiteInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SiteInfo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: String?? = nil,
        type: MessageType? = nil
    ) -> SiteInfo {
        return SiteInfo(
            name: name ?? self.name,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SiteOperationComplete
public struct SiteOperationComplete: Codable {
    public let operationType: OperationType
    public let type: MessageType
    public let value: String

    public init(operationType: OperationType, type: MessageType, value: String) {
        self.operationType = operationType
        self.type = type
        self.value = value
    }
}

// MARK: SiteOperationComplete convenience initializers and mutators

public extension SiteOperationComplete {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SiteOperationComplete.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        operationType: OperationType? = nil,
        type: MessageType? = nil,
        value: String? = nil
    ) -> SiteOperationComplete {
        return SiteOperationComplete(
            operationType: operationType ?? self.operationType,
            type: type ?? self.type,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum OperationType: String, Codable {
    case accountNumberSelected = "ACCOUNT_NUMBER_SELECTED"
    case amountUpdated = "AMOUNT_UPDATED"
    case bankSelected = "BANK_SELECTED"
    case brandColorUpdated = "BRAND_COLOR_UPDATED"
    case personalIdentifier = "PERSONAL_IDENTIFIER"
}

// MARK: - Translations
public struct Translations: Codable {
    public let data: [String: String]?
    public let type: MessageType

    public init(data: [String: String]?, type: MessageType) {
        self.data = data
        self.type = type
    }
}

// MARK: Translations convenience initializers and mutators

public extension Translations {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Translations.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: [String: String]?? = nil,
        type: MessageType? = nil
    ) -> Translations {
        return Translations(
            data: data ?? self.data,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
