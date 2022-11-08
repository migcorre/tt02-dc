//##########################################################################################################
// PROJECT: DEBOUNCER
// AUTHOR: MARCELO POUSO, MIGUEL CORREIA
//##########################################################################################################

`default_nettype none

module debouncer #(
  parameter BOUNCING_CLK_WAIT = 12
  ) (
  input [7:0] io_in,
  output [7:0] io_out
  );
  
  wire i_clk = io_in[0]; // clock input. 100khz 
  wire i_increase_duty = io_in[1]; // increase duty cycle by 10%
  wire i_decrease_duty = io_in[2]; // decrease duty cycle by 10%
  wire o_pwm; // 10kHz PWM output signal 
  wire increase_duty_sync;
  wire decrease_duty_sync;
  wire duty_decrease,duty_increase; 

  reg[3:0] pwm_duty = 5; // initial duty cycle in 50%
  reg[3:0] counter_duty = 0;// counter for creating 10khz PWM output signal
  reg increase_duty_sync_last; 
  reg increase_duty_signal_detected;
  reg decrease_duty_sync_last;
  reg decrease_duty_signal_detected;

  //input sinchronizers
  synchronizer synchronizer_increase_duty(increase_duty_sync,i_increase_duty,i_clk);
  synchronizer synchronizer_decrease_duty(decrease_duty_sync,i_decrease_duty,i_clk);

  reg[BOUNCING_CLK_WAIT-1:0] timer_counter = {(BOUNCING_CLK_WAIT){1'b0}}; //bouncing time

  //detect change from 0 to 1 in the inputs signals
  always @(posedge i_clk)
    if (timer_counter == {(BOUNCING_CLK_WAIT){1'b1}})
      begin
        increase_duty_sync_last <= increase_duty_sync;
        increase_duty_signal_detected <= increase_duty_sync_last;
        decrease_duty_sync_last <= decrease_duty_sync;
        decrease_duty_signal_detected <= decrease_duty_sync_last;
        timer_counter <= {(BOUNCING_CLK_WAIT){1'b0}};
      end
     else 
       timer_counter <= timer_counter + 1'b1;

  //trigger signals increase/descrease 
  assign duty_decrease = (!decrease_duty_signal_detected) && (decrease_duty_sync_last) && (timer_counter=={(BOUNCING_CLK_WAIT){1'b1}});
  assign duty_increase = (!increase_duty_signal_detected) && (increase_duty_sync_last) && (timer_counter=={(BOUNCING_CLK_WAIT){1'b1}});


  //if trigger signal was issue then increase/decrease duty cycle 
  always @(posedge i_clk)
    begin
      if(duty_increase && pwm_duty <= 9)
        pwm_duty <= pwm_duty + 1; // increase duty cycle by 10%
      else if(duty_decrease && pwm_duty >=1) 
        pwm_duty <= pwm_duty - 1; //decrease duty cycle by 10%
    end 

  //counter 10 clock cycles to crate final pwm output 
  always @(posedge i_clk)
    begin
      counter_duty <= counter_duty + 1;
      if(counter_duty>=9)
        counter_duty <= 0;
    end

 assign o_pwm = counter_duty < pwm_duty ? 1:0; //final output signal
 assign io_out[0] = o_pwm;

endmodule



module synchronizer #(
  parameter NUM_STAGES = 2
) (
  output    sync_out,
  input     async_in,
  input     clk
);
 
  reg   [NUM_STAGES:1]    sync_reg;
 
  always @ (posedge clk) begin
    sync_reg <= {sync_reg[NUM_STAGES-1:1], async_in};
  end
 
  assign sync_out = sync_reg[NUM_STAGES];
 
endmodule
