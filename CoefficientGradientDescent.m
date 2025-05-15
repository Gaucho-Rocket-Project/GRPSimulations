clear
clc
close all

set_param("GRPsimWorkingPID","ReturnWorkspaceOutputs","on")

%set random thrust time
t2 = 4.8314;

%initial PID coefficients
Kp = 3;
Ki = 0;
Kd = 1;
K = [Kp, Ki, Kd];
Coeffs = [0,0,0;K];

%Run sim
out = sim("GRPsimWorkingPID.slx");
  
%Height
h = out.yout{2}.Values.Data(:,3);
H = [max(h)];

%Angles
a = out.yout{3}.Values.Data(:,1);
A = [max(a)];

%Set search step size
s=0.1;

%For finite iterations
%for iter = 1:5

%Run until stable point is reached
iter = 0;
while ~isequal(Coeffs(end,:),Coeffs(end-1,:))
   iter= iter + 1;
   tempCoeffs = [Coeffs(end,:)];
   tempH = [H(end)];
   tempA = [A(end)];

   for stepP = -s:s:s
       for stepI = -s:s:s
           for stepD = -s:s:s

               if stepP==0 && stepI==0 && stepD==0
                   continue
               else
                   Kp = Kp + stepP;
                   Ki = Ki + stepI;
                   Kd = Kd + stepD;
                  
                   %Add Coeffs
                   tempCoeffs = [tempCoeffs; Kp, Ki, Kd];
                  
                   %Run sim
                   out = sim("GRPsimWorkingPID.slx");
  
                   %Height
                   h = out.yout{2}.Values.Data(:,3);
                   %Add apogee height
                   tempH = [tempH, max(h)];

                   %Angles
                   a = out.yout{3}.Values.Data(:,1);
                   %Add max angles
                   tempA = [tempA, max(a)];

                   %Return to center
                   Kp = Kp - stepP;
                   Ki = Ki - stepI;
                   Kd = Kd - stepD;

               end
           end
       end
   end

   %Display results for iteration
   disp('Iteration')
   disp(iter)
   disp('PID Coeffs')
   disp(tempCoeffs)
   %disp('Max Heights')
   %disp(tempH)
   %disp('Max Angles')
   %disp(tempA)
  
   %Find the coefficients for the minimum angle among the steps
   [MinA, I] = min(tempA);
   Kp = tempCoeffs(I,1);
   Ki = tempCoeffs(I,2);
   Kd = tempCoeffs(I,3);
   HA = tempH(I);

   %Add to "best coeff per iteration" list
   disp('Best Coeffs')
   disp([Kp, Ki, Kd])
   disp('Height')
   disp(HA)
   disp('Max Angle')
   disp(MinA)

   Coeffs = [Coeffs; [Kp, Ki, Kd]];
   H = [H, HA];
   A = [A, MinA];

end
disp('Result:')
disp('PID Coeffs')
disp(Coeffs(2:end,:));
disp('Heights')
disp(H);
disp('Max Angles')
disp(A)
