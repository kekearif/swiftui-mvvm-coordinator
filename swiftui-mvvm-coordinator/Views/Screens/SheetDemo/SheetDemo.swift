//
//  SheetDemo.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct SheetDemo: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: SheetDemoViewModel

    // MARK: - Views

    var body: some View {
        VStack {
            Text(viewModel.title)

            Button("Dismiss") {
                viewModel.event.dismissButtonTapped.send(())
            }
        }
    }

    // MARK: - Initializers

    init(viewModel: SheetDemoViewModel) {
        self.viewModel = viewModel
    }

}

struct SheetDemo_Previews: PreviewProvider {
    static var previews: some View {
        SheetDemo(viewModel: AppAssembler.previewResolver().resolve(SheetDemoViewModel.self)!)
    }
}
