module responder_control(
	input start,
	input touch,
	input[3:0] flag,
	input clk, rst_n,
	output reg en_count, lock_flag);
	
	reg [1:0]NS,CS;
	
	prameter [1:0]
		WAIT =2'b00,
		COUNT =2'b01,
		LOCK =2'b10;
	always@(posedge clk or negedge rst_n)
		if(!rst_n)
			CS<=WAIT;
		else
			CS<=NS;
	always@( CS or start or touch or flag)
		begin
			NS=2'bx;
			case(CS)
				WAIT: begin
							if(start)
								NS=COUNT;
							else
								NS=WAIT;
						end
				COUNT: begin
							if(!touch)
								if(flag==0)
									NS=WAIT;
								else
									NS=COUNT;
							else
								NS=LOCK;
						end
				LOCK: NS=LOCK;
			default: NS=WAIT;
			endcase
		end
	always@(pasedge clk or negedge rst_n)
		begin
			if(!rst_n) begin
								en_count<=0;
								lock_flag<=0;
							end
			else
				begin
					case(NS)
						WAIT:begin en_count <=0;end
						COUNT:begin en_count <=1;end
						LOCK:begin en_count <=0;lock_flag<=1;end
					default:en_count<=0;
					endcase
				end
		end
endmodule

				