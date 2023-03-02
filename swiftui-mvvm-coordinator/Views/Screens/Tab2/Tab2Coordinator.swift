//
//  Tab2Coordinator.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Combine
import Foundation
import Swinject

final class Tab2Coordinator: ViewModel {

    // MARK: - Properties

    @Published var sheetDemoViewModel: SheetDemoViewModel?

    let tab2ViewModel: Tab2ViewModel

    private let resolver: Resolver
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(resolver: Resolver, tab2ViewModel: Tab2ViewModel) {
        self.resolver = resolver
        self.tab2ViewModel = tab2ViewModel

        super.init()

        bindEvents()
    }

    // MARK: - Binding

    private func bindEvents() {
        tab2ViewModel.event.presentDemoSheetButtonTapped
            .sink { [weak self] _ in self?.presentDemoSheet() }
            .store(in: &cancellables)
    }

    // MARK: - Navigation

    private func presentDemoSheet() {
        let sheetDemoViewModel = resolver.resolve(SheetDemoViewModel.self)!

        sheetDemoViewModel.event.dismissButtonTapped
            .map { _ in nil }
            .assign(to: &$sheetDemoViewModel)

        self.sheetDemoViewModel = sheetDemoViewModel
    }

}
