import SwiftUI
import KhenshinProtocol


@available(iOS 15.0, *)
class MockDataGenerator {
    static func createOperationInfo(
        acceptManualTransfer: Bool = true,
        amount: String = "$",
        body: String = "Transaction Body",
        email: String = "example@example.com",
        merchantLogo: String? = nil,
        merchantName: String? = nil,
        operationID: String = "12345",
        subject: String = "Transaction Subject",
        type: MessageType = .operationInfo,
        merchant: Merchant? = nil,
        urls: Urls = Urls(
            attachment: ["https://example.com/attachment"],
            cancel: "https://example.com/cancel",
            changePaymentMethod: "https://example.com/changePaymentMethod",
            fallback: "https://example.com/fallback",
            image: "https://example.com/image",
            info: "https://example.com/info",
            manualTransfer: "https://example.com/manualTransfer",
            urlsReturn: "https://example.com/return"
        ),
        welcomeScreen: WelcomeScreen = WelcomeScreen(enabled: true, ttl: 3600)
    ) -> OperationInfo {
        let merchant: Merchant? = {
            if let logo = merchantLogo, let name = merchantName, !logo.isEmpty, !name.isEmpty {
                return Merchant(logo: logo, name: name)
            }
            return nil
        }()

        return OperationInfo(
            acceptManualTransfer: acceptManualTransfer,
            amount: amount,
            body: body,
            email: email,
            merchant: merchant,
            operationID: operationID,
            subject: subject,
            type: type,
            urls: urls,
            welcomeScreen: welcomeScreen
        )
    }
    
    static func createOperationWarning(
        type: MessageType = .operationWarning,
        body: String = "[Mensaje autómata].",
        events: [OperationEvent]? = nil,
        exitURL: String = "exitUrl",
        operationID: String = "htre-2345-hqtt",
        resultMessage: String = "resultMessage",
        title: String = "Tu transferencia aún no está acreditada",
        reason: FailureReasonType = .taskDumped
    ) -> OperationWarning {
        return OperationWarning(
            type: type,
            body: body,
            events: events,
            exitURL: exitURL,
            operationID: operationID,
            resultMessage: resultMessage,
            title: title,
            reason: reason
        )
    }
    
    static func createOperationFailure(
        type: MessageType = .operationFailure,
        body: String = "[Mensaje autómata].",
        events: [OperationEvent]? = nil,
        exitURL: String = "exitUrl",
        operationID: String = "htre-2345-hqtt",
        resultMessage: String = "resultMessage",
        title: String = "Tu transferencia aún no está acreditada",
        reason: FailureReasonType = .formTimeout
    )-> OperationFailure {
        return OperationFailure(
            type: type,
            body: body,
            events: events,
            exitURL: exitURL,
            operationID: operationID,
            resultMessage: resultMessage,
            title: title,
            reason: reason
        )
    }
    
    static func createOperationMustContinue(
        type: MessageType = .operationMustContinue,
        body: String = "[Mensaje autómata].",
        events: [OperationEvent]? = nil,
        exitURL: String = "exitUrl",
        operationID: String = "htre-2345-hqtt",
        resultMessage: String = "resultMessage",
        title: String = "Tu transferencia aún no está acreditada",
        reason: FailureReasonType = .formTimeout
    )-> OperationMustContinue {
        return OperationMustContinue(
            type: type,
            body: body,
            events: events,
            exitURL: exitURL,
            operationID: operationID,
            resultMessage: resultMessage,
            title: title,
            reason: reason
        )
    }
    
    static func createOperationSuccess(
        canUpdateEmail: Bool = false,
        type: MessageType = .operationSuccess,
        body: String = "Enviaremos el comprobante  de pago a tu correo",
        events: [OperationEvent]? = nil,
        exitURL: String = "exitUrl",
        operationID: String = "htre-2345-hqtt",
        resultMessage: String = "resultMessage",
        title: String = "¡Listo, transferiste!"
    )-> OperationSuccess {
        return OperationSuccess(
            canUpdateEmail: canUpdateEmail,
            type: type,
            body: body,
            events: events,
            exitURL: exitURL,
            operationID: operationID,
            resultMessage: resultMessage,
            title: title
        )
    }
    
    
    static func createAuthorizationRequest(
        authorizationType: AuthorizationRequestType = .qr,
        imageData: String = "data:image/png;base64,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",
        message:String = "Abre y autoriza esta operación con tu aplicación",
        type: MessageType = .authorizationRequest
    )-> AuthorizationRequest{
        return AuthorizationRequest(
            authorizationType: authorizationType,
            imageData: imageData,
            message: message,
            type: type)
    }
    
    static func createTranslator() -> KhipuTranslator {
        return KhipuTranslator(translations: [
            "default.amount.label": "Monto",
            "default.back.to.origin.site": "Volver al sitio de origen",
            "default.continue.label": "Continuar",
            "default.destinatary.label": "Destinatario",
            "default.detail.label": "Detalle",
            "default.end.and.go.back": "Finalizar y volver",
            "default.end.to.end.encryption": "Cifrado de extremo a extremo",
            "default.merchant.label": "Comercio",
            "default.operation.bank.label": "Medio de pago",
            "default.operation.cancel.label": "Anular pago",
            "default.operation.code.label": "Código operación",
            "default.operation.code.short.label": "Cód. operación",
            "default.operation.verifying": "Pago en verificación",
            "default.powered.by": "Impulsado por",
            "default.redirect.n.seconds": "Te redireccionaremos en {{time}} segundos",
            "default.remember.credentials": "Recordar credenciales",
            "default.restart.message": "Hemos encontrado un problema, la transferencia no ocurrió. Por favor, reintente",
            "default.retry.operation": "Reintentar pago",
            "default.terms.continue.description": "Al continuar tu pago estás aceptando las ||condiciones de uso del servicio de Khipu",
            "default.thanks": "¡Gracias por preferirnos!",
            "default.user.other.bank": "Pagar con otro banco",
            "default.user.regular.transfer": "Paga con transferencia manual",
            "footer.help": "Ayuda",
            "footer.powered.by": "Impulsado por",
            "footer.privacy": "Privacidad",
            "form.bank.continue.label": "Selecciona tu banco o cuenta",
            "form.bank.find.by.name.placeholder": "Ingresa el nombre",
            "form.bank.show.all.button": "Mostrar todos",
            "form.bank.title": "Selecciona tu banco o cuenta",
            "form.bank.placeholder": "Buscar banco o institución financiera",
            "form.email.title": "Ingresa un email para recibir tu comprobante de pago",
            "form.email.label": "Correo",
            "form.email.placeholder": "Ej: nombre@correo.com",
            "form.email.tooltip": "",
            "form.password.hide": "Ocultar contraseña",
            "form.password.show": "Mostrar contraseña",
            "header.amount": "MONTO A PAGAR",
            "header.code.label": "Código",
            "header.details.show": "Ver detalle",
            "header.merchant.image.tooltip": "Logo merchant",
            "modal.abortOperation.cancel.button": "Sí, salir del pago",
            "modal.abortOperation.continue.button": "No, continuar pagando",
            "modal.abortOperation.title": "¿Quieres salir del pago?",
            "modal.authorization.use.app": "Autoriza con tu App",
            "modal.authorization.wait": "Esperando autorización",
            "modal.merchant.info.amount.label": "Monto a pagar",
            "modal.merchant.info.close.button": "Cerrar",
            "modal.merchant.info.description.label": "Descripción",
            "modal.merchant.info.destinatary.label": "Destinatario",
            "modal.merchant.info.subject.label": "Asunto",
            "modal.merchant.info.title": "Detalle del pago",
            "modal.privacy.back": "Volver al pago",
            "modal.privacy.better.standard": "Igualamos o superamos los estándares de seguridad de la industria bancaria.",
            "modal.privacy.credentials": "Tus claves son utilizadas para realizar únicamente el pago que estás autorizando.",
            "modal.privacy.khipu.is.safe": "Al pagar con Khipu, nos confías tus datos. Proteger tu información es nuestra principal responsabilidad.",
            "modal.privacy.more.information": "Más información en",
            "modal.privacy.one.at.a.time": "Un pago a la vez",
            "modal.privacy.policies": "políticas de privacidad",
            "modal.privacy.policy": "Política de privacidad",
            "modal.privacy.protected.data": "Tus datos están protegidos",
            "modal.terms.close": "Cerrar",
            "modal.biometric.authentication.title": "Autenticación biométrica",
            "modal.biometric.authentication.subtitle": "Autoriza usando tus credenciales biométricas",
            "page.are.you.there.continue.button": "Continuar pago",
            "page.are.you.there.continue.operation": "Continua con tu pago, ",
            "page.are.you.there.session.about.to.end": "¡La sesión está a punto de cerrarse!",
            "page.are.you.there.title": "¿Sigues ahí?",
            "page.operationComplete.already.body": "Revisa tu correo, ya deberías tener un comprobante de pago asociado",
            "page.operationComplete.already.title": "Este cobro ya fue pagado",
            "page.operationComplete.body": "Enviaremos el comprobante de pago a tu correo",
            "page.operationComplete.operation.code.copied": "Código de operación copiado",
            "page.operationComplete.title": "¡Listo, transferiste!",
            "page.operationFailure.cant.connect.to.bank.body": "Por favor, inténtalo más tarde",
            "page.operationFailure.cant.connect.to.bank.title": "No pudimos conectarnos con tu banco",
            "page.operationFailure.header.text.default": "Servicio no disponible",
            "page.operationFailure.header.text.operation.task.finished": "Pago no realizado",
            "page.operationFailure.no.backend.title": "No pudimos conectarnos con tu banco",
            "page.operationFailure.operation.deleted.body": "El cobro ha sido eliminado por el comercio",
            "page.operationFailure.operation.deleted.title": "Cobro eliminado",
            "page.operationFailure.operation.download.error.body": "No se puede descargar la información para iniciar el pago",
            "page.operationFailure.operation.download.error.title": "No pudimos conectarnos con tu banco",
            "page.operationFailure.operation.fail.load.body": "El sitio está tomando demasiado tiempo en cargar. Por favor, reintente",
            "page.operationFailure.operation.fail.load.title": "La página no se pudo cargar",
            "page.operationFailure.operation.form.timeout.body": "Has sobrepasado el tiempo máximo para completar el formulario",
            "page.operationFailure.operation.form.timeout.title": "No pudimos conectarnos con tu banco",
            "page.operationFailure.operation.task.finished.body": "Por favor, inténtalo más tarde",
            "page.operationFailure.operation.task.finished.title": "No se pudo completar la transferencia",
            "page.operationFailure.operation.user.canceled.title": "Pago no realizado",
            "page.operationFailure.operation.user.canceled.body": "Has decidido cancelar el pago",
            "page.operationFailure.real.timeout.title": "No pudimos conectarnos con tu banco",
            "page.operationMustContinue.header": "Pago pendiente de autorización",
            "page.operationMustContinue.share.description": "Comparte este enlace con los autorizadores para completar el pago.",
            "page.operationMustContinue.share.link.body": "Ingresa al siguiente enlace para autorizar el pago.",
            "page.operationMustContinue.share.link.title": "Tienes un pago pendiente de autorización.",
            "page.operationMustContinue.title": "Este pago requiere autorización de terceros",
            "page.operationMustContinue.url.copied": "Url Copiada",
            "page.operationWarning.failure.after.notify.pre.header": "Pago en verificación",
            "page.operationWarning.failure.after.notify.pre.body": "Tu banco no ha confirmado la transferencia, pero esta pudo haberse realizado. Por favor revisa tu cartola antes de volver a intentar el pago",
            "page.operationWarning.failure.after.notify.pre.title": "Tu transferencia aún no está acreditada",
            "page.operationWarning.operation.in.verification.body": "Antes de reintentar pagar, revisa tu cartola, así evitarás pagos duplicados.",
            "page.operationWarning.operation.in.verification.title": "Tu transferencia aún no está acreditada",
            "page.operationWarning.succeeded.delayed.body": "Tu banco informa que faltan pasos para que la transferencia se complete. Si tu cuenta requiere más de un firmante, es necesario que se conecte a la página del banco para autorizar el proceso. En cuanto el banco verifique la transferencia, khipu te enviará un comprobante de pago",
            "page.operationWarning.succeeded.delayed.title": "Tu transferencia aún no está acreditada",
            "page.operationWarning.timeout.after.notify.pre.body": "Tu banco no ha confirmado la transferencia, pero esta pudo haberse realizado. Por favor revisa tu cartola antes de volver a intentar el pago",
            "page.operationWarning.timeout.after.notify.pre.title": "Tu transferencia aún no está acreditada",
            "page.redirectManual.only.regular": "El banco seleccionado solo acepta pagos con transferencia manual",
            "page.redirectManual.other.bank": "o intenta pagar con otro banco",
            "page.redirectManual.redirecting": "Redireccionando pago",
            "page.timeout.end": "¡0:00 Tiempo!",
            "page.timeout.session.closed": "Cerramos tu sesión",
            "page.timeout.try.again": "Se agotó el tiempo para completar el pago. Inténtalo nuevamente.",
            "page.welcomeScreen.confirmation": "Recibe la confirmación en pantalla.",
            "page.welcomeScreen.connect.with.your.bank": "Conéctate a tu banco con Khipu.",
            "page.welcomeScreen.encrypted.connection": "Por conexión encriptada. ||Sin almacenamiento de claves.",
            "page.welcomeScreen.enter.credentials": "Ingresa tus credenciales.",
            "page.welcomeScreen.how.it.works": "Cómo funciona",
            "page.welcomeScreen.secure.operations": "Pagos más seguros",
            "page.welcomeScreen.start.button": "Comenzar",
            "page.welcomeScreen.title": "Paga con tu banco",
            "progress.info.default": "Procesando pago",
            "progress.info.downloading.automaton": "Iniciando el proceso",
            "progress.info.downloading.helper": "Preparando la transacción",
            "progress.info.downloading.library": "Preparando la transacción",
            "progress.info.start": "Iniciando pago...",
            "progress.info.starting.operation": "Iniciando una conexión segura",
            "progress.info.updating.operation": "Actualizando el pago",
            "form.validation.error.rut.invalid": "El RUT es inválido",
            "form.validation.error.rut.nullable": "El RUT no puede estar vacío",
            "form.validation.error.default.email.invalid": "La dirección de correo electrónico no es válida",
            "form.validation.error.default.empty": "Campo obligatorio",
            "form.validation.error.default.minLength.not.met": "El campo debe tener al menos {{min}} caracteres",
            "form.validation.error.default.maxLength.exceeded": "El campo no debe tener más de {{max}} caracteres",
            "form.validation.error.default.pattern.invalid": "El valor es inválido",
            "form.validation.error.default.minValue.not.met": "El valor es menor al mínimo de {{min}}",
            "form.validation.error.default.maxValue.exceeded": "El valor es mayor al máximo de {{max}}",
            "form.validation.error.default.number.invalid": "El valor no es número",
            "form.validation.error.default.required": "El campo es requerido",
            "form.validation.error.switch.decline.required": "Debes rechazar",
            "form.validation.error.switch.accept.required": "Debes aceptar",
            "geolocation.warning.title": "{{bank}} solicita comprobar tu ubicación",
            "geolocation.warning.description": "A continuación, se solicitará conocer tu ubicación.",
            "geolocation.warning.button.continue": "Ir a activar ubicación",
            "geolocation.warning.button.decline": "No activar ubicación",
            "geolocation.request.description": "Revisando permisos de ubicación",
            "geolocation.blocked.title": "Restablece el permiso de ubicación para continuar",
            "geolocation.blocked.description": "Activar este permiso es necesario para completar el pago en {{bank}}.",
            "geolocation.blocked.button.continue": "Activar permiso de ubicación",
            "geolocation.blocked.button.decline": "Salir"
        ])
    }
    
    static func createTextFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        hint: String = "Default Hint",
        placeHolder: String = "Default Placeholder",
        secure: Bool = false
    ) -> FormItem {
        return try! FormItem(
               """
               {
                 "id": "\(id)",
                 "label": "\(label)",
                 "type": "\(FormItemTypes.text.rawValue)",
                 "hint": "\(hint)",
                 "placeHolder": "\(placeHolder)",
                 "secure": \(secure)
               }
               """
        )
    }
    
    static func createDataTableFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        placeholder: String = "placeholder",
        dataTable: DataTable = DataTable(rows: [DataTableRow(cells: [DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)])], rowSeparator: nil),
        groupedOptions: GroupedOptions? = nil
    ) -> FormItem {
        let dataTableRowsJSON = (try? dataTable.rows.map { try $0.jsonString()! }.joined(separator: ",")) ?? ""
        let rowSeparatorJSON = (try? dataTable.rowSeparator?.jsonString() ?? "{}") ?? "{}"
        
        let dataTableJSON = """
        {
            "rows": [\(dataTableRowsJSON)],
            "rowSeparator": \(rowSeparatorJSON)
        }
        """
        
        let groupedOptionsJSON = groupedOptions != nil ? (try? groupedOptions?.jsonString() ?? "{}") ?? "{}" : nil
        
        let jsonString = """
        {
            "id": "\(id)",
            "label": "\(label)",
            "placeholder": "\(placeholder)",
            "type": "\(FormItemTypes.dataTable.rawValue)",
            "dataTable": \(dataTableJSON)
            \(groupedOptionsJSON != nil ? ", \"groupedOptions\": \(groupedOptionsJSON!)" : "")
        }
        """
        
        return try! FormItem(jsonString)
    }
    
    
    static func createOtpFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        length: Int = 4,
        hint: String = "Default Hint",
        number: Bool = true,
        secure: Bool = false
        
    ) -> FormItem {
        return try! FormItem(
               """
               {
                 "id": "\(id)",
                 "label": "\(label)",
                 "length": \(length),
                 "type": "\(FormItemTypes.otp.rawValue)",
                 "hint": "\(hint)",
                 "number": \(number),
                 "secure": \(secure)
               }
               """
        )
    }
    
    static func createSeparatorFormItem(
        id: String = "default_id",
        color: String = "#df00b9"
    ) -> FormItem {
        let jsonString = """
        {
            "id": "\(id)",
            "type": "\(FormItemTypes.separator.rawValue)",
            "color": "\(color)"
        }
        """
        return try! FormItem(jsonString)
    }
    
    static func createCheckboxFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        requiredState: String = "on",
        defaultState: String = "off",
        title: String? = nil,
        bottomText: String? = nil,
        items: [String]? = nil,
        mandatory: Bool? = nil
    ) -> FormItem {
        var jsonDict: [String: Any] = [
            "id": id,
            "label": label,
            "type": FormItemTypes.checkbox.rawValue,
            "requiredState": requiredState,
            "defaultState": defaultState
        ]
        
        if let title = title {
            jsonDict["title"] = title
        }
        
        if let bottomText = bottomText {
            jsonDict["bottomText"] = bottomText
        }
        
        if let items = items {
            jsonDict["items"] = items
        }
        
        if let mandatory = mandatory {
            jsonDict["mandatory"] = mandatory
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        return try! FormItem(jsonString)
    }
    
    static func createCoordinatesFormItem(
        id: String = "default_id",
        labels: [String] = ["A1", "A1", "A1"],
        hint: String = "",
        number: Bool = false,
        secure: Bool = false
        
    ) -> FormItem {
        let labelsJSON = labels.map { "\"\($0)\"" }.joined(separator: ", ")
        let jsonString = """
        {
            "id": "\(id)",
            "labels": [\(labelsJSON)],
            "type": "\(FormItemTypes.coordinates.rawValue)",
            "hint": "\(hint)",
            "number": \(number),
            "secure": \(secure)
        
        }
        """
        return try! FormItem(jsonString)
    }
    
    static func createImageChallengeFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        placeHolder: String = "It is a khipu",
        imageData: String = "data:image/png;base64,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",
        hint: String = "This is mandatory"
    ) -> FormItem {
        return try! FormItem(
            """
            {
                "id": "\(id)",
                "label": "\(label)",
                "placeHolder": "\(placeHolder)",
                "imageData": "\(imageData)",
                "type": "\(FormItemTypes.imageChallenge.rawValue)",
                "hint": "\(hint)"
            }
            """
        )
    }
    
    static func createListFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        placeholder: String = "placeholder",
        options: [[String: Any]]
    ) -> FormItem {
        let optionsJSON = try! JSONSerialization.data(withJSONObject: options, options: [])
        let optionsString = String(data: optionsJSON, encoding: .utf8) ?? "[]"
        
        let jsonString = """
        {
            "id": "\(id)",
            "label": "\(label)",
            "placeholder": "\(placeholder)",
            "type": "\(FormItemTypes.list.rawValue)",
            "options": \(optionsString)
        }
        """
        
        return try! FormItem(jsonString)
    }
    
    
    static func createSwitchFormItem(
        id: String = "default_id",
        label: String = "Default Label",
        defaultState: String = "on",
        requiredState: String = "on"
    ) -> FormItem {
        let jsonString = """
        {
            "id": "\(id)",
            "label": "\(label)",
            "type": "\(FormItemTypes.formItemTypesSWITCH.rawValue)",
            "defaultState": "\(defaultState)",
            "requiredState": "\(requiredState)"
        }
        """
        return try! FormItem(jsonString)
    }
    
    static func createFormRequest(
        alternativeAction: AlternativeAction? = nil,
        continueLabel: String = "Continue",
        errorMessage: String = "There are some errors",
        id: String = "default_id",
        info: String = "This is an info alert",
        items: [FormItem] = [
            createTextFormItem(id: "username", label: "Username", hint: "Enter your username", placeHolder: "Ej: Username"),
            createTextFormItem(id: "password", label: "Password", hint: "Enter your password", secure: true)
        ],
        pageTitle: String = "Page Title",
        progress: KhenshinProtocol.Progress = Progress(current: 1, total: 2),
        rememberValues: Bool = true,
        termsURL: String = "",
        timeout: Int = 300,
        title: String = "Login",
        type: MessageType = .formRequest
    ) -> FormRequest {
        return FormRequest(
            alternativeAction: alternativeAction,
            continueLabel: continueLabel,
            errorMessage: errorMessage,
            id: id,
            info: info,
            items: items,
            pageTitle: pageTitle,
            progress: progress,
            rememberValues: rememberValues,
            termsURL: termsURL,
            timeout: timeout,
            title: title,
            type: type
        )
    }
}

extension Encodable {
    func jsonString() -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}
