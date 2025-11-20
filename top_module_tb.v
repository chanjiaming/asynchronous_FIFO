`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 22:23:46
// Design Name: 
// Module Name: top_module_tb
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

module top_module_tb;

    // DUT signals
    reg         i_wclk = 0;
    reg         i_rclk = 0;
    reg         i_rst_n = 0;
    reg         i_wen = 0;
    reg         i_ren = 0;
    reg  [3:0]  data_in = 0;
    
    wire [3:0]  data_out;
    wire        full_flag;
    wire        empty_flag;

    // Simple counter for test data
    reg [3:0] test_data = 4'h0;

    // Instantiate your FIFO
    top_module dut (
        .i_wclk     (i_wclk),
        .i_rclk     (i_rclk),
        .i_rst_n    (i_rst_n),
        .i_wen      (i_wen),
        .data_in    (data_in),
        .full_flag  (full_flag),
        .i_ren      (i_ren),
        .data_out   (data_out),
        .empty_flag (empty_flag)
    );

    // Clock generation
    always #5   i_wclk = ~i_wclk;   // 100 MHz
    always #12  i_rclk = ~i_rclk;   // ~41 MHz (async!)

    // Main test sequence
    initial begin
        $display("========================================");
        $display("  Async FIFO Simple Testbench Start");
        $display("========================================");

        // Reset
        #50;
        i_rst_n = 0;
        #100;
        i_rst_n = 1;
        #50;

        // Phase 1: Write 12 data (will go full at 8)
        $display("\n--- Phase 1: Writing 12 values (expect full) ---");
        repeat(12) begin
            @(posedge i_wclk);
            if (!full_flag) begin
                i_wen     = 1;
                data_in   = test_data;
                $display("WRITE -> %h  (at %0t)", test_data, $time);
                test_data = test_data + 1;
            end else begin
                i_wen = 0;
                $display("FULL! Cannot write %h  (at %0t)", test_data, $time);
            end
            @(posedge i_wclk) i_wen = 0;
        end

        #200;

        // Phase 2: Read everything back
        $display("\n--- Phase 2: Reading all data (expect match) ---");
        test_data = 0;  // expected starts from 0 again
        repeat(15) begin
            @(posedge i_rclk);
            if (!empty_flag) begin
                i_ren = 1;
                @(posedge i_rclk);
                #1;
                i_ren = 0;

                if (data_out == test_data) begin
                    $display("READ OK -> %h (match!) at %0t", data_out, $time);
                end else begin
                    $display("ERROR! Got %h, expected %h at %0t", data_out, test_data, $time);
                end
                test_data = test_data + 1;
            end else begin
                $display("EMPTY! Nothing to read (at %0t)", $time);
            end
        end

        #200;
        $display("\n========================================");
        $display("  TEST FINISHED - Check waveform!");
        $display("  If all READ OK -> Your FIFO works perfectly!");
        $display("========================================");

        #500;
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("async_fifo_wave.vcd");
        $dumpvars(0, tb_async_fifo);
    end

endmodule
