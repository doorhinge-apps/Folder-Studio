import SwiftUI
import SwiftData


struct IconsPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var currentIcon: String
    
    @State var currentHoverIcon = ""
    
    @FocusState private var searchFocused: Bool
    
    @State var allIcons = false
    
    @State var iconSearch = ""
    
    @State var filterApplied: IconFilter = .all
    
    enum IconFilter {
        case all, outline, fill, circle, circleFill
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    TextField("Search for an Icon", text: $iconSearch)
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
                }
                .frame(height: 50)
                .padding(10)

                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .center) {
                    Button {
                        filterApplied = .all
                    } label: {
                        Text("All")
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
                        Text("Outline")
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
                        Text("Fill")
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
                        Text("Circle")
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
                        Text("Circle Fill")
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
                                if icon.contains(iconSearch.lowercased()) || icon.replacingOccurrences(of: ".", with: " ").contains(iconSearch.lowercased()) || iconSearch == "" {
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
}

