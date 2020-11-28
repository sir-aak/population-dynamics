import numpy as np
import matplotlib.pyplot as plt


np.random.seed(1)

# generates data for a single population dynamics simulation
def simulatePopulation (maxPop=100, nSteps=1000, Pop0=25):
    
    birthRate = 0.5 / maxPop
    deathRate = 0.5 / maxPop
    
    # initialize population vector
    Pop = np.zeros(nSteps)
    # initial population
    Pop[0] = Pop0
    
    for t in range(nSteps - 1):
        # check if population is within bounds
        if 0 < Pop[t] < maxPop:
            # is there a birth?
            birth = np.random.rand() <= birthRate * Pop[t]
            # is there a death?
            death = np.random.rand() <= deathRate * Pop[t]
            # update population
            Pop[t+1] = Pop[t] + 1.0 * birth - 1.0 * death
        
        else:
            Pop[t+1] = Pop[t]
    
    return (Pop)


# generates data for multiple population dynamics simulations
def simulatePopulations(maxPop=100, nSteps=1000, nSeries=10):

    birthRate = 0.5 / maxPop
    deathRate = 0.5 / maxPop
        
    # initialize population matrix
    Pop  = np.zeros((nSeries, nSteps))
    # initial populations
    Pop[:, 0] = np.random.randint(maxPop+1, size=nSeries)
    
    for t in range(nSteps-1):
        # check if populations are within bounds
        cond = (0 < Pop[:, t]) & (Pop[:, t] < maxPop)
        # are there births?
        birth = 1*(np.random.rand(nSeries) <= birthRate*Pop[:, t])
        # are there deaths?
        death = 1*(np.random.rand(nSeries) <= deathRate*Pop[:, t])
        # update populations
        Pop[:, t+1]        = Pop[:, t]
        Pop[:, t+1][cond] += birth[cond] - death[cond]
    
    return (Pop)


# plot data for single population dynamics simulation
def showPopulation():
    
    Y = simulatePopulation()
    X = np.arange(Y.size)
    
    plt.figure()
    plt.plot(X, Y)
    plt.title("population time series")
    plt.xlabel("time $t$")
    plt.ylabel("population($t$)")


# plot data for multiple population dynamics simulation
def showPopulations():
    
    maxPop  = 100
    nSteps  = 10000
    nSeries = 10
    
    Y = simulatePopulations(maxPop, nSteps, nSeries)
    X = np.arange(nSteps)
    
    fig = plt.figure()
    fig.set_size_inches(14, 6)
    fig.suptitle("populations", fontsize=14)
    plt.subplots_adjust(wspace=0.2)
    
    plt.subplot(1, 2, 1)
    for i in range(nSeries):
        plt.plot(X, Y[i])
    plt.title(str(nSeries) + " populations' time series")
    plt.xlabel("time $t$")
    plt.ylabel("population($t$)")
    plt.grid(color="lightgray")
    
    plt.subplot(1, 2, 2)
    plt.hist(Y[:, -1], bins=maxPop, zorder=2)
    plt.title("histogram for " + str(nSeries) + " populations")
    plt.xlabel("population")
    plt.ylabel("frequency")
    plt.grid(color="lightgray")


showPopulations()
