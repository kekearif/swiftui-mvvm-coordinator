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
