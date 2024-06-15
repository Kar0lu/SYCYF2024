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
    input [7:0] reg_c_count,
    input [10:0] reg_p_count,

    output reg [K-1:0] reg_e_in,
    output reg [N-1:0] reg_c_in,
    output reg [N-1:0]  reg_p_in,

    output reg shift_e,
    output reg shift_c,
    output reg shift_p,
    output reg [N-1:0] data_out
);

    reg [2:0] state;
    reg [25:0] i;
    reg [14:0] reg_c_out_temp;
    reg [7:0] reg_c_count_temp;
    reg [8:0] reg_p_out_temp;
    reg [10:0] reg_p_count_temp;
    reg is_negative;

    // initial begin
    //     $monitor("[%4t] | reg_c_out: %b | reg_c_count: %d | reg_p_out: %b | reg_p_count: %d", $time, reg_c_out, reg_c_count, reg_p_out, reg_p_count);
    //     $monitor("[%4t] | reg_c_out_temp: %b | reg_c_count_temp: %d | reg_p_out_temp: %b | reg_p_count_temp: %d", $time, reg_c_out_temp, reg_c_count_temp, reg_p_out_temp, reg_p_count_temp);
    //     $monitor("[%4t] | i: %d", $time, i);
    // end

    localparam IDLE = 3'b000;
    localparam ENCODE = 3'b001;
    localparam DECODE = 3'b010;
    localparam DECODE_SHIFT_C = 3'b011;
    localparam DECODE_SHIFT_P = 3'b100;
    localparam DECODE_MODULO = 3'b101;

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
                        shift_c <= 0;
                        $display("[%4t] | DECODE_1 FINISHED", $time);
                        state <= DECODE_SHIFT_C;
                    end
                end

                DECODE_SHIFT_C: begin
                    if ((reg_c_out[6:0] & 7'b1111111) == 7'b0000000) begin
                        shift_c <= 0;
                        reg_c_out_temp <= reg_c_out; 
                        reg_c_count_temp <= reg_c_count; 
                        $display("[%4t] | DECODE_2 FINISHED", $time);
                        state <= DECODE_SHIFT_P;
                    end else begin
                        shift_c <= 1;
                    end
                end

                DECODE_SHIFT_P: begin
                    if (reg_p_out == {1'b0, reg_c_out_temp[14:7]}) begin
                        $display("[%4t] | DECODE_3 FINISHED", $time);
                        reg_p_out_temp <= reg_p_out; 
                        reg_p_count_temp <= reg_p_count; 
                        shift_p <= 0;
                        if((-510*(reg_p_count) + 511*(reg_c_count_temp))<65536) begin
                            i <= (-510*(reg_p_count) + 511*(reg_c_count_temp));
                            $display("[%4t] | DIVIDENT POSITIVE", $time);
                            is_negative <= 0;
                        end else begin
                            i <= (510*(reg_p_count) - 511*(reg_c_count_temp));
                            $display("[%4t] | DIVIDENT NEGATIVE", $time);
                            is_negative <= 1;
                        end
                        state <= DECODE_MODULO;
                    end else begin
                        shift_p <= 1;
                    end
                end

                DECODE_MODULO: begin
                    if(i>=7665) begin
                        i <= i-7665;
                    end else begin
                        if(is_negative) begin
                            i = 7665-i;
                        end
                        i = 7219 - i;
                        if (i>63 || i<17) begin
                            data_out = (data_in>>24)&40'b1111111111111111111111111111111111111111;
                        end else begin
                            data_out = ((({reg_p_out_temp[0], reg_p_out_temp[1], reg_p_out_temp[2], reg_p_out_temp[3], reg_p_out_temp[4], reg_p_out_temp[5], reg_p_out_temp[6], reg_p_out_temp[7]} << i)^data_in)>>24)&40'b1111111111111111111111111111111111111111;
                        end
                        
                        $display("[%4t] | rc = %d | rp = %d | i = %d | pattern: %b", $time, reg_c_count_temp, reg_p_count_temp, i, {reg_p_out_temp[0], reg_p_out_temp[1], reg_p_out_temp[2], reg_p_out_temp[3], reg_p_out_temp[4], reg_p_out_temp[5], reg_p_out_temp[6], reg_p_out_temp[7]});
                        $display("[%4t] | DECODE_4 FINISHED | data_out: %40b", $time, data_out);

                        shift_p <= 0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule