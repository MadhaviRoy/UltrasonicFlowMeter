clear all
T=1e-12;                %Time axis is 1pSec
fs1=125000;              %Pick every 125000th sample to achive required sampling rate of 8MHz

freq=2*1e6;             %Sensor freq 2MHz
cycles=40;               %no. of cycles in a chirp is 8
time=1e-12;               %Start of chirp time
indx1=uint32(time/T);     %Index of start of chirp (Value for given time is 1)
indx=indx1;               %Copy of start index
T1=1/freq;                 %Single cycle time of 2MHz signal (0.5 micro sec)

t=0:T:2*cycles*T1;          %Total time of chirp 16 cycle (8 increasing+8 decreasing)20microsec
sig=sin((2*pi*freq).*t);    %Signal generation

T_mod=2*cycles*T1;          %Period of Modulation frequency
f_mod=(1/T_mod);            %Modulation freuency

l=length(t);
fs=l*f_mod;
Cycles2=0.5;
t1=0:1/fs:(Cycles2*T_mod);
sig1=sin((2*pi*f_mod).*t1);

for x=1:length(t1)
    chirp(indx)=1000*sig1(x).*sig(x);
    indx=indx+1;
end

p=1;
for i=1:fs1:length(chirp)-fs1
    chirp_new(p)=chirp(i);
    time_stmp_chirp(p)=t(i);
    p=p+1;
end
g=1;
for a=60*1e-12:1e-12:600*1e-9
 time2(g)=a;
indx2(g)=uint32(time2(g)/T);
indx=indx2(g);

for x=1:length(t1)
    chirp1(indx)=1000*sig1(x).*sig(x);
    indx=indx+1;
end
p=1;
for i=1:fs1:length(chirp1)-fs1
    chirp_new1(p)=chirp1(i);
    p=p+1;
end
[c1,lags1]=xcorr(chirp_new1,chirp_new);
c=c1./max(abs(c1(:)));

max_cor=max(c);
 ind=find(c==max_cor);

 time_cor=lags1(ind);
 zm1=c(ind-1);
 zp1=c(ind+1);
 [i_cor,p_cor]=interpolate([zm1 max_cor zp1]);
%  time_final(g)=(p_cor(g)*(1/(8*1e6)))+time_cor(g);
  time_final1=p_cor+time_cor;
  time_final(g)=time_final1/(8*1e6);
 time_cor_final(g)=time_cor+time_final(g)+52.641*1e-6;
 expected(g)=time2(g)-time;
 error(g)=expected(g)-time_final(g);
  error_percent(g)=((expected(g)-time_final(g))/expected(g))*100;
 g=g+1;
 clearvars chirp1 chirp_new1 c1 c lags1 indx
end

