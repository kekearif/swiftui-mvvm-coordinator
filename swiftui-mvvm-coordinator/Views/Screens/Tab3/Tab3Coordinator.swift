//
//  Tab3Coordinator.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Combine
import Foundation
import Swinject

final class Tab3Coordinator: ViewModel {

    // MARK: - Properties

    @Published var path: [ViewModel] = []

    let tab3ViewModel: Tab3ViewModel

    private let resolver: Resolver
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(resolver: Resolver, tab3ViewModel: Tab3ViewModel) {
        self.resolver = resolver
        self.tab3ViewModel = tab3ViewModel

        super.init()

        bindEvents()
    }

    // MARK: - Binding

    private func bindEvents() {
        tab3ViewModel.event.pushDemoViewButtonTapped
            .sink { [weak self] _ in self?.navigateToDemoView() }
            .store(in: &cancellables)
    }

    // MARK: - Navigation

    private func navigateToDemoView() {
        path.append(resolver.resolve(NavigationStackDemoViewModel.self)!)
    }

}
