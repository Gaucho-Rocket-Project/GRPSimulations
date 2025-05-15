clear
clc
close all

set_param("GRPsimWorkingPID","ReturnWorkspaceOutputs","on")

%set random thrust time
t2 = 4.8314;

%PID coefficients
Kp = 3.3125;
Ki = 0.2;
Kd = 1.3;
Coeffs = [Kp,Ki,Kd];

%Run sim
out = sim("GRPsimWorkingPID.slx");
  
%Time series
t = out.yout{1}.Values.Time;

%Height
h = out.yout{2}.Values.Data(:,3);
[HA,I] = max(h);

%Angles
a = out.yout{3}.Values.Data;
A = max(a(:,1));

%PID response
pid = out.yout{4}.Values.Data;

%Time of apogee
TA = t(I);

disp('Result:')
disp('PID Coeffs')
disp(Coeffs)
disp('Time of Apogee')
disp(TA)
disp('Height of Apogee')
disp(HA)
disp('Max Angle')
disp(A)
