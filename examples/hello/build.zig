const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addSharedLibrary("hello", "src/main.zig", b.version(1, 0, 0));
    lib.setBuildMode(mode);
    lib.addIncludeDir("/home/silas/.rbenv/versions/2.7.2/include/ruby-2.7.0");
    lib.addIncludeDir("/home/silas/.rbenv/versions/2.7.2/include/ruby-2.7.0/x86_64-linux");
    lib.addLibPath("/home/silas/.rbenv/versions/2.7.2/lib");
    lib.linkSystemLibrary("c");
    lib.linkSystemLibrary("ruby");

    lib.install();
}
