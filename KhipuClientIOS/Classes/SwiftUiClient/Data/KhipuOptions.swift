import Foundation

public class KhipuOptions {
    let serverUrl: String
    let serverPublicKey: String
    let header: KhipuHeader?
    let topBarTitle: String?
    let topBarImageUrl: String?
    let topBarImageScale: CGFloat?
    let topBarImageResourceName: String?
    let skipExitPage: Bool
    let theme: Theme
    let colors: KhipuColors?
    let locale: String?
    let showFooter: Bool
    let showMerchantLogo: Bool
    let showPaymentDetails: Bool

    private init(
        serverUrl: String,
        serverPublicKey: String,
        header: KhipuHeader?,
        topBarTitle: String?,
        topBarImageUrl: String?,
        topBarImageScale: CGFloat?,
        topBarImageResourceName: String?,
        skipExitPage: Bool,
        theme: Theme,
        colors: KhipuColors?,
        locale: String?,
        showFooter: Bool,
        showMerchantLogo: Bool,
        showPaymentDetails: Bool
    ) {
        self.serverUrl = serverUrl
        self.serverPublicKey = serverPublicKey
        self.header = header
        self.topBarTitle = topBarTitle
        self.topBarImageUrl = topBarImageUrl
        self.topBarImageScale = topBarImageScale
        self.topBarImageResourceName = topBarImageResourceName
        self.skipExitPage = skipExitPage
        self.theme = theme
        self.colors = colors
        self.locale = locale
        self.showFooter = showFooter
        self.showMerchantLogo = showMerchantLogo
        self.showPaymentDetails = showPaymentDetails
    }

    public enum Theme: String, Codable {
        case dark, light, system
    }

    public class Builder {
        var _serverUrl: String = "https://khenshin-ws.khipu.com"
        var _serverPublicKey: String = "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw="
        var _header: KhipuHeader?
        var _topBarTitle: String?
        var _topBarImageUrl: String?
        var _topBarImageScale: CGFloat?
        var _topBarImageResourceName: String?
        var _skipExitPage: Bool = false
        var _theme: Theme = .system
        var _colors: KhipuColors?
        var _locale: String = "es_CL"
        var _showFooter: Bool = true
        var _showMerchantLogo: Bool = true
        var _showPaymentDetails: Bool = true

        public init() {

        }

        public func serverPublicKey(_ serverPublicKey: String) -> Builder {
            self._serverPublicKey = serverPublicKey
            return self
        }

        public func serverUrl(_ serverUrl: String) -> Builder {
            self._serverUrl = serverUrl
            return self
        }

        public func skipExitPage(_ skipExitPage: Bool) -> Builder {
            self._skipExitPage = skipExitPage
            return self
        }

        public func topBarTitle(_ topBarTitle: String) -> Builder {
            self._topBarTitle = topBarTitle
            return self
        }

        public func topBarImageUrl(_ topBarImageUrl: String) -> Builder {
            self._topBarImageUrl = topBarImageUrl
            return self
        }
        
        public func topBarImageScale(_ topBarImageScale: CGFloat) -> Builder {
            self._topBarImageScale = topBarImageScale
            return self
        }

        public func topBarImageResourceName(_ topBarImageResourceName: String) -> Builder {
            self._topBarImageResourceName = topBarImageResourceName
            return self
        }

        public func theme(_ theme: Theme) -> Builder {
            self._theme = theme
            return self
        }

        public func colors(_ colors: KhipuColors) -> Builder {
            self._colors = colors
            return self
        }

        public func header(_ header: KhipuHeader) -> Builder {
            self._header = header
            return self
        }

        public func locale(_ locale: String) -> Builder {
            self._locale = locale
            return self
        }

        public func showFooter(_ showFooter: Bool) -> Builder {
            self._showFooter = showFooter
            return self
        }

        public func showMerchantLogo(_ showMerchantLogo: Bool) -> Builder {
            self._showMerchantLogo = showMerchantLogo
            return self
        }

        public func showPaymentDetails(_ showPaymentDetails: Bool) -> Builder {
            self._showPaymentDetails = showPaymentDetails
            return self
        }

        public func build() -> KhipuOptions {
            return KhipuOptions(
                serverUrl: _serverUrl,
                serverPublicKey: _serverPublicKey,
                header: _header,
                topBarTitle: _topBarTitle,
                topBarImageUrl: _topBarImageUrl,
                topBarImageScale: _topBarImageScale,
                topBarImageResourceName: _topBarImageResourceName,
                skipExitPage: _skipExitPage,
                theme: _theme,
                colors: _colors,
                locale: _locale,
                showFooter: _showFooter,
                showMerchantLogo: _showMerchantLogo,
                showPaymentDetails: _showPaymentDetails
            )
        }
    }
}

