#!/bin/bash
app=$1
ndk=/Users/stackotter/Library/Android/sdk/ndk/26.1.10909125
build_api=24
link_api=32
target_arch=aarch64
host=darwin-x86_64 # x86_64 even on apply silicon
xcrun --toolchain swift swift build --swift-sdk ${target_arch}-unknown-linux-android${build_api} --product $app \
  -Xswiftc -I${ndk}/toolchains/llvm/prebuilt/${host}/sysroot/usr/include/android \
  -Xcc -fPIC

/Library/Developer/Toolchains/swift-6.1.1-RELEASE.xctoolchain/usr/bin/swiftc -L /Users/stackotter/Desktop/Projects/SwiftCrossUI/SwiftCrossUI/Examples/.build/aarch64-unknown-linux-android24/debug -o /Users/stackotter/Desktop/Projects/SwiftCrossUI/SwiftCrossUI/Examples/.build/aarch64-unknown-linux-android24/debug/libCounterExample.so -emit-library -module-name CounterExample -Xlinker --defsym -Xlinker main=CounterExample_main -resource-dir /Users/stackotter/Library/org.swift.swiftpm/swift-sdks/swift-6.1-RELEASE-android-24-0.1.artifactbundle/swift-6.1-release-android-24-sdk/android-27c-sysroot/usr/lib/swift -Xclang-linker -resource-dir -Xclang-linker /Users/stackotter/Library/org.swift.swiftpm/swift-sdks/swift-6.1-RELEASE-android-24-0.1.artifactbundle/swift-6.1-release-android-24-sdk/android-27c-sysroot/usr/lib/swift/clang -Xlinker '-rpath=$ORIGIN' @/Users/stackotter/Desktop/Projects/SwiftCrossUI/SwiftCrossUI/Examples/.build/aarch64-unknown-linux-android24/debug/CounterExample.product/Objects.LinkFileList -target aarch64-unknown-linux-android24 -sdk /Users/stackotter/Library/org.swift.swiftpm/swift-sdks/swift-6.1-RELEASE-android-24-0.1.artifactbundle/swift-6.1-release-android-24-sdk/android-27c-sysroot -Xclang-linker -fuse-ld=lld -sdk /Users/stackotter/Library/org.swift.swiftpm/swift-sdks/swift-6.1-RELEASE-android-24-0.1.artifactbundle/swift-6.1-release-android-24-sdk/android-27c-sysroot -g -I/Users/stackotter/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/android
