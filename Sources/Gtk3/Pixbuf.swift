import CGtk3

public struct Pixbuf {
    public let pointer: OpaquePointer

    public init(rgbaData: [UInt8], width: Int, height: Int) {
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: rgbaData.count)
        memcpy(buffer.baseAddress!, rgbaData, rgbaData.count)

        let width = gint(width)
        let height = gint(height)
        let hasAlpha = true.toGBoolean()
        let bitsPerSample: gint = 8
        let channels: gint = 4
        let rowStride = channels * gint(width)

        pointer = gdk_pixbuf_new_from_data(
            buffer.baseAddress,
            GDK_COLORSPACE_RGB,
            hasAlpha,
            bitsPerSample,
            width,
            height,
            rowStride,
            { buffer, _ in
                buffer?.deallocate()
            },
            nil
        )
    }

    private init(pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func scaled(toWidth width: Int, andHeight height: Int) -> Pixbuf {
        // This operation fails if the destination width or destination height
        // is 0, so just make sure neither dimension hits zero.
        let newPointer = gdk_pixbuf_scale_simple(
            pointer,
            gint(max(width, 1)),
            gint(max(height, 1)),
            GDK_INTERP_BILINEAR
        )
        return Pixbuf(pointer: newPointer!)
    }

    public func hidpiAwareScaled(
        toLogicalWidth logicalWidth: Int,
        andLogicalHeight logicalHeight: Int,
        for widget: Image
    ) -> CairoSurface {
        // Get scaling and compute device dimensions from logical dimensions
        // (device dimensions being the target dimensions in terms of device
        // pixels, not the dimensions of the device)
        let scale = gtk_widget_get_scale_factor(widget.widgetPointer)
        let deviceWidth = logicalWidth * Int(scale)
        let deviceHeight = logicalHeight * Int(scale)
        let scaledPixbuf = self.scaled(
            toWidth: deviceWidth,
            andHeight: deviceHeight
        )
        let surface = gdk_cairo_surface_create_from_pixbuf(
            scaledPixbuf.pointer,
            scale,
            gtk_widget_get_window(widget.widgetPointer)
        )!
        return CairoSurface(pointer: surface)
    }
}
