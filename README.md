# SystemVerilog Class-Based Verification Environment

A complete, object-oriented verification environment for a 16x32-bit memory module, built using SystemVerilog classes and modern verification methodologies.

## 📋 Project Overview

This project demonstrates a professional verification testbench using SystemVerilog's Object-Oriented Programming (OOP) features to verify a simple memory design (16 locations × 32-bit width). The architecture follows industry-standard verification practices with reusable, modular components.

## 🎯 Features

- **Object-Oriented Design**: Leverages SystemVerilog classes for modularity and reusability
- **Layered Architecture**: Separates test stimulus generation from DUT interaction
- **Event-Based Synchronization**: Uses SystemVerilog events for component coordination
- **Constrained Random Testing**: Transaction-level randomization with user-defined constraints
- **Configurable Debug Mode**: Conditional compilation for detailed execution traces
- **Mailbox Communication**: Inter-component data transfer using SystemVerilog mailboxes
- **Virtual Interface Management**: Centralized VIF database using associative arrays

## 🏗️ Architecture

The verification environment follows a layered testbench architecture:

```
┌─────────────────────────────────────────────────────────┐
│                    Test (Top Module)                     │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                    Environment                           │
│  ┌──────────┐  ┌────────┐  ┌─────────┐  ┌────────────┐ │
│  │Sequencer │─→│ Driver │─→│   DUT   │─→│  Monitor   │ │
│  └──────────┘  └────────┘  └─────────┘  └──────┬─────┘ │
│                                                  │       │
│                    ┌─────────────────────────────┘       │
│                    │                                     │
│             ┌──────▼────────┐    ┌──────────────┐       │
│             │  Scoreboard   │    │  Subscriber  │       │
│             └───────────────┘    └──────────────┘       │
└─────────────────────────────────────────────────────────┘
```

## 📁 File Structure

```
Class_Based_Env/
│
├── pack.sv                          # Main package (includes all classes)
├── Top.sv                           # Top-level testbench module
├── interface.sv                     # Memory interface definition
├── mem.sv                           # 16x32 Memory DUT
│
├── class_base.svh                   # Virtual base class (shared resources)
├── class_based_transaction.svh      # Transaction data object
├── class_based_sequencer.svh        # Stimulus generator
├── class_based_driver.svh           # DUT driver component
├── class_based_monitor.svh          # DUT output monitor
├── class_based_scoreboard.svh       # Checker/verification component
├── class_based_subscriber.svh       # Coverage collector
├── class_based_env.svh              # Top-level environment
│
├── src_files.list                   # Compilation file list
├── run.do                           # ModelSim/QuestaSim script
└── README.md                        # This file
```

## 🔧 Components Description

### **1. Base Class (`class_base.svh`)**
- Virtual base class providing shared resources
- Static events for synchronization (`finished_driving`, `finished_monitoring`)
- Associative array for virtual interface database
- Protected members accessible to all derived classes

### **2. Transaction (`class_based_transaction.svh`)**
- Data packet for communication between components
- Randomizable fields with constraints
- Represents memory read/write operations
- Fields: `data_in`, `data_out`, `addr`, `EN`, `RW`, `rst`, `valid_out`

### **3. Sequencer (`class_based_sequencer.svh`)**
- Generates randomized transactions
- Controls test flow and stimulus generation
- Sends transactions to driver via mailbox
- Waits for scoreboard completion before generating next transaction

### **4. Driver (`class_based_driver.svh`)**
- Converts transactions to pin-level activity
- Drives signals to DUT through virtual interface
- Implements protocol-specific timing
- Signals monitor when driving is complete

### **5. Monitor (`class_based_monitor.svh`)**
- Observes DUT outputs
- Captures pin-level activity into transactions
- Sends observed data to scoreboard and subscriber
- Event-driven sampling synchronized with driver

### **6. Scoreboard (`class_based_scoreboard.svh`)**
- Compares expected vs actual results
- Maintains error and correct count statistics
- Signals sequencer when checking is complete
- Implements golden model comparison logic

### **7. Subscriber (`class_based_subscriber.svh`)**
- Collects functional coverage data
- Monitors transaction flow
- Analyzes test completeness

### **8. Environment (`class_based_env.svh`)**
- Top-level container for all components
- Instantiates and connects all verification components
- Manages mailbox connections
- Populates virtual interface database

## 🚀 Getting Started

### Prerequisites
- ModelSim or QuestaSim simulator
- SystemVerilog support (IEEE 1800-2012 or later)

### Running the Simulation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Class_Based_Env
   ```

2. **Compile and run:**
   ```bash
   vsim -do run.do
   ```

   Or manually:
   ```bash
   vlib work
   vlog -f src_files.list +cover=sbfec -coveropt 3
   vsim -voptargs=+acc work.top
   run -all
   ```

3. **Enable/Disable Debug Messages:**
   - Edit `pack.sv` and comment/uncomment the `DEBUG` macro:
   ```systemverilog
   `define DEBUG    // Uncomment for verbose output
   ```

## 🎓 Key Concepts Demonstrated

### 1. **Object-Oriented Programming**
- Class inheritance and polymorphism
- Encapsulation with local/protected members
- Virtual base classes

### 2. **Verification Methodology**
- Layered testbench architecture
- Transaction-level modeling
- Constrained random testing
- Self-checking testbenches

### 3. **SystemVerilog Features**
- Mailboxes for inter-process communication
- Events for synchronization
- Virtual interfaces
- Associative arrays
- Parameterized classes
- Conditional compilation (`ifdef`)

### 4. **Design Patterns**
- Factory pattern (environment creation)
- Observer pattern (monitor → scoreboard/subscriber)
- Producer-consumer (sequencer → driver)

## 📊 DUT Specifications

**Memory Module (`mem16x32`)**
- **Size**: 16 locations × 32 bits
- **Address Width**: 4 bits
- **Data Width**: 32 bits
- **Operations**: Read, Write
- **Features**: 
  - Synchronous operation (positive edge clock)
  - Active-high enable
  - Active-high reset
  - Read-before-write on simultaneous access
  - Valid output indicator

## 🔍 Verification Strategy

1. **Stimulus Generation**: Constrained random transactions
2. **Protocol Driving**: Cycle-accurate DUT stimulation
3. **Response Monitoring**: Passive observation of DUT outputs
4. **Checking**: Golden model comparison in scoreboard
5. **Coverage**: Functional coverage collection
6. **Flow Control**: Event-based synchronization

## 📝 Future Enhancements

- [ ] Add UVM-like base classes (driver, monitor)
- [ ] Implement coverage groups
- [ ] Add assertions for protocol checking
- [ ] Create multiple test scenarios
- [ ] Add configuration object
- [ ] Implement factory pattern for component creation
- [ ] Add register model (RAL)
- [ ] Create automated regression suite

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

This project is for educational purposes.

## 👨‍💻 Author

Created as part of Digital Design & Verification Training - Session 10

## 📚 Learning Resources

- IEEE 1800-2017 SystemVerilog Standard
- "SystemVerilog for Verification" by Chris Spear
- "Writing Testbenches using SystemVerilog" by Janick Bergeron
- UVM User Guide

---

**Note**: This is a training project demonstrating class-based verification concepts. For production environments, consider using UVM (Universal Verification Methodology) for standardization and reusability.
