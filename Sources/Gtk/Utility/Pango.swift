import CGtk

public enum Pango {
    /// Gets the size of the given text in pixels using the default font. If supplied, `proposedWidth`
    /// acts as a suggested width. The text will attempt to take up less than or equal to the proposed
    /// width but if the text wrapping strategy doesn't allow the text to become as small as required
    /// than it may take up more the proposed width.
    public static func getTextSize(
        _ text: String,
        proposedWidth: Double? = nil
    ) -> (width: Int, height: Int) {
        let fontMap = pango_cairo_font_map_new()
        let pangoContext = pango_font_map_create_context(fontMap)
        let layout = pango_layout_new(pangoContext)
        pango_layout_set_text(layout, text, Int32(text.count))
        pango_layout_set_wrap(layout, PANGO_WRAP_WORD_CHAR)

        if let proposedWidth = proposedWidth {
            pango_layout_set_width(
                layout,
                Int32((proposedWidth * Double(PANGO_SCALE)).rounded(.towardZero))
            )
        }

        var width: Int32 = 0
        var height: Int32 = 0
        pango_layout_get_pixel_size(layout, &width, &height)

        return (
            Int(width),
            Int(height)
        )
    }
}
