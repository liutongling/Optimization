clear all; %清楚所有变量
close all; %清图
clc;       %清屏幕
D = 10;    %表示基因数目，就是函数有需要十个维度
NP=100;    %表示表示种群或染色体个数
Xs=10;     %表示染色体上限
Xx=-10;    %表示染色体下限
G = 1000;  %表示最大遗传代

f = zeros(D,NP);
nf=zeros(D,NP);
Pc = 0.8;
Pm = 0.1;

f = rand(D,NP)*(Xs-Xx)+Xx;




%%%%%%%%%%%%%%%%%按照适应度升序排序%%%%%%%%%%%%%%%%%%
for np = 1:NP
    FIT(np) = func2(f(:,np));
end

[SortFIT,index] = sort(FIT);
Sortf = f(:,index);
%%%%%%%%%%%%%%%%%遗传算法循环%%%%%%%%%%%%%%%%%%
for gen =1:G
    Emper = Sortf(:,1);%君主染色体,最优的那个种群第一个
    NoPoint = round(D*Pc); %计算要有几个染色体进行交叉
    PoPoint = randi([1 D],NoPoint,NP/2); %交叉基因的位置
    nf = Sortf; %表示通过交叉变异产生新种群
    for i = 1:NP/2
        nf(:,2*i-1) = Emper;%让奇数等于君主
        nf(:,2*i) = Sortf(:,2*i);%偶数等于顺序排列
        %开始进行交叉变异
        %变异规则是让奇数交换偶数的染色体基因，偶数染色体变异君主染色体基因
        for k = 1:NoPoint
            nf(PoPoint(k,i),2*i-1) = nf(PoPoint(k,i),2*i);
            nf(PoPoint(k,i),2*i) = Emper(PoPoint(k,i));
        end
    end
    %%%%%%%%%%%%%%%%%变异操作%%%%%%%%%%%%%%%%%%
    for m=1:NP
        for n =1:D
            r = rand(1,1);%随机生成变异率，判断是否需要变异
            if r<Pm
                nf(n,m) = rand(1,1)*(Xs-Xx)+Xx;
            end
        end
    end
    %%%%%%%%%%%%%%%%%自种群按适应度升序排序%%%%%%%%%%%%%%%%%%
    
    for np=1:NP
        NFIT(np) = func2(nf(:,np));
    end
    [NSortFIT,Index] = sort(NFIT);%将生成的值进行排序，并且包括序号
    NSortf = nf(:,Index);% 
    %%%%%%%%%%%%%%%%%产生新的种群%%%%%%%%%%%%%%%%%%
    %思想：将新生成的nf种群与原种群按照适应值进行排序，取前NP个作为新种群
    f1 = [Sortf,NSortf];
    FIT1 = [SortFIT,NSortFIT];
    [SortFIT1,Index1] = sort(FIT1);
    %根据索引找到种群
    SortF1 = f1(:,Index1);
    SortFIT = SortFIT1(:,1:NP);
    Sortf = SortF1(:,1:NP);
    trace(gen) = SortFIT(1);
end

Bestf = Sortf(:,1);
trace(end) 
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度变化曲线')


