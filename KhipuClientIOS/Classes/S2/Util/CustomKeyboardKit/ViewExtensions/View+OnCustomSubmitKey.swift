//
//  View+OnCustomSubmitKey.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct OnCustomSubmitKey: EnvironmentKey {
    public static let defaultValue: CustomKeyboard.SubmitHandler? = nil
}

@available(iOS 13.0, *)
public extension EnvironmentValues {
  var onCustomSubmit: CustomKeyboard.SubmitHandler? {
    get { self[OnCustomSubmitKey.self] }
    set { self[OnCustomSubmitKey.self] = newValue }
  }
}

@available(iOS 13.0, *)
public extension View {
    @available(*, deprecated, renamed: "onCustomSubmit(action:)")
    func onSubmitCustomKeyboard(action: @escaping () -> Void) -> some View {
        self
            .onCustomSubmit(action: action)
    }
}

@available(iOS 13.0, *)
public extension View {
    func onCustomSubmit(action: @escaping CustomKeyboard.SubmitHandler) -> some View {
        self
            .environment(\.onCustomSubmit, action)
    }
}
