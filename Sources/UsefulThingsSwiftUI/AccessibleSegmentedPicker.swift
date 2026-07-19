import SwiftUI

/// A segmented picker whose labels wrap and whose layout adapts to Dynamic Type.
///
/// At accessibility sizes 3 through 5, segments are arranged vertically so each
/// option remains readable and easy to tap.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibleSegmentedPicker<Item: Hashable>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let items: [Item]
    @Binding private var selection: Item
    private let title: (Item) -> String

    @Namespace private var selectionAnimation

    public init(
        items: [Item],
        selection: Binding<Item>,
        title: @escaping (Item) -> String
    ) {
        self.items = items
        _selection = selection
        self.title = title
    }

    public var body: some View {
        Group {
            if dynamicTypeSize >= .accessibility3 {
                VStack(spacing: 0) {
                    segments
                }
            } else {
                HStack(spacing: 0) {
                    segments
                }
            }
        }
        .padding(3)
        .background {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(.quaternary)
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var segments: some View {
        ForEach(items, id: \.self) { item in
            segment(for: item)
        }
    }

    private func segment(for item: Item) -> some View {
        let isSelected = selection == item

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = item
            }
        } label: {
            Text(title(item))
                .font(.body)
                .fontWeight(isSelected ? .semibold : .regular)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
                .padding(.vertical, 10)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(.background)
                            .matchedGeometryEffect(
                                id: "selection",
                                in: selectionAnimation
                            )
                            .shadow(
                                color: .black.opacity(0.12),
                                radius: 2,
                                y: 1
                            )
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title(item))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Accessible Segmented Picker", traits: .sizeThatFitsLayout) {
    VStack {
        AccessibleSegmentedPickerPreview()
        
        Text("Accessible Segmented Picker — Accessibility 1")
        
        AccessibleSegmentedPickerPreview()
            .dynamicTypeSize(.accessibility1)
            .padding()
        
        Text("Accessible Segmented Picker — Accessibility 2")
        
        AccessibleSegmentedPickerPreview()
            .dynamicTypeSize(.accessibility2)
            .padding()
        
        Text("Accessible Segmented Picker — Accessibility 3")
        
        AccessibleSegmentedPickerPreview()
            .dynamicTypeSize(.accessibility3)
            .padding()
        
        Text("Accessible Segmented Picker — Accessibility 4")
        
        AccessibleSegmentedPickerPreview()
            .dynamicTypeSize(.accessibility4)
            .padding()
        
        Text("Accessible Segmented Picker — Accessibility 5")
        
        AccessibleSegmentedPickerPreview()
            .dynamicTypeSize(.accessibility5)
            .padding()
    }
    .frame(width: 600)
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AccessibleSegmentedPickerPreview: View {
    private enum Version: String, CaseIterable {
        case standard = "Standard Version"
        case extended = "Extended Version"
        case enterprise = "Enterprise Version"
    }

    @State private var selection = Version.standard

    var body: some View {
        AccessibleSegmentedPicker(
            items: Version.allCases,
            selection: $selection,
            title: \.rawValue
        )
    }
}
