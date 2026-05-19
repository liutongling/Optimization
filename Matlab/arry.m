clear ;
close all;
clc;
x = 0:0.01:10;
y = x+10*sin(5*x)+7*cos(4*x);
plot(x,y)
xlabel('x');
ylabel('f(x)');
title('f(x) = ');
nn = 5;
randperm(nn)
