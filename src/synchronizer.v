//##########################################################################################################
// PROJECT: SYNCHRONIZER
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module synchronizer #(
    parameter NUM_STAGES = 2
) (
    input  clk,
    input  async_in,
    output sync_out
);
  reg [NUM_STAGES:1] sync_reg;

  always @(posedge clk) begin
    sync_reg <= {sync_reg[NUM_STAGES-1:1], async_in};
  end

  assign sync_out = sync_reg[NUM_STAGES];

endmodule
