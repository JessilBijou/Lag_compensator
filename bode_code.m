clc; clear; close all;
K=9600
d1=conv([1 4 0],[1 80]) % Denominator of the given system
G=tf(K,d1) % Transfer function of the given system
%%%-----------Uncompensated system
w=logspace(-2,4,1000); %%frequency range
for k=1:length(w)
mag(k)=9600/(w(k)*sqrt(w(k)^2+4^2)*sqrt(w(k)^2+80^2)); %Magnitude Expression
end
mag_db=20*log10(mag); %Magnitude in dB
phase_rad=-atan(w/0)-atan(w/4)-atan(w/80); %phase in radians
phase_deg=phase_rad*180/pi; %phase in degrees
subplot(2,1,1)
semilogx(w,mag_db) %semi log plot
xlabel('Frequency [rad/s]'),ylabel('Magnitude in db'),grid on %x-axis label
subplot(2,1,2)
semilogx(w,phase_deg)
xlabel('Frequency [rad/s]'),ylabel('Phase Angle [deg]'),grid on
%--------Gain Margin
[wpc,fval] = fsolve(@gain_margin1,5)
gm=9600/(wpc*sqrt(wpc^2+4^2)*sqrt(wpc^2+80^2));
gm=1/gm %Gain Margin
j=1;
for i=1:length(mag_db)
if mag_db(i)>-0.2 && mag_db(i)<0.2
b(j)=(i);
j=j+1;
end
end
wgc=min(w(b))
pm=(180/pi)*(-atan(wgc/0)-atan(wgc/4)-atan(wgc/80))+180 %Phase Margin of theuncompensated system
%%%---------------Compensated System
pmreq=input('Enter Required Phase Margin') % enter 33 as given in question
pmreq=pmreq+5
phgcm=pmreq-180
wgcm=4.57784054 % Index is 444. % from the first bode plot, locate wgcm corresponding tophgcm.
Beta=4.30491478; %Magnitude at wgcm
p=-2.48061788; %Phase at wgcm
T=10/wgcm
Zc=1/T
Pc=1/(Beta*T)
Gc=tf([1 Zc],[1 Pc]) %Compensated System
%%Compensated system= Gc*G/Beta
sys.num=[9600 4394.7264]; %Compensated system numerator
sys.den=[4.3 361.657 1414.41 146.323 0]; %Compensated system denominator
w1=logspace(-2,4,1000); %%frequency range
for k=1:length(w1)
mag(k)=2232.5581*(sqrt(w1(k)^2+0.457784^2))/(w1(k)*sqrt(w1(k)^2+79.99^2)*sqrt(w1(k)^2+4^2)*sqrt(w1(k)^2+0.10634^2));
end
mag_db=20*log10(mag); %transfer function converted to dB
phase_rad=atan(w/0.457784)-atan(w/0)-atan(w/79.999)-atan(w/4)-atan(w/0.10634); %phasein radians
phase_deg=phase_rad*180/pi; %phase in degrees
figure(2)
subplot(2,1,1)
semilogx(w,mag_db) %semi log plot
xlabel('Frequency [rad/s]'),ylabel('Magnitude in db'),grid on %x-axis label
subplot(2,1,2)
semilogx(w,phase_deg)
xlabel('Frequency [rad/s]'),ylabel('Phase Angle [deg]'),grid on
%--------Gain Margin
[wpc1,fval] = fsolve(@gain_margin2,5)
gm1=2232.5581*(sqrt(wpc1^2+0.457784^2))/(wpc1*sqrt(wpc1^2+79.99^2)*sqrt(wpc1^2+4^2)*sqrt(wpc1^2+0.10634^2));
gm1=1/gm1   %Gain Margin of the compensated system
j=1;
for i=1:length(mag_db)
if mag_db(i)>-0.2 && mag_db(i)<0.2
b1(j)=(i);
j=j+1;
end
end
wgc1=min(w(b1))
pm1=(180/pi)*(atan(wgc1/0.457784)-atan(wgc1/0)-atan(wgc1/79.999)-atan(wgc1/4)-atan(wgc1/0.10634))+180 %Phase Margin of the compensated system
%Function defined for finding phase crossover frequency of the compensated system
function f= gain_margin2(w1)
f=atan(w1/0.457784)-atan(w1/0)-atan(w1/80)-atan(w1/4)-atan(w1/0.10634)+pi; 
end
%Function defined for finding phase crossover frequency of the uncompensated system
function f= gain_margin1(w)
f=-atan(w/0)-atan(w/4)-atan(w/80)+pi;
end

