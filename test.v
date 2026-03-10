`timescale 1ns/1ps

module test();
    wire [15:0] led;
    reg [15:0] sw;
    reg btnl, btnu, btnd, btnr, btnc;

    top uut(
        .led(led),
        .sw(sw),
        .btnL(btnl),
        .btnU(btnu),
        .btnD(btnd),
        .btnR(btnr),
        .btnC(btnc)
    );

    reg [4:0] i;
    reg fail = 1'b0;
    
    wire [1:0] mult_sel;
    wire [1:0] demult_sel;
    
    wire [3:0] current_mult;
    wire [3:0] current_demult;
    
    assign mult_sel = {btnu, btnl};
    assign demult_sel = {btnr, btnd};
    
    assign current_mult = (sw >> (4 * mult_sel)) & 'hF;
    assign current_demult = (led >> (4 * demult_sel)) & 'hF;

    initial begin
        $dumpvars(0, test);
        sw = 'b0110_1010_0101_1001;
        btnl = 0;
        btnu = 0;
        btnd = 0;
        btnr = 0;
        btnc = 0;
        #10;
        btnc = 1;
        
        $display("Mux Input for all testcases: sw[15:12] = %b , sw[11:8] = %b, sw[7:4] = %b, sw[3:0] = %b", sw[15:12], sw[11:8], sw[7:4], sw[3:0]);
        
        for (i = 0; i < 16; i = i + 1) begin
            #10;
            btnl = i[0];
            btnu = i[1];
            btnd = i[2];
            btnr = i[3];
            
            $display ("Testcase %d: muxSel = %b , demuxSel = %b, Expected Output = %b, Observed Output = %b", 
                        i, mult_sel, demult_sel, current_mult, current_demult);
                        
            if (current_mult !== current_demult) begin
                fail = 1'b1;
                $error("Observed output does not match expected output!");
            end
        end
        
        if (fail)
            $error("Failing Testcases! Review above messages and fix the design."); 
        else
            $display ("All Testcases Passed!");
            
        #10 $finish;
    end
endmodule
