//
//  NetworkUtil.swift
//  KhipuClientIOS
//
//  Created by Emilio Davis on 13-08-25.
//

import Foundation

struct IpifyResponse: Decodable {
    let ip: String
}

@available(iOS 13.0, *)
final class NetworkUtil {
    
    /// Obtiene la IP pública del cliente usando ipify.
    /// - Parameters:
    ///   - ipv6: `true` para intentar IPv6 (o IPv4 si no está disponible).
    ///   - timeout: tiempo máximo de espera en segundos.
    /// - Returns: String con la IP pública o `""` si falla.
    static func fetchPublicIP(ipv6: Bool = false, timeout: TimeInterval = 8) async -> String {
        let urlString = ipv6
            ? "https://api64.ipify.org?format=json"
            : "https://api.ipify.org?format=json"
        
        guard let url = URL(string: urlString) else {
            return ""
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: config)
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                return ""
            }
            
            let decoded = try JSONDecoder().decode(IpifyResponse.self, from: data)
            return decoded.ip
        } catch {
            return ""
        }
    }
}
