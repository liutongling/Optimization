%粒子群算法（Particle Swarm Optimization）
%原理：粒子群算法是受到大自然鸟群觅食现象启发开发的优化算法。
%鸟群觅食的规律，一般是一群鸟群在一片空间中觅食，鸟群中的每个个体的觅食受到两个因素的影响
%第一个因素是自身在空间中寻找食物的时候，自身在路过路径的时候找到哪些地方有食物概率最大，第二个因素是受到整个群体的影响
%群体中那个位置有最大食物的概率最大。每个个体均由两个方面的因素影响。
%基于上述的启发，寻优问题也是类似之处，在寻优空间中，每个个体都会积极往最优出靠，会受到自身寻优路径的影响
%同时又受到整个群体的最优点的影响。
%基本粒子群算法的实现
%根据理论搜索空间每个个体要受到两个因素影响
%个体或粒子有个变量受影响
%Xi=(xi1,xi2,...,xid),i=(1,2,...,N) 表示每个个体的位置
%Vi=(Vi1,Vi2,...,Vid),i=(1,2,...,N) 表示每个个体的速度
%Vij(t+1) = vij + c1r1(t)[Pij(t)-xij(t)]+c2r2(t)[pgj(t)-xij(t)]
%该式子中Vij(t+1)表示一个粒子经过一个循环之后的速度
%xij(t+1) = xij(t)+Vij(t+1) 表示一个粒子经过一个循环之后，根据更新之后的粒子的速度进行更新位置


clear;
close all;
clc;
%优化函数
func = funccollect().func2;
N = 100; %表示粒子数目
D = 10; %函数维度
T = 200; %最大迭代次数
c1 = 1.5; %学习因子
c2 = 1.5; %学习因子
w = 0.8; %惯性权重
Xmax = 10;%位置最大值
Xmin = -10;%位置最小值 也就是函数的上下界
Vmax = 10;%速度最大值
Vmin = -10;%速度最小值
%对速度和位置进行更新
x = rand(N,D)*(Xmax-Xmin)+Xmin;
v = rand(N,D)*(Vmax-Vmin)+Vmin;
%初始化全局最优值和最优位置
gbest = inf;%存储整个群体中最优的个体
g = ones(1,D);%存储最优个体
p = x;%用于存储每个最优的个体
pbest = ones(N,1);%用于存储每个最优个体的值
for i = 1:N
    pbest(i) = func(x(i,:));
    if gbest> pbest(i)
        gbest = pbest(i);
        g = x(i,:);
    end
end
gb = ones(1,T); %存储迭代过程中最优的个体;
for i  = 1:T
    for j = 1:N
        %更新个体最优的值和位置
        val = func(x(j,:));
        if val<pbest(j)
            pbest(j) = val;
            p(j,:) = x(j,:);
        end
        %更新全局最优
        if val < gbest
            gbest = val;
            g = x(j,:);
        end
        %依靠粒子群原则进行粒子的更新
        %即依靠全局的速度和原来的速度，
        r1 = rand;
        r2 = rand;
        v(j,:) = w*v(j,:)+c1*r1*(p(j,:)-x(j,:))+c2*r2*(g-x(j,:));
        x(j,:) = x(j,:) + v(j,:);
        %对边界进行处理,边界包括两个方面，第一个方面是对位置的处理，第二个是速度的处理
        for k=1:D
            if v(j,k)>Vmax || v(j,k)<Vmin
                v(j,k) = rand*(Vmax-Vmin)+Vmin;
            end
            if x(j,k)>Xmax || x(j,k)<Xmin
                x(j,k) = rand*(Xmax-Xmin)+Xmin;
            end
        end

    end
    gb(i) = gbest;

end
g;%最优个体
gbest(end);%最优值
figure
plot(gb)
xlabel('迭代次数');
ylabel('适应度值');
title('适应度进化曲线');

