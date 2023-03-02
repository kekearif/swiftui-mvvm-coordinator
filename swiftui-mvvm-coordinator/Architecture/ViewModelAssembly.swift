//
//  ViewModelAssembly.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Foundation
import Swinject

final class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Tab1ViewModel.self) { _ in
            Tab1ViewModel()
        }.inObjectScope(.transient)

        container.register(Tab2ViewModel.self) { _ in
            Tab2ViewModel()
        }.inObjectScope(.transient)

        container.register(Tab3ViewModel.self) { _ in
            Tab3ViewModel()
        }.inObjectScope(.transient)

        container.register(SheetDemoViewModel.self) { _ in
            SheetDemoViewModel()
        }.inObjectScope(.transient)

        container.register(NavigationStackDemoViewModel.self) { _ in
            NavigationStackDemoViewModel()
        }.inObjectScope(.transient)
    }

}
