//
//  Users.swift
//  Chirped
//
//  Created by Michal Nierebinski on 02/01/2023.
//

import CommonUI
import SwiftUI
import Twift

struct Users: View {
    @EnvironmentObject var twitterClient: Twift

    var body: some View {
        Form {
            Section("Get Users") {
                NavigationLink(destination: GetMe()) { MethodRow(label: "`getMe()`", method: .GET) }
            }
        }
    }
}

struct Users_Previews: PreviewProvider {
    static var previews: some View {
        Users()
    }
}
