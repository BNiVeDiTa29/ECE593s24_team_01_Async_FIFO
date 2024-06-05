class bug_injection extends uvm_component;
    `uvm_component_utils(bug_injection)
    
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task inject_data_corruption(logic [31:0] data);
        
        data = data ^ 32'hA5A5A5A5;
    endtask

   
    task inject_write_error(input logic wr_en);
       
        wr_en = ~wr_en;
    endtask

   
    task inject_read_error(input logic rd_en);

        rd_en = ~rd_en;
    endtask


    task inject_overflow(input logic wr_en, input logic full);
       
        if (full)
            wr_en = 1;
    endtask

   
    task inject_underflow(input logic rd_en, input logic empty);
        
        if (empty)
            rd_en = 1;
    endtask

   
    virtual function void run_phase(uvm_phase phase);
        super.run_phase(phase);
        logic [31:0] data;
        logic wr_en, rd_en, full, empty;

        inject_data_corruption(data);
        inject_write_error(wr_en);
        inject_read_error(rd_en);
        inject_overflow(wr_en, full);
        inject_underflow(rd_en, empty);
    endfunction
endclass