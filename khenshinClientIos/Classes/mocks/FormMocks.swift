//
//  FormMocks.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 20-02-24.
//

import Foundation
import KhenshinProtocol

public class FormMocks {
    public func createResponse(request: FormRequest) -> FormResponse {
        let answers = request.items.map{self.createItemResponse(item: $0)}
        let formResponse = FormResponse(answers: answers, id: request.id, type: MessageType.formResponse)
        return formResponse
    }
    
    func createItemResponse(item: FormItem) -> FormItemAnswer {
        let response = FormItemAnswer(id: item.id, type: item.type, value: getResponseFromType(item: item))
        return response
    }
    
    func getResponseFromType(item: FormItem) -> String {
        switch(item.type.rawValue) {
        case FormItemTypes.text.rawValue:
            if item.email! {
                return "asd@asd.com"
            } else if item.secure! {
                return "1234"
            }
            break
        case FormItemTypes.coordinates.rawValue:
            return "11|22|33"
        case FormItemTypes.list.rawValue:
            return (item.options?.first?.value)!
        case FormItemTypes.rut.rawValue:
            return "158388235"
        case FormItemTypes.groupedList.rawValue:
            return (item.groupedOptions?.options?.first?.value)!
        default:
            print("no puedo responder mensaje del tipo \(item.type.rawValue)")
            break
        }
        return ""
    }
}
