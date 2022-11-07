import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def pwm(dut):
    dut._log.info("--- START TEST 1 ---------------------------------")
    clock = Clock(dut.i_clk, 10, units="us")
    cocotb.fork(clock.start())
    
    await ClockCycles(dut.i_clk, 10)
    dut.i_increase_duty.value = 0
    dut.i_decrease_duty.value = 0

    # initial duty: value 5 = 50% 
    dut._log.info("- Check increase 0")
    for i in range(5):
        await ClockCycles(dut.i_clk, 200)
        dut.i_increase_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_increase_duty.value = 0
    assert dut.o_pwm.value == 1

    dut._log.info("- Check increase 1")
    for i in range(2):
        await ClockCycles(dut.i_clk, 200)
        dut.i_increase_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_increase_duty.value = 0
    assert dut.o_pwm.value == 1
    
    dut._log.info("- Check decrease 0")
    for i in range(10): 
        await ClockCycles(dut.i_clk, 200)
        dut.i_decrease_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_decrease_duty.value = 0
    assert dut.o_pwm.value == 0

    dut._log.info("- Check decrease 1")
    for i in range(2): 
        await ClockCycles(dut.i_clk, 200)
        dut.i_decrease_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_decrease_duty.value = 0
    assert dut.o_pwm.value == 0

    dut._log.info("--- END TEST 1 ---------------------------------")

