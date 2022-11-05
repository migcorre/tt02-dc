`default_nettype none

module pwm #(
  parameter BOUNCING_CLK_WAIT = 20
  ) (
  input [7:0] io_in,
  output [7:0] io_out
  );
  
  wire i_clk = io_in[5]; // clock input 
  wire i_increase_duty = io_in[6]; // input to increase 10% duty cycle
  wire i_decrease_duty = io_in[7]; // input to decrease 10% duty cycle
  wire o_pwm = io_out[1]; // 10MHz PWM output signal 

  reg[3:0] pwm_duty = 5; // initial duty cycle is 50%
  reg[3:0] counter_duty = 0;// counter for creating 10Mhz PWM signal

  synchronizer synchronizer_increase_duty(increase_duty_sync,i_increase_duty,i_clk)
  synchronizer synchronizer_decrease_duty(decrease_duty_sync,i_decrease_duty,i_clk)
  //latchinf latch_increase_duty(increase_duty_sync, increase_duty_latched)
  //latchinf latch_decrease_duty(decrease_duty_sync, decrease_duty_latched)

  reg[BOUNCING_CLK_WAIT-1:0] timer_enable = {(BOUNCING_CLK_WAIT){1'b1}};
  always @(posedge i_clk)
    if (timer_enable == 0)
      begin
        increase_duty_sync_last <= increase_duty_sync;
        increase_duty_signal_detected <= (increase_duty_sync) && (!increase_duty_sync_last);
	decrease_duty_sync_last <= decrease_duty_sync;
	decrease_duty_signal_detected <= (decrease_duty_sync) && (!decrease_duty_sync_last);
	timer_enable <= {(BOUNCING_CLK_WAIT){1'b1}};
      end
     else 
       timer_enable <= timer_enable - 1'b1;

  always @(posedge i_clk)
    begin
      if(increase_duty_signal_detected && pwm_duty <= 9)
        pwm_duty <= pwm_duty + 1;// increase duty cycle by 10%
      else if(decrease_duty_signal_detected && pwm_duty >=1) 
        pwm_duty <= pwm_duty - 1;//decrease duty cycle by 10%
    end 


  always @(posedge i_clk)
    begin
      counter_duty <= counter_duty + 1;
      if(counter_duty>=9)
        counter_duty <= 0;
    end

 assign o_pwm = counter_duty < pwm_duty ? 1:0;
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

module latchinf (data, q);
   input  data;
   output q;
   reg    q;
   always @ (data)
       q <= data;
endmodule
