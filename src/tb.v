
`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input clk,
    input increase_duty_sync,
    input decrease_duty_sync,
    output pwm_out,
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {decrease_duty_sync,increase_duty_sync,clk, 0, 0, 0, 0, 0};
    wire [7:0] outputs;
    assign pwm_out = outputs[2];
    

    // instantiate the DUT
    pwm pwm_dut(
        .io_in  (inputs),
        .io_out (outputs)
        );

endmodule
