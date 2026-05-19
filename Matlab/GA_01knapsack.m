clear;
close all;
clc;
func = funccollect;
V = 300;
C = [95,75,23,73,50,22,6,57,89,98];
W = [89,59,19,43,100,72,44,16,7,64];
NP = 50; %随机生成50个
G = 100;
L = size(C,2);
n = randi([0,1],NP,L);
nn = randi([0,1],NP,L);
afa = 2;
result = zeros(NP,1);
Pc = 0.8;%交叉率
Pm = 0.05;%变异率
trace = zeros(1,G);
for k = 1:G
    for i = 1:NP
        result(i) = func.func3(n(i,:),W,C,V,afa);
    end
    %%%%%%%%%%%%%%%对结果进行归一化处理
    %进行线性变化当作其概率
    maxVal = max(result);
    minVal = min(result);
    fidx = find(result==maxVal);%保留最优的个体
    fBest = n(fidx(1,1),:);
    result = (result-minVal)/(maxVal-minVal);% 进行归一化
    sum_re = sum(result); 
    result = result/sum_re;%转换成概率
    result = cumsum(result);%进行累加，便于进行轮盘赌操作
    %%%%基于轮盘赌的选择%%%%
    randlist = rand(NP,1);%生成相应的概率
    randlist = sort(randlist);
    nnidx = 1;
    oldidx = 1;
    while nnidx<NP
        if randlist(nnidx)<result(oldidx)
            nn(nnidx,:) = n(oldidx,:);
            nnidx = nnidx + 1;
        else
            oldidx = oldidx + 1;
        end
    end
    %%%%%%%%%%%%%进行交叉操作%%%%%%%%%%%%%
    %如果随机数允许交叉，则将相邻的个体进行交叉
    for j = 1:2:NP
        r = rand;
        if r < Pc %允许交叉
            loc = randi([0,1],1,L);%随机位置进行交换
            for i=1:L
                if loc(i)==1
                    temp = nn(j,i);
                    nn(j,i) = nn(j+1,i);
                    nn(j+1,i) = temp;
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%进行变异操作%%%%%%%%%%%%%
    for i = 1:NP
        %如果小于其变异率则进行变异
        for j = 1:L
            r = rand;
            if r<Pc%如果该基因变异率小于Pc,进行变异
                nn(i,j) = ~nn(i,j);
            end
        end
        
    end
    n =nn;
    n(1,:) = fBest;
    trace(k) = maxVal;
        
end
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数')
title('适应度进化曲线')


