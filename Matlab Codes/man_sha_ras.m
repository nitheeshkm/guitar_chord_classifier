function[chord] = man_sha_ras(x)
%Please provide x = path of cord.wav file
%Run this algorith couple of times to get a better tic-toc
tic
[x_n,~] = audioread(x); % Comment me to test Periodogram
%[x_n,Fs] = audioread(x); % UnComment me to test Periodogram

% figure();
% p = [1:Fs];
% stem(p, x_n);
% 'C:\Users\nitheesh\Desktop\Course work\DSP\DSP\Project\project2\chords\c_1.wav'
% For decimation, CIC filtering decimation
D = 16; % decimation factor
N = 16; % delay buffer depth

h_n = zeros(1,N); 
int_out = 0;
ycicout = [];
for ii = 1:length(x_n)
% comb section`
c_out = x_n(ii) - h_n(end);
h_n(2:end) = h_n(1:end-1);
h_n(1) = x_n(ii);
% integrator
int_out = int_out + c_out;
ycicout = [ycicout int_out];
end

ycicout = ycicout(1:D:end); % taking every other sample - decimation

%All pole using Pburg
 [psdx,F] = pburg(ycicout,40,1024,1000);


%Periodogram

% Fs=Fs/D;
% xdft = fft(ycicout);
% N1 = length(ycicout);
% xdft = xdft(1:N1/2+1);
% psdx = (1/(Fs*N1)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% F = 0:Fs/N1:Fs/2;
% fine = 0:Fs/500:Fs/2;
% psdx_interp = interp1(freq,psdx,fine);

%Periodogram end


[~,locs] = findpeaks(psdx,F,'SortStr','descend','MinPeakDistance', 2);

index = locs(1); %Peak 1
index2 = locs(2); %Peak 2
index3 = locs(3); %Peak 3

%data to compare peaks with
C = [98 130.8 164.8 196 261.6 329.6]; 
F = [87.32 130.8 174.6 220 261.6 349.2];
D = [92.5 110.0 146.8 220 293.6 370.0];
G = [98.0 123.5 146.8 196.0 246.9 392.0];

C_cord = 0;


for i=1:length(C)
    C_int1 = index-C(i);
    C_int2 = index2-C(i);
    C_int3 = index3-C(i);
    if abs(C_int1)<2 || abs(C_int2)<2 || abs(C_int3)<2
        C_cord = C_cord+1;
    end
%     cord = C_cord;
end

F_cord = 0;
F_int1 = 0;
F_int2 = 0;
F_int3 = 0;
for i=1:length(C)
    F_int1 = index-F(i);
    F_int2 = index2-F(i);
    F_int3 = index3-F(i);
    if abs(F_int1)<2 || abs(F_int2)<2 || abs(F_int3)<2
        F_cord = F_cord+1;
    end
%     cord = F_cord;
end

D_cord = 0;
D_int1 = 0;
D_int2 = 0;
D_int3 = 0;
for i=1:length(C)
    D_int1 = index-D(i);
    D_int2 = index2-D(i);
    D_int3 = index3-D(i);
    if abs(D_int1)<2 || abs(D_int2)<2 || abs(D_int3)<2
        D_cord = D_cord+1;
    end
%     cord = D_cord;
end

G_cord = 0;
G_int1 = 0;
G_int2 = 0;
G_int3 = 0;
for i=1:length(C)
    G_int1 = index-G(i);
    G_int2 = index2-G(i);
    G_int3 = index3-G(i);
    if abs(G_int1)<2 || abs(G_int2)<2 || abs(G_int3)<2
        G_cord = G_cord+1;
    end
%     cord = G_cord;
end
if C_cord > D_cord && C_cord > F_cord && C_cord > G_cord
    chord = 'c';
elseif F_cord > D_cord && F_cord > C_cord && F_cord > G_cord
    chord = 'f';
elseif D_cord > C_cord && D_cord > F_cord && D_cord > G_cord
    chord = 'd';
else
    chord = 'g';
end
toc



    
        
