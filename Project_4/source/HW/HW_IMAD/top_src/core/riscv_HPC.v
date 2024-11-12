module riscv_HPC (
    
    clk, 
    rst_i,

    //Request information from pipline controller
    req_pc,
    req_next_pc,
    req_inst_opcode,
    req_inst_valid,
    
    
    //Not used in Project 3, Interface for future use.
      // Committed & retired instruction 
      req_inst_commit,
      req_inst_retired,
      //ALU bound instruction info.
      req_inst_ALU,
      req_inst_div,
      req_inst_mul,
      stall_by_ALU,
      //Memory bound instruction info. 
      req_inst_load,
      req_inst_store,
      stall_by_MEM,
      //Control flow bound instruction info. 
      req_inst_branch,
      req_branch_taken,
      req_branch_inst_pc,
      req_branch_target

);


    input        clk;
    input        rst_i;

    input [31:0] req_pc;
    input [31:0] req_next_pc;
    input [31:0] req_inst_opcode;
    input        req_inst_valid;

    input        req_inst_commit;
    input        req_inst_retired;

    input        req_inst_ALU;
    input        req_inst_div;
    input        req_inst_mul;
    input        stall_by_ALU;

    input        req_inst_load;
    input        req_inst_store;
    input        stall_by_MEM;

    input        req_inst_branch;
    input        req_branch_taken;
    input [31:0] req_branch_inst_pc;
    input [31:0] req_branch_target;
    
    

    reg [31:0]  HPC_req_Btype;
    reg [31:0]  HPC_req_Jtype;

    reg [31:0]   HPC_req_retired;
    reg [63:0]   HPC_exe_cycle;

    reg [31:0]   HPC_req_ALU;
    reg [31:0]   HPC_req_ALU_stall_cycle;
    reg [31:0]   HPC_req_MEM;
    reg [31:0]   HPC_req_MEM_stall_cycle;
    reg [31:0]   HPC_req_MEM_cause_stall;

    reg [31:0]   HPC_req_BRANCH_taken;
    reg [31:0]   HPC_req_jalr;

    reg          req_inst_load_r;
    reg          req_inst_store_r;
    wire         req_conditional_branch;
    reg          req_conditional_branch_r;



//ALU bound instruction & stall cycle 
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_ALU  <='b0;
    else if(req_inst_div 
            //||req_inst_mul
            //||req_inst_ALU
    )        
                                         HPC_req_ALU  <= HPC_req_ALU + 1'b1;
end
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_ALU_stall_cycle  <='b0;
    else if(stall_by_ALU)                HPC_req_ALU_stall_cycle  <= HPC_req_ALU_stall_cycle + 1'b1;  
end


always @(posedge rst_i or posedge clk) begin
    if(rst_i)                                       HPC_req_Btype <='b0;
    else if(req_inst_valid 
           && req_inst_opcode[6:0] == 7'b110_0011)  HPC_req_Btype <= HPC_req_Btype +1'b1;
end


always @(posedge rst_i or posedge clk) begin
    if(rst_i)                                       HPC_req_Jtype <='b0;
    else if(req_inst_valid 
           && req_inst_opcode[6:0] == 7'b110_1111)  HPC_req_Jtype <= HPC_req_Jtype +1'b1;
end



assign req_conditional_branch = (req_inst_branch && req_inst_opcode[6:0] == 7'b110_0011);
always @(posedge rst_i or posedge clk) begin
    if(rst_i)                  req_conditional_branch_r <= 1'b0;
    else                       req_conditional_branch_r <= req_conditional_branch;
end

always @(posedge rst_i or posedge clk) begin
    if     (rst_i)            HPC_req_retired  <='b0;
    else if(req_inst_retired) HPC_req_retired  <= HPC_req_retired + 1'b1;
end


always @(posedge rst_i or posedge clk) begin
    if     (rst_i)            HPC_exe_cycle  <='b0;
    else                      HPC_exe_cycle  <= HPC_exe_cycle + 1'b1;
end


//ALU bound instruction & stall cycle 
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_ALU  <='b0;
    else if(req_inst_div 
            //||req_inst_mul
            //||req_inst_ALU
    )        
                                         HPC_req_ALU  <= HPC_req_ALU + 1'b1;
end
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_ALU_stall_cycle  <='b0;
    else if(stall_by_ALU)                HPC_req_ALU_stall_cycle  <= HPC_req_ALU_stall_cycle + 1'b1;  
end


//Memory bound instruction & stall cycle
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                         HPC_req_MEM  <='b0;
    else if(req_inst_load
            ||req_inst_store
            )                              HPC_req_MEM  <= HPC_req_MEM + 1'b1;
end
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_MEM_stall_cycle  <='b0;
    else if(stall_by_MEM)                HPC_req_MEM_stall_cycle  <= HPC_req_MEM_stall_cycle + 1'b1;  
end

always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                       HPC_req_BRANCH_taken  <='b0;
    else if(req_branch_taken)            HPC_req_BRANCH_taken  <= HPC_req_BRANCH_taken + 1'b1;  
end
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                                 HPC_req_jalr  <='b0;
    else if((req_inst_opcode[6:0] == 7'b110_0111)) HPC_req_jalr  <= HPC_req_jalr + 1'b1;  
end




wire  stall_sig_rising_edge;
assign stall_sig_rising_edge = stall_by_MEM;
reg stall_sig_rising_edge_r;
 always @(posedge rst_i or posedge clk) begin
     if     (rst_i)                          stall_sig_rising_edge_r  <=1'b0;
     else                                    stall_sig_rising_edge_r  <=stall_sig_rising_edge;  
 end
wire stall_MEM_cause_sig;
assign stall_MEM_cause_sig = (stall_sig_rising_edge==1'b1)&&(stall_sig_rising_edge_r==1'b0);


always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                          HPC_req_MEM_cause_stall  <='b0;
    else if(stall_MEM_cause_sig)            HPC_req_MEM_cause_stall  <= HPC_req_MEM_cause_stall + 1'b1;  
end



endmodule