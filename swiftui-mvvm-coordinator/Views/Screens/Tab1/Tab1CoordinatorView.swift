//
//  Tab1CoordinatorView.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab1CoordinatorView: View {

    // MARK: - Properties

    @ObservedObject private var coordinator: Tab1Coordinator

    // MARK: - Views

    var body: some View {
        NavigationStack {
            Tab1(viewModel: coordinator.tab1ViewModel)
        }
    }

    // MARK: - Initializers

    init(coordinator: Tab1Coordinator) {
        self.coordinator = coordinator
    }

}

struct Tab1CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Tab1CoordinatorView(coordinator: AppAssembler.previewResolver().resolve(Tab1Coordinator.self)!)
    }
}
