module UC(
    input reset,              // Señal de reset
    input [6:0] op,           // Opcode de la instrucción
    input [2:0] func3,        // func3 de la instrucción
    input func7,              // func7 de la instrucción
    input zero,               // Señal de comparación de la ALU
    output pcSrc,             // Señal para seleccionar el PC
    output branch,            // Señal de branch
    output resSrc,            // Selección de fuente de resultado
    output memWrite,          // Señal de escritura de memoria
    output aluSrc,            // Selección de fuente de entrada para la ALU
    output regWrite,          // Señal de escritura de registros
    output [2:0] aluControl,  // Señal de control de la ALU
    output [1:0] immSrc       // Selección del tipo de inmediato
);

    // Señal interna para la conexión entre DecodificadorPrincipal y ALUDecoder
    wire [1:0] aluOp;

    // Instancia del Decodificador Principal
    mainDeco mainDecoder (
        .reset(reset),
        .op(op),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .immSrc(immSrc),
        .aluOp(aluOp)
    );

    // Instancia del Decodificador de ALU
    aluDeco aluDecoder (
        .aluOp(aluOp),
        .func3(func3),
        .func7(func7),
        .aluControl(aluControl)
    );

    // Señal de pcSrc basada en branch y zero
    assign pcSrc = (branch & zero) |               // BEQ
               (op == 7'b1101111);                  // JAL
endmodule

/* Unidad de control:
Unidad de Control: es la circuitería que controla el flujo de 
datos a través del procesador, generando las señales necesarias 
para operar el camino de datos. 
*/