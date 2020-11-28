set.seed(1)


# generates data for a single population dynamics simulation
simulatePopulation = function (maxPop=100, nSteps=1000, Pop0=25)
{
  
  birthRate = 0.5 / maxPop
  deathRate = 0.5 / maxPop
  
  # initialize population vector
  Pop = list()
  
  # initial population
  Pop[1] = Pop0
  
  for (t in 1:(nSteps-1)) {
    # check if population is within bounds
    if ((0 < Pop[t]) & (Pop[t] < maxPop)) {
      # is there a birth?
      birth = runif(1) <= birthRate * Pop[[t]]
      # is there a death?
      death = runif(1) <= deathRate * Pop[[t]]
      # update population
      Pop[t+1] = Pop[[t]] + as.integer(birth) - as.integer(death)
    }

    else {
      Pop[t+1] = Pop[t]
    }
    
  }
  
  return (Pop)
  
}


# generates data for multiple population dynamics simulations
simulatePopulations = function (maxPop=100, nSteps=1000, nSeries=10)
{
  
  birthRate = 0.5 / maxPop
  deathRate = 0.5 / maxPop
  
  # initialize population matrix
  Pop = matrix(0, nSeries, nSteps)
  
  # initial populations
  Pop[, 1] = sample(0:maxPop, nSeries)
  
  for (t in 2:nSteps-1) {
    
    # check if populations are within bounds
    cond  = (0 < Pop[, t]) & (Pop[, t] < maxPop)
    
    # are there births?
    birth = (runif(nSeries) <= birthRate*Pop[, t])
    
    # are there deaths?
    death = (runif(nSeries) <= deathRate*Pop[, t])
    
    # update populations
    Pop[, t+1]       = Pop[, t]
    Pop[, t+1][cond] = Pop[, t+1][cond] + as.integer(birth[cond]) - as.integer(death[cond])
    
  }
  
  return (Pop)
  
}


# plot data for single population dynamics simulation
showPopulation = function ()
{
  
  Y = simulatePopulation()
  X = c(1:length(Y))
  
  plot(X, Y, type="l", 
       main="population time series", 
       xlab="time t", 
       ylab=expression("population(t)"))
  
}


# plot data for multiple population dynamics simulation
showPopulations = function ()
{
  
  maxPop  = 100
  nSteps  = 10000
  nSeries = 10
  
  Y = simulatePopulations(maxPop, nSteps, nSeries)
  X = 1:nSteps
  
  par(mfrow=c(1, 2))
  
  # plot time series data
  plot(X, Y[1,], type="l", 
       xlab="time t", ylab="population(t)", 
       ylim=c(0.0, maxPop), col="blue", 
       main=bquote(paste(.(nSeries), " populations time series")))
  
  par(new=T)
  
  for (i in 2:(nSeries-1)) {
    plot(X, Y[i,], type="l",
         xlab="", ylab="",
         ylim=c(0.0, maxPop), col="blue", axes=F)
    par(new=T)
  }
  
  plot(X, Y[nSeries,], type="l",
       xlab="", ylab="",
       ylim=c(0.0, maxPop), col="blue")
  
  
  # plot histogram data
  hist(Y[, nSteps], breaks=100, 
       xlab="population", ylab="frequency", col="blue", 
       main=bquote(paste("histogram for ", .(nSeries), " populations")))
  
}


showPopulations()