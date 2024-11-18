// ex_count.v - example counter module, input 1 MHz clock, outputs 1s period
// signal
module ex_count(
	input safe_reset,
	input safe_clk,
	output ex_count_out
);

    // example counter using 1 Mhz MMCM cascade clock (clk_out) and synchronous reset (safe_reset): 
    localparam EX_COUNT_MAX = 1_000_000; // wants 1s period from 1 MHz clock
    // $clog2() not supported in localparam
    parameter  EX_COUNT_W = $clog2(EX_COUNT_MAX); // width in bits
    reg [EX_COUNT_W-1:0]ex_count = { EX_COUNT_W { 1'b0 } };    

    // make output symmetrical
    assign ex_count_out = (ex_count >= EX_COUNT_MAX/2);
    
    // without "posedge safe_reset" is RESET synchronous
    always @(posedge safe_clk) begin
        if (safe_reset)
            ex_count <= { EX_COUNT_W { 1'b0 } };
        else begin
            if (ex_count < EX_COUNT_MAX)
                ex_count <= ex_count + 1;
            else
                ex_count <= { EX_COUNT_W { 1'b0 } };
        end
    end

endmodule
