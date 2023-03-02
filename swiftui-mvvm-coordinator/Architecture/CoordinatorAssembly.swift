//
//  CoordinatorAssembly.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Foundation
import Swinject

class CoordinatorAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MainCoordinator.self) { resolver in
            MainCoordinator(
                tab1Coordinator: resolver.resolve(Tab1Coordinator.self)!,
                tab2Coordinator: resolver.resolve(Tab2Coordinator.self)!,
                tab3Coordinator: resolver.resolve(Tab3Coordinator.self)!
            )
        }.inObjectScope(.container)
        // .container scope since the root coordinator instance should only be created once

        container.register(Tab1Coordinator.self) { resolver in
            Tab1Coordinator(tab1ViewModel: resolver.resolve(Tab1ViewModel.self)!)
        }.inObjectScope(.transient)

        container.register(Tab2Coordinator.self) { resolver in
            Tab2Coordinator(
                resolver: resolver,
                tab2ViewModel: resolver.resolve(Tab2ViewModel.self)!
            )
        }.inObjectScope(.transient)

        container.register(Tab3Coordinator.self) { resolver in
            Tab3Coordinator(
                resolver: resolver,
                tab3ViewModel: resolver.resolve(Tab3ViewModel.self)!
            )
        }.inObjectScope(.transient)
    }

}
