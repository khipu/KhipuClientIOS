import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
class MockDataGenerator {
    static func createOperationInfo(
        acceptManualTransfer: Bool = true,
        amount: String = "$",
        body: String = "Transaction Body",
        email: String = "example@example.com",
        merchantLogo: String = "merchant_logo",
        merchantName: String = "[nombre]",
        operationID: String = "12345",
        subject: String = "Transaction Subject",
        type: MessageType = .operationInfo,
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
        return OperationInfo(
            acceptManualTransfer: acceptManualTransfer,
            amount: amount,
            body: body,
            email: email,
            merchant: Merchant(logo: merchantLogo, name: merchantName),
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
            "form.validation.error.switch.accept.required": "Debes aceptar"
        ])
    }
}
