//
//  MethodRow.swift
//  CommonUI
//
//  Created by Michal Nierebinski on 02/01/2023.
//

import SwiftUI

public struct MethodRow: View {
  var label: String
  var method: HTTPMethod

  var attributedLabel: AttributedString {
    try! AttributedString(markdown: label)
  }

    public init(label: String, method: HTTPMethod) {
        self.label = label
        self.method = method
    }
    
  public var body: some View {
    HStack {
      Text(attributedLabel)
      Spacer()
      HTTPMethodBadge(method: method)
    }.lineLimit(1)
  }
}

struct MethodRow_Previews: PreviewProvider {
    static var previews: some View {
      MethodRow(label: "`getMe()`", method: .GET)
    }
}
