clear
clc
close all

set_param("GRPSecondMotorTest","ReturnWorkspaceOutputs","on")

%Ideal values
%dt = 0.761;
%h = 15.36;

f = [];
H = 6:0.1:16;
for h = H
    vf = [];
    dT = 0.1:0.01:1.7;
    for dt = dT
        out = sim("GRPSecondMotorTest.slx");
        t = out.yout{1}.Values.Time;
        v = out.yout{1}.Values.Data(:,3);
        vf = [vf, abs(v(end))];
    end
    [vfmin, I] = min(vf);
    f = [f, dT(I)];
end
disp(dT)
disp(f)