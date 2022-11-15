![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# DUTY CONTROLLER

* This design is a simple duty controller which is intended to control the duty of a input signal through increase and decrease inputs signals.
* This Project was submited into the [Tiny Tapeout 2 Program.](https://github.com/TinyTapeout/tinytapeout-02?mc_cid=1725baa7ba&mc_eid=3667d64e8a)
* we use openLane to go from synthesis to GDS.

## Overview 

This design receives as input a square signal of 12kHz and spit a signal of 1.2kHz. The duty of the output signal is increased or descreased by step of 10% when their respective input signals are issued. \
This design has in consideration the bouncing of the input switches. We created an input that enable/disable this consideration for the increase/decrease bottoms. \
We created a test to allow to see the performace of the design in the corner case as when we continue trying to increase/decrease the signal in their limits, and the change of the signal when the input bottom signal are bouncing. \


## Resources

* [TinyTapout](https://tinytapeout.com/)
* [digikey - debouncing logic circuit](https://forum.digikey.com/t/debounce-logic-circuit-verilog/13196)

