module decoder #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input reset,
    input start,
    input [N-1:0] data_in,
    output reg [K-1:0] data_out,
    output reg done
);

    reg [14:0] reg_c;
    reg [8:0] reg_p;
    integer rc = 0;
    integer rp = 0;
    reg buffor_c;
    reg buffor_p;
    integer count;
    integer shift_count;
    reg [1:0] state;
    integer i;

    localparam IDLE = 2'b00;
    localparam SHIFT_N = 2'b01;
    localparam SHIFT_C = 2'b10;
    localparam SHIFT_P = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_c <= 0;
            reg_p <= 0;
            data_out <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        $display("[%0t] | START", $time);
                        reg_c <= 0;
                        reg_p <= 0;
                        state <= SHIFT_N;
                    end
                end
                
                SHIFT_N: begin
                    // $display("SHIFT_N | [%0t] | reg_c: %15b | reg_p: %9b | data_in: %64b", $time, reg_c, reg_p, data_in);
                    for (count = N; count > 0; count = count - 1) begin

                        buffor_p = reg_p[0];

                        reg_p[0] = reg_p[1];
                        reg_p[1] = reg_p[2];
                        reg_p[2] = reg_p[3];
                        reg_p[3] = reg_p[4];
                        reg_p[4] = reg_p[5] ^ buffor_p;
                        reg_p[5] = reg_p[6];
                        reg_p[6] = reg_p[7];
                        reg_p[7] = reg_p[8];
                        reg_p[8] = buffor_p ^ data_in[count-1];

                        buffor_c = data_in[count-1] ^ reg_c[0];

                        reg_c[0] = reg_c[1];
                        reg_c[1] = reg_c[2];
                        reg_c[2] = reg_c[3];
                        reg_c[3] = reg_c[4];
                        reg_c[4] = reg_c[5];
                        reg_c[5] = reg_c[6];
                        reg_c[6] = reg_c[7];
                        reg_c[7] = reg_c[8];
                        reg_c[8] = reg_c[9];
                        reg_c[9] = reg_c[10];
                        reg_c[10] = reg_c[11];
                        reg_c[11] = reg_c[12];
                        reg_c[12] = reg_c[13];
                        reg_c[13] = reg_c[14];
                        reg_c[14] = buffor_c;

                        // $display("SHIFT_N | [%0t] | [%2d] | [%1b] | reg_c: %15b | reg_p: %9b", $time, count, data_in[count-1], reg_c, reg_p);
                    end
                        state <= SHIFT_C;
                end

                SHIFT_C: begin
                    if (reg_c[6:0] != 7'b0000000) begin
                        reg_c <= {reg_c[0], reg_c[14:1]};
                        rc = rc + 1;
                        $display("SHIFT_C | [%0t] | reg_c: %15b | reg_p: %9b | rc: %2d | rp: %2d", $time, reg_c, reg_p, rc, rp);
                    end else begin
                        state <= SHIFT_P;
                    end
                end

                SHIFT_P: begin
                    if (reg_p != {1'b0, reg_c[14:7]}) begin
                        buffor_p = reg_p[0];

                        reg_p[0] = reg_p[1];
                        reg_p[1] = reg_p[2];
                        reg_p[2] = reg_p[3];
                        reg_p[3] = reg_p[4];
                        reg_p[4] = reg_p[5] ^ buffor_p;
                        reg_p[5] = reg_p[6];
                        reg_p[6] = reg_p[7];
                        reg_p[7] = reg_p[8];
                        reg_p[8] = buffor_p;
                        rp = rp + 1;
                        $display("SHIFT_P | [%0t] | reg_c: %15b | reg_p: %9b | rc: %2d | rp: %2d", $time, reg_c, reg_p, rc, rp);
                    end else begin
                        i = (-510*rp + 511*rc -7099) % 7665;
                        if(i < 0) i = i + 7665;
                        $display("LOCATION: %2d", i);
                        $display("data_in: %64b", data_in);
                        data_out = ({reg_p[0], reg_p[1], reg_p[2], reg_p[3], reg_p[4], reg_p[5], reg_p[6], reg_p[7]} << (32-i)) ^ data_in[63:24];
                        $display("data_out: %40b", data_out);
                        $display("IDK: %8b", {reg_p[0], reg_p[1], reg_p[2], reg_p[3], reg_p[4], reg_p[5], reg_p[6], reg_p[7]});
                        $display("IDK: %8b", {reg_p});
                        done <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
