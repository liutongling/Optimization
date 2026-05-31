import math

import numpy as np
import matplotlib.pyplot as plt
#基本粒子群算法的实现
#优化实例为sum(xi^2)的求和函数
def func(x):
    return sum(x**2)
class PSO:
    #将粒子群算法全局参数，定义在构造参数中
    def __init__(self):
        #定义函数上下限
        self.Xmax = 10
        self.Xmin = -10
        #定义速度的上下限
        self.Vmax = 10
        self.Vmin = -10
        #定义转换因子
        self.c1 = 2.0
        self.c2 = 2.0
        self.w = 0.8 #原始速度权重
        #定义迭代次数，种群数，包括函数参数维度
        self.T = 1000
        self.N = 100
        self.D = 10
        #初始化种群
        self.x = np.random.rand(self.N,self.D)*(self.Xmax-self.Xmin) + self.Xmin
        self.v = np.random.rand(self.N,self.D)*(self.Vmax-self.Vmin) + self.Vmin
        #定义保存每个个体最优的值和位置
        self.p = np.ones((self.N,self.D))
        self.pbest = np.ones(self.N)
        #群里最优位置和值
        self.g = np.ones(self.D)
        self.gbest = math.inf
        self.gp = np.ones(self.T)
    def PSO_OP(self):
        #进行算法的初始化，计算随机的位置的值，并且保存到每个个体的最优
        for i in range(self.N):
            val = func(self.x[i,:])
            if val <self.gbest:
                self.gbest = val
                self.g = self.x[i,:]
            self.p[i,:] = self.x[i,:]
            self.pbest[i] = val
        for i in range(self.T):
            # 首先进输入一个种群循环计算出所有节点的值，然后筛选出最优位置和个体最优位置，进行下一代的更新
            for j in range(self.N):
                val = func(self.x[j,:])
                if val <self.gbest:
                    self.gbest = val
                    self.g = self.x[j,:]
                if val < self.pbest[j]:
                    self.pbest[j] = val
                    self.p[j,:] = self.x[j,:]
                # 按照公式开始更新新的解
                r1 = np.random.rand();
                r2 = np.random.rand();
                self.v[j,:] = self.w*self.v[j,:] + self.c1*r1*(self.p[j,:] - self.x[j,:])+self.c2*r2*(self.g - self.x[j,:])
                self.x[j,:] = self.v[j,:] + self.x[j,:]
                #处理边界问题
                # 速度如果超过界限
                for k in range(self.D):
                    if self.v[j,k]<self.Vmin or self.v[j,k]>self.Vmax:
                        self.v[j,k] = np.random.rand()*(self.Vmax-self.Vmin) + self.Vmin
                    if self.x[j,k]<self.Xmin or self.x[j,k]>self.Xmax:
                        self.x[j,k] = np.random.rand()*(self.Xmax-self.Xmin) + self.Xmin


            self.gp[i] = self.gbest
