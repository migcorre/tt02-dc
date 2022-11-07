
`default_nettype none
`timescale 1us/1ns

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input i_clk,
    input i_increase_duty,
    input i_decrease_duty,
    output o_pwm
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {5'b0, i_decrease_duty, i_increase_duty, i_clk};
    wire [7:0] outputs;
    assign o_pwm = outputs[0];
    

    // instantiate the DUT
    pwm #(2) pwm_dut (
        .io_in  (inputs),
        .io_out (outputs)
        );


endmodule
