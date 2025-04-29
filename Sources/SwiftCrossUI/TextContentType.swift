public enum TextContentType {
    /// Plain text.
    /// 
    /// This is the default value.
    case text
    /// Just digits.
    ///
    /// For numbers that may include decimals or negative numbers, see ``decimal(signed:)``.
    ///
    /// If `ascii` is true, the user should only enter the ASCII digits 0-9. If `ascii` is
    /// false, they may see a different numeric keypad depending on their locale settings
    /// (for example, they may see the digits ० १ २ ३ ४ ५ ६ ७ ८ ९ instead if the language
    /// is set to Hindi).
    case digits(ascii: Bool)
    /// A URL.
    ///
    /// This keyboard type typically has prominent buttons for "/" and ".com", and might not
    /// include a spacebar.
    case url
    /// A phone number.
    ///
    /// This input type has buttons for the digits 0-9 and the symbols "#" and "*", and may
    /// include other symbols or even letters.
    case phoneNumber
    /// A person's name.
    case name
    /// A number.
    ///
    /// This keyboard type is guaranteed to have at least digits and a decimal separator. If
    /// `signed` is true, the input will also have a plus sign and minus sign. Other characters
    /// may also appear.
    case decimal(signed: Bool)
    /// An email address.
    ///
    /// This keyboard type typically has prominent buttons for "@", ".", and/or ".com".
    case emailAddress
}
