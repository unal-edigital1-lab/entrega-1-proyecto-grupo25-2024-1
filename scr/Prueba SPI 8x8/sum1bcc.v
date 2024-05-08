module sum1bcc (A, B, Ci,Cout,S);

  input  A;
  input  B;
  input  Ci;
  output Cout;
  output S;
//se declaran los puertos, entradas y salidas de la misma forma en al cual se hizo en el primitive

  reg [1:0] st;  //registro que duarda la suma, este vector tiene dos bits de longitud
  
  assign S = st[0];  //se asigna el valor de la suma 
  assign Cout = st[1]; //se asigna el calor del carry 


  always @ ( * ) begin //aca se inicia el proseso
  
  	st  = 	A+B+Ci; //se realiza la operacion de suma directamente

  end
  
endmodule 

