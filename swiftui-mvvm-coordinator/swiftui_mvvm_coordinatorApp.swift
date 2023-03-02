//
//  swiftui_mvvm_coordinatorApp.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

private let appAssembler: AppAssembler = AppAssembler()

@main
struct swiftui_mvvm_coordinatorApp: App {
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(coordinator: appAssembler.resolver.resolve(MainCoordinator.self)!)
        }
    }
}
