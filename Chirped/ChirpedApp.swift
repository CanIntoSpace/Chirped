//
//  ChirpedApp.swift
//  Chirped
//
//  Created by Michal Nierebinski on 05/09/2022.
//

import CommonUI
import SwiftUI
import Twift
import Utils
import AuthenticationServices

let clientCredentials = OAuthCredentials(
    key: TWITTER_API_KEY,
    secret: TWITTER_API_SECRET
)

class ClientContainer: ObservableObject {
    @Published var client: Twift?
    @KeychainItem(account: "twiftAccount") var twiftAccount
}

@main
struct ChirpedApp: App {
    @StateObject var container = ClientContainer()
    var body: some Scene {
        WindowGroup {
            if let twitterClient = container.client {
                ContentView()
                    .environmentObject(twitterClient)
                    .environmentObject(container)
            } else {
                NavigationView {
                    Form {
                        Section(
                            header: Text("OAuth 2.0 User Authentication"),
                            footer: Text("Use this authentication method for most cases. This test app enables all user scopes by default.")
                        ) {
                            AsyncButton {
                                await onTap()
                            } label: {
                                Text("Sign In With Twitter")
                            }
                        }
                    }
                    .navigationTitle("Choose Auth Type")
                    .onAppear {
                        if let keychainItem = container.twiftAccount?.data(using: .utf8),
                           let decoded = try? JSONDecoder().decode(OAuth2User.self, from: keychainItem) {
                            container.client = Twift(oauth2User: decoded, onTokenRefresh: onTokenRefresh)
                        }
                    }
                }
            }
        }
    }

    private func onTokenRefresh(_ token: OAuth2User) {
        print(token)
        guard let encoded = try? JSONEncoder().encode(token) else { return }
        container.twiftAccount = String(data: encoded, encoding: .utf8)
    }

    private func onTap() async {
        let user = try? await Twift.Authentication().authenticateUser(clientId: CLIENT_ID,
                                                                      redirectUri: URL(string: TWITTER_CALLBACK_URL)!,
                                                                      scope: Set(OAuth2Scope.allCases))

        if let user {
            container.client = Twift(oauth2User: user) { token in
                onTokenRefresh(token)
            }
        }
    }
}
