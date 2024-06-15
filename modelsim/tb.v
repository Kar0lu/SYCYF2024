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

    reg [K-1:0] original_data, decoded_data;
    reg [7:0] error_pattern;
    reg [6:0] shift_amount;
    reg [N-1:0] encoded_data, corrupted_data;
    integer infile, outfile;
    integer r;

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
        // Open the input and output files
        infile = $fopen("input_data.txt", "r");
        outfile = $fopen("output_data.txt", "w");

        if (infile == 0 || outfile == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end


        while (!$feof(infile)) begin
            data_in = 0;
            rst = 1;
            #5;
            rst = 0;
            // Read data from file
            r = $fscanf(infile, "%b %b %d\n", original_data, error_pattern, shift_amount);
            if (r != 3) begin
                $display("Error: File read error.");
                $finish;
            end

            // Start encoding
            $display("[%4t] | START ENCODING | original_data: %b | error_pattern: %b | shift_amount: %d", $time, original_data, error_pattern, shift_amount);
            $display("[%4t] | data_in: %40b", $time, original_data);
            data_in = original_data;
            mode = ENCODE;
            @(posedge data_out, negedge data_out);
            mode = IDLE;
            encoded_data = data_out;
            $display("[%4t] | DATA ENCODED | %64b", $time, encoded_data);
            #5;

            // Corrupt data
            $display("[%4t] | START DECODING", $time);
            corrupted_data = encoded_data ^ (error_pattern << shift_amount);
            $display("[%4t] | corrupted_data: %64b", $time, corrupted_data);
            data_in = corrupted_data;
            mode = DECODE;
            @(posedge data_out, negedge data_out);
            decoded_data = data_out;
            mode = IDLE;
            $display("[%4t] | DATA DECODED | %40b", $time, decoded_data);

            // Write data to file
            $fwrite(outfile, "%40b %8b %2d %s\n", original_data, error_pattern, shift_amount, (original_data == decoded_data) ? "SUCCESS" : "FAIL");
            #5;
        end

        // Close the files
        $fclose(infile);
        $fclose(outfile);
        
        $stop;
    end
endmodule