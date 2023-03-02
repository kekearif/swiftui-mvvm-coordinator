//
//  Tab2ViewModel.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Combine
import Foundation

final class Tab2ViewModel: ViewModel {

    struct Event {
        let presentDemoSheetButtonTapped = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let title = "Tab 2"
    let event = Event()

}

