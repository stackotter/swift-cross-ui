import CGtk3

public struct Pixbuf {
    public let pointer: OpaquePointer

    private class DestructorContext {
        let bufferLength: Int

        init(bufferLength: Int) {
            self.bufferLength = bufferLength
        }
    }

    public init(rgbaData: [UInt8], width: Int, height: Int, format: Int, stride: Int) {
        let bufferLength = rgbaData.count
        let destructorContext = DestructorContext(
            bufferLength: bufferLength
        )
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferLength)
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
            { buffer, context in
                let context = Unmanaged<DestructorContext>.fromOpaque(context!).takeRetainedValue()
                let buffer = UnsafeMutableBufferPointer<UInt8>(
                    start: buffer,
                    count: context.bufferLength
                )
                buffer.deallocate()
            },
            Unmanaged.passRetained(destructorContext).toOpaque()
        )
    }
}
