clear 
clc

u0= 1.26e-6 %magnetic permittivity constant

%simulation settings
n=1000; %simulation steps
v=zeros(1,1000);
t = linspace(0,0.01,n);
%railgun electrical properties
R_wire = 0.01; %0.1 ohms of wire
R_projectile = 2e-6;
R_t = R_wire+R_projectile;
V_cap = zeros(1,n);
V_cap(1) = 500; % capacitor maximum voltage
C_cap = 0.03; % Capacitance in farads

SR_rail = 2*2.488e-4; %specific resistance of rails

%Railgun setup 
d=0.005; %rail seperation
w=d; %projectile width
r=0.07; %projectile radius
m=0.005; %mass in kg
u_s = 0.53; %friction factor between copper and steel
l_rail = 0.5; %length of rail

v(1) = 5; %initial velocity
B0=10; %magnetic field from permenant magnet
s=zeros(1,n); %updated, displacement from initial position
I=zeros(1,n); %current over time
B=zeros(1,n); %magnetic field from rails
a=zeros(1,n); %acceleration
F=zeros(1,n); %magnetic force

warning=0;
for i=1:n
    if(s(i)<=l_rail) %rail length of 0.5m
        %capacitor discharge
        dt=t(2)-t(1);
        q=V_cap(i)*C_cap;
        R=R_t+SR_rail*s(i);
        I(i)=V_cap(i)/R;
        dq=-I(i)*dt;
        V_cap(i+1) = (q+dq)/C_cap;

        %calculate magnetic force
        B(i)=B0+abs((u0*I(i))/(2*pi*d)*log((d-r)/r));
        friction=m*u_s*10;
        F(i)= u0*I(i)^2/pi*log(1+2*w/d)
        if(F(i)<=friction && warning ==0)
            disp('Warning: magnetic force unable to overcome friction')
            warning = 1;
        end
        a(i)=(F(i)-friction)/m;
        v(i+1) = v(i)+a(i)*dt
        s(i+1) = s(i)+v(i)*dt;
    else
    v(i+1) = v(i);
    V_cap(i+1) = V_cap(i);
    s(i+1) = s(i)+v(i)*dt;
    end
end
if(s(end)>l_rail)
    fprintf('muzzle velocity of %d m/s',v(end))
end
E_cap=0.5*C_cap*(V_cap(1)^2-V_cap(end)^2);
KE_gain=0.5*m*(v(end)^2-v(1)^2);

fprintf('Energy discharged by capacitors: %d Joules\n',E_cap)
fprintf('Kinetic Energy gained by projectile: %d Joules\n', KE_gain)
efficiency = KE_gain/E_cap

tiledlayout(2,2)
nexttile
plot(t,V_cap(1:1000)./R);
xlabel('time(s)')
ylabel('Current(A)')

nexttile
plot(t,B(1:1000));
xlabel('time(s)');
ylabel('Magnetic field (T)');

nexttile
plot(s,V_cap./R)
xlabel('distance along rail (m)')
ylabel('Current(A)')

nexttile
plot(t,v(1:1000))
xlabel('time(s)')
ylabel('velocity(m/s)')