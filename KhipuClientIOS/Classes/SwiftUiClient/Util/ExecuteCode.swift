import SwiftUI

@available(iOS 13.0, *)
struct ExecuteCode : View {
    
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        EmptyView()
    }
}
