import SwiftUI
import Translation

struct EntryView: View {
    @StateObject var foldersViewModel = FoldersViewModel()
    
    @AppStorage("onboardingCompleted") var onboardingCompleted = false

    var body: some View {
        if onboardingCompleted {
            ContentView()
                .environmentObject(foldersViewModel)
        }
        else {
            
        }
    }
}
