clear 
clc

u0= 1.26e-6 %magnetic permittivity constant

%solenoid properties
A_wire = 2/1000^2; %wire cross section
OD_noid = 40/1000; % Solenoid outer diameter
ID_noid = 20/1000; % Solenoid inner diameter
l_noid = 50/1000; %Solenoid length
D_wire = sqrt(4*A_wire/pi);
coil_layers = floor((OD_noid-ID_noid)/D_wire/2);
n_loops = coil_layers*floor(l_noid/D_wire);

L_wire = 0; %length of coil
for i = 0:floor((OD_noid-ID_noid)/D_wire/2)-1
    L_wire = L_wire+pi*(OD_noid+2*D_wire)*floor(l_noid/D_wire);
end
R_coil = 1.72e-8*L_wire/A_wire;



function B=SolenoidField(d,I,k,l_noid,D_wire,coil_layers)
%d is the distance between projectile (point) and center of coil
%I is the current through the coil
    B = 0
    k=1
    u0= 1.26e-6;
    coil_height = floor(l_noid/D_wire);
    for i = 1:coil_height
        d1=d-l_noid/2+i*D_wire;
        B = B+u0*I*coil_layers/2/(d1);
    end
end
