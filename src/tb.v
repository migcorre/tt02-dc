
`default_nettype none `timescale 1us / 1ns

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input  clk,
    input  increase_duty_in,
    input  decrease_duty_in,
    output pwm_out
);

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // wire up the inputs and outputs
  wire [7:0] inputs = {5'b0, decrease_duty_in, increase_duty_in, clk};
  wire [7:0] outputs;
  assign pwm_out = outputs[0];

  // instantiate the DUT
  top dut2 (
      .io_in (inputs),
      .io_out(outputs)
  );


endmodule
