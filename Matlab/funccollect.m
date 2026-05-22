function Funcollect = funccollect
    Funcollect.func2 = @func2;
    Funcollect.func3 = @func3;
    Funcollect.func4 = @func4;
    Funcollect.func5 = @func5;
end
%%%%%%%%%%%%%%%%0-1背包问题适应度函数%%%%%%%%%%%%%%%%%%%%%%
%x表示物品选择是否向量
%W物品价值向量
%C物品体积向量
%超过背包承重惩罚系数
function fit = func2(x)
fit = sum(x.^2);
end
function fit = func3(x,W,C,V,afa)
Toally = sum(x.*C);
fit = sum(x.*W);
if Toally>V
    fit = fit -(afa*(Toally-V));
end
end

function result = func4(x,u,v)
a = 1/(v*(2*pi)^0.5);
b = -((x-u).^2)/(2*v^2);
result = a*exp(b);
end

function result =func5(x)
result = 1/(pi*(1+x.^2));
end
