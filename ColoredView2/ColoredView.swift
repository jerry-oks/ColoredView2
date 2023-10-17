//
//  ContentView.swift
//  ColoredView2
//
//  Created by HOLY NADRUGANTIX on 16.10.2023.
//

import SwiftUI

struct ColoredView: View {
    @State private var redValue = Double.random(in: 0...255)
    @State private var greenValue = Double.random(in: 0...255)
    @State private var blueValue = Double.random(in: 0...255)
    
    @State private var redTF = ""
    @State private var greenTF = ""
    @State private var blueTF = ""
    
    @State private var isPresented = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .bottomTrailing) {
                    Color(
                        red: redValue / 255,
                        green: greenValue / 255,
                        blue: blueValue / 255
                    )
                    .clipShape(.rect(cornerRadius: 12))
                    
                    MagicButtonView(action: buttonTapped)
                    .padding(8)
                }
                .frame(alignment: .bottomTrailing)
                .onTapGesture { endEditing() }
                
                StatusDisplayView(red: redValue, green: greenValue, blue: blueValue)
                .padding(8)
                
            }
            
            HStack {
                VStack {
                    SliderView(value: $redValue, text: "Red", color: .red)
                    SliderView(value: $greenValue, text: "Green", color: .green)
                    SliderView(value: $blueValue, text: "Blue", color: .blue)
                }
                .onTapGesture { endEditing() }
                
                VStack {
                    TFView(placeholder: $redValue, value: $redTF)
                    TFView(placeholder: $greenValue, value: $greenTF)
                    TFView(placeholder: $blueValue, value: $blueTF)
                }
                .keyboardType(.numberPad)
                .focused($isFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done", action: endEditing)
                    }
                }
                .alert("Wrong input", isPresented: $isPresented, actions: {}) {
                    Text("The text field should contain a number in a range from 0 to 255")
                }
            }
        }
        .padding()
        .onAppear {
            redTF = lround(redValue).formatted()
            greenTF = lround(greenValue).formatted()
            blueTF = lround(blueValue).formatted()
        }
        .onChange(of: redValue) { _ in
            redTF = lround(redValue).formatted()
        }
        .onChange(of: greenValue) { _ in
            greenTF = lround(greenValue).formatted()
        }
        .onChange(of: blueValue) { _ in
            blueTF = lround(blueValue).formatted()
        }
    }
    
    private func buttonTapped() {
        isFocused = false
        withAnimation(.easeIn(duration: 0.1)) {
            redValue = Double.random(in: 0...255)
            greenValue = Double.random(in: 0...255)
            blueValue = Double.random(in: 0...255)
        }
    }
    
    private func endEditing() {
        isPresented = checkInput(of: redTF, greenTF, blueTF)
        if !isPresented {
            changeValues()
        }
        
        func checkInput(of textFields: String...) -> Bool {
            for textField in textFields {
                guard let value = Double(textField), (0...255).contains(value)
                else { return true }
            }
            return false
        }
        
        func changeValues() {
            isFocused = false
            withAnimation(.easeIn(duration: 0.1)) {
                redValue = Double(redTF) ?? 0
                greenValue = Double(greenTF) ?? 0
                blueValue = Double(blueTF) ?? 0
            }
        }
    }
}

#Preview {
    ColoredView()
}

struct SliderView: View {
    @Binding var value: Double
    
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 16))
                .bold()
                .frame(width: 50, alignment: .trailing)
            
            Slider(value: $value, in: 0...255, step: 1)
                .tint(color)
        }
    }
}

struct TFView: View {
    @Binding var placeholder: Double
    @Binding var value: String
    
    var body: some View {
        TextField(lround(placeholder).formatted(), text: $value)
            .font(.system(size: 16))
            .frame(width: 45)
            .textFieldStyle(.roundedBorder)
    }
}

struct StatusDisplayView: View {
    let red: Double
    let green: Double
    let blue: Double
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.7)
                .clipShape(.rect(cornerRadius: 8))
                .frame(width: 170, height: 40)
            
            HStack(spacing: 10) {
                ComponentView(color: .red, value: red)
                ComponentView(color: .green, value: green)
                ComponentView(color: .blue, value: blue)
            }
        }
    }
}

struct ComponentView: View {
    let color: Color
    let value: Double
    
    var body: some View {
        HStack(spacing: 2) {
            Text("◈")
                .foregroundStyle(color)
            Text(lround(value).formatted())
                .font(.system(size: 12))
        }
        .frame(width: 40, alignment: .leading)
    }
}

struct MagicButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "wand.and.stars")
                .resizable()
                .padding(8)
        }
        .buttonStyle(.plain)
        .tint(Color(.secondarySystemBackground))
        .background(in: .rect(cornerRadius: 8))
        .frame(width: 40, height: 40)
        .opacity(0.7)
    }
}
