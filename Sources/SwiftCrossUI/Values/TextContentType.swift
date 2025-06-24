public enum TextContentType: Sendable {
    /// Plain text.
    ///
    /// This is the default value.
    case text
    /// Just digits.
    ///
    /// For numbers that may include decimals or negative numbers, see ``decimal(signed:)``.
    ///
    /// If `ascii` is true, the user should only enter the ASCII digits 0-9. If `ascii` is
    /// false, on mobile devices they may see a different numeric keypad depending on their
    /// locale settings (for example, they may see the digits ० १ २ ३ ४ ५ ६ ७ ८ ९ instead
    /// if the language is set to Hindi).
    case digits(ascii: Bool)
    /// A URL.
    ///
    /// On mobile devices, this type shows a keyboard with prominent buttons for "/" and ".com",
    /// and might not include a spacebar.
    case url
    /// A phone number.
    case phoneNumber
    /// A person's name.
    ///
    /// This typically uses the default keyboard, but informs autocomplete to use contact
    /// names rather than regular words.
    case name
    /// A number.
    ///
    /// If `signed` is false, on mobile devices it shows a numeric keypad with a decimal point,
    /// but not necessarily plus and minus signs. If `signed` is true then more punctuation can
    /// be entered.
    case decimal(signed: Bool)
    /// An email address.
    ///
    /// This informs autocomplete that the input is an email address, and on mobile devices,
    /// displays a keyboard with prominent "@" and "." buttons.
    case emailAddress
}
