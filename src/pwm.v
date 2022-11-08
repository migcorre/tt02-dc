//##########################################################################################################
// PROJECT: DUTY VARIATOR
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module pwm #(
    parameter INITIAL_DUTY = 5  // initial duty cycle in 50%
) (
    input clk,  // clock input. 100khz 
    input reset,  // reset active high 
    input increase_duty_in,  // increase duty cycle by 10%
    input decrease_duty_in,  // decrease duty cycle by 10%
    output pwm_out  // 10kHz PWM output signal 
);
  parameter DUTY_COUNT_MAX = 9;
  parameter DUTY_STEPTS = 1;

  reg [3:0] pwm_duty;
  reg [3:0] counter_duty;

  // if trigger signal was issue then decrease duty cycle 
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      pwm_duty <= INITIAL_DUTY;
    end else begin
      if (increase_duty_in && pwm_duty <= DUTY_COUNT_MAX) begin
        pwm_duty <= pwm_duty + DUTY_STEPTS;  // increase duty cycle by 10%
      end else if (decrease_duty_in && pwm_duty >= 1) begin
        pwm_duty <= pwm_duty - DUTY_STEPTS;  // decrease duty cycle by 10%
      end
    end
  end

  // counter 10 clock cycles to crate final pwm output 
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      counter_duty <= 4'b0000;
    end else begin
      counter_duty <= counter_duty + DUTY_STEPTS;
      if (counter_duty >= DUTY_COUNT_MAX) begin
        counter_duty <= 0;
      end
    end
  end

  assign pwm_out = counter_duty < pwm_duty ? 1 : 0;

endmodule

