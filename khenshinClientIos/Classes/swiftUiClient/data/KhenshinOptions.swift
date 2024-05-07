//
//  KhenshinOptions.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 06-05-24.
//

import Foundation

public class KhenshinOptions: Codable {
    let serverUrl: String
    let serverPublicKey: String
    let header: KhenshinHeader?
    let topBarTitle: String?
    let topBarImageResourceId: Int?
    let skipExitPage: Bool
    let theme: Theme
    let colors: KhenshinColors?
    let locale: String?

    private init(
        serverUrl: String,
        serverPublicKey: String,
        header: KhenshinHeader?,
        topBarTitle: String?,
        topBarImageResourceId: Int?,
        skipExitPage: Bool,
        theme: Theme,
        colors: KhenshinColors?,
        locale: String?
    ) {
        self.serverUrl = serverUrl
        self.serverPublicKey = serverPublicKey
        self.header = header
        self.topBarTitle = topBarTitle
        self.topBarImageResourceId = topBarImageResourceId
        self.skipExitPage = skipExitPage
        self.theme = theme
        self.colors = colors
        self.locale = locale
    }

    public enum Theme: String, Codable {
        case dark, light, system
    }

    public class Builder {
        var _serverUrl: String = "https://khenshin-ws.khipu.com"
        var _serverPublicKey: String = "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw="
        var _header: KhenshinHeader?
        var _topBarTitle: String?
        var _topBarImageResourceId: Int?
        var _skipExitPage: Bool = false
        var _theme: Theme = .system
        var _colors: KhenshinColors?
        var _locale: String?
        
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

        public func topBarImageResourceId(_ topBarImageResourceId: Int) -> Builder {
            self._topBarImageResourceId = topBarImageResourceId
            return self
        }

        public func theme(_ theme: Theme) -> Builder {
            self._theme = theme
            return self
        }

        public func colors(_ colors: KhenshinColors) -> Builder {
            self._colors = colors
            return self
        }

        public func header(_ header: KhenshinHeader) -> Builder {
            self._header = header
            return self
        }

        public func locale(_ locale: String) -> Builder {
            self._locale = locale
            return self
        }

        public func build() -> KhenshinOptions {
            return KhenshinOptions(
                serverUrl: _serverUrl,
                serverPublicKey: _serverPublicKey,
                header: _header,
                topBarTitle: _topBarTitle,
                topBarImageResourceId: _topBarImageResourceId,
                skipExitPage: _skipExitPage,
                theme: _theme,
                colors: _colors,
                locale: _locale
            )
        }
    }
}

