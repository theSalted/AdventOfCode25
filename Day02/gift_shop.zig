const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile("input", .{ .mode = .read_only });
    defer file.close();

    const data = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(data);
    // std.debug.print("File contents:\n{s}\n", .{data});

    var ranges = std.mem.splitSequence(u8, data, ",");
    var total: u64 = 0;
    while (ranges.next()) |range| {
        // std.debug.print("range: {s}\n", .{range});
        const dash_index = std.mem.indexOfScalar(u8, range, '-').?;
        const lowStr = std.mem.trim(u8, range[0..dash_index], " \r\n\t");
        const highStr = std.mem.trim(u8, range[dash_index + 1 ..], " \r\n\t");
        const low = try std.fmt.parseInt(u64, lowStr, 10);
        const high = try std.fmt.parseInt(u64, highStr, 10);
        // std.debug.print("low: {d}, high: {d}\n", .{ low, high });

        var n = low;
        while (n <= high) : (n += 1) {
            var buf: [32]u8 = undefined;
            const s = try std.fmt.bufPrint(&buf, "{d}", .{n});
            const length = s.len;
            if (length % 2 == 1) {
                continue;
            }
            const base = std.math.pow(u64, 10, length / 2);
            const upper = n / base;
            const lower = n % base;

            // std.debug.print("{}, upper: {}, lower: {}, base: {}, length: {}\n", .{ n, upper, lower, base, length });
            if (upper == lower) {
                total += n;
            }
        }
    }

    std.debug.print("TOTAL: {}\n", .{total});
}
