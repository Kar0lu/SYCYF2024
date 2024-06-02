module system #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input mode,
    input [N-1:0] data_in,
    output [N-1:0] data_out
);
    wire load_e;
    wire load_c;
    wire load_p;
    wire shift_e;
    wire shift_c;
    wire shift_p;
    wire [23:0] out_e;
    wire [14:0] out_c;
    wire [8:0] out_p;

    reg_e #(.N(N), .K(K)) reg_e (
        .clk(clk),
        .rst(rst),
        .shift(shift_e),
        .data_in(load_e),
        .data_out(out_e)
    );

    reg_c #(.N(N), .K(K)) reg_c (
        .clk(clk),
        .rst(rst),
        .shift(shift_c),
        .data_in(load_c),
        .data_out(out_c)
    );

    reg_p #(.N(N), .K(K)) reg_p (
        .clk(clk),
        .rst(rst),
        .shift(shift_p),
        .data_in(load_p),
        .data_out(out_p)
    );

    controler #(.N(N), .K(K)) controler (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .mode(mode),
        .reg_e(out_e),
        .reg_c(out_c),
        .reg_p(out_p),
        .load_e(load_e),
        .load_c(load_c),
        .load_p(load_p),
        .shift_e(shift_e),
        .shift_c(shift_c),
        .shift_p(shift_p),
        .data_out(data_out)
    );
    

endmodule
