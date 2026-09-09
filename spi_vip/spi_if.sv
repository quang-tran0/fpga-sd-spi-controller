`timescale 1us/1ns

interface spi_if;
    // controller-side interface
    logic rst_n;
    logic start;
    logic tx_data;

    logic rx_data;
    logic busy;
    logic done;

    // SPI-side interface
    logic sclk;
    logic miso;
    logic mosi;
endinterface
