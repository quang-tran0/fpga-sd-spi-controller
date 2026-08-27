module spi_master #(
    parameter CLK_DIV = 4
) (
    input logic         clk,
    input logic         rst_n,

    input logic         start,
    input logic [7:0]   tx_data,

    output logic [7:0]   rx_data,
    output logic         busy,
    output logic         done,

    output logic         sclk,
    output logic         mosi,
    input logic         miso
);
    localparam integer DIV_WIDTH = (CLK_DIV <= 1) ? 1 : $clog2(CLK_DIV);

    logic [7:0] tx_shift;
    logic [7:0] rx_shift;
    logic [3:0] sample_count;
    logic [DIV_WIDTH - 1:0] div_count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_count       <= 0;
            tx_shift        <= 8'h00;
            rx_shift        <= 8'h00;

            sample_count    <= 4'd0;

            rx_data         <= 8'h00;

            busy            <= 1'b0;
            done            <= 1'b0;

            sclk            <= 1'b0;
            mosi            <= 1'b0;

        end else begin
            done <= 1'b0;

            // IDLE
            if (!busy) begin
                sclk        <= 1'b0;
                div_count   <= '0;

                if (start) begin
                    busy <= 1'b1;

                    tx_shift <= tx_data;
                    rx_shift <= 8'h0;

                    sample_count <= 4'd0;

                    mosi <= tx_data[7];
                end

            // ACTIVE SPI TRANSACTION
            end else begin
                if (div_count == CLK_DIV - 1) begin
                    div_count <= '0;

                    if (sclk == 1'b0) begin
                        sclk <= 1'b1;

                        rx_shift <= {rx_shift[6:0], miso};
                        sample_count <= sample_count + 1'b1;
                    
                    end else begin
                        sclk <= 1'b0;

                        // send/receive done scenario
                        if (sample_count <= 4'd8) begin
                            busy <= 1'b0;
                            done <= 1'b1;

                            rx_data <= rx_shift;
                            mosi <= 1'b0;
                        // prepare for next TX
                        end else begin
                            tx_shift <= {tx_shift[6:0], 1'b0};

                            mosi <= tx_shift[6];
                        end
                    end
                end else begin
                    div_count <= div_count + 1'b1;
                end
            end
        end
    end
endmodule
