# The MVVM Coordinator Pattern in SwiftUI
A demo on how to cleanly isolate business logic, view logic, and navigation logic in SwiftUI.

## SwinJect

The [SwinJect](https://github.com/Swinject/Swinject) package is used for dependency injection. A main *AppAssembler* class is created to build the various sub assemblers.

```swift
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
```

It is important to note that inside the *CoordinatorAssembly* the root coordinator *inObjectScope* should be set to *container*, this ensures that it is only created once and persists.

```swift
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
        // All other coordinators will be .transient scope and re-created when needed
    }

}
```

## ViewModel

For convenience a parent class *ViewModel* is created. This class conforms to *ObservableObject* so the view models can be injected as *ObservedObject* in the various views. It also conforms to *Identifiable* for presenting sheets and *Hashable* for use in a *NavigationStack*.

```swift
typealias ViewModelDefinition = (ObservableObject & Identifiable & Hashable)

class ViewModel: ViewModelDefinition {

    // MARK: - Identifiable

    let id = UUID()

    // MARK: - Equatable

    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
```

## Coordinator

The *coordinator* stores the various view models and coordinators needed for a view in *Published* properties. When a coordinator is init with its root view model its events are also bound to various navigation methods that will set the *Published* properties.

```swift
final class Tab2Coordinator: ViewModel {

    // MARK: - Properties

    @Published var sheetDemoViewModel: SheetDemoViewModel?

    // root view model
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
```

## CoordinatorView

Each view that needs navigation must be wrapped in a *CoordinatorView*. The *CoordinatorView* holds a reference to the *Coordinator* and will manage navigation such as sheets, tabs and *NavigationStack*.

```Swift
struct Tab2CoordinatorView: View {

    // MARK: - Properties

    @ObservedObject private var coordinator: Tab2Coordinator

    // MARK: - Views

    var body: some View {
        NavigationStack {
            // Wrapped view
            Tab2(viewModel: coordinator.tab2ViewModel)
                // Navigation managed by the coordinator
                .sheet(item: $coordinator.sheetDemoViewModel) {
                    SheetDemo(viewModel: $0)
                }
        }
    }

    // MARK: - Initializers

    init(coordinator: Tab2Coordinator) {
        self.coordinator = coordinator
    }

}
```
