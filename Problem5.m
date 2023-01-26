close all;
clear;
clc;

data = readmatrix("nba_height_weight.csv");
height = data(:,1);
weight = data(:,2);

sumH = sum(height);
sumH2 = sum(height.^2);
sumW = sum(weight);
sumHW = sum(height.*weight);

A = [size(height,1) sumH; sumH sumH2];
B = [sumW; sumHW];
coeff = A\B;
line = @(x) coeff(1,1) + coeff(2,1)*x;
figure
scatter(height,weight);
hold
fplot(line,[min(height), max(height)])

sumH3 = sum(height.^3);
sumH4 = sum(height.^4);
sumH2W = sum((height.^2).*weight);

A2 = [size(height,1) sumH sumH2; sumH sumH2 sumH3; sumH2 sumH3 sumH4];
B2 = [sumW; sumHW; sumH2W];
coeff2 = A2\B2;
poly = @(x) coeff2(1,1) + coeff2(2,1)*x + coeff2(3,1)*(x^2);
figure
scatter(height,weight);
hold
fplot(poly,[min(height), max(height)])
