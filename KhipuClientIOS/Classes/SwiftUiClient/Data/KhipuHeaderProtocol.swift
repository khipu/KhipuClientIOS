import Foundation

public protocol KhipuHeaderProtocol {
    func setSubject(_ subject: String)
    func setAmount(_ amount: String)
    func setMerchantName(_ merchantName: String)
    func setPaymentMethod(_ paymentMethod: String)
}
