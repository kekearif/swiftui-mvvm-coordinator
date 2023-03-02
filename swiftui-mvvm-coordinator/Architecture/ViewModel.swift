//
//  ViewModel.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

/// `Identifiable` is needed for sheets and `Hashable` is needed for `NavigationStack`
typealias ViewModelDefinition = (ObservableObject & Identifiable & Hashable)

class ViewModel: ViewModelDefinition {

    // MARK: - Identifiable

    let id = UUID()

    // MARK: - Equatable

    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
