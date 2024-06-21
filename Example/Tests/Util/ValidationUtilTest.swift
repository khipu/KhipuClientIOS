import XCTest
import KhenshinProtocol

@testable import KhipuClientIOS

func randomString(_ length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomNumeric(_ length: Int) -> String {
    let numbers = "0123456789"
    return String((0..<length).map{ _ in numbers.randomElement()! })
}

func randomAlphabetic(_ length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

final class ValidationUtilTest: XCTestCase {
    let translator = KhipuTranslator(
        translations: [
            "form.validation.error.default.empty": "value empty",
            "form.validation.error.switch.accept.required": "must accept",
            "form.validation.error.switch.decline.required": "must decline",
            "form.validation.error.default.email.invalid": "invalid email",
            "form.validation.error.default.pattern.invalid": "invalid pattern",
            "form.validation.error.default.number.invalid": "invalid number",
            "form.validation.error.default.minValue.not.met": "min value not met",
            "form.validation.error.default.maxValue.exceeded": "max value exceeded",
            "form.validation.error.default.minLength.not.met": "min length not met",
            "form.validation.error.default.maxLength.exceeded": "max length exceeded"
        ])
    
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
        XCTAssertTrue(ValidationUtils.isValidRut("19.797.379-K"))
        XCTAssertTrue(ValidationUtils.isValidRut("19.797.379-k"))
        
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
        XCTAssertEqual(ValidationUtils.validateCheckRequiredState(true, "on", translator), "")
        XCTAssertEqual(ValidationUtils.validateCheckRequiredState(false, "off", translator), "")
        XCTAssertEqual(ValidationUtils.validateCheckRequiredState(true, "off", translator), "Debe declinar")
        XCTAssertEqual(ValidationUtils.validateCheckRequiredState(false, "on", translator), "Debe aceptar")
    }
    
    func testValidateTextField_validateEmpty() {
        let formItem = try! FormItem(
                 """
                     {
                       "id": "Some text",
                       "type": "\(FormItemTypes.text.rawValue)"
                     }
                 """
        )
        
        let error = ValidationUtils.validateTextField("", formItem, translator)
        XCTAssertEqual(error, "value empty")
    }
    
    func testValidateTextField_validateMinLength() {
        let formItem = try! FormItem(
                            """
                                {
                                  "id": "Some text",
                                  "type": "\(FormItemTypes.text.rawValue)",
                                   "minLength": 10
                                }
                            """
        )
        
        let error = ValidationUtils.validateTextField(randomAlphabetic(9), formItem, translator)
        XCTAssertEqual(error, "min length not met")
    }
    
    func testValidateTextField_validateMinLengthZero() {
        let formItem = try! FormItem(
                    """
                        {
                          "id": "Some text",
                          "type": "\(FormItemTypes.text.rawValue)",
                           "minLength": 0
                        }
                    """
        )
        
        let error = ValidationUtils.validateTextField(randomAlphabetic(9), formItem, translator        )
        XCTAssertTrue(error.isEmpty)
    }
    
    func testValidateTextField_validMinLength() {
        let formItem = try! FormItem(
                      """
                          {
                            "id": "Some text",
                            "type": "\(FormItemTypes.text.rawValue)",
                             "minLength": 10
                          }
                      """
        )
        
        XCTAssertTrue(
            ValidationUtils.validateTextField(
                randomAlphabetic(10), formItem, translator
            ).isEmpty
        )
        XCTAssertTrue(
            ValidationUtils.validateTextField(
                randomAlphabetic(11), formItem, translator
            ).isEmpty
        )
    }
    
    func testValidateTextField_validateMaxLength() {
        let formItem = try! FormItem(
             """
                 {
                   "id": "Some text",
                   "type": "\(FormItemTypes.text.rawValue)",
                    "maxLength": 10
                 }
             """
        )
        
        let error = ValidationUtils.validateTextField(
            randomAlphabetic(11), formItem, translator
        )
        XCTAssertEqual(error, "max length exceeded")
    }
    
    func testValidateTextField_validateMaxLengthZero() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "maxLength": 0
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField(
            randomAlphabetic(11), formItem, translator
        )
        assert(error.isEmpty)
    }
    
    func testValidateTextField_validMaxLength() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "maxLength": 10
                  }
              """
        )
        
        assert(ValidationUtils.validateTextField(randomAlphabetic(10), formItem, translator ).isEmpty)
        
        assert( ValidationUtils.validateTextField( randomAlphabetic(9), formItem, translator).isEmpty)
        
    }
    
    func testValidateTextField_notEmailInvalidEmail() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "email": false
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField( randomAlphabetic(11), formItem, translator)
        assert(error.isEmpty)
    }
    
    func testValidateTextField_emailInvalidEmail() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "email": true
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField(randomAlphabetic(11), formItem, translator)
        XCTAssertEqual(error, "invalid email")
    }
    
    func testValidateTextField_notPatternAndInvalid() {
        let formItem = try! FormItem(
               """
                   {
                     "id": "Some text",
                     "type": "\(FormItemTypes.text.rawValue)"
                   }
               """
        )
        
        let error = ValidationUtils.validateTextField( randomAlphabetic(10), formItem, translator)
        assert(error.isEmpty)
    }
    
    func testValidateTextField_patternAndInvalid() {
        let formItem = try! FormItem(
            """
                 {
                   "id": "Some text",
                   "type": "\(FormItemTypes.text.rawValue)",
                    "pattern": "^A.*B$"
                 }
            """
        )
        
        let error = ValidationUtils.validateTextField("abc", formItem, translator)
        XCTAssertEqual(error, "invalid pattern")
    }
    
    func testValidateTextField_patternAndValid() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "pattern": "^A.*B$"
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField("AxyzB", formItem, translator)
        XCTAssertTrue(error.isEmpty)
    }
    
    func testValidateTextField_stringNotNumber() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "number": false
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField("ABC", formItem, translator)
        XCTAssertTrue(error.isEmpty)
    }
    
    func testValidateTextField_stringInvalidNumber() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "number": true
                  }
              """
        )
        
        let error = ValidationUtils.validateTextField("ABC", formItem, translator)
        XCTAssertEqual(error, "invalid number")
    }
    
    func testValidateTextField_validateMinValue() {
        let formItem = try! FormItem(
               """
                   {
                     "id": "Some text",
                     "type": "\(FormItemTypes.text.rawValue)",
                     "number": true,
                      "minValue": 20
                   }
               """
        )
        
        let error = ValidationUtils.validateTextField("9", formItem, translator)
        XCTAssertEqual(error, "min value not met")
    }
    
    func testValidateTextField_validateMinValueZero() {
        let formItem = try! FormItem(
                """
                      {
                        "id": "Some text",
                        "type": "\(FormItemTypes.text.rawValue)",
                         "minValue": 0,
                        "number": true
                      }
                """
        )
        
        XCTAssert(ValidationUtils.validateTextField("11", formItem, translator).isEmpty)
    }
    
    func testValidateTextField_validMinValue() {
        let formItem = try! FormItem(
              """
                  {
                    "id": "Some text",
                    "type": "\(FormItemTypes.text.rawValue)",
                     "minValue": 10,
                    "number": true
                  }
              """
        )
        
        XCTAssertTrue(
            ValidationUtils.validateTextField(
                "10", formItem, translator
            ).isEmpty
        )
        XCTAssertTrue(
            ValidationUtils.validateTextField(
                "11", formItem, translator
            ).isEmpty
        )
    }
    
    func testValidateTextField_validateMaxValue() {
        let formItem = try! FormItem(
               """
                   {
                     "id": "Some text",
                     "type": "\(FormItemTypes.text.rawValue)",
                      "maxValue": 10,
                     "number": true
                   }
               """
        )
        
        let error = ValidationUtils.validateTextField("11", formItem, translator)
        XCTAssertEqual(error, "max value exceeded")
    }
    
    func testValidateTextField_validateMaxValueZero() {
        let formItem = try! FormItem(
            """
               {
                 "id": "Some text",
                 "type": "\(FormItemTypes.text.rawValue)",
                  "maxValue": 0
               }
           """
        )
        
        let error = ValidationUtils.validateTextField("11", formItem, translator)
        assert(error.isEmpty)
    }
    
    func testValidateTextField_validMaxValue() {
        let formItem = try! FormItem(
             """
                 {
                   "id": "Some text",
                   "type": "\(FormItemTypes.text.rawValue)",
                    "maxValue": 10
                 }
             """
        )
        
        assert(ValidationUtils.validateTextField("10", formItem, translator).isEmpty)
        assert(ValidationUtils.validateTextField("9", formItem, translator).isEmpty)
        
    }
    
    func testValidateRut() {
        XCTAssertEqual(ValidationUtils.validateRut("", translator), "campo obligatorio")
        XCTAssertEqual(ValidationUtils.validateRut("23423", translator), "form.validation.error.rut.invalid")
        XCTAssertEqual(ValidationUtils.validateRut("12.872.346-3", translator), "")
    }
}
