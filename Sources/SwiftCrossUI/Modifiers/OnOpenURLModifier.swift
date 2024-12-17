import Foundation

extension View {
    public func onOpenURL(perform action: @escaping (URL) -> Void) -> some View {
        PreferenceModifier(self) { preferences in
            var newPreferences = preferences
            newPreferences.onOpenURL = { url in
                action(url)
                preferences.onOpenURL?(url)
            }
            return newPreferences
        }
    }
}
