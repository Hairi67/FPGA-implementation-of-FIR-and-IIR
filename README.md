# FPGA-implementation-of-FIR-and-IIR
This project demonstrates the design, simulation, and FPGA implementation of FIR and IIR digital filters for real-time signal processing. These filters are applied to denoise biomedical (ECG), audio, and sine wave signals. Both filters are designed using MATLAB/Python for coefficient generation and implemented in SystemVerilog.

---

## 📌 Table of Contents

- [📊 Overview](#-overview)
- [🎚️ FIR Filter Design](#-fir-filter-design)
- [🔄 IIR Filter Design](#-iir-filter-design)
- [🧠 Architecture](#-architecture)
- [🧪 Simulation and Results](#-simulation-and-results)
- [📄 License](#-license)

---

## 📊 Overview
FIR Filter
- Type: Low-pass filter
- Order: 30 taps
- Design Method: Hamming window using MATLAB
- Architecture: Transposed pipelined form for FPGA optimization
- Application: Clean low-frequency noise in ECG and audio signals
- Strength: Linear phase, stable, accurate response
- Limitation: High resource usage at high orders

IIR Filter
- Type: 4th-order Low-pass
- Design Method: Butterworth filter using Python
- Architecture: Direct Form II Transposed
- Application: Efficient denoising of low-frequency components
- Strength: Low resource usage, suitable for narrow-band applications
- Limitation: Potential stability challenges at high orders

---

## 🎚️ FIR Filter Design

- **Order**: 30
- **Cutoff Frequency**: 50 Hz
- **Sampling Rate**: 44.1 kHz
- **Design Tool**: MATLAB (`fir1` with Hamming window)
- **Architecture**: Transposed pipelined form (to reduce DSP usage)
- **Use Cases**:
  - ECG signal cleaning
  - Audio low-pass filtering
- **Advantages**:
  - Absolutely stable
  - Linear phase
- **Limitations**:
  - Higher hardware complexity at high orders

### MATLAB Snippet:
```matlab
fs = 44100;
fc = 50;
n = 30;
b = fir1(n, fc/(fs/2), 'low', hamming(n+1));
```

---

## 🔄 IIR Filter Design
- Type: Low-pass
- Order: 4
- Design Tool: Python with SciPy (butter)
- Architecture: Direct Form II Transposed
- Use Cases:
  - ECG and audio denoising
- Advantages:
  - Efficient for low-order designs
  - Requires fewer multipliers
- Limitations:
  - Can be unstable at high orders
  - Nonlinear phase

### Python Snippet:
```python
from scipy.signal import butter
b, a = butter(4, 2000/22050, btype='low')  # fs = 44100
```

---

## 🧠 Architecture
- FIR Filter:
  - Transposed structure with pipelining to reduce critical path
  - Coefficients pre-scaled to 24-bit signed hex
- IIR Filter:
  - Uses shift registers, multipliers, and accumulators
  - Fixed-point coefficients for FPGA implementation

---

## 🧪 Simulation and Results
- Simulated using ModelSim
- Verified using:
  - Test input files: sine.hex, ecg.hex, audio.hex
  - MATLAB/Python FFTs before/after filtering
- Plots and waveform screenshots are located in /images/

---

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.
