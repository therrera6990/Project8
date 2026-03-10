module mux4_4bit(
        input[3:0] ceo,
        input[3:0] you,
        input[3:0] fred,
        input[3:0] jill,
        input[1:0] sel,
        input      enable,
        output[3:0] y
);
    assign y= (enable ==1'b0) ? 4'b0000:
              (sel == 2'b00) ? ceo:
              (sel == 2'b01) ? you:
              (sel == 2'b10) ? fred:
                               jill;
endmodule
                               
module demux_4_4bit(
        input [3:0] in,
        input [1:0] sel,
        input       enable,
        output [3:0] local_lib,
        output [3:0] fire_dept,
        output [3:0] school,
        output [3:0] rib_shack
);

assign local_lib = (enable == 1'b1 && sel == 2'b00) ? in : 4'b0000;
assign fire_dept = (enable == 1'b1 && sel == 2'b01) ? in : 4'b0000;
assign school    = (enable == 1'b1 && sel == 2'b10) ? in : 4'b0000;
assign rib_shack = (enable == 1'b1 && sel == 2'b11) ? in : 4'b0000;

endmodule

module top(
    input[15:0]sw,
    input btnL,btnU,btnD,btnR,btnC,
    output[15:0] led
);
    wire [3:0] ceo_data;
    wire [3:0] your_data;
    wire [3:0] fred_data;
    wire [3:0] jill_data;
    
    wire [1:0] mux_sel;
    wire [1:0] demux_sel;
    
    wire [3:0] internet_line;
    
    wire [3:0] local_lib_data;
    wire [3:0] fire_dept_data;
    wire [3:0] school_data;
    wire [3:0] rib_shack_data;
    
    assign ceo_data = sw[3:0];
    assign your_data= sw[7:4];
    assign fred_data= sw[11:8];
    assign jill_data= sw[15:12];
    
    assign mux_sel= {btnU,btnL};
    assign demux_sel= {btnR,btnD};
    
    mux4_4bit my_mux(
            .ceo (ceo_data),
            .you (your_data),
            .fred (fred_data),
            .jill (jill_data),
            .sel (mux_sel),
            .enable (btnC),
            .y (internet_line)
);
    demux_4_4bit my_demux(
            .in (internet_line),
            .sel (demux_sel),
            .enable (btnC),
            .local_lib (local_lib_data),
            .fire_dept (fire_dept_data),
            .school (school_data),
            .rib_shack (rib_shack_data)
);
    assign led [3:0]= local_lib_data;
    assign led [7:4]= fire_dept_data;
    assign led [11:8]= school_data;
    assign led [15:12]= rib_shack_data;
endmodule