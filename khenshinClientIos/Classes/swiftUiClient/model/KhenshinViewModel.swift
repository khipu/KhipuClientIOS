//
//  KhenshinViewModel.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 02-05-24.
//

import Foundation

@available(iOS 13.0, *)
public class KhenshinViewModel: ObservableObject {
    var khenshinSocketClient: KhenshinClient? = nil
    @Published var uiState = KhenshinUiState()
    
    func setKhenshinSocketClient(serverUrl: String, publicKey: String) {
        if(khenshinSocketClient == nil) {
            khenshinSocketClient = KhenshinClient(serverUrl: serverUrl, publicKey: publicKey, viewModel: self)
            //khenshinSocketClient = KhenshinClient(serverUrl: "https://khenshin-ws.khipu.com", publicKey: "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw=", viewModel: self)
        }
    }
    
    func connectClient() {
        khenshinSocketClient?.connect()
    }
    
}
