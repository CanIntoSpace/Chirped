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
        NavigationView {
            Form {
                Section("Examples") {
                    NavigationLink(destination: Users()) { Label("Users", systemImage: "person") }
                }
                .disabled(!twitterClient.hasUserAuth)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
