//
// SF Folders
// Preview and Drag.swift
//
// Created on 7/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct PreviewDrag: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel
    
    @State var bottomShapeColor = Color.blue
    @State var topShapeColor = Color.blue
    @State var symbolColor = Color.blue
    
    @State var bottomShapeColorIsUpdating: Bool = false
    @State var topShapeColorIsUpdating: Bool = false
    @State var symbolColorIsUpdating: Bool = false
    
    let timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { smallGeo in
            VStack {
                VStack {
                    FolderIconView(
                        resolutionScale: 0.25
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(0.43)
                    .cornerRadius(10)
                    .zIndex(10)
                    .accessibilityHidden(true)
                    
                    Text("drag_to_set")
                        .foregroundStyle(Color.white)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                    
                    Button(action: foldersViewModel.savePNG) {
                        Text("save_image")
                    }
                    .buttonStyle(Button3DStyle())
                    .frame(width: 200, height: 50)
                    .padding(.top, 10)
                    
                    Button {
                        foldersViewModel.selectFolder()
                    } label: {
                        Text("select_folder_button")
                    }
                    .buttonStyle(Button3DStyle())
                    .frame(width: 200, height: 50)
                    .padding(.top, 10)
                    .accessibilityLabel("accessibility_select_folder_button_description")
                    .alert("folder_set_alert_title", isPresented: $foldersViewModel.showSetFolderAlert) {
                        Button {
                            foldersViewModel.showSetFolderAlert = false
                        } label: {
                            Text("close_popup")
                        }
                    }
                }//.accessibilityLabel("accessibility_folder_preview_label")
                .accessibilityElement(children: .contain)
                .accessibilityLabel(content: { label in
                    Text("accessibility_folder_preview_label")
                    label
                })
                .overlay {
                    ZStack {
                        Color(hex: "78D6FF")
                            .frame(width: smallGeo.size.width, height: smallGeo.size.height)
                        
                        VStack {
                            Text("drop_folder")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                            
                            Spacer()
                                .frame(height: 75)
                            
                            ZStack {
                                ZStack {
                                    HStack {
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundStyle(Color.white)
                                        
                                        Spacer()
                                            .frame(width: foldersViewModel.breatheAnimation ? 190: 120)
                                            .animation(.bouncy(duration: 0.75), value: foldersViewModel.breatheAnimation)
                                        
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundStyle(Color.white)
                                            .rotationEffect(Angle(degrees: 180))
                                    }
                                    
                                    HStack {
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundStyle(Color.white)
                                        
                                        Spacer()
                                            .frame(width: foldersViewModel.breatheAnimation ? 190: 120)
                                            .animation(.bouncy(duration: 0.75), value: foldersViewModel.breatheAnimation)
                                        
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundStyle(Color.white)
                                            .rotationEffect(Angle(degrees: 180))
                                        
                                    }.rotationEffect(Angle(degrees: 90))
                                }.rotationEffect(Angle(degrees: Double(foldersViewModel.rotationAngle)))
                                    .animation(.bouncy(duration: 0.5), value: foldersViewModel.rotationAngle)
                                    .onReceive(timer) { thing in
                                        foldersViewModel.breatheAnimation.toggle()
                                        foldersViewModel.rotationAngle += 90
                                    }
                                
                                FolderIconView(
                                    resolutionScale: 0.125
                                )
                                .frame(width: 100, height: 100)
                                .scaleEffect(0.21)
                            }
                        }
                    }.opacity(foldersViewModel.isTargetedDrop ? 1 : 0)
                        .animation(.default, value: foldersViewModel.isTargetedDrop)
                        .accessibilityHidden(true)
                }
                .onDrop(of: ["public.file-url"], isTargeted: $foldersViewModel.isTargetedDrop) { providers in
                    foldersViewModel.handleDrop(providers: providers)
                }
                
                // -- Colors
                HStack {
                    Text("colors_label")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.white)
                    Spacer()
                }.padding(.top, 20)
                
                HStack {
                    VStack(alignment: .center) {
                        Text("base_color_label")
                            .foregroundStyle(Color.white)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .accessibilityHidden(true)
                        
                        AccessibleColorWell(color: $bottomShapeColor)
                            .accessibilityElement()
                            .accessibilityLabel(
                                Text("accessibility_bottom_color_label") + Text(": ") + Text(NSColor(bottomShapeColor).accessibilityName)
                            )
                            .onChange(of: bottomShapeColor) { oldValue, newValue in
                                bottomShapeColorIsUpdating = true
                                foldersViewModel.bottomShapeColor = newValue
                                print("Updating 1")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    bottomShapeColorIsUpdating = false
                                }
                            }
                            .onChange(of: foldersViewModel.bottomShapeColor) { oldValue, newValue in
                                if !bottomShapeColorIsUpdating {
                                    bottomShapeColor = newValue
                                    print("Updating 2")
                                }
                            }
                    }
                    .padding(.trailing, 20)
                    
                    VStack(alignment: .center) {
                        Text("tab_color_label")
                            .foregroundStyle(Color.white)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .accessibilityHidden(true)
                        
                        AccessibleColorWell(color: $topShapeColor)
                            .accessibilityElement()
                            .accessibilityLabel(
                                Text("accessibility_top_color_label") + Text(": ") + Text(NSColor(topShapeColor).accessibilityName)
                            )
                            .onChange(of: topShapeColor) { oldValue, newValue in
                                topShapeColorIsUpdating = true
                                foldersViewModel.topShapeColor = newValue
                                print("Updating 1")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    topShapeColorIsUpdating = false
                                }
                            }
                            .onChange(of: foldersViewModel.topShapeColor) { oldValue, newValue in
                                if !topShapeColorIsUpdating {
                                    topShapeColor = newValue
                                    print("Updating 2")
                                }
                            }
                    }
                    .padding(.trailing, 20)
                    
                    VStack(alignment: .center) {
                        Text("symbol_color_label")
                            .foregroundStyle(Color.white)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .accessibilityHidden(true)
                        
                        AccessibleColorWell(color: $symbolColor)
                            .accessibilityElement()
                            .accessibilityLabel(
                                Text("accessibility_symbol_color_label") + Text(": ") + Text(NSColor(symbolColor).accessibilityName)
                            )
                            .onChange(of: symbolColor) { oldValue, newValue in
                                symbolColorIsUpdating = true
                                foldersViewModel.symbolColor = newValue
                                print("Updating 1")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    symbolColorIsUpdating = false
                                }
                            }
                            .onChange(of: foldersViewModel.symbolColor) { oldValue, newValue in
                                if !symbolColorIsUpdating {
                                    symbolColor = newValue
                                    print("Updating 2")
                                }
                            }
                    }
                    .padding(.trailing, 20)
                }.frame(height: 50)
                    .onAppear() {
                        bottomShapeColor = foldersViewModel.bottomShapeColor
                        topShapeColor = foldersViewModel.topShapeColor
                        symbolColor = foldersViewModel.symbolColor
                    }
            }
        }.frame(width: 300)
    }
}


