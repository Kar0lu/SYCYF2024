module tb;

    parameter K = 40;
    parameter N = 64;
    parameter L = 8'b11111111;
    parameter EL = 10;

    reg clk;
    reg reset;
    reg start_encoder;
    reg start_decoder;
    reg [K-1:0] data_in;
    wire [N-1:0] encoded_data;
    wire [N-1:0] corrupted_data;
    wire [K-1:0] decoded_data;
    
    // Encoder
    encoder #(.N(N), .K(K)) enc (
        .clk(clk),
        .reset(reset),
        .start(start_encoder),
        .data_in(data_in),
        .data_out(encoded_data),
        .done(encoder_done)
    );

    // Error
    assign corrupted_data = encoded_data ^ (64'b11011001 << 56);

    // Decoder
    decoder #(.N(N), .K(K)) dec (
        .clk(clk),
        .reset(reset),
        .start(start_decoder),
        .data_in(corrupted_data),
        .data_out(decoded_data),
        .done(decoder_done)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start_encoder = 0;
        start_decoder = 0;
        data_in = 40'b1001110101010100100001101010101010010001;

        // Reset the system
        #2 reset = 0;

        // Encode
        $display("[%0t] | Starting encoder", $time);
        #1 start_encoder = 1;
        #2 start_encoder = 0;

        // Wait
        $display("[%0t] | Waiting for encoder", $time);
        wait(encoder_done);
        $display("[%0t] | encoded_data = %0b", $time, encoded_data);

        // Decode
        $display("[%0t] | Starting decoder", $time);
        #1 start_decoder = 1;
        #2 start_decoder = 0;


        // Wait
        $display("[%0t] | Waiting for decoder", $time);
        wait(decoder_done);
        $display("[%0t] | decoded_data = %0b", $time, decoded_data);

        if(decoded_data == data_in) $display("SUCCESS");
        else $display("NOOOO");

        #2;
        $stop;
    end

    // Clock generation
    always #1 clk = ~clk;

endmodule
