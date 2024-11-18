`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 07:44:03 AM
// Design Name: 
// Module Name: top
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


module top(
    input sys_clk_p,
    input sys_clk_n,
    input glbl_rst,
    output [3:0]led,
    output [3:0]pmod
    );

    wire safe_clk; // use safe_clk (before ODDR) to internal safe clocking with synchronous safe_reset
    wire count;
    wire locked;
    wire safe_reset;
    wire ex_count_out;

    assign led =  { ex_count_out, safe_reset, locked, glbl_rst };
    assign pmod = { safe_reset, safe_clk, locked, glbl_rst };

    // Xilinx Artix-7 AC701 specific -> convert Diff clock to regular clock
    wire clk; // output clock 200 MHz
    IBUFDS ibufds (
        .I  (sys_clk_p),
        .IB (sys_clk_n),
        .O  (clk) );

    // MMCM clock base converts 200 MHz => 1 MHz, and provides safe_reset
    clk_wiz_0_exdes clk_wiz_inst1 (
        .clk_in1( clk ), .reset( glbl_rst ),
        .locked( locked ), .safe_reset( safe_reset ), .safe_clk( safe_clk ) );

    // example counter using 8 Mhz MMCM clock (clk_out) and synchronous reset (safe_reset):
    ex_count ex_count_inst1 (
        .safe_reset( safe_reset ), .safe_clk( safe_clk ),
        .ex_count_out( ex_count_out) );

endmodule // top