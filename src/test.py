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
        await ClockCycles(dut.clk, 25000) # 10us*25000 = 250m
        dut.increase_duty_in.value = 0
    assert dut.pwm_out.value == 1

    dut._log.info("- Check increase 1")
    for i in range(2):
        await ClockCycles(dut.clk, 200)
        dut.increase_duty_in.value = 1
        await ClockCycles(dut.clk, 25000) # 10us*25000 = 250m
        dut.increase_duty_in.value = 0
    assert dut.pwm_out.value == 1
    
    dut._log.info("- Check decrease 0")
    for i in range(10): 
        await ClockCycles(dut.clk, 200)
        dut.decrease_duty_in.value = 1
        await ClockCycles(dut.clk, 25000) # 10us*25000 = 250m
        dut.decrease_duty_in.value = 0
    assert dut.pwm_out.value == 0

    dut._log.info("- Check decrease 1")
    for i in range(2): 
        await ClockCycles(dut.clk, 200)
        dut.decrease_duty_in.value = 1
        await ClockCycles(dut.clk, 25000) # 10us*25000 = 250m
        dut.decrease_duty_in.value = 0
    assert dut.pwm_out.value == 0

    dut._log.info("--- END TEST 1 ---------------------------------")

# @cocotb.test()
# async def pwm_debouncer_test(dut):
#     dut._log.info("--- START TEST 2 ---------------------------------")
#     clock = Clock(dut.clk, 10, units="us")
#     cocotb.fork(clock.start())
    
#     await ClockCycles(dut.clk, 10)
#     dut.increase_duty_in.value = 0
#     dut.decrease_duty_in.value = 0

#     # initial duty: value 5 = 50% 
#     # tengo que filtrar spureos menores a 250ms
#     # genero pulsos inferiores a 250ms
#     # 250m/10u = 25000clk
#     dut._log.info("- Check increase 0")

#     for i in range(4):
#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 1000) # 10us*1000 = 10m
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 5000) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 250) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 7000) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 20000) # 10us*20000 = 200m
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 7000) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 5000) 
#         dut.increase_duty_in.value = 0

#     await ClockCycles(dut.clk, 100000) # 1sec

#     for i in range(2):
#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 1000) # 10us*1000 = 10m
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 5000) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 250) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 7000) 
#         dut.increase_duty_in.value = 0

#         await ClockCycles(dut.clk, 1000) # 10us*500 = 5m
#         dut.increase_duty_in.value = 1
#         await ClockCycles(dut.clk, 20000) # 10us*20000 = 200m
#         dut.increase_duty_in.value = 0


#     dut._log.info("--- END TEST 2 ---------------------------------")
