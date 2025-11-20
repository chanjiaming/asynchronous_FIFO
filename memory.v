`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 09:34:02
// Design Name: 
// Module Name: memory
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


module memory(
    input i_wclk, i_wen, i_rclk, i_ren,
    input [3:0] g_w_ptr_next, g_r_ptr_next,
    input [3:0] data_in,
    input full_flag, empty_flag,
    output reg [3:0] data_out
);
    reg [3:0] fifo[7:0];
    wire [2:0] w_ptr;
    wire [2:0] r_ptr;
    
    gray2bin g2b_w(g_w_ptr_next, w_ptr);
    gray2bin g2b_r(g_r_ptr_next, r_ptr);
    always@(posedge i_wclk) begin
        if(i_wen & !full_flag) begin
            fifo[w_ptr] <= data_in;
        end
    end
    
    always@(posedge i_rclk) begin
        if(i_ren & !empty_flag) begin
            data_out <= fifo[r_ptr];
        end
    end
endmodule 
