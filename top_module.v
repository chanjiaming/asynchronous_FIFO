`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 22:21:37
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_module (
    // Write domain
    input              i_wclk,
    input              i_wen,
    input              i_rst_n,       // active-low async reset
    input      [3:0]   data_in,
    output             full_flag,     // to user

    // Read domain
    input              i_rclk,
    input              i_ren,
    output     [3:0]   data_out,
    output             empty_flag     // to user
);

    // ------------------------------------------------------------------
    // Internal signals exactly matching your module ports
    // ------------------------------------------------------------------
    wire [3:0] g_w_ptr_next;
    wire [3:0] g_r_ptr_next;

    wire       full_flag_signal;
    wire       empty_flag_signal;

    // Synchronized pointers (2-stage synchronizers using your module)
    wire [3:0] g_w_ptr_sync;   // write pointer synchronized to read clock domain
    wire [3:0] g_r_ptr_sync;   // read pointer synchronized to write clock domain

    // ------------------------------------------------------------------
    // Write pointer handler (write domain)
    // ------------------------------------------------------------------
    w_ptr_handler u_w_ptr_handler (
        .g_r_ptr_sync     (g_r_ptr_sync),
        .i_wclk           (i_wclk),
        .i_rst_n          (i_rst_n),
        .i_wen            (i_wen),
        .full_flag        (full_flag),          // registered inside
        .g_w_ptr_next     (g_w_ptr_next),
        .full_flag_signal (full_flag_signal)
    );

    // ------------------------------------------------------------------
    // Read pointer handler (read domain)
    // ------------------------------------------------------------------
    r_ptr_handler u_r_ptr_handler (
        .g_w_ptr_sync     (g_w_ptr_sync),
        .i_rclk           (i_rclk),
        .i_rst_n          (i_rst_n),
        .i_ren            (i_ren),
        .empty_flag       (empty_flag),         // registered inside
        .g_r_ptr_next     (g_r_ptr_next),
        .empty_flag_signal(empty_flag_signal)
    );

    // ------------------------------------------------------------------
    // Synchronizer: write gray pointer → read domain
    // ------------------------------------------------------------------
    ptr_ff_sync #( .WIDTH(4) ) u_sync_w2r (
        .ptr       (g_w_ptr_next),
        .clk       (i_rclk),
        .i_rst_n   (i_rst_n),
        .ptr_sync  (g_w_ptr_sync)
    );

    // ------------------------------------------------------------------
    // Synchronizer: read gray pointer → write domain
    // ------------------------------------------------------------------
    ptr_ff_sync #( .WIDTH(4) ) u_sync_r2w (
        .ptr       (g_r_ptr_next),
        .clk       (i_wclk),
        .i_rst_n   (i_rst_n),
        .ptr_sync  (g_r_ptr_sync)
    );

    // ------------------------------------------------------------------
    // Dual-port memory (your original module, unchanged)
    // ------------------------------------------------------------------
    memory u_memory (
        .i_wclk      (i_wclk),
        .i_wen       (i_wen),
        .i_rclk      (i_rclk),
        .i_ren       (i_ren),
        .g_w_ptr_next(g_w_ptr_next),
        .g_r_ptr_next(g_r_ptr_next),
        .data_in     (data_in),
        .full_flag   (full_flag),      // used to block write
        .empty_flag  (empty_flag),     // used to block read
        .data_out    (data_out)
    );

    // Optional: expose the combinatorial flags if you ever need them
    assign full_flag_signal  = full_flag_signal;
    assign empty_flag_signal = empty_flag_signal;

endmodule