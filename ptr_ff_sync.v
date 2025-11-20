`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2025 11:29:59
// Design Name: 
// Module Name: ptr_ff_sync
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


module ptr_ff_sync #(parameter WIDTH = 3)(
    input [WIDTH-1:0] ptr,
    input clk,
    input i_rst_n,
    output reg [WIDTH-1:0] ptr_sync
    );
    
    reg [WIDTH-1:0] q1;
    always @(posedge clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            q1 <= ptr;
            ptr_sync <= q1;
        end
        else begin
            q1 <= 4'b0;
            ptr_sync <= 4'b0;
        end         
    end 
endmodule
