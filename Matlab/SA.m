%模拟退火（simulated Annealing）算法
%一句话先总结一下模拟退火算法的思想：受到金属退火的物理过程的启发。金属在高温状态下
%金属块内部的大多数的粒子均是在高能的状态，随着温度的下降，受到热力学定律的影响，金属粒子会偏向
%较为稳定的状态。（一般都逐渐降温的过程，如果是快速或瞬时降温金属内部的粒子来不仅转换到稳定的状态）
%受到上述物理过程的启发，提出模拟退火算法。
%模拟退火算法是基于上述物理过程，算法初始可以控制“温度”，使其候选解有较高的“能量”，此时的状态有较强的全局寻优能力
%随着温度的降低，则逐渐收敛，最终找到最优解或接近最优解。
clear;
close all;
clc;
func = funccollect().func2;
D = 10;
Xs = 10;
Xx = -10;
%%%%%%%%%%%%%冷却表参数%%%%%%%%%%%%%%%%
L = 200;
k = 0.998;
S = 0.01;
T = 100;
YZ = 1e-8;
P = 0; %Metroplis过程中总接受点
%循环的思路：迭代受到两个方面的影响，当前最优解和上次最优解的差值小于阈值并且温度小于0.01
PreX = rand(D,1)*(Xs-Xx)+Xx;
PreBestX = PreX; %上一次最优解
PreX = rand(D,1)*(Xs-Xx)+Xx;
BestX = PreX; %这一次最优解
data = abs(func(PreBestX)-func(BestX));
while (data>YZ)&&(T>0.01)
    %进入循环
    T = k*T;
    for i = 1:L
        NextX = PreX + S*(rand(D,1)*(Xs-Xx)+Xx);%新解是在原来解的基础上进行变异
        %对其进行初始化
        for j = 1:D
            %if NextX(j)>Xs || NextX(j)<Xx
            while NextX(j)>Xs || NextX(j)<Xx %这里有问题，还会可能出现越界情况
                NextX(j) = PreX(j) + S*(rand*(Xs-Xx)+Xx);
            end
        end
        %进行与当前最优解进行判断
        if func(BestX)>func(NextX)
            PreBestX = BestX;
            BestX = NextX; %保存这次循环的（1-L）最优解和次最优解
        end
        %根据与上一次结果进行比较，
        if func(PreX)>func(NextX)
            %直接留下来做下次循环1-L的位置
            PreX = NextX;
            P = P+1;
        else
            %否则按照退火规则进行
            changer = -1*(func(NextX)-func(PreX))/T;
            p1 = exp(changer);
            if p1 > rand %温度越高越有较大的可能接受较差的解
                PreX = NextX;
                P = P+1;
            end
        end
        trace(P+1) = func(BestX);
    end
    data = abs(func(PreBestX)-func(BestX)); %这里也有问题，如果进行一次马可夫链循环，最优解和次最优解的小于阈值，不就停了吗，但是还远远没有达到最优解收敛

end
figure
plot(trace);
xlabel('迭代次数')
ylabel('目标函数')
title('SA算法')