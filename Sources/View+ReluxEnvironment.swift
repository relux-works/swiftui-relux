import SwiftUI
import Relux

private struct ReluxEnvironmentKey: EnvironmentKey {
    static let defaultValue: Relux? = nil
}

public extension EnvironmentValues {
    var relux: Relux? {
        get { self[ReluxEnvironmentKey.self] }
        set { self[ReluxEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func relux(_ relux: Relux) -> some View {
        environment(\.relux, relux)
    }

    func reluxTemporal<State: Relux.HybridState>(
        state: State,
        onConnect: (@MainActor (Relux, State) async -> Void)? = nil
    ) -> some View {
        modifier(
            ReluxTemporalStateConnector(
                state: state,
                onConnect: onConnect
            )
        )
    }
}

private struct ReluxTemporalStateConnector<State: Relux.HybridState>: ViewModifier {
    @Environment(\.relux) private var relux
    let state: State
    let onConnect: (@MainActor (Relux, State) async -> Void)?

    func body(content: Content) -> some View {
        content
            .task {
                await connect()
            }
    }

    @MainActor
    private func connect() async {
        guard let relux else { return }
        let connectedState = relux.store.connectTemporally(state: state)
        await onConnect?(relux, connectedState)
    }
}
