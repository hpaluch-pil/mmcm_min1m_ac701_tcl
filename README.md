# MMCM MINIMAL 1 MHz clock basic example

> WARNING! There are now 2 branches for different Vivado Versions:
> 1. Vivado 2023.2 in [branch v2023.2](../v2023.2) - using that version to avoid TPWS violation
> 2. Vivado 2015.1 in [branch v2015.1](../v2015.1) - last version supported by AC701 examples, but
>    produces critical TPWS warning
> Please see discussion on: https://adaptivesupport.amd.com/s/question/0D54U00008qlAmRSAU/mmcm-clkout4cascade-works-for-1-mhz-output-but-with-tpws-violation?language=en_US

Minimalistic example using MMCM clock base IP module for Artix-7 on AC701
board - where all extra stuff was removed from  generated module.

Function:
* Input clock 200 Mhz
* MMCM generates 1 MHz clock using CLKOUT4 Cascade mode

> WARNING! There is reported timing violation - but it seems to be incorrect (minimum frequency
> required for non-cascade mode:
> 
> ![Timing Summary Violation](assets/timing-summary.gif)

> WARNING! Test Bench TB `clk_wiz_0_tb.v` is broken! (It depends on internal
> counter stuff in `clk_wiz_0_exdes.v`, that I removed to minimize design for
> schematic).

Main reset code was generated using `Open IP Example Design...` and can be
found in [clk_wiz_0_exdes.v](clk_wiz_0_exdes.v).

Here is schematic image (from Synthesis) of minimized version:

![Clock Reset Synchronizer](assets/clk-wiz-inst1.gif)

Requirements:
* [Artix-7 FPGA Evaluation Kit](Artix-7 FPGA Evaluation Kit)
* Vivado 2015.1 (last version supported by official AC701 examples)

# Setup

* Run `Vivado 2015.1 Tcl Shell`
* `cd` to this project directory
* create new project `../mmcm_min1m_ac701_work/` by typing:
  ```tcl
  source aa-gen-project.tcl
  ```
* `exit` this TCL shell
* run `Vivado 2015.1` GUI
* open project in parent directory: `../mmcm_min1m_ac701_work/`
* click on Program and Debug -> `Generate Bistream` (it will invoke all required steps)

# Demo input/output

There are following Input keys:
* Button `CPU_RESET` - master clock RESET including MMCM clock base, while pressed MMCM clock output is inhibited
  and `locked` signal is inactive

Outputs:
* GPIO LEDS:
  - `LED_0` - `glbl_rest`  Global Reset from CPU RESET button, Active High
  - `LED_1` - `locked` High when MMCM clock output is valid - Asynchronous (!)
    module
  - `LED_2` - `safe_reset`
  - `LED_3` - example counter (`ex_count` from top.v) with 1s period using `safe_clock` and `safe_reset` signals.
* PMOD connector:
  - `PMOD_0` - `glbl_rst` - copy of CPU RESET button, Active High
  - `PMOD_1` - clock locked ("valid") signal from MMCM, active High
  - `PMOD_2` - `safe_clk` 1 MHz clock output from MMCM
  - `PMOD_2` - `safe_reset` - this signal should be used (with `safe_clk`) for safe synchronous RESET in your
    applications

What signal's to use:
- In your Verilog modules you should use 
  - `safe_reset` - synchronous safe reset signal
  - `safe_clk` - synchronous safe clock 1 MHz
see Example counter stuff in [ex_count.v](ex_count.v) for demo.

You can see live results (on Digilent Analog Discovery 2 scope/analyzer) when CPU RESET button was release (`glbl_reset`):

![MMCM Reset Analyzer](assets/mmcm-min1m-analyzer.gif)

Digilent WaveForms workspace file: [assets/ac701_mmcm_min1m.dwf3work](assets/ac701_mmcm_min1m.dwf3work)


[Artix-7 FPGA Evaluation Kit]: https://www.xilinx.com/products/boards-and-kits/ek-a7-ac701-g.html
