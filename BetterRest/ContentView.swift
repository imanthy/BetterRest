//
//  ContentView.swift
//  BetterRest
//
//  Created by Anthy Chen on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = Date.now
    @State private var sleepAmountInHours = 8.0
    @State private var coffeeAmoutInCups = 1
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
        }
    }
    
    func calculateBedtime() {
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
