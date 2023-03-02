//
//  Tab2CoordinatorView.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab2CoordinatorView: View {

    // MARK: - Properties

    @ObservedObject private var coordinator: Tab2Coordinator

    // MARK: - Views

    var body: some View {
        NavigationStack {
            Tab2(viewModel: coordinator.tab2ViewModel)
                .sheet(item: $coordinator.sheetDemoViewModel) {
                    SheetDemo(viewModel: $0)
                }
        }
    }

    // MARK: - Initializers

    init(coordinator: Tab2Coordinator) {
        self.coordinator = coordinator
    }

}

struct Tab2CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Tab2CoordinatorView(coordinator: AppAssembler.previewResolver().resolve(Tab2Coordinator.self)!)
    }
}
