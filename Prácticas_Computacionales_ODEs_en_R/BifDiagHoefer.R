source('Grind.r') # descargado de {http://theory.bio.uu.nl/rdb/grind.html}

# definir la funci�n
model <- function(t, state, parms){  
  with(as.list(c(state,parms)), {
  dy=alpha*IL4+k_g*y^2/(1+y^2)-k*y
    return(list(c(dy)))
  })
}


# Par�metro de bifurcacion:
IL4<-1;
# Declarar los valores de par�metros que permanecen constantes
p <-  c(alpha=0.02, k_g=5, k=1, IL4=1)

# "Initial guess" para buscar ra�ces con el algoritmo de Newton Raphson
s <- c(y=.1)

# correr
run(state=c(y=.5))


# ahora obtengamos estos tres puntos de equilibrio 
low <- newton(c(y=.01),plot=F)
mid <- newton(c(y=.1),plot=F)
hig <- newton(c(y=10),plot=F)


par(pty="s")

continue(state=hig, parms=p, odes=model, x="IL4", step=0.01, xmin=0, xmax=5,y="y", ymin=0, ymax=5) # log="", time=0, positive=TRUE, add=TRUE)
continue(state=low, parms=p, odes=model, x="IL4", step=0.01, xmin=0, xmax=5,y="y", ymin=0, ymax=5, add=TRUE) # log="", time=0, positive=TRUE, add=TRUE)
continue(state=mid, parms=p, odes=model, x="IL4", step=0.01, xmin=0, xmax=5,y="y", ymin=0, ymax=5, add=TRUE) # log="", time=0, positive=TRUE, add=TRUE)
