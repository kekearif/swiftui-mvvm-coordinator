//
//  SheetDemoViewModel.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Combine
import Foundation

final class SheetDemoViewModel: ViewModel {

    struct Event {
        let dismissButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let title = "Sheet Demo"
    let event = Event()

}
