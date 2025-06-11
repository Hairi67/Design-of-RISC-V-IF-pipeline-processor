# Design-of-RISC-V-IF-pipeline-processor
This project implements a scientific calculator on FPGA using a custom RISC-V processor with both integer (I) and floating-point (F) instruction set support. It was developed as a final-year capstone project at Ho Chi Minh City University of Technology (HCMUT), Faculty of Electrical and Electronic Engineering.

---

## 📌 Table of Contents

- [🔍 Project Summary](#-project-summary)
- [🧠 Project Description](#-project-description)
- [🧮 Supported Calculator Operations](#-supported-calculator-operations)
- [🏗️ System Architecture](#-system-architecture)
- [📁 Directory Structure](#-directory-struture)
- [🧪 Testing and Verification](#-testing-and-verification)
- [📚 Documentation](#-documentation)
- [✨ Future Improvements](#-future-improvements)
- [👤 Authors](#-authors)
- [📜 License](#-license)

---

## 🔍 Project Summary

- **Title:** Implement a Calculator on FPGA Using RISC-V IF Extension  
- **Students:** Nguyễn Phước Hải (2111137), Dương Minh Đức (2151009)  
- **Instructor:** TS. Trần Hoàng Linh  
- **Platform:** Altera DE2 Development Kit  
- **Language:** SystemVerilog (RTL), RISC-V Assembly  
- **Tools:** Quartus II, ModelSim/QuestaSim

---

## 🧠 Project Description

The goal of this project is to build a calculator on FPGA that can handle both integer and floating-point operations. We designed a custom 5-stage pipelined RISC-V processor supporting the RV32I and RV32F extensions, integrated with:

- ✅ A **2-bit branch predictor** to minimize control hazards  
- ✅ A **Floating Point Unit (FPU)** with:
  - **CLA Adder** for fast floating-point addition
  - **Vedic Multiplier** for efficient multiplication
  - **Newton-Raphson Divider** for accurate division  
- ✅ **Hazard detection** and **forwarding logic** for pipeline efficiency

The processor is programmed in RISC-V assembly to behave as a scientific calculator that takes input from a 4x4 keypad and displays results on a 16x2 LCD.

---

## 🧮 Supported Calculator Operations

- Basic Arithmetic: `+`, `-`, `×`, `/`
- Scientific Functions: `sin(x)`, `cos(x)`, `tan(x)`, `sqrt(x)`
- Floating-point input and output (IEEE 754, single precision)

---

## 🏗️ System Architecture

- **Pipeline Stages:** IF → ID → EX → MEM → WB
- **Modules:**
  - ALU
  - FPU (CLA + Vedic + Newton-Raphson)
  - Register File (I & F)
  - Control Unit
  - Immediate Generator
  - Hazard Unit & Forwarding Logic
  - Branch Predictor (2-bit saturating counters)
- **Peripherals:** Keypad interface, LCD controller
- To know more, see [`diagram/FinalCapstoneProjectReport.pdf`](./diagram/Pipelined_RISCV_IF.png).

---

## 📁 Directory Structure
RISC-V-IF-Calculator/
├── README.md ← This file
├── LICENSE ← Project license (MIT)
├── doc/ ← Project documentation
│ └── FinalCapstoneProjectReport.pdf
├── src/ ← RTL source files
│ ├── 00_src/ ← Verilog modules (ALU, FPU, etc.)
│ └── 01_tb/ ← Simulation testbenches
│ └── 02_test/ ← Assembly hex and value for ROM division
├── asm/ ← RISC-V assembly calculator programs
└── diagram/ ← Diagram for certain block design

---

## 🧪 Testing and Verification

- ✅ All modules tested using **ModelSim/QuestaSim**
- ✅ Integer and floating-point instructions verified through waveform analysis
- ✅ Calculator functionality tested directly on the DE2 FPGA board

---

## 📚 Documentation

Please refer to the full project report in [`doc/FinalCapstoneProjectReport.pdf`](./doc/FinalCapstoneProjectReport.pdf) for:

- Floating-point algorithm details
- Pipeline design and hazard handling
- FPGA implementation strategy
- Testbench results and hardware validation

---

## ✨ Future Improvements

- Add double-precision (D) extension
- Extend calculator UI for more complex math expressions
- Optimize resource utilization for larger FPGA deployment

---

## 👤 Authors

- **Nguyễn Phước Hải** (2111137)  
- **Dương Minh Đức** (2151009)

---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

