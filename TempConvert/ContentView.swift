//
//  ContentView.swift
//  TempConvert
//
//  Created by carlosgalvankamey on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    
    enum TemperatureUnit: String, CaseIterable {
        case celsius = "Celsius"
        case fahrenheit = "Fahrenheit"
        case kelvin = "Kelvin"
        
        var unitSymbol: String {
            switch self {
            case .celsius:
                return "°C"
            case .fahrenheit:
                return "°F"
            default:
                return "K"
            }
        }
    }
    
    @State private var temperature = 0.0
    @State private var currentTemperatureUnit = TemperatureUnit.celsius
    @State private var targetTemperatureUnit = TemperatureUnit.fahrenheit
    @State private var conversionResult = 0.0
    
    @FocusState private var currentTemperatureFieldIsFocused: Bool
    
    private var temperatureInCelsius: Double {
        
        switch currentTemperatureUnit {
        case .fahrenheit:
            return (temperature - 32.0) * 5.0 / 9.0
        case .kelvin:
            return temperature - 273.15
        default:
            return temperature
        }
    }
    
    private var convertedTemperature: Double {
        
        switch targetTemperatureUnit {
        case .fahrenheit:
            return (temperatureInCelsius * (9.0 / 5.0)) + 32.0
        case .kelvin:
            return temperatureInCelsius + 273.15
        default:
            return temperatureInCelsius
        }
        
    }
    
    private var validUnits: [TemperatureUnit] {
        TemperatureUnit.allCases.filter {
            $0 != currentTemperatureUnit
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Original temperature") {
                    TextField("Temperature", value: $temperature, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($currentTemperatureFieldIsFocused)
                    
                    Picker("Temperature Unit", selection: $currentTemperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section("Convert to") {
                    Picker("Temperature Unit", selection: $targetTemperatureUnit) {
                        ForEach(validUnits, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section("Conversion Result") {
                    Text("\(convertedTemperature, specifier: "%.2f") \(targetTemperatureUnit.unitSymbol)")
                }
              
            }
            
            .toolbar {
                if currentTemperatureFieldIsFocused {
                    Button("Done") {
                        currentTemperatureFieldIsFocused.toggle()
                    }
                }
            }
            .navigationTitle("TempConvert")
            .onChange(of: currentTemperatureUnit) {
                targetTemperatureUnit = validUnits[0]
            }
        }
    }
}

#Preview {
    ContentView()
}
