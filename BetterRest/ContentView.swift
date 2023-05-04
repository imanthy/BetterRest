//
//  ContentView.swift
//  BetterRest
//
//  Created by Anthy Chen on 5/3/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var sleepAmountInHours = 8.0
    @State private var coffeeAmoutInCups = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmountInHours, coffee: Double(coffeeAmoutInCups))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            return "Your ideal bed time is " + sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            return "there was an error"
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desire amount of sleep (hours)") {
                    Stepper("\(sleepAmountInHours.formatted())", value: $sleepAmountInHours, in: 4...12, step: 0.25)
                }
                Section("Daily coffee intake") {
//                    Stepper(coffeeAmoutInCups == 1 ? "1 cup" : "\(coffeeAmoutInCups) cups", value: $coffeeAmoutInCups, in: 1...20)
                    Picker(coffeeAmoutInCups == 1 ? "Cup" : "Cups", selection: $coffeeAmoutInCups) {
                        ForEach(1..<21, id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                    .pickerStyle(.automatic)

                }
                Section {
                    Text(sleepResults)
                        .font(.headline)
                }
            }
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate") {
//                    calculateBedtime()
//                }
//            }
//            .alert(alertTitle, isPresented: $showAlert) {
//                Button("OK") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmountInHours, coffee: Double(coffeeAmoutInCups))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            alertTitle = "Your ideal bed time is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showAlert = true
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
