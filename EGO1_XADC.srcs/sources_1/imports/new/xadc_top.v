//////////////////////////////////////////////////////////////////////////////////
// Single Channel XADC Version, Continous Version

module MyA2D_SingleChannel_05_ContinousMode(
    input clk,
    input [15:0] sw,          //sw[0], Hex vs. Decimal display, sw[15] reset  
    output[15:0] led,
    input  vauxp1,
    input  vauxn1
    );
   

// ADC channel to be used h5 means AUXPOS: JA[4] AUXNEG: JA[0]  IMPORTANT READ BELOW
// NOTE: if you change XADC channel, you must also change the corresponding port asignments below!!!!!!! 
wire analog_pos_in, analog_neg_in;
assign analog_pos_in = vauxp1;
assign analog_neg_in = vauxn1;

wire [15:0] do_out;  // ADC value; useful part are only [15:4] bits

wire [4 : 0] channel_out;
// assign led[4:0] = channel_out;

wire eoc_out;
// assign led[5] = eoc_out;


// instantiate IP XADC using IP Catatlog / FPGA Features and Design / XADC / XADC Wizard
// BASIC TAB: DRP, Continuous Mode; Single Channel rest default
// ADC Setup TAB: Seqencer Mode: Off; Channel Averaging: None; Enable CALIBRATION Averagin checked; (rest unchecked or default)
// Alarms Tab:  Turn off all alarms
// Single Channel Tab:  Slected Channel: VAUXP0 VAUXN0; Channel Enable: checked (rest un checked)

///----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG  THIS IS THE CONTINOUS MODE
xadc_wiz_0 CoolADCd (
  //.di_in(di_in),              // input wire [15 : 0] di_in
  .daddr_in(channel_out),        // input wire [6 : 0] daddr_in
  .den_in(eoc_out),            // input wire den_in
  .dwe_in(1'b0),            // input wire dwe_in
  //.drdy_out(drdy_out),        // output wire drdy_out
  .do_out(do_out),            // output wire [15 : 0] do_out
  .dclk_in(clk),          // input wire dclk_in
  .reset_in(sw[14]),        // input wire reset_in

  .vauxp1(analog_pos_in),            // note since vauxn5, channel 5, is used  .daddr_in(ADC_ADDRESS), ADC_ADRESS = 15h, i.e., 010101 
  .vauxn1(analog_neg_in),            // note since vauxn5, channel 5, is used  .daddr_in(ADC_ADDRESS), ADC_ADRESS = 15h, i.e., 010101     
 
  .channel_out(channel_out),  // output wire [4 : 0] channel_out
  .eoc_out(eoc_out),          // output wire eoc_out
  .alarm_out(led[0]),      // output wire alarm_out
  .eos_out(led[1]),         // output wire eos_out
 
  .busy_out(led[2])        // output wire busy_out
);
// INST_TAG_END ------ End INSTANTIATION Template ---------


// Setup Hex Display
wire [12:0] adcx_data;
assign adcx_data =  do_out[15:4];
assign led[15:4] = adcx_data;



endmodule