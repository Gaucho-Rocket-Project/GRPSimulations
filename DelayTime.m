clear
clc
close all

set_param("GRPsimWorkingPID","ReturnWorkspaceOutputs","on")

%PID coefficients
Kp = -1.3875;
Ki = -2.1;
Kd = 1.1;

%List of final velocities for each T2
vf = [];

%List of heights at apogee
H = [];

%List of T2 - time to turn on second motor
T2 = 4:0.1:6;

%loop over T2 times
for t2 = T2
    %Run sim
    out = sim("GRPsimWorkingPID.slx");

    %Time series
    t = out.yout{1}.Values.Time;
    %Vertical velocity
    v = out.yout{1}.Values.Data(:,3);
    %Height
    h = out.yout{2}.Values.Data(:,3);

    %Add final velocity to list
    vf = [vf, abs(v(end))];

    %Add apogee height
    H = [H, max(h)];
end

%Find minimum final velocity
[vfmin, I] = min(vf);

%Time to turn on second motor
T2 = T2(I);
disp(T2);

%Height at apogee
H = H(I);
disp(H);
