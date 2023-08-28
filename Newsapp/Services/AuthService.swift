//
//  AuthService.swift
//  Newsapp
//
//  Created by LinhMAC on 24/08/2023.
//

import Foundation
import KeychainSwift
class AuthService {
    static var shared = AuthService()
    private init() {
        print("")
    }
    enum Keys: String {
        case keyAccessToken
    }
    func saveAccesToken(acessToken : String) {
        let keychain = KeychainSwift()
        keychain.set(acessToken, forKey: Keys.keyAccessToken.rawValue)
        
    }
    func getAccessToken() -> String? {
        let keychain = KeychainSwift()
        return keychain.get(Keys.keyAccessToken.rawValue)
    }
    func clearAccessToken() {
        let keychain = KeychainSwift()
        keychain.delete(Keys.keyAccessToken.rawValue)
    }
    var isLoggedIn: Bool {
        let token = getAccessToken()
//        print("\(token)")
        return token != nil && !(token!.isEmpty)
    }
    
}
