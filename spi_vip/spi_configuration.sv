class spi_configuration extends uvm_object;
    `uvm_object_utils(spi_configuration);

    virtual spi_if vif;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "spi_configuration");
        super.new(name);
    endfunction

    
endclass
