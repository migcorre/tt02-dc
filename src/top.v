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
  wire disable_debouncer_in = io_in[3];
  wire pwm_out;  // 10kHz PWM output signal 

  wire increase_duty_sync;
  wire decrease_duty_sync;
  wire disable_debouncer_sync;
  wire increase_duty_deb;
  wire decrease_duty_deb;
  wire increase_duty;
  wire decrease_duty;

  // Sinchronizers ------------------------/
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

  synchronizer #(
      .NUM_STAGES(2)
  ) synchronizer_sisable_debouncer (
      .clk(clk),
      .async_in(disable_debouncer_in),
      .sync_out(disable_debouncer_sync)
  );

  // Debuncers ------------------------/
  debouncer increase_debuncer (
      .clk(clk),
      .signal_in(increase_duty_sync),
      .signal_out(increase_duty_deb)
  );

  debouncer decrease_debuncer (
      .clk(clk),
      .signal_in(decrease_duty_sync),
      .signal_out(decrease_duty_deb)
  );

  assign increase_duty = disable_debouncer_sync == 1 ? increase_duty_sync : increase_duty_deb;
  assign decrease_duty = disable_debouncer_sync == 1 ? decrease_duty_sync : decrease_duty_deb;

  // PWM ------------------------/
  pwm #(
      .INITIAL_DUTY(5)
  ) pwm_dc (
      .clk(clk),  // clock input ~ 100khz 
      .increase_duty_in(increase_duty),  // increase duty cycle by 10%
      .decrease_duty_in(decrease_duty),  // decrease duty cycle by 10%
      .pwm_out(pwm_out)  // 10kHz PWM output signal 
  );

  assign io_out[0] = pwm_out;
  assign io_out[1] = ~pwm_out;

endmodule

