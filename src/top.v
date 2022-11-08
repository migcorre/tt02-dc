//##########################################################################################################
// PROJECT: PWM TOP
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module top (
    input  [7:0] io_in,
    output [7:0] io_out
);

  wire clk = io_in[0];  // clock input. 100khz 
  wire increase_duty_in = io_in[1];  // increase duty cycle by 10%
  wire decrease_duty_in = io_in[2];  // decrease duty cycle by 10%

  wire pwm_out;  // 10kHz PWM output signal 
  wire increase_duty_sync;
  wire decrease_duty_sync;

  // input sinchronizers
  synchronizer #(
      .NUM_STAGES(2)
  ) synchronizer_increase_duty (
      .clk(clk),
      .async_in(increase_duty_in),
      .sync_out(increase_duty_sync)
  );

  synchronizer #(
      .NUM_STAGES(2)
  ) synchronizer_decrease_duty (
      .clk(clk),
      .async_in(decrease_duty_in),
      .sync_out(decrease_duty_sync)
  );

  // debuncer
  // TODO

  // pwm 
  pwm #(
      .INITIAL_DUTY(5)
  ) pwm_dc (
      .clk(clk),  // clock input ~ 100khz 
      .increase_duty_in(increase_duty_sync),  // increase duty cycle by 10%
      .decrease_duty_in(decrease_duty_sync),  // decrease duty cycle by 10%
      .pwm_out(pwm_out)  // 10kHz PWM output signal 
  );

  assign io_out[0] = pwm_out;

endmodule

