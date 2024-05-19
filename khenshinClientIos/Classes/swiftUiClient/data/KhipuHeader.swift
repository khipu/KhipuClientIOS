import Foundation

public struct KhipuHeader: Codable {
    let headerLayoutId: Int?
    let merchantNameId: Int?
    let paymentMethodId: Int?
    let amountId: Int?
    let subjectId: Int?
    
    private init(headerLayoutId: Int? = nil, merchantNameId: Int? = nil, paymentMethodId: Int? = nil, amountId: Int? = nil, subjectId: Int? = nil) {
        self.headerLayoutId = headerLayoutId
        self.merchantNameId = merchantNameId
        self.paymentMethodId = paymentMethodId
        self.amountId = amountId
        self.subjectId = subjectId
    }
    
    public class Builder {
        var _headerLayoutId: Int?
        var _merchantNameId: Int?
        var _paymentMethodId: Int?
        var _amountId: Int?
        var _subjectId: Int?
        
        public func headerLayoutId(_ headerLayoutId: Int) -> Builder {
            self._headerLayoutId = headerLayoutId
            return self
        }
        public func merchantNameId(_ merchantNameId: Int) -> Builder {
            self._merchantNameId = merchantNameId
            return self
        }
        public func paymentMethodId(_ paymentMethodId: Int) -> Builder {
            self._paymentMethodId = paymentMethodId
            return self
        }
        public func amountId(_ amountId: Int) -> Builder {
            self._amountId = amountId
            return self
        }
        public func subjectId(_ subjectId: Int) -> Builder {
            self._subjectId = subjectId
            return self
        }
        
        public func build() -> KhipuHeader {
            return KhipuHeader(
                headerLayoutId: _headerLayoutId,
                merchantNameId: _merchantNameId,
                paymentMethodId: _paymentMethodId,
                amountId: _amountId,
                subjectId: _subjectId
            )
        }
        
        
    }
}

