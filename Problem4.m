close all;
clear;
clc;

raw = importdata("diabetes.csv"); % assumes csv file is in same directory
data = raw.data;
title = raw.textdata;
[~,ax] = plotmatrix(data(:,1:end)); % ignore all parameters except subplot axes
% ax in this case is a K x K (K columns being plotted) matrix of axes for each subplot
font = 12; % font size
% Formatting subplots - you can also make your own array of titles like title = {'one', 'two', 'three'...}
for i = 1:length(ax)
ax(i,1).YLabel.String = title(i);
ax(i,1).YLabel.FontSize = font;
ax(end,i).XLabel.String = title(i);
ax(end,i).XLabel.FontSize = font;
end