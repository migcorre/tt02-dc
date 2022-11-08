//##########################################################################################################
// PROJECT: DEBOUNCER
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module debouncer  (
    input  clk,
    input  signal_in,
    output signal_out
);

  reg  signal_r1;
  wire slow_clk_en;

  clock_enable clk_ena (
      clk,
      slow_clk_en
  );

  always @(posedge clk) begin
    signal_r1 <= signal_in;
  end

  assign signal_out = slow_clk_en ? signal_r1 : 0;

endmodule
 
module clock_enable (
    input  clk_100k,
    output slow_clk_en  // 4 HZ
);
  reg [26:0] counter = 0;
  always @(posedge clk_100k) begin
    counter <= (counter >= 24999) ? 0 : counter + 1;
  end
  assign slow_clk_en = (counter == 24999) ? 1'b1 : 1'b0;
endmodule

