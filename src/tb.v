

`timescale 1ns / 1ps
// fpga4student.com: FPGA Projects, Verilog projects, VHDL projects 
// Verilog project: Verilog testbench code for PWM Generator with variable duty cycle 
module tb;
 // Inputs
 reg clk;
 reg increase_duty;
 reg decrease_duty;
 // Outputs
 wire pwm_out;
 // Instantiate the PWM Generator with variable duty cycle in Verilog
 pwm DUT(
  .io_in(decrease_duty,increase_duty,clk,0,0,0,0,0),	 
  .io_out(0,0,0,0,0,0,pwm_out,0)
 );
 // Create 100Mhz clock
 initial begin
 clk = 0;
 forever #5 clk = ~clk;
 end 
 initial begin
  increase_duty = 0;
  decrease_duty = 0;
  #100; 
    increase_duty = 1; 
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100;
    decrease_duty = 1; 
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100; 
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100;
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
 end
endmodule


