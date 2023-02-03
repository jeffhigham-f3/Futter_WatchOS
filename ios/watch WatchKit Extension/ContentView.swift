//
//  ContentView.swift
//  watch WatchKit Extension
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var manager = WatchCommunicationManager()
    
    var body: some View {
        VStack {
            Text(manager.text!).font(.largeTitle)
            Spacer()
            Button(action: increment) {
                Text("➕")
                    .font(.title)
            }
            Button(action: decrement) {
                Text("➖")
                    .font(.title)
                
            }
        }.padding()
    }

    private func increment() {
        manager.updateText("increment")
    }

    private func decrement() {
        manager.updateText("decrement")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
