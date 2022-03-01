clear all;
clc;

% Failo nuskaitymas
[file,path] = uigetfile('*.wav');
filename = fullfile(path, file);

% Audio iraso informacijos nuskaitymas pasinaudojant matlab pagalbinemis
% funkcijomis
info = audioinfo(filename);
[y,Fs] = audioread(filename);

% Susidarome laiko asi - signalo ilgi padaliname is diskretizacijos daznio 
% ir padauginame is 1000, kad gautume laika sekundemis
t = linspace(0,length(y)/Fs,length(y));
t = t * 1000;

% Atvaizduojame pagrindines garso signalo charakteristikas -
% diskretizacijos dazni, kanalu skaiciu ir kvantavimo bitu skaiciu
fprintf('Diskretizavimo daznis - %d Hz\n',Fs);
fprintf('Kvantavimo bitu skaicius - %d b\n',info.BitsPerSample);
fprintf('Kanalu skaicius - %d\n', info.NumChannels);


% Signalu atvaizdavimas jei jis turi 1 kanala
if info.NumChannels == 1
% Breziame nauja figura
figure(1)
subplot(2,1,1);
plot(t,y);
xlabel('Laikas, ms');
ylabel('s(t)');
title('Pasirinktas garso failas');
grid on;

% Vartotojo ivesties skaitymas - leidziama vartotojui ivesti pradzia ir
% pabaiga
prompt = {'Atkarpos pradzia:','Atkarpos pabaiga:'};
dlgtitle = 'Garso iskirpimas (milisekundemis)';
dims = [1 35];
definput = {'0','1'};
dialog = inputdlg(prompt,dlgtitle,dims,definput);
input = str2double(dialog); % dialog vertes verciu i masyva
start = input(1);
finish = input(2);

% Pagal vartotojo ivestyje gautus duomenis susidarome logini masyva kuri
% naudosime mums norimu reiksmiu isgavimui
segment = ((t) >= start) & ((t) < finish);
t2 = t(segment);
y2 = y(segment);

% Atvaizduojame nauja iskirpta grafika
subplot(2,1,2);
plot(t2-start, y2);
xlabel('Laikas, ms');
ylabel('s(t)');
title('Iskirpta garso failo atkarpa');
grid on;

% Issaugojame faila
[file, path, index] = uiputfile('new_signal.wav');
audiowrite(strcat(path,file), y2, Fs);

end

% Signalo atvaizdavimas jei jis turi 2 kanalus (stereo)
if info.NumChannels > 1
    figure(2);
    subplot(4,1,1);
    % Atvaizduojame pirma kanala, del to imame tik pirmaji 2D masyvo masyva 
    plot(t,y(:, 1));
    xlabel('Laikas, ms');
    ylabel('s(t)');
    title('Pasirinktas garso failas. 1 kanalas');
    grid on;

    subplot(4,1,2);
    % Imame antraji 2D masyvo masyva, nes 2 kanalas
    plot(t,y(:, 2));
    xlabel('Laikas, ms');
    ylabel('s(t)');
    title('Pasirinktas garso failas. 2 kanalas');
    grid on;

    prompt = {'Atkarpos pradzia:','Atkarpos pabaiga:'};
    dlgtitle = 'Garso iskirpimas (milisekundemis)';
    dims = [1 35];
    definput = {'0','1'};
    dialog = inputdlg(prompt,dlgtitle,dims,definput);
    input = str2double(dialog);
    start = input(1);
    finish = input(2);
    
    % Vel taip pat susidedame logikini masyva pagal kuri istrauksime mums
    % norimas reiksmes
    segment = ((t) >= start) & ((t) < finish);
    t2 = t(segment);
    % 1 kanalas
    y2 = y(segment, 1);
    % 2 kanalas    
    y3 = y(segment, 2);


    subplot(4,1,3);
    % Breziame grafika kur laikas yra is viso laiko atimus jo pradzia
    plot(t2-start,y2);
    xlabel('Laikas, ms');
    ylabel('s(t)');
    title('Pasirinktas garso failo atkarpa. 1 kanalas');
    grid on;


    subplot(4,1,4);
    plot(t2-start,y3);
    xlabel('Laikas, ms');
    ylabel('s(t)');
    title('Pasirinktas garso failo atkarpa. 2 kanalas');
    grid on;

    % Issaugome faila
    [file, path, index] = uiputfile('new_signal_stereo.wav');
    audiowrite(strcat(path,file), y2, Fs);
end

