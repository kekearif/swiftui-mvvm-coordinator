//
//  MainCoordinator.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Foundation
import Swinject

final class MainCoordinator: ViewModel {

    enum Tab {
        case one, two, three
    }

    // MARK: - Properties

    @Published var selectedTab = Tab.one

    let tab1Coordinator: Tab1Coordinator
    let tab2Coordinator: Tab2Coordinator
    let tab3Coordinator: Tab3Coordinator

    // MARK: - Initializers

    init(tab1Coordinator: Tab1Coordinator, tab2Coordinator: Tab2Coordinator, tab3Coordinator: Tab3Coordinator) {
        self.tab1Coordinator = tab1Coordinator
        self.tab2Coordinator = tab2Coordinator
        self.tab3Coordinator = tab3Coordinator
    }

}
