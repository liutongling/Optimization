%%%%%%%%%%%基础蚁群算法%%%%%%%%%%%%%

%基础理论：
%蚁群算法是一种启发式算法，受到自然界蚁群寻找食物的启发，创新提出蚁群算法
%自然界中蚁群寻找食物，每个蚂蚁个体均独自寻找食物，在寻找食物的过程中会在路径上
%散播信息素，每只蚂蚁在寻找食物的过程中又会倾向于信息素较多的路径作为较大概率的选择寻找食物
%根据上述的启发，创新提出蚁群算法。
%%%%%%%%%%%蚁群算法解决旅行商问题%%%%%%%%%%%%%
%%%%%%%%%%%基础参数设置%%%%%%%%%
clear;
close all;
clc;
m = 50; %蚂蚁数量
Alpha = 1;%信息素重要程度
Beta = 5;%期望程度
Rho=0.1;%信息素蒸发系数
G = 200;%最大迭代次数
Q = 100;%信息素增加强度系数
C = [1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;...
    3238 1229;4196 1044;4312  790;4386  570;3007 1970;2562 1756;...
    2788 1491;2381 1676;1332  695;3715 1678;3918 2179;4061 2370;...
    3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;...
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;...
    2370 2975];                 %31个省会城市坐标%三个点表示下一行继续
cityNum = size(C,1);%城市个数
%计算出所有城市的举例%
dis = zeros(cityNum,cityNum);%存储城市之间的距离
for i = 1:cityNum
    for j = i:cityNum
        if i~=j
            dis(i,j) = ((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
            dis(j,i) = dis(i,j);
        else
            dis(i,j) = eps;%eps表示最小精度，并且不等于零
        end

    end
end
Eta = 1./dis;%表示距离期望
Tau = ones(cityNum,cityNum);
Tabu = zeros(m,cityNum);
NC = 1;
R_best = zeros(G,cityNum);%记录各代最优解的路径
L_best = inf.*ones(G,1); %记录各代的最优解

figure(1); %把最优解画出来
while NC <= G
    %%%%%%%%%%%%%%第二步：将m只蚂蚁放到n个城市上%%%%%%%%%%%%%%%%%%%%%%%
    %一般选择m>n，因此是需要多循环几次
    Randpos = [];
    for i = 1:(ceil(m/cityNum))
        Randpos = [Randpos,randperm(cityNum)];

    end
    Tabu(:,1) = (Randpos(1,1:m))';
    %%%%%%%%%%%%%%%第三步：m只蚂蚁按概率函数选择下一座城市，完成各自的周游%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=2:cityNum %表示每只第下次选择的城市
        for i = 1:m
            %首先，先把拜访的城市提出来
            visited = Tabu(i,1:(j-1));%注意matlab的切片是包括首和尾索引
            
            J = zeros(1,(cityNum-j+1));%剩下还需要几个城市需要选择
            P = J;
            Jc = 1;
            for k = 1:cityNum%统计剩下待选城市，记录下来计算概率用
                if length(find(visited==k))==0
                    J(Jc) = k;
                    Jc = Jc+1;
                end
            end
            %计算待选城市的概率
            %根据计算概率公式，从Tau中获得信息素，从L中获得每个城市期望，计算得到概率
            %disp(visited);
            for k = 1:length(J)
                P(k) = (Tau(visited(end),J(k))^Alpha)...
                    *(Eta(visited(end),J(k))^Beta);
            end
            P = P/(sum(P));
            fprintf("当前的%d\n",j);
            disp("start");
            disp(P);
            disp("finsh");
            %%%%%%%%%%%%%%%%%%按照概率原则选择下一个城市%%%%%%%%%%%%%%%%%%%%%
            Pcum = cumsum(P);
            Select = find(Pcum>=rand);
            disp("start1");
            disp(Pcum);
            disp("finsh1");
            to_visit=J(Select(1));
            Tabu(i,j)=to_visit;



        end
    end

    %%%%%%%%%%注意保留最优秀的那个个体%%%%%%%%%%
    if NC>=2
        Tabu(1,:) = R_best(NC-1,:);
    end
    %%%%%%%%%%%%%%%%%%第四步：记录本次迭代最佳路线%%%%%%%%%%%%%%%%%%%%%%%%%
    %根据距离表，计算出m只蚂蚁所有的距离算出最优路径，以及最小距离
    L = zeros(m,1);
    for i =1:m
        for j =1:cityNum-1
            L(i) = L(i)+dis(Tabu(i,j),Tabu(i,j+1));
        end
        L(i) = L(i)+dis(Tabu(i,cityNum),Tabu(i,1));
    end
    %%%%%%%%%%找到最短的距离%%%%%%%%%%%
    L_best(NC) = min(L);
    pos = find(L_best(NC)==L);
    R_best(NC,:) = Tabu(pos(1),:);
    %%%%%%%%%%%%%%第五步：更新信息素%%%%%%%%%%%%%%%%%%%%%%
    Delta_Tau = zeros(cityNum,cityNum);
    for i = 1:m
        for j = 1:cityNum-1
            Delta_Tau(Tabu(i,j),Tabu(i,j+1)) = Delta_Tau(Tabu(i,j),Tabu(i,j+1)) + Q/L(i);
        end
        Delta_Tau(Tabu(i,cityNum),Tabu(i,1)) = Delta_Tau(Tabu(i,cityNum),Tabu(i,1)) + Q/L(i);
    end
    %计算信息素
    for i = 1:cityNum
        for j = 1:cityNum
            Tau(i,j) = Tau(i,j)*Rho + Delta_Tau(i,j);
        end
    end
    Tabu = zeros(m,cityNum);
    NC=NC+1;
end



plot(L_best);
xlabel('迭代次数')
ylabel('目标函数')
title('DE算法')