module decodificador(clk,r,rc,flag);

parameter n=7,k=4;// parametros do codigo
wire [n-k:0]g = 'b1011; // coeficientes do polinomio gerador(x^3+x+1)
wire [n-k-1:0]s = 'b101; //escolha do padrao de erro

input clk;
input [n-1:0]r;
output [n-1:0]rc;
output reg flag;

reg [n-1:0]buffer;
reg [n-k-1:0]LFSR=0;

integer count=0;
integer i;
integer j;

wire feedback;
wire check;

assign feedback = count<2*n ? LFSR[0]:1'b0;
assign check = count>=n & count<2*n ? s==LFSR :1'b0;
always@(posedge clk)
begin
	if (count<n)
	begin
		buffer = {r[count],buffer[n-1:1]};
		LFSR[n-k-1] <= feedback^r[count];
		for(i=n-k-2,j=1;i>=0;i=i-1,j=j+1)
			LFSR[i] <= (feedback&g[j])^LFSR[i+1];
		
		count <= count+1;
		flag = 0;
	end
	
	else if (count<2*n)
	begin
		buffer = {check^buffer[0],buffer[n-1:1]};
		LFSR[n-k-1] <= feedback^check;
		for(i=n-k-2,j=1;i>=0;i=i-1,j=j+1)
			LFSR[i] <= (feedback&g[j])^LFSR[i+1];
		count<= count+1;
	end
	else if (count==2*n)
	begin
		flag =1;
	end
end
assign rc = buffer;	
endmodule
