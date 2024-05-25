//
//  CredentialsStorageUtil.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 06-03-24.
//
import Foundation
public struct Credentials {
    var username: String
    var password: String
}
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
public class CredentialsStorageUtil {
    public static func storeCredentials(credentials: Credentials, server: String) throws -> Void {
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        if(try! searchCredentials(server: server) != nil){
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrServer as String: server]
            let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                             kSecValueData as String: password]
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        } else {
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: account,
                                        kSecAttrServer as String: server,
                                        kSecValueData as String: password]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    public static func searchCredentials(server: String) throws -> Credentials? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            return nil
        }
        return Credentials(username: account, password: password)
    }
    
    public static func deleteCredentials(server: String) throws -> Void {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
}
