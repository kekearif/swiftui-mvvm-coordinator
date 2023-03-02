//
//  Tab3CoordinatorView.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab3CoordinatorView: View {

    // MARK: - Properties

    @ObservedObject private var coordinator: Tab3Coordinator

    // MARK: - Views

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Tab3(viewModel: coordinator.tab3ViewModel)
                .navigationDestination(for: ViewModel.self) { viewModel in
                    switch viewModel {
                    case let navigationStackDemoViewModel as NavigationStackDemoViewModel:
                        NavigationStackDemo(viewModel: navigationStackDemoViewModel)
                    default:
                        EmptyView()
                    }
                }
        }
    }

    // MARK: - Initializers

    init(coordinator: Tab3Coordinator) {
        self.coordinator = coordinator
    }

}

struct Tab3CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Tab3CoordinatorView(coordinator: AppAssembler.previewResolver().resolve(Tab3Coordinator.self)!)
    }
}
