//
//  AppAssembler.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import Foundation
import Swinject

final class AppAssembler {

    static func previewResolver() -> Resolver {
        let assembler = AppAssembler()
        return assembler.resolver
    }

    // MARK: - Properties

    private let assembler: Assembler

    var resolver: Resolver {
        assembler.resolver
    }

    // MARK: - Initializers

    init() {
        self.assembler = Assembler([
            CoordinatorAssembly(),
            ViewModelAssembly()
        ])
    }

}
