// file: clk_wiz_0_tb.v - Test Bench for Clock Wizard, verifies that output clock is 1 MHz
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 

//----------------------------------------------------------------------------
// Clocking wizard demonstration testbench
//----------------------------------------------------------------------------
// This demonstration testbench instantiates the example design for the 
//   clocking wizard. Input clocks are toggled, which cause the clocking
//   network to lock and the counters to increment.
//----------------------------------------------------------------------------

`timescale 1ps/1ps

`define wait_lock @(posedge locked)

module clk_wiz_0_tb ();

  // timescale is 1ps/1ps
  localparam  ONE_NS      = 1000;
  localparam  PHASE_ERR_MARGIN   = 100; // 100ps
  // how many cycles to run
  localparam  COUNT_PHASE = 1024;
  // we'll be using the period in many locations
  localparam CLKIN_PER_NS = 5.0; // 5 ns = 200 MHz input clock
  localparam time PER1    = CLKIN_PER_NS*ONE_NS;
  localparam time PER1_1  = PER1/2;
  localparam time PER1_2  = PER1 - PER1/2;

  // Declare the input clock signals
  reg         clk_in1     = 1;

  // The high bit of the sampling counter
  wire        COUNT;
  // Status and control signals
  reg         reset      = 0;
  wire        locked;
  reg [13:0]  timeout_counter = 14'b00000000000000;
  wire safe_clk;


//Freq Check using the  M & D values setting and actual Frequency generated
  real period1;
// see c:\Xilinx\Vivado\2015.1\data\ip\xilinx\clk_wiz_v5_1\ttcl\variables.ttcl
//  or c:\Xilinx\Vivado\2023.2\data\ip\xilinx\clk_wiz_v6_0\ttcl\ 
// and tb_v.ttcl how these values are used:
  localparam TB_MMCM_CLKFBOUT_MULT_F = 24.0; // copy value of MMCM_CLKFBOUT_MULT_F from ..\mmcm_min1m_ac701_v2023-2\mmcm_min1m_ac701_v2023-2.srcs\sources_1\ip\clk_wiz_0\clk_wiz_0.xci
  localparam TB_MMCM_DIVCLK_DIVIDE = 5.0; 
  localparam TB_MMCM_CLKOUT6_DIVIDE_F = 60.0;
  // must include cascaded division of CLKOUT4 from CLKOUT6
  localparam TB_MMCM_CLKOUT4_DIVIDE = 16.0;
  localparam ref_period1_clkin1 = (CLKIN_PER_NS*TB_MMCM_DIVCLK_DIVIDE*TB_MMCM_CLKOUT6_DIVIDE_F*1000*TB_MMCM_CLKOUT4_DIVIDE/TB_MMCM_CLKFBOUT_MULT_F);
  time prev_rise1;

  // Input clock generation
  //------------------------------------
  always begin
    clk_in1 = #PER1_1 ~clk_in1;
    clk_in1 = #PER1_2 ~clk_in1;
  end

  // Test sequence
  reg [15*8-1:0] test_phase = "";
  initial begin
    // Set up any display statements using time to be readable
    $timeformat(-12, 2, "ps", 10);
    $display ("Timing checks are not valid");
    test_phase = "reset";
    reset = 1;
    #(PER1*200);
    reset = 0;
    test_phase = "wait lock";
    `wait_lock;
    #(PER1*41);
    $display ("Timing checks are valid");
    test_phase = "counting";
    #(PER1*COUNT_PHASE);
    if ((period1 -ref_period1_clkin1) <= 100 && (period1 -ref_period1_clkin1) >= -100) begin
    $display("Freq of safe_clk ( in MHz ) : %0f\n", 1000000/period1);
    end else 
    begin
    $display("ERROR: Freq of safe_clk (in MHz) : %0f is not correct, expected: %0f", 1000000/period1, 1000000/ref_period1_clkin1);
    $finish;
    end 
    $display("SIMULATION PASSED");
    $display("Test Completed Successfully");
    $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
    $finish;
  end


   always@(posedge clk_in1) begin
      timeout_counter <= timeout_counter + 1'b1;
      if (timeout_counter == 14'b11000000000000) begin
         if (locked != 1'b1) begin
            $display("ERROR : NO LOCK signal");
            $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
            $finish;
         end
      end
   end

  // Instantiation of the example design containing the clock
  //    network and sampling counters
  //---------------------------------------------------------
  clk_wiz_0_exdes 
    dut
   (// Clock in ports
    .clk_in1            (clk_in1),
    // Clock out
    .safe_clk            (safe_clk),
    // Status and control signals
    .reset              (reset),
    .locked             (locked));


// Freq Check 
initial
  prev_rise1 = 0;

always @(posedge safe_clk)
begin
  if (prev_rise1 != 0)
    period1 = $time - prev_rise1;
  prev_rise1 = $time;
end

endmodule
