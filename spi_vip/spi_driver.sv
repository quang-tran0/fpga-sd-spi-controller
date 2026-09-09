class spi_driver extends uvm_driver #(spi_transaction);
    `uvm_component_utils(spi_driver);

    spi_configuration cfg;
    virtual spi_if vif;

    uvm_analysis_port #(spi_transaction) expected_ap;

    function new(string name = "spi_driver", uvm_component parent);
        super.new(name, parent);

        expected_ap = new("expected_ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db#(spi_transaction)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(get_type_name(), "spi_driver cannot get spi_configuration")
        end
        vif = cfg.vif;
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        spi_transaction expected;

        vif.start =     1'b0;
        vif.tx_data =   8'h00;
        vif.miso =      1'b0;

        forever begin
            seq_item_port.get_next_item(req);
            
            drive(req);

            expected = spi_transaction::type_id::create("expected");
            expected.copy(req);

            expected_ap.write(expected);

            seq_item_port.item_done();
        end
    endtask : run_phase

    virtual task drive(inout spi_transaction req) begin
        wait(vif.rst_n);
        wait(vif.busy === 1'b0);


    end
endclass
