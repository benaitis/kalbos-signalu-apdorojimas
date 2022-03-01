clear all
[file,path] = uigetfile('*.wav');

filename = fullfile(path, file);

info = audioinfo(filename);

[y,Fs] = audioread(filename);
t = linspace(0,length(y)/Fs,length(y));
t = t *1E+3;
subplot(2,1,1);
plot(t,y);

fprintf('Diskretizavimo daznis - %d Hz\n',Fs);
fprintf('Kvantavimo bitu skaicius - %d b\n',info.BitsPerSample);

prompt = {'Atkarpos pradzia:','Atkarpos pabaiga:'};
dlgtitle = 'Garso iskirpimas (milisekundemis)';
dims = [1 35];
definput = {'0','1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
ivestisMS = str2double(answer);

gabaliukas = [ivestisMS(1) / 1000 * Fs + 1, ivestisMS(2) / 1000 * Fs];

[y2,Fs2] = audioread(filename, gabaliukas);
t2 = linspace(0,length(y2)/Fs2,length(y2));
t2 = t2 *1E+3;
subplot(2,1,2);
plot(t2,y2);

