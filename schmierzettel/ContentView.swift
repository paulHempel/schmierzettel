//
//  ContentView.swift
//  schmierzettel
//
//  Created by Paul Hempel on 11.06.24.
//

import SwiftUI
import SwiftData
import Foundation

let defaults = UserDefaults.standard
let pasteboard = UIPasteboard.general

struct ContentView: View {    
    @State var textEditorHeight : CGFloat = 20
    
    @FocusState private var nameIsFocused: Bool
    @State private var showingDeleteAlert = false
    @State private var content: String = (defaults.string(forKey: "content") ?? "Tap anywhere to start typing...")

    var body: some View {
        NavigationView {
                TextEditor(text: $content)
                .focused($nameIsFocused)
                    .frame(minHeight: 50)
//                    .fixedSize(horizontal: false, vertical: true)
                    .border(.clear)
                    .onChange(of: content) {
                        defaults.set(content, forKey: "content") }
                    .contentMargins(.horizontal, 12.0)
                
            .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
            .navigationBarTitle(Text("Schmierzettel"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
//                currently broken in this position
//                ShareLink("Export note...", item: content)
                Button("Copy all", systemImage: "doc.on.doc") {
                    pasteboard.string = content
                }
                Button("Delete note",
                       systemImage: "trash",
                       role: .destructive) {
                    showingDeleteAlert = true
                }
               .alert("Are you sure to delete all your notes? You won't be able to recover them.", isPresented: $showingDeleteAlert) {
                          Button("Cancel", role: .cancel) { }
                          Button("Delete Note", role: .destructive) { 
                              content = "Tap anywhere to start typing..."
                              defaults.set(content, forKey: "content")
                          }
                }
            }
            .toolbar {
                Button("Hide Keyboard",
                       systemImage: "keyboard") {
                    nameIsFocused = !nameIsFocused
                }
            }
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

#Preview {
    ContentView()
}
