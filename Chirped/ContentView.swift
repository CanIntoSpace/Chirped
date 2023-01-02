//
//  ContentView.swift
//  Chirped
//
//  Created by Michal Nierebinski on 05/09/2022.
//

import SwiftUI
import Twift

struct ContentView: View {
    @EnvironmentObject var clientContainer: ClientContainer
    @EnvironmentObject var twitterClient: Twift
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .imageScale(.medium)
                .foregroundColor(.accentColor)
            Text("Hallo, die Welt!")
                .font(.title)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
