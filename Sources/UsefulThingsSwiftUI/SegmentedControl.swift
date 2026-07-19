#if canImport(UIKit)
import SwiftUI
import UIKit

@available(iOS 15.0, *)
struct SegmentedControl<Item: Hashable>: UIViewRepresentable {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let items: [Item]
    @Binding var selection: Item
    let title: (Item) -> String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(
            items: items.map(title)
        )

        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.changed(_:)),
            for: .valueChanged
        )

        return control
    }

    func updateUIView(
        _ control: UISegmentedControl,
        context: Context
    ) {
        control.selectedSegmentIndex =
            items.firstIndex(of: selection) ?? 0

        let category = UIContentSizeCategory(dynamicTypeSize)
        let traits = UITraitCollection(
            preferredContentSizeCategory: category
        )

        let font = UIFont.preferredFont(
            forTextStyle: .body,
            compatibleWith: traits
        )

        control.setTitleTextAttributes(
            [.font: font],
            for: .normal
        )

        control.setTitleTextAttributes(
            [.font: font],
            for: .selected
        )
    }

    final class Coordinator: NSObject {
        var parent: SegmentedControl

        init(_ parent: SegmentedControl) {
            self.parent = parent
        }

        @objc
        func changed(_ sender: UISegmentedControl) {
            guard parent.items.indices.contains(
                sender.selectedSegmentIndex
            ) else {
                return
            }

            parent.selection =
                parent.items[sender.selectedSegmentIndex]
        }
    }
}


@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Segmented Control", traits: .sizeThatFitsLayout) {
    VStack {
        SegmentedControlPreview()

        Text("Segmented Control — Accessibility 1")

        SegmentedControlPreview()
            .dynamicTypeSize(.accessibility1)
            .padding()

        Text("Segmented Control — Accessibility 2")

        SegmentedControlPreview()
            .dynamicTypeSize(.accessibility2)
            .padding()

        Text("Segmented Control — Accessibility 3")

        SegmentedControlPreview()
            .dynamicTypeSize(.accessibility3)
            .padding()

        Text("Segmented Control — Accessibility 4")

        SegmentedControlPreview()
            .dynamicTypeSize(.accessibility4)
            .padding()

        Text("Segmented Control — Accessibility 5")

        SegmentedControlPreview()
            .dynamicTypeSize(.accessibility5)
            .padding()
    }
    .padding().padding().padding()
    .frame(width: 1200)
}

@available(iOS 15.0, *)
private struct SegmentedControlPreview: View {
    private enum Version: String, CaseIterable {
        case standard = "Standard Version"
        case extended = "Extended Version"
        case enterprise = "Enterprise Version"
    }

    @State private var selection = Version.standard

    var body: some View {
        SegmentedControl(
            items: Version.allCases,
            selection: $selection,
            title: \.rawValue
        )
    }
}
#endif
