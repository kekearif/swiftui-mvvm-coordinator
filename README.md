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

For convenience, a parent class *ViewModel* is created. This class conforms to *ObservableObject*, allowing the view models to be injected as *ObservedObject* in various views. Additionally, it conforms to *Identifiable* for presenting sheets and *Hashable* for use in a *NavigationStack*.

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

The coordinator stores the various view models and coordinators needed for a view in *@Published* properties. When a coordinator is initialized with its root view model, its events are bound to various navigation methods that will set the *@Published* properties. Either delegation or *Combine* can be used for handling events.

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

Each view that needs navigation must be wrapped in a *CoordinatorView*. The *CoordinatorView* holds a reference to the *Coordinator* and will manage navigation such as sheets, tabs, and *NavigationStack*.

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

## Navigation

### Sheets

A sheet is presented by assigning a view model to an optional *Published* property in the *Coordinator*.

```swift
private func presentDemoSheet() {
    let sheetDemoViewModel = resolver.resolve(SheetDemoViewModel.self)!

    sheetDemoViewModel.event.dismissButtonTapped
        .map { _ in nil }
        .assign(to: &$sheetDemoViewModel)

    // Assign to published property
    self.sheetDemoViewModel = sheetDemoViewModel
}

```
This propety is then used in the *CoordinatorView*

```swift
var body: some View {
    NavigationStack {
        // Wrapped view
        Tab2(viewModel: coordinator.tab2ViewModel)
            .sheet(item: $coordinator.sheetDemoViewModel) {
                SheetDemo(viewModel: $0)
            }
    }
}
```

### Tabs

The relevant tab coordinators or view models are stored in view's coordinator

```swift
let tab1Coordinator: Tab1Coordinator
let tab2Coordinator: Tab2Coordinator
let tab3Coordinator: Tab3Coordinator
```

These properties are then used in the *CoordinatorView*

```swift
var body: some View {
    TabView(selection: $coordinator.selectedTab) {
        Tab1CoordinatorView(coordinator: coordinator.tab1Coordinator)
            .tabItem {
                Constants.tab1Image
            }
            .tag(MainCoordinator.Tab.one)

        Tab2CoordinatorView(coordinator: coordinator.tab2Coordinator)
            .tabItem {
                Constants.tab2Image
            }
            .tag(MainCoordinator.Tab.two)

        Tab3CoordinatorView(coordinator: coordinator.tab3Coordinator)
            .tabItem {
                Constants.tab3Image
            }
            .tag(MainCoordinator.Tab.three)
    }
}
```

### NavigationStack

The *path* for the *NavigationStack* is stored in the *Coordinator*. When navigating to a view a new view model is appended onto the array.

```swift
private func navigateToDemoView() {
    path.append(resolver.resolve(NavigationStackDemoViewModel.self)!)
}
```

Since the view models already conform to *hashable* the *path* can easily be inspected using a *switch* statement in the *CoordinatorView* and the relevant view pushed.

```swift
var body: some View {
    NavigationStack(path: $coordinator.path) {
        // Wrapped view
        Tab3(viewModel: coordinator.tab3ViewModel)
            .navigationDestination(for: ViewModel.self) { viewModel in
                switch viewModel {
                case let navigationStackDemoViewModel as NavigationStackDemoViewModel:
                    NavigationStackDemo(viewModel: navigationStackDemoViewModel)
                default:
                    EmptyView()
                }
            }
    }
}
```
