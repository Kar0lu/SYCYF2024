module controler #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input [N-1:0] data_in,
    input [2:0]  mode,

    input [23:0] reg_e_out,
    input [14:0] reg_c_out,
    input [8:0]  reg_p_out,

    input [5:0] reg_e_count,
    input [6:0] reg_c_count,
    input [9:0] reg_p_count,

    output reg [K-1:0] reg_e_in,
    output reg [N-1:0] reg_c_in,
    output reg [N-1:0]  reg_p_in,

    output reg shift_e,
    output reg shift_c,
    output reg shift_p,
    output reg [N-1:0] data_out
);

    reg [2:0] state;
    reg [15:0] i;

    localparam IDLE = 3'b000;
    localparam ENCODE = 3'b001;
    localparam DECODE = 3'b010;
    localparam DECODE_SHIFT_C = 3'b011;
    localparam DECODE_SHIFT_P = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            reg_e_in <= 0;
            reg_c_in <= 0;
            reg_p_in <= 0;
            shift_e <= 0;
            shift_c <= 0;
            shift_p <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (mode == ENCODE) begin
                        state <= ENCODE;
                        reg_e_in <= data_in;
                        shift_e <= 1;
                    end else if (mode == DECODE) begin
                        state <= DECODE;
                        reg_c_in <= data_in;
                        shift_c <= 1;
                        reg_p_in <= data_in;
                        shift_p <= 1;
                    end
                end

                ENCODE: begin
                    if (reg_e_count == K-1) begin
                        reg_e_in <= 0;
                        shift_e <= 0;
                    end
                    if(shift_e == 0) begin
                        $display("[%4t] | ENCODE FINISHED | reg_e_out: %24b | shift_e: %0b | reg_e_count: %2d", $time, reg_e_out, shift_e, reg_e_count);
                        data_out <= {data_in, reg_e_out[0], reg_e_out[1], reg_e_out[2], reg_e_out[3], reg_e_out[4], reg_e_out[5], reg_e_out[6], reg_e_out[7], reg_e_out[8], reg_e_out[9], reg_e_out[10], reg_e_out[11], reg_e_out[12], reg_e_out[13], reg_e_out[14], reg_e_out[15], reg_e_out[16], reg_e_out[17], reg_e_out[18], reg_e_out[19], reg_e_out[20], reg_e_out[21], reg_e_out[22], reg_e_out[23]};
                        state <= IDLE;
                    end
                end

                DECODE: begin
                    if (reg_c_count == N-1) begin
                        reg_c_in <= 0;
                        reg_p_in <= 0;
                        shift_p <= 0;
                    end
                    if(shift_p == 0) begin
                        $display("[%4t] | DECODE_1 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d", $time, reg_c_out, shift_c, reg_c_count);
                        $display("[%4t] | DECODE_1 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d", $time, reg_p_out, shift_p, reg_p_count);
                        state <= DECODE_SHIFT_C;
                    end
                end

                DECODE_SHIFT_C: begin
                    if ((reg_c_out[7:0] & 8'b11111110) == 8'b00000000) begin
                        shift_c <= 0;
                        shift_p <= 1;
                    end
                    if(shift_c == 0) begin
                        $display("[%4t] | DECODE_2 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d", $time, reg_c_out, shift_c, reg_c_count);
                        $display("[%4t] | DECODE_2 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d", $time, reg_p_out, shift_p, reg_p_count);
                        state <= DECODE_SHIFT_P;
                    end
                end

                DECODE_SHIFT_P: begin
                    if (reg_p_out == {1'b0, reg_c_out[14:7]}) begin
                        $display("[%4t] | DECODE_3 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d", $time, reg_c_out, shift_c, reg_c_count);
                        $display("[%4t] | DECODE_3 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d", $time, reg_p_out, shift_p, reg_p_count);
                        i = (-510*(reg_p_count-64) + 511*(reg_c_count-64) - 6620) % 7665;
                        if(i < 0) i = i + 7665;
                        $display("[%4t] | rc = %3d | rp = %3d | i = %3d |", $time, reg_c_count, reg_p_count, i);
                        data_out = (({reg_p_out[0], reg_p_out[1], reg_p_out[2], reg_p_out[3], reg_p_out[4], reg_p_out[5], reg_p_out[6], reg_p_out[7]} << (56-i))^data_in)>>24;
                        $display("[%4t] | DECODE_3 FINISHED | data_out: %40b", $time, data_out);

                        shift_p <= 0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule