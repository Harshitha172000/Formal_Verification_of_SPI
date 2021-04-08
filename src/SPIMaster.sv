

module Top ();
  
  parameter SPI_MODE = 3; // CPOL = 0, CPHA = 1
  parameter SPI_CLK_DELAY = 20;  // 2.5 MHz
  parameter MAIN_CLK_DELAY = 2;  // 25 MHz

  wire w_CPOL; // clock polarity
  wire w_CPHA; // clock phase

  assign w_CPOL = (SPI_MODE == 2) | (SPI_MODE == 3);
  assign w_CPHA = (SPI_MODE == 1) | (SPI_MODE == 3);

  reg r_Rst_L     = 1'b0;

 
  wire w_SPI_Clk;
  
  reg r_Clk       = 1'b0;
  wire w_SPI_MOSI;
  wire w_SPI_MISO;

  // Master Specific
  reg [15:0] r_Master_TX_Byte ;
  reg r_Master_TX_DV = 1'b0;
  reg r_Master_CS_n = 1'b1;
  wire w_Master_TX_Ready;
  wire r_Master_RX_DV;
  wire [15:0] r_Master_RX_Byte;

  // Slave Specific
  wire       w_Slave_RX_DV; reg r_Slave_TX_DV;
  wire [15:0] w_Slave_RX_Byte; reg [15:0] r_Slave_TX_Byte;

  // Clock Generators:
  always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

  // Instantiate UUT
  SPI_SLAVE #(.SPI_MODE(SPI_MODE)) SPI_Slave_UUT
  (
   // Control/Data Signals,
   .i_Rst_L(r_Rst_L),      // FPGA Reset
   .i_Clk(r_Clk),          // FPGA Clock
   .o_RX_DV(w_Slave_RX_DV),      // Data Valid pulse (1 clock cycle)
   .o_RX_Byte(w_Slave_RX_Byte),  // Byte received on MOSI
   .i_TX_DV(r_Slave_TX_DV),      // Data Valid pulse
   .i_TX_Byte(r_Slave_TX_Byte),  // Byte to serialize to MISO (set up for loopback)

   // SPI Interface
   .i_SPI_Clk(w_SPI_Clk),
   .o_SPI_MISO(w_SPI_MISO),
   .i_SPI_MOSI(w_SPI_MOSI),
   .i_SPI_CS_n(r_Master_CS_n)
   );

  // Instantiate Master to drive Slave
  SPIMaster
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(2)) SPI_Master_UUT
  (
   // Control/Data Signals,
   .i_Rst_L(r_Rst_L),     // FPGA Reset
   .i_Clk(r_Clk),         // FPGA Clock
   
   // TX (MOSI) Signals
   .i_TX_Byte(r_Master_TX_Byte),     // Byte to transmit on MOSI
   .i_TX_DV(r_Master_TX_DV),         // Data Valid Pulse with i_TX_Byte
   .o_TX_Ready(w_Master_TX_Ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
   .o_RX_DV(r_Master_RX_DV),       // Data Valid pulse (1 clock cycle)
   .o_RX_Byte(r_Master_RX_Byte),   // Byte received on MISO

   // SPI Interface
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MISO),
   .o_SPI_MOSI(w_SPI_MOSI)
   );


   
 //Assertion 1
  always @(posedge w_SPI_Clk ) begin
   
   if (r_Rst_L) begin
   if (w_Slave_RX_DV) begin
             assert(r_Master_TX_Byte==r_Slave_RX_Byte);
   end
   
   if (r_Master_RX_DV) begin
             assert(r_Slave_TX_Byte==r_Master_RX_Byte);
   end
   end
   end
 
  
  
   
     

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module SPIMaster
  #(parameter SPI_MODE = 0,
    parameter CLKS_PER_HALF_BIT = 2)
  (
   // Control/Data Signals,
   input        i_Rst_L,     // Reset
   input        i_Clk,       //  Clock
   
   // TX (MOSI) Signals
    input [15:0]   i_TX_Byte,        
   input        i_TX_DV,          
   output reg   o_TX_Ready,       
   
   // RX (MISO) Signals
   output reg       o_RX_DV,     
    output reg [15:0] o_RX_Byte,   

   // SPI Interface
   output reg o_SPI_Clk,
   input      i_SPI_MISO,
   output reg o_SPI_MOSI
   );

  // SPI Interface (All Runs at SPI Clock Domain)
  wire w_CPOL;     // Clock polarity
  wire w_CPHA;     // Clock phase

  reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_Clk_Count;
  reg r_SPI_Clk;
  reg [5:0] r_SPI_Clk_Edges;
  reg r_Leading_Edge;
  reg r_Trailing_Edge;
  reg       r_TX_DV;
  reg [15:0] r_TX_Byte;

  reg [3:0] r_RX_Bit_Count;
  reg [3:0] r_TX_Bit_Count;

  assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);

  
  assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);



  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_TX_Ready      <= 1'b0;
      r_SPI_Clk_Edges <= 0;
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      r_SPI_Clk       <= w_CPOL; 
      r_SPI_Clk_Count <= 0;
    end
    else
    begin

      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      
      if (i_TX_DV)
      begin
        o_TX_Ready      <= 1'b0;
        r_SPI_Clk_Edges <= 32;  
      end
      else if (r_SPI_Clk_Edges > 0)
      begin
        o_TX_Ready <= 1'b0;
        
        if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1;
          r_Trailing_Edge <= 1'b1;
          r_SPI_Clk_Count <= 0;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1;
          r_Leading_Edge  <= 1'b1;
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else
        begin
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1;
        end
      end  
      else
      begin
        o_TX_Ready <= 1'b1;
      end
      
      
    end 
  end 


  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r_TX_Byte <= 16'h00;
      r_TX_DV   <= 1'b0;
    end
    else
      begin
        r_TX_DV <= i_TX_DV; // 1 clock cycle delay
        if (i_TX_DV)
        begin
          r_TX_Byte <= i_TX_Byte;
        end
      end 
  end 


  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_MOSI     <= 1'b0;
      r_TX_Bit_Count <= 4'b1111;
    end
    else
    begin
      if (o_TX_Ready)
      begin
        r_TX_Bit_Count <= 4'b1111;
      end
      else if (r_TX_DV & ~w_CPHA)
      begin
        o_SPI_MOSI     <= r_TX_Byte[3'b111];
        r_TX_Bit_Count <= 4'b1110;
      end
      else if ((r_Leading_Edge & w_CPHA) | (r_Trailing_Edge & ~w_CPHA))
      begin
        r_TX_Bit_Count <= r_TX_Bit_Count - 1;
        o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
      end
    end
  end


  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_RX_Byte      <= 16'h00;
      o_RX_DV        <= 1'b0;
      r_RX_Bit_Count <= 4'b1111;
    end
    else
    begin

      o_RX_DV   <= 1'b0;
      if (o_TX_Ready) 
      begin
        r_RX_Bit_Count <= 4'b1111;
      end
      else if ((r_Leading_Edge & ~w_CPHA) | (r_Trailing_Edge & w_CPHA))
      begin
        o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;  
        r_RX_Bit_Count            <= r_RX_Bit_Count - 1;
        if (r_RX_Bit_Count == 4'b0000)
        begin
          o_RX_DV   <= 1'b1;   
        end
      end
    end
  end
  
  
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_Clk  <= w_CPOL;
    end
    else
      begin
        o_SPI_Clk <= r_SPI_Clk;
      end 
  end 
  

endmodule 



module SPI_SLAVE
  #(parameter SPI_MODE = 0)
  (
   // Control/Data Signals,
   input            i_Rst_L,    //  Reset
   input            i_Clk,      //  Clock
   output reg       o_RX_DV,    
    output reg [15:0] o_RX_Byte,  
   input            i_TX_DV,    
    input  [15:0]     i_TX_Byte,  

   // SPI Interface
   input      i_SPI_Clk,
   output     o_SPI_MISO,
   input      i_SPI_MOSI,
   input      i_SPI_CS_n
   );


  // SPI Interface (All Runs at SPI Clock Domain)
  wire w_CPOL;     // Clock polarity
  wire w_CPHA;     // Clock phase
  wire w_SPI_Clk;  
  wire w_SPI_MISO_Mux;
  
  reg [3:0] r_RX_Bit_Count;
  reg [3:0] r_TX_Bit_Count;
  reg [15:0] r_Temp_RX_Byte;
  reg [15:0] r_RX_Byte;
  reg r_RX_Done, r2_RX_Done, r3_RX_Done;
  reg [15:0] r_TX_Byte;
  reg r_SPI_MISO_Bit, r_Preload_MISO;

 
  assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);

  
  assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);

  assign w_SPI_Clk = w_CPHA ? ~i_SPI_Clk : i_SPI_Clk;



  always @(posedge w_SPI_Clk or posedge i_SPI_CS_n)
  begin
    if (i_SPI_CS_n)
    begin
      r_RX_Bit_Count <= 0;
      r_RX_Done      <= 1'b0;
    end
   
    else
    
    begin
      r_RX_Bit_Count <= r_RX_Bit_Count + 1;

      // Receive in LSB, shift up to MSB
      r_Temp_RX_Byte <= {r_Temp_RX_Byte[14:0], i_SPI_MOSI};
    
      if (r_RX_Bit_Count == 4'b1111)
      begin
        r_RX_Done <= 1'b1;
        r_RX_Byte <= {r_Temp_RX_Byte[14:0], i_SPI_MOSI};
      end
      else if (r_RX_Bit_Count == 4'b0100)
      begin
        r_RX_Done <= 1'b0;        
      end

    end 
  end 


  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r2_RX_Done <= 1'b0;
      r3_RX_Done <= 1'b0;
      o_RX_DV    <= 1'b0;
      o_RX_Byte  <= 8'h00;
    end
    else
    begin
      r2_RX_Done <= r_RX_Done;

      r3_RX_Done <= r2_RX_Done;
   
      if (r3_RX_Done == 1'b0 && r2_RX_Done == 1'b1) 
      begin
        o_RX_DV   <= 1'b1;  
        o_RX_Byte <= r_RX_Byte;
      end
      else
      begin
        o_RX_DV <= 1'b0;
      end
    end 
  end 


 
  always @(posedge w_SPI_Clk or posedge i_SPI_CS_n)
  begin
    if (i_SPI_CS_n)
    begin
      r_Preload_MISO <= 1'b1;
    end
    else
    begin
      r_Preload_MISO <= 1'b0;
    end
  end


 
  always @(posedge w_SPI_Clk or posedge i_SPI_CS_n)
  begin
    if (i_SPI_CS_n) begin
      r_TX_Bit_Count <= 4'b1111;  
      r_SPI_MISO_Bit <= r_TX_Byte[3'b111];  
    end
    else
    begin
      r_TX_Bit_Count <= r_TX_Bit_Count - 1;

     
      r_SPI_MISO_Bit <= r_TX_Byte[r_TX_Bit_Count];

    end 
  end 


  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r_TX_Byte <= 16'h00;
    end
    else
    begin
      if (i_TX_DV)
      begin
        r_TX_Byte <= i_TX_Byte; 
      end
    end 
  end 

  
  assign w_SPI_MISO_Mux = r_Preload_MISO ? r_TX_Byte[4'b1111] : r_SPI_MISO_Bit;

  
  assign o_SPI_MISO = i_SPI_CS_n ? 1'bZ : w_SPI_MISO_Mux;

endmodule 

