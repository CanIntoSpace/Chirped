//
//  GetMe.swift
//  Chirped
//
//  Created by Michal Nierebinski on 02/01/2023.
//

import SwiftUI
import Twift
import CommonUI
import Domain

struct GetMe: View {
  @EnvironmentObject var twitterClient: Twift
  @State var user: User?
  @State var errors: [TwitterAPIError] = []
    var body: some View {
      Form {
        Section {
          AsyncButton(action: {
            do {
              let result = try await twitterClient.getMe(fields: allUserFields)
              withAnimation {
                user = result.data
                errors = result.errors ?? []
              }
            } catch {
              if let error = error as? TwitterAPIError {
                withAnimation { errors = [error] }
              } else {
                print(error.localizedDescription)
              }
            }
          }) {
            Text("Get currently authenticated user")
          }
        }

        if let user = user {
          Section("User") {
            UserRow(user: user)
          }
        }

        if !errors.isEmpty {
          Section("Errors") {
            ForEach(errors, id: \.self) { error in
              Text(String(describing: error))
            }
          }
        }
      }.navigationTitle("Get Currently Authenticated User")
    }
}

struct GetMe_Previews: PreviewProvider {
    static var previews: some View {
        GetMe()
    }
}
