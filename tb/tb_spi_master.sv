`timescale 1ns/1ns

module  tb_spi_master;
    localparam CLK_DIV = 4;

    logic clk;
    logic rst_n;

    logic       start;
    logic [7:0] tx_data;

    logic [7:0] rx_data;
    logic       busy;
    logic       done;

    logic       sclk;
    logic       mosi;
    logic       miso;
    logic [7:0] slave_rx;

    spi_master #(
        .CLK_DIV(CLK_DIV)
    ) spi_master (
        .clk    (clk),
        .rst_n  (rst_n),
        .start  (start),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .busy   (busy),
        .done   (done),
        .sclk   (sclk),
        .mosi   (mosi),
        .miso   (miso)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        start = 0;
        tx_data = '0;
        miso = 1;

        repeat(5) @(posedge clk);

        rst_n = 1;

        repeat(2) @(posedge clk);

        fork

            spi_slave_transfer(
                8'h3C,
                slave_rx
            );

            spi_master_transfer(
                8'hA5
            );

        join


        if (rx_data !== 8'h3C)
            $fatal(
                1,
                "MASTER RX ERROR: got %02h expected 3C",
                rx_data
            );


        if (slave_rx !== 8'hA5)
            $fatal(
                1,
                "SLAVE RX ERROR: got %02h expected A5",
                slave_rx
            );


        $display(
            "SPI TEST PASS: master_tx=A5 master_rx=%02h",
            rx_data
        );


        #100;

        $finish;
    end

    task automatic spi_master_transfer(
        input logic [7:0] data
    );
        begin
            @(posedge clk);

            tx_data <= data;
            start <= 1'b1;

            @(posedge clk);

            start <= 1'b0;
            wait(done);
        end
    endtask

    task automatic spi_slave_transfer(
        input logic [7:0] slave_tx,
        output logic [7:0] slave_rx
    );
    begin
        slave_rx = 8'h00;

        miso = slave_tx[7];
        for (int i = 7; i >= 0; i--) begin
            @(posedge sclk);

            slave_rx[i] = mosi;

            if (i > 0) begin
                @(negedge sclk);
                miso = slave_tx[i - 1];
            end
        end
    end
    endtask
endmodule
