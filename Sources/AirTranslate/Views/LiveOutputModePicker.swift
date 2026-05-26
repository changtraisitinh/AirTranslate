import SwiftUI

struct LiveOutputModePicker: View {
    @Binding var selection: LiveOutputMode
    let isDisabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                Image(systemName: selection.systemImage)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 14)

                Text(AppText.outputMode)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)
            }

            Picker(AppText.outputMode, selection: $selection) {
                ForEach(LiveOutputMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .disabled(isDisabled)
            .accessibilityLabel(AppText.outputMode)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}
