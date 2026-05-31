import numpy as np
from GA import Ga_knapsack
from GA.Ga_knapsack import Ga_knapsack
from GA.PSO import func,PSO
import matplotlib.pyplot as plt
if __name__ == '__main__':
    # W = np.array([95,75,23,73,50,22,6,57,89,98],dtype=int)
    # C = np.array([89,59,19,43,100,72,44,16,7,64],dtype=int)
    # V = 300
    # tr = Ga_knapsack(W,C,300)
    # z = tr.GA_0knapsack()
    # print(z[-1])
    # tt = np.zeros(10,dtype=int)
    # tt[0] = 1
    # print(tt)
    pso = PSO()
    pso.PSO_OP()

    plt.plot(pso.gp)
    plt.show()
    print(pso.gp[-1])
    print(pso.g)
