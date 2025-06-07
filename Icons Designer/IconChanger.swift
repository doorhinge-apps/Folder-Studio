////
//// Icon Changing Test
//// ContentView.swift
////
//// Created on 28/12/24
////
//// Copyright ©2024 DoorHinge Apps.
////
//
//
//import SwiftUI
//import AppKit
//
//
//struct IconChanger: View {
//    @State private var selectedImageURL: URL? = nil
//    @State private var dropError: String? = nil
//
//    var body: some View {
//        VStack {
//            Text("Folder Icon Changer")
//                .font(.title)
//                .padding()
//
//            if let selectedImageURL = selectedImageURL {
//                Text("Selected Icon: \(selectedImageURL.lastPathComponent)")
//            } else {
//                Text("No icon selected.")
//            }
//
//            Button("Choose PNG Icon") {
//                let panel = NSOpenPanel()
//                panel.allowedFileTypes = ["png"]
//                panel.allowsMultipleSelection = false
//                if panel.runModal() == .OK {
//                    selectedImageURL = panel.url
//                }
//            }
//            .padding()
//
//            Text("Drag folders here to change their icons")
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//                .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
//                    handleDrop(providers: providers)
//                }
//
//            if let error = dropError {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .padding()
//    }
//
//    private func handleDrop(providers: [NSItemProvider]) -> Bool {
//        let group = DispatchGroup()
//        var encounteredError: String? = nil
//
//        for provider in providers {
//            group.enter()
//            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, error in
//                DispatchQueue.main.async {
//                    defer { group.leave() }
//
//                    if let error = error {
//                        encounteredError = "Error loading item: \(error.localizedDescription)"
//                        return
//                    }
//
//                    guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else {
//                        encounteredError = "Invalid URL format."
//                        return
//                    }
//
//                    do {
//                        var isDirectory: ObjCBool = false
//                        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else {
//                            encounteredError = "The dropped item is not a folder."
//                            return
//                        }
//
//                        guard let iconURL = selectedImageURL else {
//                            encounteredError = "No icon selected. Please choose a PNG file first."
//                            return
//                        }
//
//                        try setFolderIcon(folderURL: url, iconURL: iconURL)
//                    } catch {
//                        encounteredError = "Failed to set folder icon: \(error.localizedDescription)"
//                    }
//                }
//            }
//        }
//
//        group.notify(queue: .main) {
//            dropError = encounteredError
//        }
//
//        return true
//    }
//
//    private func setFolderIcon(folderURL: URL, iconURL: URL) throws {
//        let image = NSImage(contentsOf: iconURL)
//        guard let icon = image else {
//            throw NSError(domain: "FolderIconChanger", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid PNG file."])
//        }
//
//        // Adjust image to fit within 512x512 and maintain aspect ratio
//        let targetSize = NSSize(width: 512, height: 512)
//        let resizedIcon = NSImage(size: targetSize)
//        resizedIcon.lockFocus()
//        let rect = NSRect(origin: .zero, size: targetSize)
//        let aspectRatio = min(targetSize.width / icon.size.width, targetSize.height / icon.size.height)
//        let newSize = NSSize(width: icon.size.width * aspectRatio, height: icon.size.height * aspectRatio)
//        let drawRect = NSRect(
//            x: (targetSize.width - newSize.width) / 2,
//            y: (targetSize.height - newSize.height) / 2,
//            width: newSize.width,
//            height: newSize.height
//        )
//        icon.draw(in: drawRect, from: NSRect(origin: .zero, size: icon.size), operation: .sourceOver, fraction: 1.0)
//        resizedIcon.unlockFocus()
//
//        let ws = NSWorkspace.shared
//        do {
//            try ws.setIcon(resizedIcon, forFile: folderURL.path, options: .excludeQuickDrawElementsIconCreationOption)
//        } catch {
//            throw NSError(domain: "FolderIconChanger", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to set folder icon.\n\(error.localizedDescription)"])
//        }
//    }
//}
//
