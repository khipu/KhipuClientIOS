import XCTest
@testable import KhipuClientIOS

final class ValidationUtilTest: XCTestCase {
    func testValidEmail() throws {
        XCTAssertTrue(ValidationUtils.isValidEmail("khipu@khipu.com"))
        XCTAssertTrue(ValidationUtils.isValidEmail("prueba@khipu.cl"))
        XCTAssertTrue(ValidationUtils.isValidEmail("kh@khipu.com"))
        XCTAssertTrue(ValidationUtils.isValidEmail("k@k.cl"))
        
        XCTAssertFalse(ValidationUtils.isValidEmail("khipu"))
        XCTAssertFalse(ValidationUtils.isValidEmail("111"))
        XCTAssertFalse(ValidationUtils.isValidEmail("K"))
        XCTAssertFalse(ValidationUtils.isValidEmail(""))
    }
    
    func testValidRut() throws {
        XCTAssertTrue(ValidationUtils.isValidRut("11111111-1"))
        XCTAssertTrue(ValidationUtils.isValidRut("22222222-2"))
        XCTAssertTrue(ValidationUtils.isValidRut("77777777-7"))
        XCTAssertTrue(ValidationUtils.isValidRut("88.888.888-8"))
        
        XCTAssertFalse(ValidationUtils.isValidRut("99999999999999"))
        XCTAssertFalse(ValidationUtils.isValidRut("1-9"))
        XCTAssertFalse(ValidationUtils.isValidRut("K"))
        XCTAssertFalse(ValidationUtils.isValidRut(""))
    }
    
    func testValidMinLength() throws {
        XCTAssertTrue(ValidationUtils.validMinLength("khp", minLength: 3))
        XCTAssertTrue(ValidationUtils.validMinLength("khipu", minLength: 3))
        
        XCTAssertFalse(ValidationUtils.validMinLength("khp", minLength: 10))
        XCTAssertFalse(ValidationUtils.validMinLength("khipu", minLength: 10))
    }
    
    func testValidMaxLength() throws {
        XCTAssertTrue(ValidationUtils.validMaxLength("khp", maxLength: 5))
        XCTAssertTrue(ValidationUtils.validMaxLength("khipu", maxLength: 5))
        
        XCTAssertFalse(ValidationUtils.validMaxLength("khp", maxLength: 2))
        XCTAssertFalse(ValidationUtils.validMaxLength("khipu", maxLength: 2))
    }
    
    func testValidMinValue() throws {
        XCTAssertTrue(ValidationUtils.validMinValue(3, minValue: 3))
        XCTAssertTrue(ValidationUtils.validMinValue(5, minValue: 3))
        
        XCTAssertFalse(ValidationUtils.validMinValue(5, minValue: 10))
        XCTAssertFalse(ValidationUtils.validMinValue(9, minValue: 10))
    }
    
    func testValidMaxValue() throws {
        XCTAssertTrue(ValidationUtils.validMaxValue(3, maxValue: 3))
        XCTAssertTrue(ValidationUtils.validMaxValue(2, maxValue: 3))
        
        XCTAssertFalse(ValidationUtils.validMaxValue(11, maxValue: 10))
        XCTAssertFalse(ValidationUtils.validMaxValue(20, maxValue: 10))
    }
    
    func testValidNumber() throws {
        XCTAssertTrue(ValidationUtils.isValidNumber("50", decimals: false))
        XCTAssertTrue(ValidationUtils.isValidNumber("50.4", decimals: true))
        
        XCTAssertFalse(ValidationUtils.isValidNumber("50Mil", decimals: false))
        XCTAssertFalse(ValidationUtils.isValidNumber("50Mil", decimals: true))
        XCTAssertFalse(ValidationUtils.isValidNumber("50.4", decimals: false))
        XCTAssertFalse(ValidationUtils.isValidNumber("Mil", decimals: true))
    }
    
    func testValidCheckRequiredState() throws {
        let translator = KhipuTranslator(
            translations: [
                "form.validation.error.switch.accept.required": "Debe aceptar",
                "form.validation.error.switch.decline.required": "Debe declinar"
            ])
        XCTAssertEqual(ValidationUtils.valiateCheckRequiredState(true, "on", translator), "")
        XCTAssertEqual(ValidationUtils.valiateCheckRequiredState(false, "off", translator), "")
        XCTAssertEqual(ValidationUtils.valiateCheckRequiredState(true, "off", translator), "Debe declinar")
        XCTAssertEqual(ValidationUtils.valiateCheckRequiredState(false, "on", translator), "Debe aceptar")
    }
}
