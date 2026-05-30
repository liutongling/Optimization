clear ;
close all; %清图
clc;
func = funccollect().func2;
x = ones(1,10);
t = func(x);
t