### Pr�ctica 2: An�lisis de un sistma de ecuaciones diferenciales acopladas y no lineales:

##. Angeli, D., Ferrell, J. E. & Sontag, E. D. Detection of multistability, bifurcations, and hysteresis in a large class of biological positive-feedback systems. PNAS 101, 1822-7 (2004).

# Borramos todo
#rm(list=ls())

# Nos ubicamos donde queremos


# Instalar la paqueter�a que necesitamos
library(deSolve)
library(phaseR)

# Declarar los valores de par�metros que permanecen constantes
alpha1=1; alpha2=1; beta1=200; beta2=10; gamma1=4; gamma2=4; 
K1=30; K2=1;
#v=1;

Angeli2004 <- function(t, y, parms){  
    #         1      2       3      4       5     6      7   8   9
  #parms=(alpha1, alpha2, beta1, beta2, gamma1, gamma2, K1, K2, v)
         dX <- parms[1]*(1-y[1])-parms[3]*y[1]*(parms[9]*y[2])^parms[5]/(parms[7]+(parms[9]*y[2])^parms[5]);  
         dY <- parms[2]*(1-y[2])-parms[4]*y[2]*y[1]^parms[6]/(parms[8]+y[1]^parms[6]);
         list(c(dX,dY))
}

# Condiciones iniciales
ini_1 <- c(0,0); ini_2 <- c(0,0.9)

# Tiempo de integraci�n
tspan <- seq(from = 0, to = 10, by = 0.01)

############## PREGUNTA 1: DIN�MICA DEL SISTEMA ######################

# par�metro de bifurcaci�n - 
for (v in c(0.75, 1, 1.9)){
 
 parms=c(alpha1, alpha2, beta1, beta2, gamma1, gamma2, K1, K2, v)

# �A integrar!
out1 <- ode(y = ini_1, times = tspan, func = Angeli2004, parms = parms)

plot(out1[,1], out1[,2],type = "l", ylim=c(0,1),col="red", xlab = "Time", ylab = "X(t)", main = paste("v=", toString(v), sep=" "))

#Ahora con la segunda condici�n inicial
out2 <- ode(y = ini_2, times = tspan, func = Angeli2004, parms = parms)
lines(out2[,1], out2[,2],type = "l", col="blue")
legend=c(paste("I.C.=", toString(ini_1), sep=" "), paste("I.C.=", toString(ini_2), sep=" "))

# A�adamos a este diagrama de espacio fase un campo vectorial
Angeli2004.flowField <- flowField(Angeli2004, xlim = c(0, 1), ylim = c(0, 1), parameters = parms, points = 10, add = FALSE)
Angeli2004.trajectory <- trajectory(Angeli2004, y0 = ini_1, tlim = c(0,10), parameters = parms, col = "blue")
Angeli2004.trajectory <- trajectory(Angeli2004, y0 = ini_2, tlim = c(0,10), parameters = parms, col = "red")
}

############ PREGUNTA 2: Cuencas de atracci�n ###############

  # par�metro de bifurcaci�n - 
  for (v in c(1, 1.6)){
    parms=c(alpha1, alpha2, beta1, beta2, gamma1, gamma2, K1, K2, v)
    
    # A�adamos a este diagrama de espacio fase un campo vectorial
    flowField(Angeli2004, xlim = c(0, 1), ylim = c(0, 1), parameters = parms, points = 10, add = FALSE)
    
    # Genera n condiciones iniciales al azar, pero sobre el m�rgen ([x=0,1; y=rand] y vice versa)
    for (ii in seq(1,20,1) ){
      # generate 3 random numbers
      r1=runif(1); r2=runif(1); r3=runif(1);
      
      if (r1<0.5){
      ini = c(as.numeric(r2<0.5), r3)
      } else {
      ini = c(r3, as.numeric(r2<0.5))
      }
      
    trajectory(Angeli2004, y0 = ini, tlim = c(0,10), parameters = parms, col = "blue")
    }
  }



############ PREGUNTA 3: Se�ales de alerta temprana ###############

LineWidth=1
# par�metro de bifurcaci�n - 
for (v in seq(0.2,1,0.1)){
  
  parms=c(alpha1, alpha2, beta1, beta2, gamma1, gamma2, K1, K2, v)
  
  # �A integrar!
  out <- ode(y = ini_2, times = tspan, func = Angeli2004, parms = parms)
  
  if (v==0.2){
  plot(out[,1], out[,3],type = "l", ylim=c(0,1),col="black", xlab = "Time", ylab = "X(t)", lwd=LineWidth, main="Alentamiento cr�tico" )
  } else {
  lines(out[,1], out[,3],type = "l", col="black", lwd=LineWidth)
  }
  
  LineWidth=LineWidth+0.5
  
}
  

############## PREGUNTA 4: Diagrama de bifurcaci�n ######################

# Corre el c�digo anexo:
source('Grind.r') # puedes hacerlo abri�ndolo y corri�ndolo, o ir a la carpeta en la que est� con setwd(..) y luego


# Declarar los valores de par�metros que permanecen constantes
alpha1=1; alpha2=1; beta1=200; beta2=10; gamma1=4; gamma2=4; 
K1=30; K2=1;
#v=1;

model <- function(t, state, parms){  
  with(as.list(c(state,parms)), {
    dx = alpha1*(1-x)-beta1*x*(v*y)^gamma1/(K1+(v*y)^gamma1)
    dy = alpha2*(1-y)-beta2*y*x^gamma2/(K2+x^gamma2)
    return(list(c(dx, dy)))
  })
}
  

p <-  c(alpha1=1, alpha2=1, beta1=200, beta2=10, gamma1=4, gamma2=4, K1=30, K2=1, v=1)

s <- c(x=0,y=0)
plane(xmax=4)
mid <- newton(s,plot=T)
low <- newton(c(x=1,y=0),plot=T)
hig <- newton(c(x=0,y=1),plot=T)

continue(state=hig, parms=p, odes=model, x="v", step=0.001, xmin=0, xmax=2,y="y", ymin=0, ymax=1.1) # log="", time=0, positive=TRUE, add=TRUE)
continue(state=low, parms=p, odes=model, x="v", step=0.001, xmin=0, xmax=2,y="y", ymin=0, ymax=1.1, log="", time=0, positive=TRUE, add=TRUE)
continue(state=mid, parms=p, odes=model, x="v", step=0.001, xmin=0, xmax=2,y="y", ymin=0, ymax=1.1, log="", time=0, positive=TRUE, add=TRUE)


