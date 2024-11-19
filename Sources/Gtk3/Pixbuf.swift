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
        let newPointer = gdk_pixbuf_scale_simple(
            pointer,
            gint(width),
            gint(height),
            GDK_INTERP_BILINEAR
        )
        return Pixbuf(pointer: newPointer!)
    }
}
