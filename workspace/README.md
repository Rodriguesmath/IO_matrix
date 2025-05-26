# Project Documentation

## Overview
This project implements a digital design consisting of two main modules: `teclado_matriz` and `decodificador_bcd_to_seg7`. The `teclado_matriz` module handles keyboard input and generates corresponding outputs, while the `decodificador_bcd_to_seg7` module converts BCD inputs into signals for a 7-segment display.

## Project Structure
```
workspace
├── src
│   ├── teclado_matriz.v          # Module for keyboard matrix handling
│   └── decodificador_bcd_to_seg7.v # Module for BCD to 7-segment display conversion
├── testbench
│   ├── teclado_matriz_tb.v       # Testbench for teclado_matriz module
│   └── decodificador_bcd_to_seg7_tb.v # Testbench for decodificador_bcd_to_seg7 module
├── README.md                     # Project documentation
```

## Modules

### teclado_matriz
- **Inputs:**
  - `clk`: Clock signal
  - `rst`: Reset signal
  - `entrada_teclado`: 4-bit input from the keyboard
- **Outputs:**
  - `saida_conf_teclado`: 4-bit configuration output
  - `bcd_out`: BCD output
  - `key_valid`: Signal indicating if the key is valid

### decodificador_bcd_to_seg7
- **Inputs:**
  - `clk`: Clock signal
  - `rst`: Reset signal
  - `bcd_in`: 4-bit BCD input
  - `key_valid`: Signal indicating if the key is valid
- **Outputs:**
  - `bcd1`, `bcd2`, `bcd3`, `bcd4`, `bcd5`, `bcd6`: Signals for 7-segment displays

## Testbenches
- The testbench files simulate the behavior of the respective modules to verify their functionality and ensure correct operation.

## Running Simulations
To run the simulations, ensure you have a compatible simulation tool installed. Compile the source files and testbench files, then execute the testbenches to observe the output and verify the functionality of the modules.

## License
This project is licensed under the MIT License.