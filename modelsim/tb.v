`timescale 1ps/1ps
module tb;
    localparam N = 64;
    localparam K = 40;

    localparam IDLE = 3'b000;
    localparam ENCODE = 3'b001;
    localparam DECODE = 3'b010;

    reg clk, rst;
    reg [2:0] mode;
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
        mode = ENCODE;
        @(posedge data_out, negedge data_out);
        mode = IDLE;
        $display("[%4t] | DATA ENCODED | %64b", $time, data_out);
        #5;
        $display("[%4t] | START DECODING", $time);
        data_in = data_out ^ (64'b11111111 <<59);
        $display("[%4t] | data_in: %64b", $time, data_in);
        mode = DECODE;
        @(posedge data_out, negedge data_out);
        $display("[%4t] | DATA DECODED | %40b", $time, data_out);
        if(data_out == 40'b1101110101010100100001101010101010010001) begin
            $display("[%4t] | SUCCESS", $time);
        end else begin
            $display("[%4t] | FAIL", $time);
        end
        mode = IDLE;
        #5;
        rst = 1;
        // #5;
        // rst = 0;
        // #5;
        // $display("[%4t] | START ENCODING", $time);
        // data_in = 40'b1001110101010100101001101010101010011001;
        // $display("[%4t] | data_in: %40b", $time, data_in);
        // mode = ENCODE;
        // @(posedge data_out, negedge data_out);
        // mode = IDLE;
        // $display("[%4t] | DATA ENCODED | %64b", $time, data_out);
        // #5;
        // $display("[%4t] | START DECODING", $time);
        // data_in = data_out ^ (64'b11111111 << 20);
        // $display("[%4t] | data_in: %64b", $time, data_in);
        // mode = DECODE;
        // @(posedge data_out, negedge data_out);
        // $display("[%4t] | DATA DECODED | %40b", $time, data_out);
        // if(data_out == 40'b1001110101010100101001101010101010011001) begin
        //     $display("[%4t] | SUCCESS", $time);
        // end else begin
        //     $display("[%4t] | FAIL", $time);
        // end
        // mode = IDLE;
    end
endmodule