import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }) {
                        HStack {
                            Label {
                                Text(NSLocalizedString("Language", comment: "Language settings option"))
                            } icon: {
                                Image(systemName: "globe")
                                    .foregroundStyle(.blue)
                            }
                            Spacer()
                          Text(
                            Locale.current.language.languageCode?.identifier ?? "en"
                          )
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text(NSLocalizedString("General", comment: "General settings section header"))
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment: "Settings screen title"))
        }
    }
} 
