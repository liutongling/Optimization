
% 使用遗传算法解决TSP（旅行商问题）
clear all;
close all;
clc;
C = [1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;...
    3238 1229;4196 1044;4312  790;4386  570;3007 1970;2562 1756;...
    2788 1491;2381 1676;1332  695;3715 1678;3918 2179;4061 2370;...
    3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;...
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;...
    2370 2975];                 %31个省会城市坐标%三个点表示下一行继续
N = size(C,1);
D = zeros(N);
%%%%%%%%%%%%%%%%%%求任意两个城市距离间隔矩阵%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    for j=1:N
        D(i,j)=((C(i,1)-C(j,1))^2 + (C(i,2)-C(j,2))^2)^0.5;
    end
end
%%%%%%%%%%%%%%%%%%遗传算法的参数设置%%%%%%%%%%%%%%%%%%%%%%%%%%
NP = 200; %表示种群数量
G = 1000; % 表示遗传（循环）多少代
f = zeros(NP,N); % 存储种群
F = []; %更新中间存储
for i = 1:NP
    f(i,:)=randperm(N); %随机生成初始种群
end
R = f(1,:); %存储最优种群
len = zeros(NP,1); %存储路径长度
fitness = zeros(NP,1); % 存储归一化适应值
gen = 0;

%%%%%%%%%%%%%%%%%%遗传算法循环%%%%%%%%%%%%%%%%%%%%%%%%%%
while gen < G
    %计算所有解的路径长度%
    for i = 1:NP
        %旅行商问题是从源点出发再回到源点，因此知道所有城市的排序之后，还需要计算从终点到源点的路径
        len(i,1) = D(f(i,N),f(i,1));
        for j = 1:(N-1)
            len(i,1) =len(i,1)+ D(f(i,j),f(i,j+1));
        end
    end
    %求所有可能解的最大值和最小值，方便进行归一化操作
    maxlen = max(len);
    minlen = min(len);
    %%%%%%%%%%%%更新最短路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rr = find(len==minlen);
    R = f(rr(1,1),:);
    %%%%%%%%%%%%计算归一化适应值%%%%%%%%%%%%%%%%%%%%%%%%%
    %计算适应度值，值越大效果越好
    for i = 1:length(len)
        fitness(i,1) = (1-((len(i,1)-minlen)/((maxlen-minlen)+0.001)));
    end
    %%%%%%%%%%%%选择操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %思路：根据算法设置，会筛选相对较好的若干个个体，
    %具体实现：适应度与选择的概率进行对比判断该个体是否需要被选择
    nn = 0;
    for i = 1:NP
        if fitness(i,1)>=rand
            nn = nn+1;
            F(nn,:) = f(i,:);
            
        end
    end
    [aa,bb] = size(F); %求出F选择多少个
    %进行交叉操作和变异操作
    while aa < NP
        nnper = randperm(nn);%用于随机产生任意两个进行交叉
        A = F(nnper(1),:);
        B = F(nnper(2),:);
        %交叉点个数
        W = ceil(N/10);
        p = unidrnd(N-W+1);
        for i=1:W
            x = find(A==B(p+i-1));
            y = find(B==A(p+i-1));
            %交叉选择的位置
            temp = A(p+i-1);
            A(p+i-1) = B(p+i-1);
            B(p+i-1) = temp;
            %此时会有重复的，A中的位置会有重复的
            temp = A(x);
            A(x)= B(y);
            B(y) = temp;
        end
        %%%%%%%%%%%%%%%%进行变异操作%%%%%%%%%%%
        %思路：就是找两个位置将其进行交换，必须要交换，因为TSP问题是排列组合问题
        p1 = floor(1+N*rand);
        p2 = floor(1+N*rand);
        while p1 == p2
            p1 = floor(1+N*rand);
            p2 = floor(1+N*rand);
        end
        temp = A(p1);
        A(p1) = A(p2);
        A(p2) = temp;
        temp = B(p1);
        B(p1) = B(p2);
        B(p2) = temp;
        %将新生成的假如到新种群中
        F = [F;A;B];
        [aa,bb] = size(F);


    end
    if aa>NP
        F = F(1:NP,:);
    end
    f = F;
    clear F;
    f(1,:) = R;%保留最优个体
    gen = gen+1;
    Rlength(gen) = minlen;
    
end
figure
for i=1:N-1
    plot([C(R(i),1),C(R(i+1),1)],[C(R(i),2),C(R(i+1),2)],'bo-');
    hold on;
end
plot([C(R(N),1),C(R(1),1)],[C(R(N),2),C(R(1),2)],'ro-');
title(['优化最短距离:',num2str(minlen)]);
figure
plot(Rlength)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')