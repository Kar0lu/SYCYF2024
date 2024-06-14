module system #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input [2:0] mode,
    input [N-1:0] data_in,
    output [N-1:0] data_out
);
    wire shift_e;
    wire shift_c;
    wire shift_p;
    wire [23:0] reg_e_out;
    wire [14:0] reg_c_out;
    wire [8:0]  reg_p_out;
    wire [5:0] reg_e_count;
    wire [7:0] reg_c_count;
    wire [9:0] reg_p_count;
    wire [K-1:0] reg_e_in;
    wire [N-1:0] reg_c_in;
    wire [N-1:0] reg_p_in;

    wire [31:0] modulo_remainder;
    wire [31:0] dividend;
    wire [31:0] divisor;
    wire start_modulo;
    wire modulo_done;

    reg_e #(.N(N), .K(K)) u_reg_e (
        .clk(clk),
        .rst(rst),
        .shift(shift_e),
        .data_in(reg_e_in),
        .count(reg_e_count),
        .data_out(reg_e_out)
    );

    reg_c #(.N(N), .K(K)) u_reg_c (
        .clk(clk),
        .rst(rst),
        .shift(shift_c),
        .data_in(reg_c_in),
        .count(reg_c_count),
        .data_out(reg_c_out)
    );

    reg_p #(.N(N), .K(K)) u_reg_p (
        .clk(clk),
        .rst(rst),
        .shift(shift_p),
        .data_in(reg_p_in),
        .count(reg_p_count),
        .data_out(reg_p_out)
    );

    modulo_divisor u_modulo_divisor (
        .dividend(dividend),
        .divisor(divisor),
        .clk(clk),
        .rst(rst),
        .start(start_modulo),
        .remainder(modulo_remainder),
        .done(modulo_done)
    );

    controler #(.N(N), .K(K)) u_controler (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .mode(mode),
        .reg_e_in(reg_e_in),
        .reg_c_in(reg_c_in),
        .reg_p_in(reg_p_in),
        .reg_e_out(reg_e_out),
        .reg_c_out(reg_c_out),
        .reg_p_out(reg_p_out),
        .reg_e_count(reg_e_count),
        .reg_c_count(reg_c_count),
        .reg_p_count(reg_p_count),
        .shift_e(shift_e),
        .shift_c(shift_c),
        .shift_p(shift_p),
        .data_out(data_out),
        .dividend(dividend),
        .divisor(divisor),
        .modulo_remainder(modulo_remainder),
        .modulo_done(modulo_done),
        .start_modulo(start_modulo)
    );
    

endmodule
