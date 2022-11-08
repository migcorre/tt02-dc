import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def pwm_directed_test(dut):
    dut._log.info("--- START TEST 1 ---------------------------------")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())
    
    await ClockCycles(dut.clk, 10)
    dut.increase_duty_in.value = 0
    dut.decrease_duty_in.value = 0

    # initial duty: value 5 = 50% 
    dut._log.info("- Check increase 0")
    for i in range(5):
        await ClockCycles(dut.clk, 200)
        dut.increase_duty_in.value = 1
        await ClockCycles(dut.clk, 30)
        dut.increase_duty_in.value = 0
    assert dut.pwm_out.value == 1

    dut._log.info("- Check increase 1")
    for i in range(2):
        await ClockCycles(dut.clk, 200)
        dut.increase_duty_in.value = 1
        await ClockCycles(dut.clk, 30)
        dut.increase_duty_in.value = 0
    assert dut.pwm_out.value == 1
    
    dut._log.info("- Check decrease 0")
    for i in range(10): 
        await ClockCycles(dut.clk, 200)
        dut.decrease_duty_in.value = 1
        await ClockCycles(dut.clk, 30)
        dut.decrease_duty_in.value = 0
    assert dut.pwm_out.value == 0

    dut._log.info("- Check decrease 1")
    for i in range(2): 
        await ClockCycles(dut.clk, 200)
        dut.decrease_duty_in.value = 1
        await ClockCycles(dut.clk, 30)
        dut.decrease_duty_in.value = 0
    assert dut.pwm_out.value == 0

    dut._log.info("--- END TEST 1 ---------------------------------")

