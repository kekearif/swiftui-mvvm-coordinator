//
//  Tab3ViewModel.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Combine
import Foundation

final class Tab3ViewModel: ViewModel {

    struct Event {
        let pushDemoViewButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let title = "Tab 3"
    let event = Event()

}
