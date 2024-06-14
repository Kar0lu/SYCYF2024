module modulo_divisor (
    input wire [31:0] dividend,
    input wire [31:0] divisor,
    input wire clk,
    input wire rst,
    input wire start,
    output reg [31:0] remainder,
    output reg done
);

    reg [31:0] current_dividend;
    reg [31:0] current_divisor;
    reg [1:0] state;

    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            remainder <= 0;
            done <= 0;
            current_dividend <= 0;
            current_divisor <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start && divisor != 0) begin
                        current_dividend <= dividend;
                        current_divisor <= divisor;
                        done <= 0;
                        state <= CALC;
                    end else if (start && divisor == 0) begin
                        remainder <= 0;
                        done <= 1;
                        state <= DONE;
                    end else begin
                        done <= 0;
                        state <= IDLE;
                    end
                end

                CALC: begin
                    // $display("[%4t] | CALC | current_dividend: %0b | current_divisor: %0b", $time, current_dividend, current_divisor);
                    if (current_dividend >= current_divisor) begin
                        current_dividend <= current_dividend - current_divisor;
                    end else begin
                        remainder <= current_dividend;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // $display("[%4t] | STOPPING MODULO DIVISION | result: %0b", $time, remainder);
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
