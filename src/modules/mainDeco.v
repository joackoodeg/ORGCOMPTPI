module mainDeco(
    input reset,                // Señal de reset
    input [6:0] op,
    output reg branch,           // Señal de control para salto condicional (Branch)
    output reg resSrc,           // Selección de fuente de resultado (ResultSrc)
    output reg memWrite,         // Señal de escritura de memoria (MemWrite)
    output reg aluSrc,           // Selección de fuente de entrada para la ALU (ALUSrc)
    output reg regWrite,         // Señal de escritura de registros (RegWrite)
    output reg [1:0] immSrc,     // Selección del tipo de inmediato (ImmSrc)
    output reg [1:0] aluOp       // Operación de la ALU (ALUOp)
);

    always @(*) begin
        if (reset) begin
            // Estado seguro durante reset
            branch = 1'b0;
            resSrc = 1'b0;
            memWrite = 1'b0;
            aluSrc = 1'b0;
            regWrite = 1'b0;
            immSrc = 2'b00;
            aluOp = 2'b00;
        end
        else begin    

        // Decodificación según el valor del opcode (op)
        case(op)
            7'b0000011: begin // lw (load word)
                regWrite = 1;
                immSrc = 2'b00;
                aluSrc = 1;
                memWrite = 0;
                resSrc = 1;
                branch = 0;
                aluOp = 2'b00;
            end
            7'b0100011: begin // sw (store word)
                regWrite = 0;
                immSrc = 2'b01;
                aluSrc = 1;
                memWrite = 1;
                resSrc = 0;
                branch = 0;
                aluOp = 2'b00;
            end
            7'b0110011: begin // R-type
                regWrite = 1;
                immSrc = 2'b00;
                aluSrc = 0;
                memWrite = 0;
                resSrc = 0;
                branch = 0;
                aluOp = 2'b10;
            end
            7'b0010011: begin // addi (I-type)
                regWrite = 1;   // Escribe en registro destino
                immSrc = 2'b00; // Formato inmediato tipo-I
                aluSrc = 1;     // Usa inmediato como segundo operando
                memWrite = 0;   // No escribe en memoria
                resSrc = 0;     // Resultado viene de la ALU
                branch = 0;     // No es salto
                aluOp = 2'b00;  // Operación suma
            end
            7'b1101111: begin // jal (J-type)
                regWrite = 1;   // Guarda dirección de retorno
                immSrc = 2'b11; // Formato inmediato tipo-J
                aluSrc = 0;     // No usa inmediato para ALU
                memWrite = 0;   // No escribe en memoria
                resSrc = 0;     // Resultado no viene de memoria
                branch = 1;     // Es un salto
                aluOp = 2'b00;  // Operación basica
            end
            7'b1100011: begin // beq (branch if equal)
                regWrite = 0;
                immSrc = 2'b10;
                aluSrc = 0;
                memWrite = 0;
                resSrc = 0;
                branch = 1;
                aluOp = 2'b01;
            end
            default: begin
                // En caso de opcode desconocido, todas las señales se mantienen en 0
                branch = 0;
                resSrc = 0;
                memWrite = 0;
                aluSrc = 0;
                regWrite = 0;
                immSrc = 2'b00;
                aluOp = 2'b00;
            end
        endcase
        end
    end

endmodule

/*
Decodificador principal:
Unidad que decodifica el tipo de instruccion
para generar el camino de datos
*/
