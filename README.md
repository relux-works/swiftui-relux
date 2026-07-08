# SwiftUIRelux

SwiftUI helpers for apps that use `Relux`.

## Relux Resolver

Use `Relux.Resolver` when a SwiftUI root needs to wait for an async `Relux`
runtime before rendering product UI:

```swift
Relux.Resolver(
    splash: ProgressView.init,
    content: { _ in
        AppContent()
    },
    resolver: {
        await makeRelux()
    }
)
```

After the runtime is resolved, `Relux.Resolver` automatically:

- stores the resolved `Relux` in SwiftUI environment as `\.relux`;
- passes registered Relux UI states to SwiftUI environment objects;
- keeps the splash visible until the runtime exists.

The content closure still receives the resolved `Relux` for callers that need it
as an explicit value, but root containers usually do not need to pass it further
only to populate SwiftUI environment. Any child view rendered under
`Relux.Resolver` can read:

```swift
@Environment(\.relux) private var relux
```

If the view is not created by `Relux.Resolver`, pass the runtime manually:

```swift
AppContent()
    .relux(relux)
```

The `.relux(_:)` modifier is public intentionally. It is the manual escape hatch
for custom composition surfaces, previews, tests, or presentation paths that are
not rendered under `Relux.Resolver`.

## Temporal State

For wizard-style or modal flows, keep the temporal state owned by the SwiftUI
container and connect it to the current `Relux.Store` with
`reluxTemporal(state:)`:

```swift
struct MoneyTransferFlow: View {
    @StateObject private var state = MoneyTransfer.State()

    var body: some View {
        content
            .reluxTemporal(state: state)
    }
}
```

`reluxTemporal(state:)` reads `Relux` from `\.relux` and calls
`relux.store.connectTemporally(state:)` from a SwiftUI `.task`.

If the flow must dispatch initial Relux actions after the temporal state is
connected, use the optional `onConnect` callback:

```swift
content
    .reluxTemporal(state: state) { relux, state in
        await relux.dispatch(StartSessionEffect(state: state))
    }
```

`onConnect` runs only after the store registers and returns the connected state,
so startup actions can depend on the temporal state being available in the
store.

`Relux.Store` stores temporal states weakly. The SwiftUI container must own the
state, for example with `@StateObject`; when the container is dismissed, the
state can be released with the container.

<!-- relux-ecosystem:start -->

## About Relux Works

This project is part of the open-source ecosystem of
[Relux Works](https://relux.works), an AI-native software development studio.
We build fixed-price MVPs, rescue vibe-coded apps, run local AI inference, and
train teams to work with coding agents — and we open-source much of the
infrastructure behind it.

- Full catalog: [relux.works/en/open-source](https://relux.works/en/open-source/)
- Agentic enablement: [agent harnesses & team training](https://relux.works/en/agentic-enablement/)
- Hire us the agent-native way — point your assistant at `https://api.relux.works/mcp`
- Contact: ivan@relux.works

<!-- relux-ecosystem:end -->
