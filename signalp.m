clear;
clc;
close all;

for i= 1: 3
    switch i
        case 1
            file= 'measurement/OpenB2/main.edf';
        case 2
            file= 'measurement/OpenB2/pos1.edf';
        case 3
            file= 'measurement/OpenB2/pos2.edf';
    end
    info= edfinfo(file);
    signal= edfread(file, 'SelectedSignals','EMGBITREV');
    fs = info.NumSamples/seconds(info.DataRecordDuration);
    data_carray= table2array(signal);
    data= vertcat(data_carray{:});
    
    t= 0: 1/fs: (length(data)-1)*(1/fs);
    L= length(data);
    f= (0:L/2)*(fs/L);
    
%     if i==1
%         T= 1/fs;
%         d= t>= 10;
%         d1= t>= 10 & t<= 15;
%         d2= t>= 15;
%         dummy= data;
%         dummy(10*info.NumSamples: 15*info.NumSamples)= 0;
%         dummy(15*info.NumSamples: end+(5*info.NumSamples))= data(10*info.NumSamples: end);
%         data= dummy;
%         
%         dummy= data;
%         dummy(20*info.NumSamples: 25*info.NumSamples)= 0;
%         dummy(25*info.NumSamples: end+(5*info.NumSamples))= data(20*info.NumSamples: end);
%         data= dummy;
%     end
    t= 0: 1/fs: (length(data)-1)*(1/fs);
    figure()
    subplot(2, 1, 1)
    plot(t,data);
    title('Data');
    ylabel('Amplitude (mV)');
    xlabel('Time (s)')
    
    y= fft(data);
    y= abs(y/L);
    y= y(1: L/2+1);
    %plot(f, 2*y);
    %spectrogram(abs(y), 2048, 1020, 2048, fs, 'yaxis');
    
    fnyq= fs/2;
    fh= 20;
    fl= 450;
    
    [b, a]= butter(4, [fh, fl]/fnyq, "bandpass");
    
    data= filtfilt(b, a, data);
    rec_signal= abs(data);    % matlab doesn't know its mV
    [YUPPER, YLOWER]= envelope(rec_signal, fs/10, 'rms');
    YUPPER= YUPPER- min(YUPPER);
    subplot(2, 1, 2)
    p= plot(t, rec_signal, 'b', t, YUPPER, 'r');
    p(2).LineWidth= 1.5;
    title('Rectified signal and envelope');
    xlabel('Time (s)');
    ylabel('Amplitude (V)')
    
    %decision
    decision= YUPPER>=0.10;
    %plot(t, decision);
    
end