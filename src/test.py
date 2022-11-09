import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

async def delay_ms(dut, t):
    await ClockCycles(dut.clk, t*12)

async def increase_pulse(dut, t_off_ms, t_on_ms):
    await delay_ms(dut, t_off_ms)
    dut.increase_duty_in.value = 1
    await delay_ms(dut, t_on_ms)
    dut.increase_duty_in.value = 0

async def decrease_pulse(dut, t_off_ms, t_on_ms):
    await delay_ms(dut, t_off_ms)
    dut.decrease_duty_in.value = 1
    await delay_ms(dut, t_on_ms)
    dut.decrease_duty_in.value = 0

@cocotb.test()
async def pwm_debouncer_test(dut):
    dut._log.info("--- START TEST ---------------------------------")
    clock = Clock(dut.clk, 80, units="us")
    cocotb.start_soon(clock.start())
    
    await ClockCycles(dut.clk, 10)
    dut.increase_duty_in.value = 0
    dut.decrease_duty_in.value = 0
    
    dut._log.info("- Reset")
    dut.reset.value = 1
    await ClockCycles(dut.clk, 10)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 10)

    dut._log.info("- No pulse")
    await delay_ms(dut, 50)
    
    dut._log.info("- INCREASE SATURATION TEST ---------------------")
    for i in range(1):
        #----------------------------------------------------------#
        dut._log.info("- Noisy Increase Pulse")
        # Noise
        await increase_pulse(dut, 1, 2)
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 3)
        await increase_pulse(dut, 1, 1)
        # Stable
        await increase_pulse(dut, 1, 700)
        # Noise
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 3)
        await increase_pulse(dut, 1, 2)
        
        dut._log.info("- No pulse")
        await delay_ms(dut, 1000)

        #----------------------------------------------------------#
        dut._log.info("- Noisy Increase Pulse")
        # Noise
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 5)
        await increase_pulse(dut, 1, 1)
        # Stable
        await increase_pulse(dut, 1, 300)
        # Noise
        await increase_pulse(dut, 1, 5)
        await increase_pulse(dut, 1, 1)
        await increase_pulse(dut, 1, 3)
        await increase_pulse(dut, 1, 1)

        dut._log.info("- No pulse")
        await delay_ms(dut, 50)

        #----------------------------------------------------------#
        dut._log.info("- No noisy Increase Pulse")
        # Stable
        await increase_pulse(dut, 1, 2300)
    
    # Check increase saturation
    await delay_ms(dut, 1)
    assert dut.pwm_out.value == 1
    assert dut.pwm_neg_out.value == 0

    dut._log.info("- No pulse")
    await delay_ms(dut, 700)
    assert dut.pwm_out.value == 1
    assert dut.pwm_neg_out.value == 0

    dut._log.info("- DECREASE SATURATION TEST ---------------------")
    for i in range(11):
        #----------------------------------------------------------#
        dut._log.info("- Noisy Decrease Pulse %d" % i)
        # Noise
        await decrease_pulse(dut, 1, 2)
        await decrease_pulse(dut, 1, 1)
        await decrease_pulse(dut, 1, 3)
        await decrease_pulse(dut, 1, 1)
        # Stable
        await decrease_pulse(dut, 1, 500)
        # Noise
        await decrease_pulse(dut, 1, 1)
        await decrease_pulse(dut, 1, 1)
        await decrease_pulse(dut, 1, 3)
        await decrease_pulse(dut, 1, 2)
        
        dut._log.info("- No pulse")
        await delay_ms(dut, 700)

    # Check decrease saturation
    await delay_ms(dut, 1)
    assert dut.pwm_out.value == 0
    assert dut.pwm_neg_out.value == 1

    dut._log.info("- No pulse")
    await delay_ms(dut, 700)
    assert dut.pwm_out.value == 0
    assert dut.pwm_neg_out.value == 1

    dut._log.info("--- END TEST ---------------------------------")
