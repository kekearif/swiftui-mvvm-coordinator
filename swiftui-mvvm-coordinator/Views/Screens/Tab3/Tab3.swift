//
//  Tab3.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab3: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: Tab3ViewModel

    // MARK: - Views

    var body: some View {
        VStack {
            Text(viewModel.title)

            Button("Push Demo View") {
                viewModel.event.pushDemoViewButtonTapped.send(())
            }
        }
    }

    // MARK: - Initializers

    init(viewModel: Tab3ViewModel) {
        self.viewModel = viewModel
    }

}

struct Tab3_Previews: PreviewProvider {
    static var previews: some View {
        Tab3(viewModel: AppAssembler.previewResolver().resolve(Tab3ViewModel.self)!)
    }
}
