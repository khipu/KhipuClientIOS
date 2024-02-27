//
//  KhipuComponent.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 27-02-24.
//

import Foundation
import KhenshinProtocol

protocol KhipuField {
    func getFormItem() -> FormItem
    func getValue () -> String
}

