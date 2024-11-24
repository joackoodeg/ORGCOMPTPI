module datapath_tb;
    reg clk;
    reg reset;
    reg [31:0] instr;
    reg [31:0] readData;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // DUT instantiation
    dataPath uut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readData(readData),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for instruction injection
    task execute_instruction;
        input [31:0] new_instr;
        input [8*20:1] instr_name;
        begin
            @(posedge clk);
            instr = new_instr;
            $display("\nExecuting %s", instr_name);
            $display("PC=%h, Instruction=%h", pc, instr);
            @(posedge clk);
            #1;
            $display("ALUResult=%h, WriteData=%h, MemWrite=%b", 
                    aluResult, writeData, memWrite);
        end
    endtask

    initial begin
        // Inicializar
        clk = 0;
        reset = 1;
        instr = 0;
        readData = 0;

        // Reset 
        @(posedge clk);
        reset = 0;

        // Test sequence
        $display("\n=== Starting Loop Test ===\n");

        // Inicializar 
        execute_instruction(32'h00100293, "addi x5, x0, 1");    // var = 1
        execute_instruction(32'h01000913, "addi x18, x0, 16");  // limit = 16
        execute_instruction(32'h00000313, "addi x6, x0, 0");    // counter = 0

        // Loop 
        $display("\n=== Loop Start ===\n");
        repeat(10) begin
            // Loop 
            execute_instruction(32'h01228463, "beq x5, x18, 8");    // if var==limit, exit
            execute_instruction(32'h00528293, "add x5, x5, x5");    // var = var + var
            execute_instruction(32'h00130313, "addi x6, x6, 1");    // counter++
            execute_instruction(32'hfe000ae3, "beq x0, x0, -12");   // jump to start
            
            $display("\n=== Loop State ===");
            $display("Program Counter = %h", pc);
            $display("Variable (x5)   = %h", uut.reg_x5);
            $display("Counter (x6)    = %h", uut.reg_x6);
            $display("Limit (x18)     = %h", uut.reg_x18);
            $display("==================\n");
        end

        $display("\n=== Loop Test Complete ===\n");
        #100 $finish;
    end

    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);
    end

endmodule