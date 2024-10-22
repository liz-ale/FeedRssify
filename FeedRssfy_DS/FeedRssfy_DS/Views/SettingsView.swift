//
//  SettingsView.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 22/10/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var selectedFontSize: CGFloat
    @Binding var isDarkMode: Bool
    @Binding var selectedFont: Font
    
    var body: some View {
        VStack {
            Text("Ajustes Rápidos")
                .font(.headline)
                .padding()
            
            // Cambiar tamaño de fuente
            Text("Tamaño de la fuente")
            Picker("Tamaño de fuente", selection: $selectedFontSize) {
                Text("Pequeña").tag(CGFloat(12))
                Text("Mediana").tag(CGFloat(16))
                Text("Grande").tag(CGFloat(20))
                Text("Muy grande").tag(CGFloat(24))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Toggle(isOn: $isDarkMode) {
                Text("Modo oscuro")
            }
            .padding()
            
            Text("Fuente")
            Picker("Fuente", selection: $selectedFont) {
                Text("Default").tag(Font.body)
                Text("Monospaced").tag(Font.system(.body, design: .monospaced))
                Text("Serif").tag(Font.system(.body, design: .serif))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .padding()
    }
}
