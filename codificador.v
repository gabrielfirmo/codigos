module codificador(u,clk,v,flag);

parameter n=7,k=4;// parametros do codigo
wire [n-k:0]g = 'b1011; // coeficientes do polinomio gerador(x^3+x+1)


input [k-1:0]u;// mensagem
output reg [n-1:0]v;//mensagem codificada
output reg flag;
input clk;


reg [n-k-1:0]LFSR=0;
wire feedback;


integer count=0;
integer i;
integer j;


assign feedback = count<k ? u[count]^LFSR[0]:1'b0;
always@(posedge clk)
begin
	if (count<k)
	begin
		v = {u[count],v[n-1:1]};
		count <= count+1;
		LFSR[n-k-1] <= feedback;
		for(i=n-k-2,j=1;i>=0;i=i-1,j=j+1)
			LFSR[i] <= (feedback&g[j])^LFSR[i+1];
		flag =0;
	end
	
	else if (flag==0)
	begin
		v = {LFSR,v[n-1:n-k]};
		flag = 1;
	end	
end

endmodule
