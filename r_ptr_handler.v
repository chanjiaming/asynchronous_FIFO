`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2025 12:01:10
// Design Name: 
// Module Name: r_ptr_handler
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

module r_ptr_handler(
    input [3:0] g_w_ptr_sync,
    input i_rclk,
    input i_rst_n,
    input i_ren,
    output reg empty_flag,
    output reg [3:0] g_r_ptr_next,
    output empty_flag_signal
    );
    
    wire empty_flag_wire;
    wire [3:0] g_r_ptr_next_wire;
    wire [3:0] r_ptr_next_wire;
    reg [3:0] r_ptr;    
    

    assign r_ptr_next_wire = r_ptr + 1;
    assign g_r_ptr_next_wire = r_ptr_next_wire ^ (r_ptr_next_wire >> 1);
    assign empty_flag_wire = (g_r_ptr_next_wire == g_w_ptr_sync) | (g_r_ptr_next == g_w_ptr_sync);
    assign empty_flag_signal = empty_flag_wire;
    
    always @(posedge i_rclk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_ptr <= 4'b0;
            empty_flag <= 1'b1;
            g_r_ptr_next <= 4'b0;
        end

        else begin
            empty_flag <= empty_flag_wire;
            if (i_ren) begin
                r_ptr <= (~empty_flag_wire)? r_ptr_next_wire: r_ptr;
                g_r_ptr_next <= (~empty_flag_wire)? g_r_ptr_next_wire: g_r_ptr_next;
            end 
            else begin
                g_r_ptr_next <= 4'b0;            
            end
        end
    end
endmodule