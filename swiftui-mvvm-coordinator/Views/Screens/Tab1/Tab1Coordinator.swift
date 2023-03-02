//
//  Tab1Coordinator.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Foundation
import Swinject

final class Tab1Coordinator: ViewModel {

    // MARK: - Properties

    let tab1ViewModel: Tab1ViewModel

    // MARK: - Initializers

    init(tab1ViewModel: Tab1ViewModel) {
        self.tab1ViewModel = tab1ViewModel
    }

}
