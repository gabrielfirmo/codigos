module erro(in,e,out);
parameter n=7;

input [n-1:0]e;
input [n-1:0]in;
output [n-1:0]out;

assign out = in^e;

endmodule
