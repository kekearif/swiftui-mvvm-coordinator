//
//  Tab1.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab1: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: Tab1ViewModel

    // MARK: - Views

    var body: some View {
        Text(viewModel.title)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Initializers

    init(viewModel: Tab1ViewModel) {
        self.viewModel = viewModel
    }

}

struct Tab1_Previews: PreviewProvider {
    static var previews: some View {
        Tab1(viewModel: AppAssembler.previewResolver().resolve(Tab1ViewModel.self)!)
    }
}
