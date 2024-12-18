//========================================
//  COMMIT (Compiler & Micro-architecture)
//========================================

`define NULL 0
module testbench;

reg clk;
reg rst_x;
//------------------------------------------------
//  Clock & Reset
//------------------------------------------------

parameter FREQ   = 100;
parameter CKP    = 1000.0/FREQ;
initial  forever #(CKP/2)    clk  = ~clk;
initial  begin 
   clk = 1'b1;
end


initial begin
   rst_x = 1'b1;
   repeat (5) @(posedge clk);
   #(CKP/2) rst_x = 1'b0;
   $display ("Reset disable... Simulation Start !!! ");    
end


//task define
task wait_clocks;
   input integer num_clocks;
   integer cnt_clocks;
   for(cnt_clocks = 0; cnt_clocks < num_clocks; cnt_clocks = cnt_clocks + 1) begin
     @ (posedge clk);
   end
endtask 

//------------------------------------------------
//  Test Input Trace
//------------------------------------------------
parameter TRACE_SIZE = 437;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i;
integer               start;

reg [31:0]   in_inst[0:TRACE_SIZE-1];

initial begin
  file_decsriptor = $fopen("C:/Users/handspc2/Downloads/ge/compiler/Project_4/hexfile/edited/out.hex", "r");
  if (file_decsriptor == `NULL) begin
    $display("file_decsriptor was NULL");
    $finish;
  end
  for( i =0; i< TRACE_SIZE; i=i+1) begin
    file_io = $fscanf(file_decsriptor,"%x\n", in_inst[i]); 
  end
   $display ("File Read Done!");
end

//------------------------------------------------
//  Test Logic
//------------------------------------------------

//inputs
reg          rst_cpu_i;
// instruction write port
reg  [  3:0]  tb_inst_we_i;
reg  [ 31:0]  tb_inst_addr_i;
reg  [ 31:0]  tb_inst_data_i;

riscv_tcm_top 
#( 
    .CORE_ID            (0),
    .MEM_CACHE_ADDR_MIN (0),
    .MEM_CACHE_ADDR_MAX (32'hffffffff)
)
UUT_RISCV_SOC
(
    // Inputs
    .clk_i           (clk)
    ,.rst_i           (rst_x)
    ,.rst_cpu_i       (rst_cpu_i       )
    // Outputs

    // instruction write
    ,.tb_inst_we_i    (tb_inst_we_i    )
    ,.tb_inst_addr_i  (tb_inst_addr_i  )
    ,.tb_inst_data_i  (tb_inst_data_i  )
);

//==========================
//  debugging variables
//==========================
integer     j, cycle_tick;
reg [31:0]   debug_req_retired_temp;
integer     retired_inst_cnt;

wire        debug_branch_taken_w;
wire [31:0] debug_PC_w;


assign debug_PC_w                    = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.req_pc;
assign debug_req_retired             = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_retired;


task INIT_MEM_WRITE;
  input [31:0] req_pc;
  input [31:0] req_instruction;
  begin
    tb_inst_we_i           = 4'hf;
    tb_inst_addr_i         = req_pc;
    tb_inst_data_i         = req_instruction;
    wait_clocks(1);
    tb_inst_we_i           = 4'b0;
  end
endtask

task CHECK_INST;
  input check_inst_cnt;
  begin
    if(check_inst_cnt)         $display ("Pass");
    else                       $display ("Fail");
  end
endtask


initial begin
  start   = 0;
  $display ("Request enqueue start!");
  start   = 1;
  wait_clocks(1);

  for( j =0; j< TRACE_SIZE; j=j+1) begin 
  INIT_MEM_WRITE(j * 4, in_inst[j]);
  end
  wait_clocks(1);

  $display ("Request enqueue end!");
  wait_clocks(1);


  rst_cpu_i = 1'b1;
  wait_clocks(1);
  rst_cpu_i = 1'b0; 


  //Execution Phase
  wait_clocks(1);
  $display ("Core reset");
  
  //====================
  //  Main Sequence 
  //====================

  wait_clocks(1);
  for(cycle_tick = 0; cycle_tick<40000; cycle_tick=cycle_tick+1)begin
     wait_clocks(1);

    if (cycle_tick == 0) begin
        debug_req_retired_temp[31:0] = debug_req_retired;
    end
    if (debug_req_retired_temp != debug_req_retired) begin
      retired_inst_cnt = retired_inst_cnt + 1;
      debug_req_retired_temp[31:0] = debug_req_retired;
    end

    if (debug_PC_w == 32'h0000_0170) begin  // TODO: start PC of conv
        $display("CONV start!");
        retired_inst_cnt = 0;
    end
    if (debug_PC_w == 32'h0000_0264) begin  // TODO: end PC of conv
        $display("CONV end!");
        $display("Retired instruction count: %d", retired_inst_cnt);
    end

    if (debug_PC_w == 32'h0000_016c) begin  // TODO: end PC of program
        wait_clocks(50);
        $finish();
    end
  end
    

end  




endmodule