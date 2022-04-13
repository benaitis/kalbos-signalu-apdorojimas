clear all
% close all
% 1 punktas
[file,path] = uigetfile('*.wav');
filename = fullfile(path, file);
info = audioinfo(filename);
[y,Fs] = audioread(filename);
t = linspace(0,length(y)/Fs,length(y));
t = t *1E+3;
figure(1);
subplot(2,2,1);
plot(t,y);
title('Signalas');
xlabel('Laikas, ms');
ylabel('s(t)');

% 2 punktas
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

subplot(2,2,2);
plot(t2-start, y2);
xlabel('Laikas, ms');
ylabel('s(t)');
title('Iskirpta garso failo atkarpa');
grid on;


% 3 punktas
% FFT - spektras
full_spectre = abs(fft(y2));
spectre = full_spectre(1:length(full_spectre)/2);
spectre_hz = linspace(0, Fs/2, length(spectre));
subplot(2,2,3);
plot(spectre_hz, spectre);
xlim([0 5000]);
xlabel('Hz');
ylabel('Amplitude');
title('Atkarpos spektro diagrama');


% 4 punktas
% Kepstras
% signalo Furjė transformacijos logaritmo atvirkštinę Furjė transformaciją
% find(x == max(x))
% ifft
full_kepstre = abs(ifft(log10(spectre)));
kepstre = full_kepstre(1:length(full_kepstre)/2);
kepsre_t = [0:length(kepstre)-1]/Fs;
% linspace(0,(length(kepstre)-1)/Fs)
subplot(2,2,4);
plot(kepstre);
title('Atkarpos kepstro diagrama');

% 5 punktas
% is kepstro ieskom max
% bet pradzioje atmetu pirmas ~20 reiksmes (nes kepstras pradzioj is labai
% auksto krenta,o po to toli kazkur max buna. ji ir reikia rasti
% taip yra todel, kad 1 dalis (pirmas max) nusako ka sako (kokia raide
% tarkim)
% o toliau zmogaus kalbos charakteristikas (tembra, tona)
% find(x == max(x(20:end)))
% kai randam max x, tai tada y = laiko momentas kazkoks
% tai daznis = atvirkstinis t0. 1/t0
% peaks = findpeaks(kepstre(20:end));
% max1Index = find(kepstre == max1);
maxIndex = find(kepstre == max(kepstre(25:end)));
maxTime = kepsre_t(maxIndex);
frequency = 1/(maxTime);
disp('pagrindinio tono daznis - ' + frequency);


% 6 punktas
% Formante - tai harmonika (labiau raudona, daugiau energijos
% skeptogramoje) kuri nusako apie garsa (a, e, y)
% Harmonika - labiau nusako apie balsa - tembra, tona ir pns.
% kur matosi reziai - vokalizuoti garsai
% kur nesimato - nevokalizuoti arba gal isvis nera
% trajektorija - tos linijos
frameMs = 16;%ms
frameLengthInSamples = round(frameMs / 1000 * info.SampleRate); %kadro ilgis in sample
crossover = floor(frameLengthInSamples / 2);

signal = buffer(y, frameLengthInSamples, crossover);
[rows, columns] = size(signal);

tempFFT = abs(fft(signal(:,1)));
tempLenght = floor(length(tempFFT)/2);

spectogram = zeros(tempLenght,columns);

for i = 1:columns
    signalFFT = abs(fft(signal(:,i)));
    signalFFTLength = floor(length(signalFFT)/2);
    temp = signalFFT(1:signalFFTLength);
    spectogram(:,i) = temp;
end

figure(2);
title('Spektograma');
imagesc(flipud(1-spectogram));
colormap parula


