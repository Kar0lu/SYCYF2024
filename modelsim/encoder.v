module encoder #(
    parameter K = 40,
    parameter N = 64
)(
    input clk,
    input reset,
    input start,
    input [K-1:0] data_in,
    output reg [N-1:0] data_out,
    output reg done
);

    integer count;
    reg [23:0] reg_e;
    reg state;
    reg buffor;

    localparam IDLE = 1'b0;
    localparam SHIFT = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_e <= 0;
            data_out <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        reg_e <= 0;
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    for (count = K; count > 0; count = count - 1) begin

                        buffor = data_in[count-1] ^ reg_e[0];

                        reg_e[0] = reg_e[1];
                        reg_e[1] = reg_e[2];
                        reg_e[2] = reg_e[3];
                        reg_e[3] = reg_e[4];
                        reg_e[4] = reg_e[5] ^ buffor;
                        reg_e[5] = reg_e[6];
                        reg_e[6] = reg_e[7];
                        reg_e[7] = reg_e[8];
                        reg_e[8] = reg_e[9] ^ buffor;
                        reg_e[9] = reg_e[10];
                        reg_e[10] = reg_e[11];
                        reg_e[11] = reg_e[12];
                        reg_e[12] = reg_e[13];
                        reg_e[13] = reg_e[14];
                        reg_e[14] = reg_e[15] ^ buffor;
                        reg_e[15] = reg_e[16];
                        reg_e[16] = reg_e[17];
                        reg_e[17] = reg_e[18];
                        reg_e[18] = reg_e[19];
                        reg_e[19] = reg_e[20] ^ buffor;
                        reg_e[20] = reg_e[21];
                        reg_e[21] = reg_e[22];
                        reg_e[22] = reg_e[23];
                        reg_e[23] = buffor;
                        // $display("BEFORE [%0t] [%0d] | current_bit = %0b | reg_e = %24b | reg_e[0] = %1b", $time, count, data_in[count-1], reg_e, reg_e[0]);
                        
                    end
                        // $display("AFTER [%0t] [%0d] | current_bit = %0b | reg_e = %24b | reg_e[0] = %1b", $time, count+1, data_in[count-1], reg_e, reg_e[0]);
                        data_out <= {data_in, reg_e[0], reg_e[1], reg_e[2], reg_e[3], reg_e[4], reg_e[5], reg_e[6], reg_e[7], reg_e[8], reg_e[9], reg_e[10], reg_e[11], reg_e[12], reg_e[13], reg_e[14], reg_e[15], reg_e[16], reg_e[17], reg_e[18], reg_e[19], reg_e[20], reg_e[21], reg_e[22], reg_e[23]};
                        done <= 1;
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule
