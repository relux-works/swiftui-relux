import SwiftUI
import Relux

public extension View {
    @MainActor
    func passingObservableToEnvironment(fromStore store: Relux.Store) -> some View {
        var view: any View = self

        let uistates = store
            .uiStates
            .values
            .map { $0 as Any }

        passEnvironmentObjectsOnly(inView: &view, objects: uistates)

        return AnyView(view)
    }


    @MainActor
    private func passEnvironmentObjectsOnly(inView view: inout any View, objects: [Any]) {
        objects.forEach { object in
            if let observableObj = object as? (any ObservableObject) {
                debugPrint("[ReluxRootView] passing \(observableObj) as ObservableObject to SwiftUI environment")
                view = view.environmentObject(observableObj)
            }
        }
    }
}
