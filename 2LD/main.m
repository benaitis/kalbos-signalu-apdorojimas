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
frameLength = floor(0.02 * Fs); % 0.02ms * Fs = kadro ilgis milisekundemis 
overlap = floor(0.01 * Fs);
frames = buffer(y,frameLength, overlap); % Matrix Of Signal Segments
y_pwr = sum(frames.^2)/frameLength; % - daliname is kadro ilgio

subplot(2, 2, 2);
plot(y_pwr);

% 3 punktas - zero crossing rate
% Nusako kuriose vietose signalas labai greitai perzengia 0 reiksmes
% Jei perzengia greitai, tai tikriausiai bus priebalse kazkokia arba
% triuksmas




% rate = zerocrossrate(frames);
% subplot(2, 2, 3);
% plot(rate);

frameSize = size(frames);
frameRow = frameSize(1);
frameColumn = frameSize(2);
zero_cross_rate = zeros(1, frameColumn);    

for column = 1:frameColumn
    val = 0;
    for row = 2:frameRow

        xn2 = frames(row, column);
        xn = frames(row-1, column);

        sxn = 1;
        sxn2 = 1;
        if (xn < 0)
            sxn= -1;
        end

        if (xn2 < 0)
            sxn2 = -1;
        end

        val = val + abs(sxn2-sxn);
    end
    zero_cross_rate(column) = val/frameColumn;
end

subplot(2, 2, 3);
plot(zero_cross_rate);

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

% subplot(2,2,4);
% plot(t2-start, y2);
% xlabel('Laikas, ms');
% ylabel('s(t)');
% title('Iskirpta garso failo atkarpa');
% grid on;

% 5 punktas
% Apskaičiuoti ir pateikti signalo atkarpos autokoreliacijos funkcijos laiko diagramą
% (autokoreliacijos funkcijos reikšmes normuokite)

r = xcorr(y2);
subplot(2,2,4);
plot(r);

% 6 punktas
% findpeaks
% find



