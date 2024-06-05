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

    input [10:0] reg_e_count,
    input [10:0] reg_c_count,
    input [10:0] reg_p_count,

    output reg [K-1:0] reg_e_in,
    output reg [N-1:0] reg_c_in,
    output reg [N-1:0]  reg_p_in,

    output reg shift_e,
    output reg shift_c,
    output reg shift_p,
    output reg [N-1:0] data_out
);
    // reg [10:0] re;
    // reg [10:0] rc;
    // reg [10:0] rp;

    // reg [23:0] reg_e;
    // reg [14:0] reg_c;
    // reg [8:0] reg_p;

    reg [2:0] state;

    localparam IDLE = 3'b000;
    localparam ENCODE = 3'b001;
    localparam DECODE = 3'b010;
    localparam DECODE_SHIFT_C = 3'b011;
    localparam DECODE_SHIFT_P = 3'b100;
    integer i;

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
                            $display("[%4t] | ENCODE FINISHED | reg_e_out: %24b | shift_e: %0b | reg_e_count: %2d | reg_e_in: %40b", $time, reg_e_out, shift_e, reg_e_count, reg_e_in);
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
                            $display("[%4t] | DECODE_1 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d | reg_c_in: %64b", $time, reg_c_out, shift_c, reg_c_count, reg_c_in);
                            $display("[%4t] | DECODE_1 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d | reg_p_in: %64b", $time, reg_p_out, shift_p, reg_p_count, reg_p_in);
                            state <= DECODE_SHIFT_C;
                    end
                end

                DECODE_SHIFT_C: begin
                    if ((reg_c_out[7:0] & 8'b11111110) == 8'b00000000) begin
                        shift_c <= 0;
                        shift_p <= 1;
                    end
                    if(shift_c == 0) begin
                        $display("[%4t] | DECODE_2 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d | reg_c_in: %64b", $time, reg_c_out, shift_c, reg_c_count, reg_c_in);
                        $display("[%4t] | DECODE_2 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d | reg_p_in: %64b", $time, reg_p_out, shift_p, reg_p_count, reg_p_in);
                        state <= DECODE_SHIFT_P;
                    end
                end

                DECODE_SHIFT_P: begin
                    if (reg_p_out == {1'b0, reg_c_out[14:7]}) begin
                        $display("[%4t] | DECODE_3 FINISHED | reg_c_out: %15b | shift_c: %0b | reg_c_count: %2d | reg_c_in: %64b", $time, reg_c_out, shift_c, reg_c_count, reg_c_in);
                        $display("[%4t] | DECODE_3 FINISHED | reg_p_out: %9b | shift_p: %0b | reg_p_count: %2d | reg_p_in: %64b", $time, reg_p_out, shift_p, reg_p_count, reg_p_in);
                        i = (-510*(reg_p_count-64) + 511*(reg_c_count-64) - 6620) % 7665;
                        if(i < 0) i = i + 7665;
                        data_out = ({reg_p_out[0], reg_p_out[1], reg_p_out[2], reg_p_out[3], reg_p_out[4], reg_p_out[5], reg_p_out[6], reg_p_out[7]} << (32-i)) ^ data_in[63:24];
                        $display("[%4t] | DECODE_3 FINISHED | data_out: %40b", $time, data_out);

                        shift_p <= 0;
                        state <= IDLE;
                    end
                end

                // DECODE: begin
                //     if (rc < N) begin
                //         load_c <= 1;
                //         load_p <= 1;
                //         reg_c[rc % 15] <= data_in[rc];
                //         reg_p[rp % 9] <= data_in[rp];
                //         shift_c <= 1;
                //         shift_p <= 1;
                //         rc <= rc + 1;
                //         rp <= rp + 1;
                //     end else begin
                //         load_c <= 0;
                //         load_p <= 0;
                //         shift_c <= 0;
                //         shift_p <= 0;
                //         state <= DECODE_SHIFT_C;
                //     end
                // end

                // DECODE_SHIFT_C: begin
                //     if (reg_c_in[7:0] != 0) begin
                //         shift_c <= 1;
                //         rc <= rc + 1;
                //     end else begin
                //         shift_c <= 0;
                //         state <= DECODE_SHIFT_P;
                //     end
                // end

                // DECODE_SHIFT_P: begin
                //     if (reg_p_in[8:1] != reg_c_in[14:7]) begin
                //         shift_p <= 1;
                //         rp <= rp + 1;
                //     end else begin
                //         shift_p <= 0;
                //         data_out <= {rc, rp}; // Output the number of shifts
                //         state <= IDLE;
                //     end
                // end

                default: state <= IDLE;
            endcase
        end
    end

    // always @(posedge clk or posedge rst) begin
    //     if(rst) begin
    //         state <= IDLE;
    //         rp <= 0;
    //         rc <= 0;
    //         re <= 0;
    //         shift_e <= 0;
    //         shift_c <= 0;
    //         shift_p <= 0;
    //         load_e <= 0;
    //         load_c <= 0;
    //         load_p <= 0;
    //     end else if (mode == ENCODE & state == IDLE) begin
            
    //     end else if (mode == SHIFT_N & state == IDLE) begin
        
    //     end else begin
    //         case (state)
    //             IDLE: begin
    //                 state = IDLE;
    //                 rp = 0;
    //                 rc = 0;
    //                 re = 0;
    //                 shift_e = 0;
    //                 shift_c = 0;
    //                 shift_p = 0;
    //                 load_e = 0;
    //                 load_c = 0;
    //                 load_p = 0;
    //             end

    //             ENCODE: begin
    //                 // $display("data_in: %40b", data_in);
    //                 shift_e = 1;
    //                 if(re < K) begin
    //                     load_e = data_in[K-1-re];
    //                     // $display("[%4t] | load_e: %0b | shift_e: %0b | re: %2d", $time, load_e, shift_e, re);
    //                     re = re + 1;

    //                 end else begin
    //                     shift_e = 0;
    //                     data_out = {data_in, reg_e[0], reg_e[1], reg_e[2], reg_e[3], reg_e[4], reg_e[5], reg_e[6], reg_e[7], reg_e[8], reg_e[9], reg_e[10], reg_e[11], reg_e[12], reg_e[13], reg_e[14], reg_e[15], reg_e[16], reg_e[17], reg_e[18], reg_e[19], reg_e[20], reg_e[21], reg_e[22], reg_e[23]};
    //                     // $display("[%4t] | load_e: %0b | shift_e: %0b | re: %2d | reg_e: %24b | data_in: %40b | data_out: %64b", $time, load_e, shift_e, re, reg_e, data_in, data_out);
    //                     state = IDLE;
    //                 end
                    
    //             end

    //             SHIFT_N: begin
    //                 // $display("data_in: %64b", data_in);

    //                 if(rc < N) begin
    //                     load_c = data_in[N-1-rc];
    //                     load_p = data_in[N-1-rp];
    //                     shift_c = 1;
    //                     shift_p = 1;
    //                     // $display("[%4t] | load_c: %0b | shift_c: %0b | rc: %2d | reg_c: %15b | load_p: %0b | shift_p: %0b | rp: %2d | reg_p: %9b", $time, load_c, shift_c, rc, reg_c, load_p, shift_p, rp, reg_p);
    //                     rc = rc + 1;
    //                     rp = rp + 1;

    //                 end else begin
    //                     load_p = 0;
    //                     shift_p = 0;
    //                     $display("[%4t] | SHIFT_N FINISHED | reg_c: %15b | reg_p: %9b", $time, reg_c, reg_p);
    //                     state = SHIFT_C;
    //                 end
    //             end

    //             SHIFT_C: begin
    //                 if(reg_c[6:0] != 7'b0000000) begin
    //                     load_c = 0;
    //                     shift_c = 1;
    //                     rc = rc + 1;
    //                 end else begin
    //                     shift_c = 0;
    //                     rc = rc + 1;
    //                     $display("[%4t] | SHIFT_C FINISHED  | reg_c: %15b | reg_p: %9b | rc: %3d", $time, reg_c, reg_p, rc);
    //                     state = SHIFT_P;
    //                 end
    //             end

    //             SHIFT_P: begin
    //                 if(reg_p != {0, reg_c[14:7]}) begin
    //                     load_p = 0;
    //                     shift_p = 1;
    //                     // $display("[%4t] | SHIFT_P | reg_c: %15b | reg_p: %9b | rp: %3d", $time, reg_c, reg_p, rp);
    //                     rp = rp + 1;
    //                 end else begin
    //                     shift_p = 0;
    //                     $display("[%4t] | SHIFT_P FINISHED  | reg_c: %15b | reg_p: %9b | rc: %3d | rp: %3d", $time, reg_c, reg_p, rc-64, rp-64);
    //                     i = (-510*(rp-64) + 511*(rc-64) - 6620) % 7665;
    //                     if(i < 0) i = i + 7665;
    //                     data_out = ({reg_p[0], reg_p[1], reg_p[2], reg_p[3], reg_p[4], reg_p[5], reg_p[6], reg_p[7]} << (32-i)) ^ data_in[63:24];
    //                     // $display("[%4t] | DATA_OUT | reg_c: %15b | reg_p: %9b | i : %4d | data_out: %40b", $time, reg_c, reg_p, i, data_out);
    //                     state = IDLE;
    //                 end
    //             end
    //         endcase
    //     end
    // end

    
endmodule