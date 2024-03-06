//
//  SocketMessage.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 22-02-24.
//

import Foundation
import RxSwift

class OperationState {
    var bank: String = ""
    private let bankSubject = BehaviorSubject<String>(value: "")
    
    var bankObservable: Observable<String> {
        return bankSubject.asObservable()
    }
    
    static let instance = OperationState()
    
    private init() {}
    
    func setBank(nextBank: String) {
        bank = nextBank
        bankSubject.onNext(nextBank)
    }
}
