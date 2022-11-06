import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles



@cocotb.test()
async def pwm(dut):
    dut._log.info("start")
    clock = Clock(dut.i_clk, 10, units="us")
    cocotb.fork(clock.start())
    
    await ClockCycles(dut.i_clk, 10)
    dut.i_increase_duty.value = 0
    dut.i_decrease_duty.value = 0

    dut._log.info("check increase")
    for i in range(4):
        await ClockCycles(dut.i_clk, 200)
        dut.i_increase_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_increase_duty.value = 0

    dut._log.info("check decrease")
    for i in range(4): 
        await ClockCycles(dut.i_clk, 200)
        dut.i_decrease_duty.value = 1
        await ClockCycles(dut.i_clk, 30)
        dut.i_decrease_duty.value = 0

