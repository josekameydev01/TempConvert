//
//  ContentView.swift
//  TempConvert
//
//  Created by carlosgalvankamey on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var temperature = 0.0
    @State private var currentTemperatureUnit = "Celsius"
    @State private var targetTemperatureUnit = ""
    @State private var conversionResult = 0.0
    
    @FocusState private var currentTemperatureFieldIsFocused: Bool
    @FocusState private var targetTemperatureFiledIsFocused: Bool
    
    private let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Original temperature") {
                    TextField("Temperature", value: $temperature, format: .number)
                        .keyboardType(.numberPad)
                        .focused($currentTemperatureFieldIsFocused)
                    
                    Picker("Temperature Unit", selection: $currentTemperatureUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Convert to") {
                    Picker("Temperature Unit", selection: $targetTemperatureUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            if $0 != currentTemperatureUnit {
                                Text($0)
                            }
                        }
                    }
                }
                
                Button(action: {
                    conversionResult = convertTemperature(temperature: temperature, from: currentTemperatureUnit, to: targetTemperatureUnit)
                }) {
                    Text("Convert")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                
                Section("Conversion Result") {
                    Text("\(conversionResult, specifier: "%.2f") \(getTemperatureUnitSymbol(temperatureUnit: targetTemperatureUnit))")
                }
              
            }
            
            .toolbar {
                if currentTemperatureFieldIsFocused {
                    Button("Done") {
                        currentTemperatureFieldIsFocused.toggle()
                    }
                }
            }
        }
    }
    
    private func convertTemperature(temperature currentTemperature: Double, from currentTemperatureUnit: String, to targetTemperatureUnit: String) -> Double {
        if currentTemperatureUnit == "Celsius" && targetTemperatureUnit == "Fahrenheit" {
            return (currentTemperature * (9.0 / 5.0)) + 32.0
        } else if currentTemperatureUnit == "Celsius" && targetTemperatureUnit == "Kelvin" {
            return currentTemperature + 273.15
        } else if currentTemperatureUnit == "Fahrenheit" && targetTemperatureUnit == "Celsius" {
            return (currentTemperature - 32.0) * 5.0 / 9.0
        } else if currentTemperatureUnit == "Fahrenheit" && targetTemperatureUnit == "Kelvin" {
            return ((currentTemperature - 32.0) * (5.0 / 9.0)) + 273.15
        } else if currentTemperatureUnit == "Kelvin" && targetTemperatureUnit == "Celsius" {
            return currentTemperature - 273.15
        } else {
            return ((currentTemperature - 273.15) * (9.0 / 5.0)) + 32.0
        }
    }
    
    private func getTemperatureUnitSymbol(temperatureUnit: String) -> String {
        if temperatureUnit == "Celsius" {
            return "°C"
        } else if temperatureUnit == "Fahrenheit" {
            return "°F"
        } else {
            return "K"
        }
    }
}

#Preview {
    ContentView()
}
