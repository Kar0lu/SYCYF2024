module controler #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input [N-1:0] data_in,
    input mode,
    input [23:0] reg_e,
    input [14:0] reg_c,
    input [8:0] reg_p,
    output reg load_e,
    output reg load_c,
    output reg load_p,
    output reg shift_e,
    output reg shift_c,
    output reg shift_p,
    output reg [N-1:0] data_out
);
    reg [8:0] re;
    reg [10:0] rc;
    reg [10:0] rp;

    reg [2:0] state;

    assign state = mode;
    localparam IDLE = 3'b100;
    localparam ENCODE = 3'b000;
    localparam SHIFT_N = 3'b001;
    localparam SHIFT_C = 3'b010;
    localparam SHIFT_P = 3'b011;
    integer i;

    initial begin
        state = IDLE;
        data_out = 0;
        re = 0;
        rp = 0;
        rc = 0;
        shift_e = 0;
        shift_c = 0;
        shift_p = 0;
    end



    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state = IDLE;
            rp = 0;
            rc = 0;
            re = 0;
            shift_e = 0;
            shift_c = 0;
            shift_p = 0;
            load_e = 0;
            load_c = 0;
            load_p = 0;
        end else begin
            case (state)
                IDLE: begin
                    state = IDLE;
                    rp = 0;
                    rc = 0;
                    re = 0;
                    shift_e = 0;
                    shift_c = 0;
                    shift_p = 0;
                    load_e = 0;
                    load_c = 0;
                    load_p = 0;
                end

                ENCODE: begin
                    // $display("data_in: %40b", data_in);
                    shift_e = 1;
                    if(re < K) begin
                        load_e = data_in[K-1-re];
                        // $display("[%4t] | load_e: %0b | shift_e: %0b | re: %2d", $time, load_e, shift_e, re);
                        re = re + 1;

                    end else begin
                        shift_e = 0;
                        data_out = {data_in, reg_e[0], reg_e[1], reg_e[2], reg_e[3], reg_e[4], reg_e[5], reg_e[6], reg_e[7], reg_e[8], reg_e[9], reg_e[10], reg_e[11], reg_e[12], reg_e[13], reg_e[14], reg_e[15], reg_e[16], reg_e[17], reg_e[18], reg_e[19], reg_e[20], reg_e[21], reg_e[22], reg_e[23]};
                        // $display("[%4t] | load_e: %0b | shift_e: %0b | re: %2d | reg_e: %24b | data_in: %40b | data_out: %64b", $time, load_e, shift_e, re, reg_e, data_in, data_out);
                        state = IDLE;
                    end
                    
                end

                SHIFT_N: begin
                    // $display("data_in: %64b", data_in);

                    if(rc < N) begin
                        load_c = data_in[N-1-rc];
                        load_p = data_in[N-1-rp];
                        shift_c = 1;
                        shift_p = 1;
                        // $display("[%4t] | load_c: %0b | shift_c: %0b | rc: %2d | reg_c: %15b | load_p: %0b | shift_p: %0b | rp: %2d | reg_p: %9b", $time, load_c, shift_c, rc, reg_c, load_p, shift_p, rp, reg_p);
                        rc = rc + 1;
                        rp = rp + 1;

                    end else begin
                        load_p = 0;
                        shift_p = 0;
                        $display("[%4t] | SHIFT_N FINISHED | reg_c: %15b | reg_p: %9b", $time, reg_c, reg_p);
                        state = SHIFT_C;
                    end
                end

                SHIFT_C: begin
                    if(reg_c[6:0] != 7'b0000000) begin
                        load_c = 0;
                        shift_c = 1;
                        rc = rc + 1;
                    end else begin
                        shift_c = 0;
                        rc = rc + 1;
                        $display("[%4t] | SHIFT_C FINISHED  | reg_c: %15b | reg_p: %9b | rc: %3d", $time, reg_c, reg_p, rc);
                        state = SHIFT_P;
                    end
                end

                SHIFT_P: begin
                    if(reg_p != {0, reg_c[14:7]}) begin
                        load_p = 0;
                        shift_p = 1;
                        // $display("[%4t] | SHIFT_P | reg_c: %15b | reg_p: %9b | rp: %3d", $time, reg_c, reg_p, rp);
                        rp = rp + 1;
                    end else begin
                        shift_p = 0;
                        $display("[%4t] | SHIFT_P FINISHED  | reg_c: %15b | reg_p: %9b | rc: %3d | rp: %3d", $time, reg_c, reg_p, rc-64, rp-64);
                        i = (-510*(rp-64) + 511*(rc-64) - 6620) % 7665;
                        if(i < 0) i = i + 7665;
                        data_out = ({reg_p[0], reg_p[1], reg_p[2], reg_p[3], reg_p[4], reg_p[5], reg_p[6], reg_p[7]} << (32-i)) ^ data_in[63:24];
                        // $display("[%4t] | DATA_OUT | reg_c: %15b | reg_p: %9b | i : %4d | data_out: %40b", $time, reg_c, reg_p, i, data_out);
                        state = IDLE;
                    end
                end
            endcase
        end
    end

    
endmodule