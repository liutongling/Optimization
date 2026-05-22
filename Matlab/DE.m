%差分进化算法%
%基本的差分进化算法的流程
%（1）初始化
%（2）变异
%（3）交叉
%（4）选择
%（5）边界条件处理
%已解决sum(xi^2)函数为例
%初始化相关参数
clear;
close all;
clc;
G = 200; %最大的迭代数
D = 10;
F0 = 0.4; % 变异算子,根据不同的文献，变异算子可以根据迭代次数进行动态修改，
         %修改原则是：迭代前期可以跳变幅度大一些，随着迭代次数增加，跳变幅度则减弱
         %谈谈对F变异算子的理解：DE（differential Evolution）算法本质上理解，是
         %通过不同个体之间的差距当作方向，来指导种群进化的方向。因为每次都会保留较优
         %的个体，因此差距方向，会筛选往最优解方向。通过不断的迭代直至找到接近最优解，或是最优解。
NP = 50; %表示种群数
CR = 0.1;%交叉算子
Xs = 10;%函数上界
Xx = -10;%函数下界
yz = 10^-6;%循环的阈值
func = funccollect().func2;
%%%%%%%%%%%%%%%%%对种群进行初始化%%%%%%%%%%%%%%%%%%%%%%

v = zeros(D,NP);
u = zeros(D,NP);
x = rand(D,NP)*(Xs-Xx)+Xx;
Val1 = zeros(1,NP);
Val2 = zeros(1,NP);
for i = 1:NP
    Val1(i) = func(x(:,i));
end
trace = zeros(1,G);
for k = 1:G
    lmda = exp(1-(G/(G+1-k)));
    F = F0*2^lmda;

    %%%%%%%%%%%%%选择三个r1,r2,r3互不相同，并且与更新代m也不同%%%%%%%%%%%%%%
    for m=1:NP
        r1 = randi([1,NP],1,1);
        while r1==m
            r1 = randi([1,NP],1,1);
        end
        r2 = randi([1,NP],1,1);
        while (r2==m)||(r2==r1)
            r2 = randi([1,NP],1,1);
        end
        r3 = randi([1,NP],1,1);
        while (r3==m)||(r3==r2)||(r3==r1)
            r3 = randi([1,NP],1,1);
        end
        %%%%%%%%%%%%%根据De(rand/1/bin)进行更新新值%%%%%%%%%%%%%%%%%%
        v(:,m) = x(:,r1) + F*(x(:,r2) -x(:,r3));
    end
    randomj = rand(1,NP);
    for m =1:D
        j = randi([1,D],1,1);
        if randomj(m)<=CR || j==m
            u(m,:) = v(m,:);
        else
            u(m,:) = x(m,:);
        end

    end
    %%%%%%%%%%%进行筛选u和x如果当前比较小则留%%%%%%%%%%
    for m = 1:NP
        Val2(m) = func(u(:,m));
        if Val2(m) < Val1(m)
            x(:,m) = u(:,m);
        end
    end
    for m = 1:NP
        Val1(m) =func(x(:,m));
    end
    trace(k) = min(Val1);
    if trace(k)<yz
        break
    end
   
    
end


[sortVal,Index] = sort(Val1);
idx = x(:,Index);
y = sortVal(1);
x = idx(:,1);
%%%%%%%%%%%%%%%%%绘图%%%%%%%%%%%%%%
figure
plot(trace);
xlabel('迭代次数')
ylabel('目标函数')
title('DE算法')