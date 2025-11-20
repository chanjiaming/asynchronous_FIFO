`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2025 16:19:48
// Design Name: 
// Module Name: w_ptr_handler
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



module w_ptr_handler(
    input [3:0] g_r_ptr_sync,
    input i_wclk,
    input i_rst_n,
    input i_wen,
    output reg full_flag,
    output reg [3:0] g_w_ptr_next,
    output full_flag_signal
    );
    
    wire full_flag_wire;
    wire [3:0] g_w_ptr_next_wire;
    wire [3:0] w_ptr_next_wire;
    reg [3:0] w_ptr;    

    assign w_ptr_next_wire = w_ptr + 1;
    assign g_w_ptr_next_wire = w_ptr_next_wire ^ (w_ptr_next_wire >> 1); 
    assign full_flag_wire = ((g_w_ptr_next_wire[2:0] == g_r_ptr_sync[2:0]) & (~g_w_ptr_next_wire[3] == g_r_ptr_sync[3])) | ((g_w_ptr_next[2:0] == g_r_ptr_sync[2:0]) & (~g_w_ptr_next[3] == g_r_ptr_sync[3]));
    assign full_flag_signal = full_flag_wire;
    
    always @(posedge i_wclk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            w_ptr <= 4'b0;
            full_flag <= 1'b1;
            g_w_ptr_next <= 4'b0;
        end

        else begin
            full_flag <= full_flag_wire;
            if (i_wen) begin
                w_ptr <= (~full_flag_wire)? w_ptr_next_wire: w_ptr;
                g_w_ptr_next <= (~full_flag_wire)? g_w_ptr_next_wire: g_w_ptr_next;
            end
            else begin
                g_w_ptr_next <= 4'b0;            
            end
        end    
    end
endmodule