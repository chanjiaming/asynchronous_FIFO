`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2025 18:26:12
// Design Name: 
// Module Name: gray2bin
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


module gray2bin #(parameter N = 4)(
  input  wire [N-1:0] gray,
  output wire [N-1:0] bin
);

  assign bin[N-1] = gray[N-1];

  genvar i;
  generate
    for (i = N-2; i >= 0; i = i - 1) begin : gray2bin_loop
      assign bin[i] = bin[i+1] ^ gray[i];
    end
  endgenerate
endmodule
