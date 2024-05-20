import Foundation

public struct KhipuHeader {
    let headerUIView: (UIView & KhipuHeaderProtocol)?
    let height: Int?

    
    init(headerUIView: (UIView & KhipuHeaderProtocol)? = nil, height: Int? = nil, paymentMethodId: Int? = nil) {
        self.headerUIView = headerUIView
        self.height = height
    }
    
    public class Builder {
        
        public init(){}
        
        var _headerUIView: (UIView & KhipuHeaderProtocol)?
        var _height: Int?
        
        public func headerUIView(_ headerUIView: (UIView & KhipuHeaderProtocol)) -> Builder {
            self._headerUIView = headerUIView
            return self
        }
        public func height(_ height: Int) -> Builder {
            self._height = height
            return self
        }

        
        public func build() -> KhipuHeader {
            return KhipuHeader(
                headerUIView: _headerUIView,
                height: _height
            )
        }
    }
}

