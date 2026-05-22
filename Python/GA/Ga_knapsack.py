import numpy as np
import random
class Ga_knapsack:
    def __init__(self, W, C,V):
        self.W = W #表示物品重量
        self.C = C #表示物品价值
        self.V = V #表示背包承重
        #进行遗传算法的基本设置
        self.Pc = 0.8#交叉率
        self.Pm = 0.05#变异率
        self.afa = 2 #01背包问题，如果超过背包容量可以做相应惩罚、
        self.NP = 50 #种群规模或者说基因数目
        self.L = len(self.W) #表示基因长度
        self.G = 100 #表示循环次数
        self.n = np.random.randint(2,size=(self.NP,self.L))
        self.nn = np.random.randint(2,size=(self.NP,self.L)) #进行临时存储新变异出来的基因
        self.trace = np.zeros(self.G,dtype=int)
    def func(self,x):
        #计算方案的价值
        W = sum(self.W*x)
        C = sum(self.C*x)
        if W > self.V:
            #如果质量大于背包承重则进行相应的惩罚
            C = C - (W - self.V)*self.afa
        return C


    def GA_0knapsack(self):
        for k in range(self.G):
            result = np.zeros(self.NP,dtype=int)
            #先计算生成的值
            for i in range(self.NP):
                result[i] = self.func(self.n[i,:])

            #将数值进行归一化处理
            maxVal = max(result)
            minVal = min(result)
            Bestidx = np.where(maxVal == result)[0]
            Best = self.n[Bestidx,:]

            result = (result - minVal)/(maxVal - minVal)
            # 进行概率的转换
            sumre = sum(result)
            result = result / sumre

            #基于轮盘赌的概率选择
            for i in range(1,self.NP):
                result[i] = result[i-1]+ result[i]

            rnd = np.random.rand(self.NP)

            nnidx = 0
            nidx = 0
            while(nnidx<self.NP):
                if rnd[nnidx] <result[nidx] :
                    self.nn[nnidx,:] = self.n[nidx,:]
                    nnidx = nnidx+1
                else:
                    nidx = nidx+1
            # 基于Pc概率的交叉操作
            for i in range(0,2,self.NP):
                rd = np.random.rand()
                if rd < self.Pc:
                    # 将两者进行交换
                    loc = np.random.randint(2,size=self.L)
                    for j in range(self.L):
                        if loc[j] == 1:
                            temp = self.nn[i,j]
                            self.nn[i,j] = self.nn[i+1,j]
                            self.nn[i+1,j] = temp

            # 基于Pm的变异操作
            for i in range(self.NP):
                for j in range(self.L):
                    rd = np.random.rand()
                    if rd < self.Pm:
                        self.nn[i,j] = not self.nn[i,j]
            self.n = self.nn[:]
            #把最优解保存到第一个
            self.n[0,:] = Best[0,:]            # Best 有可能不止一个，选择第一个。
            self.trace[k] = maxVal             # 保存最优解
        return self.trace