//=================
// COMMIT ADDED 
//=================

module riscv_muladder
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i 
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i
    ,input  [ 31:0]  opcode_rc_operand_i
    ,input           hold_i

    // Outputs
    ,output          writeback_valid_o
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg  [31:0]  result_e2_q;

reg [32:0]   operand_a_e1_q;
reg [32:0]   operand_b_e1_q;
reg [32:0]   operand_c_e1_q;

//-------------------------------------------------------------
// MULTIPLIER + ADDER
//-------------------------------------------------------------
wire [64:0]  mult_result_w;
reg  [32:0]  operand_a_r;
reg  [32:0]  operand_b_r;
reg  [32:0]  operand_c_r;
reg  [31:0]  result_r;

wire imad_inst_w    = ((opcode_opcode_i & `INST_IMAD_MASK) == `INST_IMAD);


always @ *
begin
    if ((opcode_opcode_i & `INST_IMAD_MASK) == `INST_IMAD)
        operand_a_r = {opcode_ra_operand_i[31], opcode_ra_operand_i[31:0]};
    else 
        operand_a_r = {1'b0, opcode_ra_operand_i[31:0]};
end

always @ *
begin
    if ((opcode_opcode_i & `INST_IMAD_MASK) == `INST_IMAD)
        operand_b_r = {1'b0, opcode_rb_operand_i[31:0]};
    else 
        operand_b_r = {1'b0, opcode_rb_operand_i[31:0]};
end

always @ *
begin
    if ((opcode_opcode_i & `INST_IMAD_MASK) == `INST_IMAD)
        operand_c_r = {1'b0, opcode_rc_operand_i[31:0]};
    else 
        operand_c_r = {1'b0, opcode_rc_operand_i[31:0]};
end


// Pipeline flops for muladder
always @(posedge clk_i or posedge rst_i)
if (rst_i)
begin
    operand_a_e1_q <= 33'b0;
    operand_b_e1_q <= 33'b0;
    operand_c_e1_q <= 33'b0;
end
else if (hold_i)
    ;
else if (opcode_valid_i && imad_inst_w)
begin
    operand_a_e1_q <= operand_a_r;
    operand_b_e1_q <= operand_b_r;
    operand_c_e1_q <= operand_c_r;
end
else
begin
    operand_a_e1_q <= 33'b0; 
    operand_b_e1_q <= 33'b0;
    operand_c_e1_q <= 33'b0;
end

assign mult_result_w = {{ 32 {operand_a_e1_q[32]}}, operand_a_e1_q}*{{ 32 {operand_b_e1_q[32]}}, operand_b_e1_q} + operand_c_e1_q;

always @ *
begin
    result_r = mult_result_w[31:0];
end

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    result_e2_q <= 32'b0;
else
    result_e2_q <= result_r;


assign writeback_value_o  = result_e2_q;



// for valid signal

reg [31:0]   q_mask_q;
reg          valid_q;
reg          complete_r;

wire imad_start_w    = opcode_valid_i & imad_inst_w;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
begin
    q_mask_q <= 32'b0;
end
else if (imad_start_w)
begin
    q_mask_q       <= 32'h00000002;
end
else
begin
    q_mask_q <= (q_mask_q >> 1);
end




always @(posedge clk_i or posedge rst_i)
begin
if (rst_i)
    valid_q <= 1'b0;
else if ((opcode_opcode_i & `INST_IMAD_MASK) == `INST_IMAD)
    valid_q <= 1'b1;
else
    valid_q <= 1'b0;
end



always @(posedge clk_i or posedge rst_i)
begin
if (rst_i)
    complete_r <= 1'b0;  
else if (q_mask_q != 32'b0)
    complete_r <= 1'b1;
else
    complete_r <= 1'b0;
end



assign writeback_valid_o = complete_r;

endmodule
