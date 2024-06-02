module reg_p #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input data_in,
    output [8:0] data_out
);
    reg [8:0] reg_p;
    wire [8:0] reg_p_next;

    assign data_out = (shift) ? reg_p_next : reg_p;

    assign reg_p_next[0] = reg_p[1];
    assign reg_p_next[1] = reg_p[2];
    assign reg_p_next[2] = reg_p[3];
    assign reg_p_next[3] = reg_p[4];
    assign reg_p_next[4] = reg_p[5] ^ reg_p[0];
    assign reg_p_next[5] = reg_p[6];
    assign reg_p_next[6] = reg_p[7];
    assign reg_p_next[7] = reg_p[8];
    assign reg_p_next[8] = reg_p[0] ^ data_in;

    initial begin
        reg_p = 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_p <= 0;
        end else if (shift) begin
            reg_p <= reg_p_next;
        end
    end

endmodule