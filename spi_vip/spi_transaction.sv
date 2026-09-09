import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_transaction extends uvm_sequence_item;
    rand bit [7:0] master_tx;
    rand bit [7:0] slave_tx;

    bit [7:0] serial_mosi;
    bit [7:0] serial_miso;
    
    bit [7:0] dut_rx;

    `uvm_object_utils_begin(spi_transaction)
        `uvm_field_int(master_tx, UVM_ALL_ON)
        `uvm_field_int(slave_tx, UVM_ALL_ON)
        `uvm_field_int(serial_mosi, UVM_ALL_ON)
        `uvm_field_int(serial_miso, UVM_ALL_ON)
        `uvm_field_int(dut_rx, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "spi_transaction");
        super.new(name);
    endfunction

    
endclass

