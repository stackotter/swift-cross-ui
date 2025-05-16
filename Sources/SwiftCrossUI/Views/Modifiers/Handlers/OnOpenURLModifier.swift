import Foundation

extension View {
    public func onOpenURL(perform action: @escaping (URL) -> Void) -> some View {
        PreferenceModifier(self) { preferences, environment in
            var newPreferences = preferences
            newPreferences.onOpenURL = { url in
                action(url)
                if let innerHandler = preferences.onOpenURL {
                    innerHandler(url)
                } else {
                    environment.bringWindowForward()
                }
            }
            return newPreferences
        }
    }
}
