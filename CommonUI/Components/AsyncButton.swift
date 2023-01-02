//
//  AsyncButton.swift
//  CommonUI
//
//  Created by Michal Nierebinski on 29/12/2022.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    public enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }

    public var action: () async -> Void
    public var actionOptions = Set(ActionOption.allCases)
    @ViewBuilder public var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false
    public init(
        action: @escaping () async -> Void,
        label: @escaping () -> Label,
        isDisabled: Bool = false,
        showProgressView: Bool = false
    ) {
        self.action = action
        self.label = label
        self.isDisabled = isDisabled
        self.showProgressView = showProgressView
    }

    public var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }

                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                HStack {
                    label()
                    Spacer()
                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

struct AsyncButton_Previews: PreviewProvider {
    static var previews: some View {
        AsyncButton {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        } label: {
            Label("Do something", systemImage: "cursorarrow.rays")
        }
        .previewLayout(.sizeThatFits)
    }
}
