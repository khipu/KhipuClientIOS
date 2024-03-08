//
//  SocketMessage.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 22-02-24.
//

import Foundation
import RxSwift
import KhenshinProtocol

class OperationState {
    private var bank: String = ""
    private let bankSubject = BehaviorSubject<String>(value: "")
    
    private var finalState: Any? = nil
    private var skipResultPage: Bool = false
    
    var bankObservable: Observable<String> {
        return bankSubject.asObservable()
    }
    
    static let instance = OperationState()
    
    private init() {}
    
    func setBank(nextBank: String) {
        bank = nextBank
        bankSubject.onNext(nextBank)
    }
    
    func getBank() -> String {
        return bank
    }
    
    func setFinalState(state: Any) {
        finalState = state
    }
    
    func getFinalState() -> Any? {
        return finalState
    }
    
    func setSkipResultPage(skip: Bool) {
        skipResultPage = skip
    }
    
    func getSkipResultPage() -> Bool {
        return skipResultPage
    }
}
