//
//  NavigationStackDemo.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct NavigationStackDemo: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: NavigationStackDemoViewModel

    // MARK: - Views

    var body: some View {
        Text(viewModel.title)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Initializers

    init(viewModel: NavigationStackDemoViewModel) {
        self.viewModel = viewModel
    }

}

struct NavigationStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackDemo(viewModel: AppAssembler.previewResolver().resolve(NavigationStackDemoViewModel.self)!)
    }
}
