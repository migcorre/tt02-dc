//##########################################################################################################
// PROJECT: DUTY VARIATOR
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module pwm #(
    parameter INITIAL_DUTY = 5  // initial duty cycle in 50%
) (
    input clk,  // clock input. 100khz 
    input increase_duty_in,  // increase duty cycle by 10%
    input decrease_duty_in,  // decrease duty cycle by 10%
    output pwm_out  // 10kHz PWM output signal 
);

  reg [3:0] pwm_duty = INITIAL_DUTY;
  reg [3:0] counter_duty = 0;

  // if trigger signal was issue then increase/decrease duty cycle 
  always @(posedge clk) begin
    if (increase_duty_in && pwm_duty <= 9) pwm_duty <= pwm_duty + 1;  // increase duty cycle by 10%
    else if (decrease_duty_in && pwm_duty >= 1)
      pwm_duty <= pwm_duty - 1;  //decrease duty cycle by 10%
  end

  // counter 10 clock cycles to crate final pwm output 
  always @(posedge clk) begin
    counter_duty <= counter_duty + 1;
    if (counter_duty >= 9) begin
      counter_duty <= 0;
    end
  end

  assign pwm_out = counter_duty < pwm_duty ? 1 : 0;

endmodule

