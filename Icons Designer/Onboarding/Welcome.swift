//
// SF Folders
// Welcome.swift
//
// Created on 6/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI
import Translation

struct Welcome: View {
    @State var currentStep = 0
    
    @State var currentTitleText: LocalizedStringKey = "welcome_title_text"
    @State var currentImage = "Folder Studio Icon"
    
    @State var titleTextKeys: [LocalizedStringKey] = ["welcome_title_text", "onboarding_2_title", "onboarding_3_title", "onboarding_4_title", "translate_notice"]
    
    @State var imageNames: [String] = ["Folder Studio Icon", "Onboarding 2", "Onboarding 3", "Onboarding 2", "Folder Studio Icon"]
    
    @State var rectSizes: [[CGFloat]] = [[0.0, 0.0], [65, 65], [75, 80], [150, 125], [0, 0]]
    @State var rectOffsets: [[CGFloat]] = [[0.0, 0.0], [-58.0, -30.0], [-58.0, -10.0], [58.0, 10.0], [0.0, 0.0]]
    
    @State private var downloadConfig: TranslationSession.Configuration?
    @State private var shouldPrepare = false
    @State private var status: LanguageAvailability.Status?
    @State private var isBusy = false
    
    @AppStorage("onboardingCompleted") var onboardingCompleted = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            
            Text(titleTextKeys[currentStep])
                .foregroundStyle(Color.white)
                .font(.system(currentStep == 0 ? .largeTitle: .title, design: .rounded, weight: .bold))
                .contentTransition(.numericText())
                .frame(height: 80)
            
            if currentStep == 4 {
                Text("translation_notice_description")
                    .foregroundStyle(Color.white)
                    .font(.system(.title3, design: .rounded, weight: .bold))
            }
            
            ZStack(alignment: .center) {
                Image(imageNames[currentStep])
                    .resizable()
                    .scaledToFit()
                
                if currentStep > 0 {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "FF00A6"), lineWidth: 4)
                        .frame(width: rectSizes[currentStep][0], height: rectSizes[currentStep][1])
                        .offset(x: rectOffsets[currentStep][0], y: rectOffsets[currentStep][1])
                }
            }.frame(width: 400)
            
            if currentStep == 4 {
                Button {
                    Task { await startDownloadIfNeeded() }
                } label: {
                    if isBusy {
                        ProgressView().controlSize(.small)
                    } else {
                        Text("translate_download_prompt_text")
                    }
                }
                .buttonStyle(Button3DStyle())
                .frame(height: 50)
                .fixedSize()
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                if currentStep > 0 {
                    Button {
                        withAnimation {
                            if currentStep > 0 {
                                currentStep -= 1
                            }
                        }
                    } label: {
                        Text("back_button_text")
                    }.buttonStyle(Button3DStyle())
                        .frame(height: 50)
                        .fixedSize()
                }
                
                Button {
                    withAnimation {
                        if currentStep >= 4 || (currentStep >= 3 && Locale.current.languageCode == "en") {
                            onboardingCompleted = true
                        }
                        else {
                            currentStep += 1
                        }
                    }
                } label: {
                    Text("continue_button_text")
                }.buttonStyle(Button3DStyle())
                    .frame(height: 50)
                    .fixedSize()
            }
            
            Spacer()
                .frame(height: 50)
        }.task(id: currentStep) {
            if currentStep == 4 { await refreshStatus() }
        }
        // download sheet lives here
        .translationTask(downloadConfig) { session in
            guard shouldPrepare else { return }
            shouldPrepare = false                       // run only once
            do {
                try await session.prepareTranslation()  // Apple sheet
                status = .installed
                print("✅ Model installed.")
            } catch {
                print("❌ prepareTranslation error:", error)
            }
        }
    }
    
    
    @MainActor
        private func refreshStatus() async {
            let uiCode = Bundle.main.preferredLocalizations.first ?? "en"
            let lang   = uiCode.split(separator: "-").first.map(String.init) ?? "en"
            guard lang != "en" else { status = .installed; return }

            let src = Locale.Language(identifier: lang)
            let tgt = Locale.Language(identifier: "en")
            status  = await LanguageAvailability().status(from: src, to: tgt)
            print("🌐 Model \(lang)→en status:", status!)
        }

        @MainActor
        private func startDownloadIfNeeded() async {
            guard !isBusy else { return }
            isBusy = true
            defer { isBusy = false }

            await refreshStatus()

            guard status == .supported else {
                print("ℹ️ Nothing to download (status = \(String(describing: status))).")
                return
            }

            let uiCode = Bundle.main.preferredLocalizations.first ?? "en"
            let lang   = uiCode.split(separator: "-").first.map(String.init) ?? "en"
            downloadConfig = .init(source: .init(identifier: lang),
                                   target: .init(identifier: "en"))
            shouldPrepare  = true                          // triggers sheet
            print("📥 Prompting user to download \(lang)→en model …")
        }
}

#Preview {
    Welcome()
}
