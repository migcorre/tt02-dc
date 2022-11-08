//##########################################################################################################
// PROJECT: DEBOUNCER
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module debouncer #(
    parameter N = 11  // (2^11) / 100 KHz = 20.48 ms debounce time
) (
    input clk,
    input reset,
    input signal_in,
    output signal_out
);
  reg debounced_signal0;
  reg debounced_signal1;
  reg [N-1 : 0] q_reg;
  reg [N-1 : 0] q_next;
  reg DFF1, DFF2;
  wire q_add;
  wire q_reset;

  assign q_reset = (DFF1 ^ DFF2);
  assign q_add   = ~(q_reg[N-1]);

  always @(q_reset, q_add, q_reg) begin
    case ({
      q_reset, q_add
    })
      2'b00:   q_next <= q_reg;
      2'b01:   q_next <= q_reg + 1;
      default: q_next <= {N{1'b0}};
    endcase
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      DFF1  <= 1'b0;
      DFF2  <= 1'b0;
      q_reg <= {N{1'b0}};
    end else begin
      DFF1  <= signal_in;
      DFF2  <= DFF1;
      q_reg <= q_next;
    end
  end

  // debounced singal
  always @(posedge clk) begin
    if (q_reg[N-1] == 1'b1) begin
      debounced_signal0 <= DFF2;
    end else begin
      debounced_signal0 <= debounced_signal0;
    end
    debounced_signal1 <= debounced_signal0;
  end

  // pulse gen
  assign signal_out = debounced_signal0 & ~debounced_signal1;

endmodule

