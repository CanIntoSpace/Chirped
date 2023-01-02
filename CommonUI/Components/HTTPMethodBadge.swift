//
//  HTTPMethodBadge.swift
//  CommonUI
//
//  Created by Michal Nierebinski on 02/01/2023.
//

import SwiftUI

public enum HTTPMethod: String, CaseIterable {
  case GET, POST, DELETE
}

struct HTTPMethodBadge: View {
  var method: HTTPMethod

  var color: Color {
    switch method {
    case .GET:
      return .blue
    case .POST:
      return .purple
    case .DELETE:
      return .red
    }
  }

  var body: some View {
    Text(method.rawValue)
      .padding(4)
      .padding(.horizontal, 4)
      .font(.caption.monospaced().weight(.semibold))
      .foregroundStyle(.primary)
      .background(.quaternary)
      .foregroundStyle(color)
      .cornerRadius(8)

  }
}
