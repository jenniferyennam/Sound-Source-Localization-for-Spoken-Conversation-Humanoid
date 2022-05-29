clc;
clear all;
close all;
format compact;
T = 500;            %No.of snapshots
K = 1;              %No. of signal sources
Nr = 2;             %No. of receiver's antenna
lamda = 340;        %Wavelength
d = lamda/2;        %Receiver's antenna spacing
SNR = 10;           %Signal to noise ratio

x1 = audioread('wav_mic1.wav');
x2 = audioread('wav_mic2.wav');

x11 = cov(x1,x1);   %Data covariance matrix
x12 = cov(x1,x2);
x21 = cov(x2,x1);
x22 = cov(x2,x2);

% To calculate Autocorrelation matrix
xa = xcorr(x11);            %autocorrelation matrix
xb = xcorr(x12);
xc = xcorr(x21);
xd = xcorr(x22);

e11 = eig(x11);             %Eigen values 
e12 = eig(x12);
e21 = eig(x21);
e22 = eig(x22);

[V11,D11] = eig(x11);       %Eigen value decomposition
[V12,D12] = eig(x12);
[V21,D21] = eig(x21);
[V22,D22] = eig(x22);

% To calculate the Steering Matrix
theta = -90:0.05:90;
SV = zeros(Nr,K);
SV = steervec(x22,theta);
Vj = diag(sqrt((10.^(SNR/10))/2));
s = Vj*(randn(K,T) + 1j*randn(K,T));

Enoise = sqrt(1/2)*(randn(Nr,T)+1j*randn(Nr,T));

%MUSIC
[eigenVec,eigenVal] = eig(x22);
Vn = eigenVec(:,1:Nr-K);

%Calculating the MUSIC Spectrum
for i = 1:length(theta) 
    SS = zeros(Nr,1);
    SS = exp(-1j*2*pi*d*(0:Nr-1)'*sind(theta(i))/lamda);
    PP = SS'*(Vn*Vn')*SS;
    Pmusic(i) = 1/ PP;
end

Pmusic = real(10*log10(Pmusic)); %Spatial Spectrum function
[pks,locs] = findpeaks(Pmusic,theta,'SortStr','descend','Annotate','extents');
MUSIC_Estim = sort(locs(1:K));
figure;
plot(theta,Pmusic,'-b',locs(1:K),pks(1:K),'r*'); hold on
text(locs(1:K)+2*sign(locs(1:K)),pks(1:K),num2str(locs(1:K)'))
xlabel('Angle \theta (degree)'); ylabel('Spatial Power Spectrum P(\theta) (dB)') 
title('DOA estimation based on MUSIC algorithm ') 
xlim([min(theta) max(theta)])
grid on

