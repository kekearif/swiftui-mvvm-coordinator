//
//  MainCoordinatorView.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct MainCoordinatorView: View {

    private enum Constants {
        static let tab1Image = Image(systemName: "1.circle")
        static let tab2Image = Image(systemName: "2.circle")
        static let tab3Image = Image(systemName: "3.circle")
    }

    // MARK: - Properties

    @ObservedObject private var coordinator: MainCoordinator

    // MARK: - Views

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab1CoordinatorView(coordinator: coordinator.tab1Coordinator)
                .tabItem {
                    Constants.tab1Image
                }
                .tag(MainCoordinator.Tab.one)

            Tab2CoordinatorView(coordinator: coordinator.tab2Coordinator)
                .tabItem {
                    Constants.tab2Image
                }
                .tag(MainCoordinator.Tab.two)

            Tab3CoordinatorView(coordinator: coordinator.tab3Coordinator)
                .tabItem {
                    Constants.tab3Image
                }
                .tag(MainCoordinator.Tab.three)
        }
    }

    // MARK: - Initializers

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView(coordinator: AppAssembler.previewResolver().resolve(MainCoordinator.self)!)
    }
}
