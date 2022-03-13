clear all
% 1 punktas
[file,path] = uigetfile('*.wav');
filename = fullfile(path, file);
info = audioinfo(filename);
[y,Fs] = audioread(filename);
t = linspace(0,length(y)/Fs,length(y));
t = t *1E+3;
subplot(2,1,1);
plot(t,y);

% 2 punktas - energijos diagrama kadrais
frameLength = 20;
numberOfFrames = floor(length(y)/frameLength);
frames = buffer(y,numberOfFrames, 10);                         % Matrix Of Signal Segments

y_pwr = sum(frames.^2)/numberOfFrames;


subplot(2, 1, 2);
plot(y_pwr);

% y_pwr = sum(y_seg.^2);
