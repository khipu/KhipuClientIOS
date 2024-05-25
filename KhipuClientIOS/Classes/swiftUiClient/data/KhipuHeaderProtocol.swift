//
//  KhipuHeaderProtocol.swift
//  khenshinClientIos
//
//  Created by Emilio Davis on 19-05-24.
//

import Foundation

public protocol KhipuHeaderProtocol {
    func setSubject(_ subject: String)
    func setAmount(_ amount: String)
    func setMerchantName(_ merchantName: String)
    func setPaymentMethod(_ paymentMethod: String)
}
