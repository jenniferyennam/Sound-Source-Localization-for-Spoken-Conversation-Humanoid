clc; 
clear all; 

%Downsampling
fs1 = 48000;
[y,fs1] = audioread('wav_mic1.wav');
[y,fs1] = audioread('wav_mic2.wav');
[y,fs1] = audioread('wav_mic3.wav');

% code to resample audio
%fs1_new = 4000;
%[Numer, Denom] = rat(fs1_new/fs1);
%y_new = resample(y, Numer, Denom);

[x1, fs1] = audioread('wav_mic1.wav');
[x2, fs1] = audioread('wav_mic2.wav');
[x3, fs1] = audioread("wav_mic3.wav");

x12 = xcorr(x1,x2);
x23 = xcorr(x2,x3);
x31 = xcorr(x3,x1);

figure(2)
plot(x12)
subplot(3,1,1)
plot(x23)
subplot(3,1,2)
plot(x31)
subplot(3,1,3)

tau12 = gccphat(x1,x2,fs1);
tau23 = gccphat(x2,x3,fs1);
tau31 = gccphat(x3,x1,fs1);

[tau12, R12, Lag12] = gccphat(x1,x2,fs1);
[tau23, R23, Lag23] = gccphat(x2,x3,fs1);
[tau31, R31, Lag31] = gccphat(x3,x1,fs1);

tau21 = gccphat(x2,x1,fs1);
tau32 = gccphat(x3,x1,fs1);
tau13 = gccphat(x1,x3,fs1);

[tau21, R21, Lag21] = gccphat(x2,x1,fs1);
[tau32, R32, lag32] = gccphat(x3,x2,fs1);
[tau13, R13, Lag13] = gccphat(x1,x3,fs1);

%Direction Of Arrival
m = 3; 
d = 0.0458;
c = 343;

p1 = (tau12*c)/((m-1)*d); 
disp(p1);
q1 = acos(p1);
disp(q1);
N1 = abs(q1);
Ph1 = angle(q1);
disp(Ph1);
disp(rad2deg(Ph1));

p2 = (tau23*c)/((m-1)*d);
disp(p2);
q2 = acosd(p2);
disp(q2);
N2 = abs(q2);
Ph2 = angle(q2);
disp(Ph2);
disp(rad2deg(Ph2));

p3 = (tau31*c)/((m-1)*d);
disp(p3);
q3 = acosd(p3);
disp(q3);
N3 = abs(q3);
Ph3 = angle(q3);
disp(Ph3);
disp(rad2deg(Ph3));

%Reverse Tau's Direction of Arrival
p4 = (tau21*c)/((m-1)*d);
disp(p4);
q4 = acosd(p4);
disp(q4);
N4 = abs(q4);
Ph4 = angle(q4);
disp(Ph4);
disp(rad2deg(Ph4));

p5 = (tau32*c)/((m-1)*d);
disp(p5);
q5 = acosd(p5);
disp(q5);
Ph5 = angle(q5);
disp(Ph5);
disp(rad2deg(Ph5));

p6 = (tau13*c)/((m-1)*d);
disp(p6);
q6 = acosd(p6);
disp(q6);
Ph6 = angle(q6);
disp(Ph6);
disp(rad2deg(Ph6));

