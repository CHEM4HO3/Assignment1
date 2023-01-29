close all;
clear;
clc;

data = readmatrix("thermal_efficiency.csv");

p = data(:, 1);
sr = data(:, 2);
sysEff = data(:, 3);
scatter3(p, sr, sysEff, 10, "filled");
hold on
n = 1/0.2;

pTr = p;
pTr(n:n:end,:) = [];
srTr = sr;
srTr(n:n:end,:) = [];
sysEffTr = sysEff;
sysEffTr(n:n:end,:) = [];

pTe = p(n:n:end,:);
srTe = sr(n:n:end,:);
sysEffTe = sysEff(n:n:end,:);


f1 = @(x1, x2) x1.^4;
f2 = @(x1, x2) x2.^2;
f3 = @(x1, x2) x1.^2;
f4 = @(x1, x2) x2;
f5 = @(x1, x2) 1;


A(1,1) = sum(f1(pTr, srTr).*f1(pTr, srTr));
A(1,2) = sum(f1(pTr, srTr).*f2(pTr, srTr));
A(1,3) = sum(f1(pTr, srTr).*f3(pTr, srTr));
A(1,4) = sum(f1(pTr, srTr).*f4(pTr, srTr));
A(1,5) = sum(f1(pTr, srTr).*f5(pTr, srTr));

A(2,2) = sum(f2(pTr, srTr).*f2(pTr, srTr));
A(2,3) = sum(f2(pTr, srTr).*f3(pTr, srTr));
A(2,4) = sum(f2(pTr, srTr).*f4(pTr, srTr));
A(2,5) = sum(f2(pTr, srTr).*f5(pTr, srTr));


A(3,3) = sum(f3(pTr, srTr).*f3(pTr, srTr));
A(3,4) = sum(f3(pTr, srTr).*f4(pTr, srTr));
A(3,5) = sum(f3(pTr, srTr).*f5(pTr, srTr));

A(4,4) = sum(f4(pTr, srTr).*f4(pTr, srTr));
A(4,5) = sum(f4(pTr, srTr).*f5(pTr, srTr));

A(5,5) = sum(f5(pTr, srTr).*f5(pTr, srTr));

A = A + A' - diag(diag(A)); % <-- This line copies A' to the other triangle of A to save time. We also need to subtract the diagonal cosce we accidentally add it twice :)

% RHS! It is important to use the basis functions IN THE SAME ORDER
b(1,1) = sum(sysEffTr.*f1(pTr, srTr));
b(2,1) = sum(sysEffTr.*f2(pTr, srTr));
b(3,1) = sum(sysEffTr.*f3(pTr, srTr));
b(4,1) = sum(sysEffTr.*f4(pTr, srTr));
b(5,1) = sum(sysEffTr.*f5(pTr, srTr));

coefs = A\b;

surf = @(x1,x2) coefs(1)*f1(x1,x2) + coefs(2)*f2(x1, x2) + coefs(3)*f3(x1,x2) + coefs(4)*f4(x1,x2) + coefs(5)*f5(x1, x2);
fsurf(surf,[min(p) max(p) min(sr) max(sr)]);
xlabel("Pressure (bar)");
ylabel("Steam Rate (kmol/hr)");
zlabel("System Efficiency (%)")

yHatTr = surf(pTr, srTr);
yBarTr = sum(sysEffTr)/length(sysEffTr);
rSqTr = 1 - sum((yHatTr-sysEffTr).^2)/sum((sysEffTr-yBarTr).^2)

yHatTe = surf(pTe, srTe);
yBarTe = sum(sysEffTe)/length(sysEffTe);
rSqTe = 1 - sum((yHatTe-sysEffTe).^2)/sum((sysEffTe-yBarTe).^2)

XY = fminsearch(@(b)-surf(b(1),b(2)), [10;1000])
surf(XY(1),XY(2))
