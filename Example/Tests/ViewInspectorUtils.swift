import XCTest
@testable import KhipuClientIOS
import SwiftUI
import ViewInspector


@available(iOS 13.0, *)
class MockKhipuViewModel: KhipuViewModel {
    override init() {
        super.init()
        uiState.translator = KhipuTranslator(translations: [
            "noKhenshinBackendsAvailable": "No hay recursos disponibles para iniciar el pago",
            "payerEmail": "Correo",
            "payerEmailHint": "Te enviaremos el comprobante aquí",
            "payerEmailPlaceholder": "Ej: nombre@correo.com",
            "updatingPayment": "Actualizando el pago",
            "downloadingAutomaton": "Iniciando el proceso",
            "downloadingKhenshinHelper {{helperId}}": "Preparando la transacción",
            "downloadingLibrary {{libraryId}}": "Preparando la transacción",
            "startingOperation": "Iniciando una conexión segura",
            "operationFailedTitle": "No se pudo completar la transferencia",
            "operationFailedBody": "Por favor, inténtalo más tarde",
            "operationAlreadyPayedTitle": "Este cobro ya fue pagado",
            "operationAlreadyPayedBody": "Revisa tu correo, ya deberías tener un comprobante de pago asociado",
            "operationDeletedTitle": "Cobro eliminado",
            "operationDeletedBody": "El cobro ha sido eliminado por el comercio",
            "operationInVerificationTitle": "Tu transferencia aún no está acreditada",
            "operationInVerificationBody": "Antes de reintentar pagar, revisa tu cartola, así evitarás pagos duplicados.",
            "operationSucceededTitle": "Pago realizado",
            "operationSucceededBody": "Enviaremos el comprobante de pago a tu correo",
            "operationCodeCopiedText": "Código de operación copiado",
            "operationSucceededDelayedTitle": "Tu transferencia aún no está acreditada",
            "operationSucceededDelayedBody": "Tu banco informa que faltan pasos para que la transferencia se complete. Si tu cuenta requiere más de un firmante, es necesario que se conecte a la página del banco para autorizar el proceso. En cuanto el banco verifique la transferencia, khipu te enviará un comprobante de pago",
            "operationFailedAfterPreNotificationTitle": "Tu transferencia aún no está acreditada",
            "operationFailedAfterPreNotificationBody": "Tu banco no ha confirmado la transferencia, pero esta pudo haberse realizado. Por favor revisa tu cartola antes de volver a intentar el pago",
            "operationFailedFormTimedOutTitle": "No se pudo completar la transferencia",
            "operationFailedFormTimedOutBody": "Has sobrepasado el tiempo máximo para completar el formulario",
            "operationFailedFormTimedOutAfterPreNotificationTitle": "Tu transferencia aún no está acreditada",
            "operationFailedFormTimedOutAfterPreNotificationBody": "Tu banco no ha confirmado la transferencia, pero esta pudo haberse realizado. Por favor revisa tu cartola antes de volver a intentar el pago",
            "automatonDownloadErrorTitle": "No se pudo completar la transferencia",
            "automatonDownloadErrorBody": "No se puede descargar la información para iniciar el pago",
            "askEmailTitle": "Ingresa un correo para tu comprobante de pago",
            "askBankTitle": "Selecciona tu banco o cuenta",
            "askCancelOperationTitle": "¿Quieres salir del pago?",
            "abortOperationOption": "Sí, salir del pago",
            "continueOperationOption": "No, continuar pagando",
            "askAreYouThereTitle": "¿Sigues ahí?",
            "continueOperationLabel": "Continua con tu pago, ",
            "sessionAboutToEnd": "¡La sesión está a punto de cerrarse!",
            "continueOperationButton": "Continuar pago",
            "restartingOperationTitle": "Hemos encontrado un problema, la transferencia no ocurrió. Por favor, reintente",
            "operationCodeTitle": "Código",
            "operationCodeLabel": "Código operación",
            "operationCodeShortLabel": "Cód. operación",
            "merchantLabel": "Comercio",
            "amountLabel": "Monto",
            "progressMessage": "Iniciando pago...",
            "cancelLinkText": "Anular pago",
            "acceptConditionsLinkText": "Al continuar tu pago estás aceptando las ||condiciones de uso del servicio de Khipu",
            "failureMessageHeaderText": "Pago no realizado",
            "pageFailedToLoadTitle": "La página no se pudo cargar",
            "pageFailedToLoadBody": "El sitio está tomando demasiado tiempo en cargar. Por favor, reintente",
            "welcomeScreenTitle": "Paga con tu banco",
            "welcomeScreenHowItWorks": "Cómo funciona",
            "welcomeScreenConnectWithYourBank": "Conéctate a tu banco con Khipu.",
            "welcomeScreenEnterCredentials": "Ingresa tus credenciales.",
            "welcomeScreenConfirmation": "Recibe la confirmación en pantalla.",
            "welcomeScreenSecureOperations": "Pagos más seguros",
            "welcomeScreenEncryptedConnection": "Por conexión encriptada. ||Sin almacenamiento de claves.",
            "welcomeScreenButton": "Comenzar",
            "defaultContinueLabel": "Continuar",
            "privacyPolicy": "Política de privacidad",
            "privacyPolicies": "políticas de privacidad",
            "moreInformationIn": "Más información en",
            "backToOperation": "Volver al pago",
            "usingKhipuIsSafe": "Al pagar con Khipu, nos confías tus datos. Proteger tu información es nuestra principal responsabilidad.",
            "protectedData": "Tus datos están protegidos",
            "equalOrBetterStandard": "Igualamos o superamos los estándares de seguridad de la industria bancaria.",
            "oneOperationAtATime": "Un pago a la vez",
            "credentialsForThisOperationOnly": "Tus claves son utilizadas para realizar únicamente el pago que estás autorizando.",
            "privacyLabel": "Privacidad",
            "helpLabel": "Ayuda",
            "poweredBy": "Impulsado por",
            "authorizeUsingApp": "Autoriza con tu App",
            "waitingAuthorization": "Esperando autorización",
            "redirectingOperation": "Redireccionando pago",
            "payWithRegularTransfer": "Paga con transferencia manual",
            "orTryAnotherBank": "o intenta pagar con otro banco",
            "redirectInNSeconds": "Te redireccionaremos en {{time}} segundos",
            "successOperationTitle": "¡Listo, transferiste!",
            "destinataryLabel": "Destinatario",
            "backToOriginalSite": "Volver al sitio de origen",
            "thanksLabel": "¡Gracias por preferirnos!",
            "sessionClosed": "Cerramos tu sesión",
            "timeoutTryAgain": "Se agotó el tiempo para completar el pago. Inténtalo nuevamente.",
            "timeout": "¡0:00 Tiempo!",
            "retryOperation": "Reintentar pago",
            "useOtherBank": "Pagar con otro banco",
            "detailLabel": "Detalle",
            "verifyingOperation": "Pago en verificación",
            "operationMustContinue": "La operación requiere acción de terceros",
            "operationMustContinueShareTitle": "Por favor, distribuye el siguiente enlace entre las personas encargadas de autorizar este pago.",
            "endToEndEncryption": "Cifrado de extremo a extremo",
            "onlyRegularTransferBank": "El banco seleccionado solo acepta pagos con transferencia manual",
            "merchantImageTooltip": "Logo merchant",
            "headerAmount": "MONTO A PAGAR",
            "endAndGoBack": "Finalizar y volver",
            "progressInfoTitle": "Procesando pago",
            "showAllAccountsAndBanks": "Mostrar todos",
            "enterAccountOrBankNamePlaceholder": "Ingresa el nombre",
            "merchantInfoTitle": "Detalle del pago",
            "merchantInfoDestinatary": "Destinatario",
            "merchantInfoSubject": "Asunto",
            "merchantInfoDescription": "Descripción",
            "merchantInfoAmount": "Monto a pagar",
            "merchantInfoClose": "Cerrar",
            "headerSeeDetails": "Ver detalle",
            "urlCopiedText": "URL Copiada",
            "shareContinueOperationTitle": "Continuar pago",
            "shareContinueOperationBody": "Tienes una autorización de pago pendiente. Ingresa al siguiente enlace para completar el pago.",
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
            "page.operationFailure.real.timeout.title": "No pudimos conectarnos con tu banco",
            "page.operationMustContinue.header": "Pago pendiente de firmas",
            "page.operationMustContinue.share.description": "Comparte el siguiente enlace con los firmantes para completar el pago.",
            "page.operationMustContinue.share.link.body": "Tienes una autorización de pago pendiente. Ingresa al siguiente enlace para completar el pago.",
            "page.operationMustContinue.share.link.title": "Continuar pago",
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
            "form.validation.error.default.empty":"El campo no puede estar vacío",
            "form.validation.error.default.minLength.not.met": "El campo debe tener al menos {{min}} caracteres",
            "form.validation.error.default.maxLength.exceeded": "El campo no debe tener más de {{max}} caracteres",
            "form.validation.error.default.pattern.invalid": "El valor es inválido",
            "form.validation.error.default.minValue.not.met": "El valor es menor al mínimo de {{min}}",
            "form.validation.error.default.maxValue.exceeded": "El valor es mayor al máximo de {{max}}",
            "form.validation.error.default.number.invalid": "El valor no es número",
            "form.validation.error.default.required": "El campo es requerido"
        ])
    }
}

@available(iOS 13.0, *)
class ViewInspectorUtils {
    
    static func verifyFormTitleInStack<T>(_ stack: InspectableView<T>, expectedText: String) throws -> Bool where T: MultipleViewContent {
        for index in 0..<stack.count {
            if let formTitle = try? stack.view(FormTitle.self, index) {
                let text = try formTitle.text().string()
                if text == expectedText {
                    XCTAssertEqual(text, expectedText)
                    return true
                }
            }
            if let innerHStack = try? stack.hStack(index) {
                if try verifyFormTitleInStack(innerHStack, expectedText: expectedText) {
                    return true
                }
            }
            if let innerVStack = try? stack.vStack(index) {
                if try verifyFormTitleInStack(innerVStack, expectedText: expectedText) {
                    return true
                }
            }
        }
        return false
    }
    
    
    static func verifyTextInStack<T>(_ stack: InspectableView<T>, expectedText: String) throws -> Bool where T: MultipleViewContent {
        for index in 0..<stack.count {
            if let text = try? stack.text(index).string() {
                if text == expectedText {
                    XCTAssertEqual(text, expectedText)
                    return true
                }
            }
            if let innerHStack = try? stack.hStack(index) {
                if try verifyTextInStack(innerHStack, expectedText: expectedText) {
                    return true
                }
            }
            if let innerVStack = try? stack.vStack(index) {
                if try verifyTextInStack(innerVStack, expectedText: expectedText) {
                    return true
                }
            }
        }
        return false
    }
    
    
    static func verifyButtonInStack<T>(_ stack: InspectableView<T>, expectedButtonText: String) throws -> Bool where T: MultipleViewContent {
        for index in 0..<stack.count {
            if let button = try? stack.button(index) {
                let buttonText = try button.labelView().text().string()
                if buttonText == expectedButtonText {
                    XCTAssertEqual(buttonText, expectedButtonText)
                    return true
                }
            }
            if let innerHStack = try? stack.hStack(index) {
                if try verifyButtonInStack(innerHStack, expectedButtonText: expectedButtonText) {
                    return true
                }
            }
            if let innerVStack = try? stack.vStack(index) {
                if try verifyButtonInStack(innerVStack, expectedButtonText: expectedButtonText) {
                    return true
                }
            }
        }
        return false
    }

    
}
