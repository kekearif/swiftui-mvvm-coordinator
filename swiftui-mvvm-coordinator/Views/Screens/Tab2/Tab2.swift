//
//  Tab2.swift
//  swiftui-mvvm-coordinator
//
//  Created by Keke Arif on 2023/3/1.
//

import SwiftUI

struct Tab2: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: Tab2ViewModel

    // MARK: - Views

    var body: some View {
        VStack {
            Text(viewModel.title)

            Button("Present Demo Sheet") {
                viewModel.event.presentDemoSheetButtonTapped.send(())
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Initializers

    init(viewModel: Tab2ViewModel) {
        self.viewModel = viewModel
    }

}

struct Tab2_Previews: PreviewProvider {
    static var previews: some View {
        Tab2(viewModel: AppAssembler.previewResolver().resolve(Tab2ViewModel.self)!)
    }
}
