//
//  UITextField+Validation+Ext.swift
//  Synthia
//
//  Created by Walery Łojko on 24/01/2023.
//

import UIKit
import RxCocoa
import RxSwift

extension UITextField {
    typealias E = Localization.ValidationErrors
    
    var validatedEmail: ControlEvent<String> {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let source = self.rx.text.orEmpty
            .map { email in
                if email.isEmpty {
                    return E.emptyEmail
                } else if !emailPred.evaluate(with: email) {
                    return E.emailFormat
                }
                return ""
            }
        return ControlEvent(events: source)
    }
    
    var validatedPassword: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { password in
                var errors: String = ""
                if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password) {
                    errors = E.oneUppercase
                }
                if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password) {
                    errors = E.oneDigit
                }
                if !NSPredicate(format: "SELF MATCHES %@", ".*[^a-zA-Z0-9].*").evaluate(with: password) {
                    errors = E.oneSymbol
                }
                if !NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password) {
                    errors = E.oneLovercase
                }
                if password.count < 8 {
                    errors = E.eightCharacters
                }
                if password.count > 256 {
                    errors = E.moreCharacters
                }
                return errors
            }
        return ControlEvent(events: source)
    }
    
    var validatePasswordLength: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { password in
                var errors: String = ""
                if password.count < 8 {
                    errors = E.eightCharacters
                }
                if password.count > 256 {
                    errors = E.moreCharacters
                }
                return errors
            }
        return ControlEvent(events: source)
    }
    
    var validatedCode: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { code in
                var error: String = ""
                if code.isEmpty {
                    error = E.enterYourCode
                } else if code.count < 6 || code.count > 6 {
                    error = E.sixDigits
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateAge: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { age in
                var error: String = ""
                if age.isEmpty {
                    error = E.emptyAge
                } else if age.count == 0 || age.count > 3 || Int(age) ?? Int() > 130 {
                    error = E.invalidAge
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateWeight: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { weight in
                var error: String = ""
                if weight.isEmpty {
                    error = E.emptyWeight
                } else if weight.count == 0 || weight.count > 3 || Int(weight) ?? Int() > 230 || Int(weight) ?? Int() < 30 {
                    error = E.invalidWeight
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateHeight: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { height in
                var error: String = ""
                if height.isEmpty {
                    error = E.emptyHeight
                } else if height.count == 0 || height.count > 3 || Int(height) ?? Int() > 200 || Int(height) ?? Int() < 1 {
                    error = E.invalidHeight
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateHeartRateInput: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { heartRate in
                var error: String = ""
                if heartRate.isEmpty {
                    error = E.newDataValidationError
                } else if error.count == 0 || Int(heartRate) ?? Int() < 20 || Int(heartRate) ?? Int() > 300 {
                    error = E.newDataValidationError
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateUserSex: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { userName in
                var error: String = ""
                if userName.isEmpty {
                    error = E.emptySex
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var validateUserName: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { userName in
                var error: String = ""
                if !NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]*$").evaluate(with: userName) || userName.count > 40 {
                    error = E.newDataValidationError
                } else if userName.isEmpty {
                    error = E.emptyUsername
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    var checkDataInput: ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { dataInput in
                var error: String = ""
                if dataInput.isEmpty {
                    error = E.newDataValidationError
                }
                return error
            }
        return ControlEvent(events: source)
    }
    
    func passwordTheSame(_ password: UITextField) -> ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { repeatPassword in
                var error: String = ""
                if repeatPassword == password.text {
                    error = ""
                    return error
                } else {
                    error = E.notTheSame
                    return error
                }
            }
        return ControlEvent(events: source)
    }
    
    func validateMeasurementInput(measurementType: MeasurementName) -> ControlEvent<String> {
        let source = self.rx.text.orEmpty
            .map { input in
                var error: String = ""
                switch measurementType {
                case .heartRate:
                    if input.isEmpty || Int(input) ?? Int() < 20 || Int(input) ?? Int() > 300 {
                        error = E.newDataValidationError
                    }
                case .oxigenSaturation:
                    if input.isEmpty || Float(input) ?? Float() < 60 || Float(input) ?? Float() > 100 {
                        error = E.newDataValidationError
                    }
                case .bodyTemperature:
                    if input.isEmpty || Float(input) ?? Float() < 33 || Float(input) ?? Float() > 44 {
                        error = E.newDataValidationError
                    }
                case .heartRateVariability:
                    if input.isEmpty || Float(input) ?? Float() < 10 || Float(input) ?? Float() > 100 {
                        error = E.newDataValidationError
                    }
                case .pulseRate:
                    if input.isEmpty || Int(input) ?? Int() < 20 || Int(input) ?? Int() > 300 {
                        error = E.newDataValidationError
                    }
                case .bodyWeight:
                    if input.isEmpty || Float(input) ?? Float() < 5 || Float(input) ?? Float() > 300 {
                        error = E.newDataValidationError
                    }
                case .systolicPressure:
                    if input.isEmpty || Float(input) ?? Float() < 20 || Float(input) ?? Float() > 300 {
                        error = E.newDataValidationError
                    }
                case .diastolicPressure:
                    if input.isEmpty || Float(input) ?? Float() < 20 || Float(input) ?? Float() > 300 {
                        error = E.newDataValidationError
                    }
                case .mpaPressure:
                    if input.isEmpty || Float(input) ?? Float() < 20 || Float(input) ?? Float() > 300 {
                        error = E.newDataValidationError
                    }
                default:
                    if input.isEmpty {
                        error = E.newDataValidationError
                    }
                }
                
                return error
            }
        return ControlEvent(events: source)
    }
}
