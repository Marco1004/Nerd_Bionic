clear;
clc;

info= edfinfo('open_close.edf');
signal= edfread('open_close.edf', 'SelectedSignals','EMGBITREV');
data_carray= table2array(signal);
data= vertcat(data_carray{:});
plot(data);

y= fft(data);
