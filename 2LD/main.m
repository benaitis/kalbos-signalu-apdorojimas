clear all
% 1 punktas
[file,path] = uigetfile('*.wav');
filename = fullfile(path, file);
info = audioinfo(filename);
[y,Fs] = audioread(filename);
t = linspace(0,length(y)/Fs,length(y));
t = t *1E+3;
subplot(2,2,1);
plot(t,y);

% 2 punktas - energijos diagrama kadrais
frameLength = 20;
numberOfFrames = floor(length(y)/frameLength);
frames = buffer(y,numberOfFrames, 10);                         % Matrix Of Signal Segments

y_pwr = sum(frames.^2)/numberOfFrames;

subplot(2, 2, 2);
plot(y_pwr);

% 3 punktas - zero crossing rate
rate = zerocrossrate(frames);
subplot(2, 2, 3);
plot(rate);

% 4 punktas
prompt = {'Atkarpos pradzia:','Atkarpos pabaiga:'};
dlgtitle = 'Garso iskirpimas (milisekundemis)';
dims = [1 35];
definput = {'0','1'};
dialog = inputdlg(prompt,dlgtitle,dims,definput);
input = str2double(dialog); % dialog vertes verciu i masyva
start = input(1);
finish = input(2);

segment = ((t) >= start) & ((t) < finish);
t2 = t(segment);
y2 = y(segment);

subplot(2,2,4);
plot(t2-start, y2);
xlabel('Laikas, ms');
ylabel('s(t)');
title('Iskirpta garso failo atkarpa');
grid on;




