const ruby = @cImport({
    @cInclude("ruby.h");
});

const std = @import("std");

const chars: []const u8 = "0123456789ABCDEF";

pub const UUID = struct {
    const Self = @This();
    id: [36]u8,

    pub fn new(seed: u64) !*Self {
        var r = std.rand.DefaultPrng.init(seed);
        var uu = try std.heap.page_allocator.create(Self);

        errdefer std.heap.page_allocator.free(uu);

        var i: usize = 0;
        while (i < 36) : (i += 1) {
            uu.id[i] = '0';
        }

        uu.id[8] = '-';
        uu.id[13] = '-';
        uu.id[14] = '4';
        uu.id[18] = '-';
        uu.id[23] = '-';

        i = 0;
        while (i < 36) : (i += 1) {
            if (i != 8 and i != 13 and i != 14 and i != 18 and i != 23) {
                var res: u8 = r.random.uintLessThanBiased(u8, 16);
                uu.id[i] = chars[res];
            }
        }

        return uu;
    }
};

fn rb_uuid() callconv(.C) c_ulong {
    var i = UUID.new(std.crypto.random.int(u8)) catch unreachable;
    var rb_mHello = ruby.rb_str_new2(@as([*]const u8, i.to_string()));
    return rb_mHello;
}

export fn Init_hello() void {
    var Hello = ruby.rb_define_class("Hello", ruby.rb_cObject);
    var ptr_uuid = @ptrCast(fn (...) callconv(.C) c_ulong, rb_uuid);
    ruby.rb_define_method(Hello, "uuid", ptr_uuid, 0);
}
