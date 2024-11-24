module rv32i_tb;
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;
    wire [31:0] reg_x5;
    wire [31:0] reg_x6;
    wire [31:0] reg_x7;
    wire [31:0] reg_x8;
    wire [31:0] reg_x9;
    wire [31:0] reg_x18;

    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite),
        .reg_x5(reg_x5),
        .reg_x6(reg_x6),
        .reg_x7(reg_x7),
        .reg_x8(reg_x8),
        .reg_x9(reg_x9),
        .reg_x18(reg_x18)
    );

    always #5 clk = ~clk;

    task display_key_registers;
        begin
            $display("\n--- Register State ---");
            $display("x5  (t0) = 0x%h", reg_x5);
            $display("x6  (t1) = 0x%h", reg_x6);
            $display("x7  (t2) = 0x%h", reg_x7);
            $display("x8  (s0) = 0x%h", reg_x8);
            $display("x9  (s1) = 0x%h", reg_x9);
            $display("x18 (s2) = 0x%h", reg_x18);
        end
    endtask

    task display_instruction;
        begin
            $display("\nCurrent Instruction:");
            $display("PC: %h", pc);
            $display("Instruction: %h", uut.dp.instr);
            $display("ALU Result: %h", aluResult);
            $display("Memory Write: %b", memWrite);
            display_key_registers();
        end
    endtask

    task display_control_signals;
        begin
            $display("\nControl Signals:");
            $display("memWrite=%b branch=%b", 
                    memWrite, uut.dp.branch);
            $display("ALU Control=%b", uut.dp.aluControl);
        end
    endtask

    initial begin
        // Inicializar
        clk = 0;
        reset = 1;
        
        #8
        reset = 0;
 
        // Monitor 
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h memWrite=%b",
                 $time, pc, uut.dp.instr, aluResult, memWrite);

        forever @(posedge clk) begin
            display_instruction();
            if (memWrite) begin
                $display("\n--- Memory Write Operation ---");
                $display("Address: %h Data: %h", aluResult, writeData);
            end
            if (uut.dp.branch) begin
                $display("\n--- Branch Operation ---");
                $display("Branch Target: %h", uut.dp.pcBranch);
            end
        end
    end

    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb);

        $dumpvars(0, uut.dp.pcNext);
        $dumpvars(0, uut.dp.pcSrc);
        $dumpvars(0, uut.dp.pcBranch);
        #1000
        $display("\nFinal State:");
        display_key_registers();
        display_control_signals();
        $finish;
    end

endmodule
