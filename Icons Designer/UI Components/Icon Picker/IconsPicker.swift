import SwiftUI
import NaturalLanguage
import SwiftData
import Translation


struct IconsPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var currentIcon: String
    
    @State var currentHoverIcon = ""
    
    @FocusState private var searchFocused: Bool
    
    @State var allIcons = false
    
    @State var iconSearch = ""
    
    @State private var translationConfig: TranslationSession.Configuration?
    @State private var translatedSearchTerm: String = ""

        @State private var session:       TranslationSession?
        @State private var translateTask: Task<Void,Never>?
    
    @State var filterApplied: IconFilter = .all
    
    enum IconFilter {
        case all, outline, fill, circle, circleFill
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    TextField("search_icon_prompt", text: $iconSearch)
                        .padding(15)
                        .textFieldStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .focused($searchFocused)
                        .onAppear() {
                            searchFocused = true
                        }
                        .autocorrectionDisabled(true)
                        .onChange(of: iconSearch) { newValue in
                            Task { await handleSearchInput(newValue) }
                        }
                        .translationTask(translationConfig) { s in
                                    await MainActor.run { session = s }
                                }
                }
                .frame(height: 50)
                .padding(10)

                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .center) {
                    Button {
                        filterApplied = .all
                    } label: {
                        Text("all_button_label")
                            .frame(width: 100)
                    }
                        .padding(15)
                        .opacity(filterApplied == .all ? 1.0: 0.5)
                        .scaleEffect(filterApplied == .all ? 1.0: 0.75)
                        .animation(.default, value: filterApplied)
                        .buttonStyle(Button3DStyle())
                    
                    Button {
                        filterApplied = .outline
                    } label: {
                        Text("outline_button_label")
                            .frame(width: 100)
                    }
                        .padding(15)
                        .opacity(filterApplied == .outline ? 1.0: 0.5)
                        .scaleEffect(filterApplied == .outline ? 1.0: 0.75)
                        .animation(.default, value: filterApplied)
                        .buttonStyle(Button3DStyle())
                    
                    Button {
                        filterApplied = .fill
                    } label: {
                        Text("fill_button_label")
                            .frame(width: 100)
                    }
                        .padding(15)
                        .opacity(filterApplied == .fill ? 1.0: 0.5)
                        .scaleEffect(filterApplied == .fill ? 1.0: 0.75)
                        .animation(.default, value: filterApplied)
                        .buttonStyle(Button3DStyle())
                    
                    Button {
                        filterApplied = .circle
                    } label: {
                        Text("circle_button_label")
                            .frame(width: 100)
                    }
                        .padding(15)
                        .opacity(filterApplied == .circle ? 1.0: 0.5)
                        .scaleEffect(filterApplied == .circle ? 1.0: 0.75)
                        .animation(.default, value: filterApplied)
                        .buttonStyle(Button3DStyle())
                    
                    Button {
                        filterApplied = .circleFill
                    } label: {
                        Text("crcle_fill_button_label")
                            .frame(width: 100)
                    }
                        .padding(15)
                        .opacity(filterApplied == .circleFill ? 1.0: 0.5)
                        .scaleEffect(filterApplied == .circleFill ? 1.0: 0.75)
                        .animation(.default, value: filterApplied)
                        .buttonStyle(Button3DStyle())
                }
                
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 8)) {
                            ForEach(sfNewIconOptions.filter { icon in
                                if filterApplied == .all {
                                    return true
                                } else {
                                    switch filterApplied {
                                    case .outline:
                                        return (!icon.contains("outline") && !icon.contains("fill") && !icon.contains("circle"))
                                    case .fill:
                                        return (icon.contains("fill")  && !icon.contains("circle"))
                                    case .circle:
                                        return (icon.contains("circle") && !icon.contains("fill"))
                                    case .circleFill:
                                        return icon.contains("circle.fill")
                                    default:
                                        return true
                                    }
                                }
                            }, id:\.self) { icon in
                                //if icon.contains(iconSearch.lowercased()) || icon.replacingOccurrences(of: ".", with: " ").contains(iconSearch.lowercased()) || iconSearch == "" {
                                if icon.contains(translatedSearchTerm.lowercased()) ||
                                   icon.replacingOccurrences(of: ".", with: " ").contains(translatedSearchTerm.lowercased()) ||
                                   translatedSearchTerm.isEmpty {
                                    Button {
                                        currentIcon = icon
                                        print("Icon: \(icon)")
                                        print("Current Icon: \(currentIcon)")
                                        
                                        dismiss()
                                    } label: {
                                        ZStack {
                                            Image(systemName: icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(Color.black)
                                                .opacity(currentIcon == icon ? 1.0: currentHoverIcon == icon ? 0.6: 0.3)
                                            
                                        }.frame(width: 50, height: 50).cornerRadius(7)
                                            .onHover(perform: { hovering in
                                                if hovering {
                                                    currentHoverIcon = icon
                                                }
                                                else {
                                                    currentHoverIcon = ""
                                                }
                                            })
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                }.scrollIndicators(.hidden)
            }.frame(maxHeight: 700)
            .background {
                ZStack {
                    Color(hex: "6FCDF6")
                    
                    Image("grain")
                        .scaledToFill()
                }.ignoresSafeArea()
            }
        }
    }
    
    @MainActor
        private func handleSearchInput(_ input: String) async {
            // Cancel any in-flight translation immediately
            translateTask?.cancel()
            translateTask = nil

            guard !input.isEmpty else {
                translatedSearchTerm = ""
                return
            }

            // 1. Determine fixed source language from app localisation
            let raw   = Bundle.main.preferredLocalizations.first ?? "en"
            let base  = raw.split(separator: "-").first.map(String.init) ?? "en"
            print("🌐 UI locale:", raw, "| base:", base)

            guard base != "en" else {                 // English UI → no translate
                translatedSearchTerm = input
                translationConfig    = nil
                print("⚠️ English UI – using raw input.")
                return
            }

            // Support only es / fr / de → en
            let supported = ["es","fr","de"]
            guard supported.contains(base) else {
                translatedSearchTerm = input
                translationConfig    = nil
                print("⚠️ UI language '\(base)' not supported – raw input.")
                return
            }

            let src = Locale.Language(identifier: base)
            let tgt = Locale.Language(identifier: "en")
            let availability = await LanguageAvailability().status(from: src, to: tgt)

            switch availability {
            case .installed:
                // supply config once (stable); session will arrive via modifier
                if translationConfig == nil {
                    translationConfig = .init(source: src, target: tgt)
                    print("📥 Model \(base)→en installed – session ready.")
                }

                // 2. launch a new translation task for this keystroke
                if let s = session {
                    translateTask = Task {
                        do {
                            let r = try await s.translate(input)
                            await MainActor.run {
                                translatedSearchTerm = r.targetText
                                print("✅ '\(input)' → '\(translatedSearchTerm)'")
                            }
                        } catch {
                            if !Task.isCancelled {
                                await MainActor.run {
                                    translatedSearchTerm = input
                                    print("❌ translate error:", error)
                                }
                            } else {
                                print("⏹️  cancelled previous translate.")
                            }
                        }
                    }
                } else {
                    // session not delivered yet – fall back
                    translatedSearchTerm = input
                }

            case .supported:
                print("🔕 Model \(base)→en supported but NOT installed – raw input.")
                translatedSearchTerm = input
                translationConfig    = nil

            case .unsupported:
                print("🚫 Pair \(base)→en unsupported – raw input.")
                translatedSearchTerm = input
                translationConfig    = nil

            @unknown default:
                print("❔ Unknown availability.")
                translatedSearchTerm = input
                translationConfig    = nil
            }
        }
}

