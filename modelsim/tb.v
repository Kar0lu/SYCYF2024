`timescale 1ps/1ps
module tb;
    localparam N = 64;
    localparam K = 40;
    reg clk, rst, mode;
    reg [N-1:0] data_in;
    wire [N-1:0] data_out;

    system #(.N(N), .K(K)) UUT (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        data_in = 0;
        rst = 1;
        #5;
        rst = 0;
        $display("[%4t] | START ENCODING", $time);
        data_in = 40'b1101110101010100100001101010101010010001;
        $display("[%4t] | data_in: %40b", $time, data_in);
        mode = 0;
        $display("[%4t] | mode: %0b", $time, mode);
        wait(data_out);
        $display("[%4t] | DATA ENCODED | %64b", $time, data_out);
        #5;
        $display("[%4t] | START DECODING", $time);
        data_in = data_out ^ (64'b11111111 << 50);
        $display("[%4t] | data_in: %64b", $time, data_in);
        mode = 1;
        $display("[%4t] | mode: %0b", $time, mode);
        @(posedge data_out);
        $display("[%4t] | DATA DECODED | %40b", $time, data_out);
        if(data_out == 40'b1101110101010100100001101010101010010001) begin
            $display("SUCCESS");
        end else begin
            $display("FAIL");
        end
    end
endmodule