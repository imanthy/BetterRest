//
//  ContentView.swift
//  BetterRest
//
//  Created by Anthy Chen on 5/3/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = Date.now
    @State private var sleepAmountInHours = 8.0
    @State private var coffeeAmoutInCups = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desire amount of sleep (hours)")
                    .font(.headline)
                Stepper("\(sleepAmountInHours.formatted())", value: $sleepAmountInHours, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(coffeeAmoutInCups == 1 ? "1 cup" : "\(coffeeAmoutInCups) cups", value: $coffeeAmoutInCups, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate") {
                    calculateBedtime()
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
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
