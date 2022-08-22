function qddot = fun_qddot(x,u,dt)
%%%% SSP phase- 1   %%%%%%%%%%%%%%


global A B Nx Nu pert MI L m nx ny tx ty g  ra     
%{
clear; clc; close all
global A B Nx Nu pert MI L m nx ny tx ty g r 
m1=2;m2=3;m3=2;m4=3;m5=2;m6=3;m7=2;m8=3;m9=3;
L1=2;L2=3;L3=2;L4=3;L5=2;L6=3;L7=2;L8=3;L9=3;
MI1 =5; MI2 =5; MI3 =5; MI4 =5; MI5 = 5; MI6 =5; MI7 = 5;
MI = [MI1;MI2;MI3;MI4;MI5;MI6;MI7 ];
L = [L1;L2;L3;L4;L5;L6;L7;L8;L9;];
m = [m1;m2;m3;m4;m5;m6;m7;m8;m9];
g = 9.81; % gravity
Nx = 18;
Nu  = 9;
Tf = 1;
dt = 0.1;
Nt = round(Tf/dt)+1;
A = zeros(Nx,Nx);
B = zeros(Nx,Nu);
pert = 0.001;
nx = 0;
tx = 1;
ny = 1;
ty = 0;
% initial conditions
tht1=deg2rad(20);tht2=deg2rad(35);tht3=deg2rad(20);tht4=deg2rad(35);tht5=deg2rad(20);tht6=deg2rad(35);tht7=deg2rad(35);hx=0.5;hy=1.5;
omg1 = 1;omg2 = 1;omg3 = 1;omg4 = 0;omg5 = 1;omg6 = 1;omg7 = 0;vhx = 1;vhy = 1;
x0 = [tht1;tht2;tht3;tht4;tht5;tht6;tht7;hx;hy;omg1;omg2;omg3;omg4;omg5;omg6;omg7;vhx;vhy];

% goal
thtf1=deg2rad(20);thtf2=deg2rad(35);thtf3=deg2rad(20);thtf4=deg2rad(35);thtf5=deg2rad(20);thtf6=deg2rad(35);thtf7=deg2rad(35);hfx=0.5;hfy=1.5;
omgf1 = 1;omgf2 = 1;omgf3 = 1;omgf4 = 1;omgf5 = 1;omgf6 = 1;omgf7 = 0;vhfx = 0.4;vhfy = 0.1;
xf = [thtf1;thtf2;thtf3;thtf4;thtf5;thtf6;thtf7;hfx;hfy;omgf1;omgf2;omgf3;omgf4;omgf5;omgf6;omgf7;vhfx;vhfy];

% costs
%Q = 1e-5*eye(4);
Q =  1e-5*eye(Nx);
Qf = 15*eye(Nx);
R = 5*1e-4*eye(Nu);
%I = eye(Nu);

e_dJ = 1e-12;

%simulation
%dt = 0.1;
%tf = 1;
%N = floor(tf/dt);
%t = linspace(0,tf,N);
%iterations = 100;

% initialization
u = zeros(Nu,Nt-1);
x = zeros(Nx,Nt);
x_prev = zeros(Nx,Nt);
x(:,1) = x0;


%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m1 = m(1);
m2 = m(2);
m3 = m(3);
m4 = m(4);
m5 = m(5);
m6 = m(6);
m7 = m(7);
L1 = L(1);
L2 = L(2);
L3 = L(3);
L4 = L(4);
L5 = L(5);
L6 = L(6);
L7 = L(7);
%r = L./2;
%{
r1 = L(1)/2;
r2 = L(2)/2;
r3 = L(3)/2;
r4 = L(4)/2;
r5 = L(5)/2;
r6 = L(6)/2;
r7 = L(7)/2;
%}
%MI = m.*L.^3./12;

r1 = ra(1);
r2 = ra(2);
r3 = ra(3);
r4 = ra(4);
r5 = ra(5);
r6 = ra(6);
r7 = ra(7);

MI1 = MI(1);
MI2 = MI(2);
MI3 = MI(3);
MI4 = MI(4);
MI5 = MI(5);
MI6 = MI(6);
MI7 = MI(7);

tht1 = x(1);
tht2 = x(2);
tht3 = x(3);
tht4 = x(4);
tht5 = x(5);
tht6 = x(6);
tht7 = x(7);
hx   = x(8);
hy   = x(9);
omg1 = x(10);
omg2 = x(11);
omg3 = x(12);
omg4 = x(13);
omg5 = x(14);
omg6 = x(15);
omg7 = x(16);
vhx = x(17);
vhy = x(18);


T1  = u(1);
T2  = u(2);
T3  = u(3);
T4  = u(4);
T5  = u(5);
T6  = u(6);
T7  = u(7);
%fx  = u(8);
%fy  = u(9);
lam1 = 0;
lam2 = 0;
lam3 = 0;
lam4 = 0;

thtac =  1.0085/2;
ththm =  1.0085;   % 57.7811 degree
Ram = 0.1437604;
Rah = 0.0866565;



Mmat=[MI1+(m2+m3+m4+m5+m6+m7).*r1.^2,r1.*(L2.*(m3+m4)+m2.*r2).*cos( ...
  tht1+(-1).*tht2),r1.*(L3.*m4+m3.*r3).*cos(tht1+(-1).*tht3),m4.* ...
  r1.*r4.*cos(tht1+(-1).*tht4+thtac),r1.*(L5.*(m6+m7)+m5.*r5).*cos( ...
  tht1+(-1).*tht5),r1.*(L6.*m7+m6.*r6).*cos(tht1+(-1).*tht6),m7.* ...
  r1.*r7.*cos(tht1+(-1).*tht7+thtac),(m2+m3+m4+m5+m6+m7).*r1.*sin( ...
  tht1),(-1).*(m2+m3+m4+m5+m6+m7).*r1.*cos(tht1);r1.*(L2.*(m3+m4)+ ...
  m2.*r2).*cos(tht1+(-1).*tht2),L2.^2.*(m3+m4)+MI2+m2.*r2.^2,L2.*( ...
  L3.*m4+m3.*r3).*cos(tht2+(-1).*tht3),L2.*m4.*r4.*cos(tht2+(-1).* ...
  tht4+thtac),0,0,0,(L2.*(m3+m4)+m2.*r2).*sin(tht2),(-1).*(L2.*(m3+ ...
  m4)+m2.*r2).*cos(tht2);r1.*(L3.*m4+m3.*r3).*cos(tht1+(-1).*tht3), ...
  L2.*(L3.*m4+m3.*r3).*cos(tht2+(-1).*tht3),L3.^2.*m4+MI3+m3.*r3.^2, ...
  L3.*m4.*r4.*cos(tht3+(-1).*tht4+thtac),0,0,0,(L3.*m4+m3.*r3).*sin( ...
  tht3),(-1).*(L3.*m4+m3.*r3).*cos(tht3);m4.*r1.*r4.*cos(tht1+(-1).* ...
  tht4+thtac),L2.*m4.*r4.*cos(tht2+(-1).*tht4+thtac),L3.*m4.*r4.* ...
  cos(tht3+(-1).*tht4+thtac),MI4+m4.*r4.^2,0,0,0,m4.*r4.*sin(tht4+( ...
  -1).*thtac),(-1).*m4.*r4.*cos(tht4+(-1).*thtac);r1.*(L5.*(m6+m7)+ ...
  m5.*r5).*cos(tht1+(-1).*tht5),0,0,0,L5.^2.*(m6+m7)+MI5+m5.*r5.^2, ...
  L5.*(L6.*m7+m6.*r6).*cos(tht5+(-1).*tht6),L5.*m7.*r7.*cos(tht5+( ...
  -1).*tht7+thtac),(L5.*(m6+m7)+m5.*r5).*sin(tht5),(-1).*(L5.*(m6+ ...
  m7)+m5.*r5).*cos(tht5);r1.*(L6.*m7+m6.*r6).*cos(tht1+(-1).*tht6), ...
  0,0,0,L5.*(L6.*m7+m6.*r6).*cos(tht5+(-1).*tht6),L6.^2.*m7+MI6+m6.* ...
  r6.^2,L6.*m7.*r7.*cos(tht6+(-1).*tht7+thtac),(L6.*m7+m6.*r6).*sin( ...
  tht6),(-1).*(L6.*m7+m6.*r6).*cos(tht6);m7.*r1.*r7.*cos(tht1+(-1).* ...
  tht7+thtac),0,0,0,L5.*m7.*r7.*cos(tht5+(-1).*tht7+thtac),L6.*m7.* ...
  r7.*cos(tht6+(-1).*tht7+thtac),MI7+m7.*r7.^2,m7.*r7.*sin(tht7+(-1) ...
  .*thtac),(-1).*m7.*r7.*cos(tht7+(-1).*thtac);(m2+m3+m4+m5+m6+m7).* ...
  r1.*sin(tht1),(L2.*(m3+m4)+m2.*r2).*sin(tht2),(L3.*m4+m3.*r3).* ...
  sin(tht3),m4.*r4.*sin(tht4+(-1).*thtac),(L5.*(m6+m7)+m5.*r5).*sin( ...
  tht5),(L6.*m7+m6.*r6).*sin(tht6),m7.*r7.*sin(tht7+(-1).*thtac),m1+ ...
  m2+m3+m4+m5+m6+m7,0;(-1).*(m2+m3+m4+m5+m6+m7).*r1.*cos(tht1),(-1) ...
  .*(L2.*(m3+m4)+m2.*r2).*cos(tht2),(-1).*(L3.*m4+m3.*r3).*cos(tht3) ...
  ,(-1).*m4.*r4.*cos(tht4+(-1).*thtac),(-1).*(L5.*(m6+m7)+m5.*r5).* ...
  cos(tht5),(-1).*(L6.*m7+m6.*r6).*cos(tht6),(-1).*m7.*r7.*cos(tht7+ ...
  (-1).*thtac),0,m1+m2+m3+m4+m5+m6+m7];

%{
%%%%%%%%%%%%%%% PHI  %%%%%%%%%%%%%%%%%%%%%%%%

phi1 = T1+(-1).*T5+(-1).*L2.*((lam1+lam3).*ny.*cos(tht1)+m3.*omg2.^2.* ...
  r1.*sin(tht1+(-1).*tht2)+m4.*omg2.^2.*r1.*sin(tht1+(-1).*tht2))+( ...
  -1).*r1.*((-1).*g.*m4.*cos(tht1)+(-1).*g.*m5.*cos(tht1)+(-1).*g.* ...
  m6.*cos(tht1)+(-1).*g.*m7.*cos(tht1)+lam1.*ny.*cos(tht1)+lam3.* ...
  ny.*cos(tht1)+lam2.*ty.*cos(tht1)+lam4.*ty.*cos(tht1)+(-1).*lam1.* ...
  nx.*sin(tht1)+(-1).*lam3.*nx.*sin(tht1)+(-1).*lam2.*tx.*sin(tht1)+ ...
  (-1).*lam4.*tx.*sin(tht1)+m2.*((-1).*g.*cos(tht1)+omg2.^2.*r2.* ...
  sin(tht1+(-1).*tht2))+L3.*m4.*omg3.^2.*sin(tht1+(-1).*tht3)+m3.*(( ...
  -1).*g.*cos(tht1)+omg3.^2.*r3.*sin(tht1+(-1).*tht3))+L5.*m6.* ...
  omg5.^2.*sin(tht1+(-1).*tht5)+L5.*m7.*omg5.^2.*sin(tht1+(-1).* ...
  tht5)+m5.*omg5.^2.*r5.*sin(tht1+(-1).*tht5)+L6.*m7.*omg6.^2.*sin( ...
  tht1+(-1).*tht6)+m6.*omg6.^2.*r6.*sin(tht1+(-1).*tht6)+m4.* ...
  omg4.^2.*r4.*sin(tht1+(-1).*tht4+thtac)+m7.*omg7.^2.*r7.*sin(tht1+ ...
  (-1).*tht7+thtac));

phi2 = T2+(-1).*T3+(-1).*L3.*(lam1+lam3).*ny.*cos(tht2)+g.*m2.*r2.*cos( ...
  tht2)+m2.*omg1.^2.*r1.*r2.*sin(tht1+(-1).*tht2)+L2.*((-1).*lam2.* ...
  ty.*cos(tht2)+(-1).*lam4.*ty.*cos(tht2)+lam1.*nx.*sin(tht2)+lam3.* ...
  nx.*sin(tht2)+lam2.*tx.*sin(tht2)+lam4.*tx.*sin(tht2)+m3.*(g.*cos( ...
  tht2)+omg1.^2.*r1.*sin(tht1+(-1).*tht2)+(-1).*omg3.^2.*r3.*sin( ...
  tht2+(-1).*tht3))+m4.*(g.*cos(tht2)+omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht2)+(-1).*L3.*omg3.^2.*sin(tht2+(-1).*tht3)+(-1).*omg4.^2.*r4.* ...
  sin(tht2+(-1).*tht4+thtac)));

phi3 = T3+(-1).*T4+m3.*r3.*(g.*cos(tht3)+omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht3)+L2.*omg2.^2.*sin(tht2+(-1).*tht3))+L3.*((-1).*(lam2+lam4).* ...
  ty.*cos(tht3)+((lam1+lam3).*nx+(lam2+lam4).*tx).*sin(tht3)+m4.*( ...
  g.*cos(tht3)+omg1.^2.*r1.*sin(tht1+(-1).*tht3)+L2.*omg2.^2.*sin( ...
  tht2+(-1).*tht3)+(-1).*omg4.^2.*r4.*sin(tht3+(-1).*tht4+thtac)));

phi4 = T4+Ram.*((-1).*(lam1.*ny+lam2.*ty).*cos(tht4)+(lam1.*nx+lam2.*tx) ...
  .*sin(tht4))+m4.*omg1.^2.*r1.*r4.*sin(tht1+(-1).*tht4+thtac)+L2.* ...
  m4.*omg2.^2.*r4.*sin(tht2+(-1).*tht4+thtac)+L3.*m4.*omg3.^2.*r4.* ...
  sin(tht3+(-1).*tht4+thtac)+Rah.*((-1).*(lam3.*ny+lam4.*ty).*cos( ...
  tht4+(-1).*ththm)+(lam3.*nx+lam4.*tx).*sin(tht4+(-1).*ththm));


phi5 = T5+(-1).*T6+m5.*r5.*(g.*cos(tht5)+omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht5))+L5.*(m6.*(g.*cos(tht5)+omg1.^2.*r1.*sin(tht1+(-1).*tht5)+( ...
  -1).*omg6.^2.*r6.*sin(tht5+(-1).*tht6))+m7.*(g.*cos(tht5)+ ...
  omg1.^2.*r1.*sin(tht1+(-1).*tht5)+(-1).*L6.*omg6.^2.*sin(tht5+(-1) ...
  .*tht6)+(-1).*omg7.^2.*r7.*sin(tht5+(-1).*tht7+thtac)));


phi6 = T6+(-1).*T7+m6.*r6.*(g.*cos(tht6)+omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht6)+L5.*omg5.^2.*sin(tht5+(-1).*tht6))+L6.*m7.*(g.*cos(tht6)+ ...
  omg1.^2.*r1.*sin(tht1+(-1).*tht6)+L5.*omg5.^2.*sin(tht5+(-1).* ...
  tht6)+(-1).*omg7.^2.*r7.*sin(tht6+(-1).*tht7+thtac));

phi7 = T7+g.*m4.*r4.*cos(tht7+(-1).*thtac)+m7.*r7.*(g.*cos(tht7+(-1).* ...
  thtac)+omg1.^2.*r1.*sin(tht1+(-1).*tht7+thtac)+L5.*omg5.^2.*sin( ...
  tht5+(-1).*tht7+thtac)+L6.*omg6.^2.*sin(tht6+(-1).*tht7+thtac));


phi8 = lam1.*nx+lam3.*nx+lam2.*tx+lam4.*tx+(-1).*m4.*omg1.^2.*r1.*cos( ...
  tht1)+(-1).*m5.*omg1.^2.*r1.*cos(tht1)+(-1).*m6.*omg1.^2.*r1.*cos( ...
  tht1)+(-1).*m7.*omg1.^2.*r1.*cos(tht1)+(-1).*L2.*m4.*omg2.^2.*cos( ...
  tht2)+(-1).*m2.*(omg1.^2.*r1.*cos(tht1)+omg2.^2.*r2.*cos(tht2))+( ...
  -1).*L3.*m4.*omg3.^2.*cos(tht3)+(-1).*m3.*(omg1.^2.*r1.*cos(tht1)+ ...
  L2.*omg2.^2.*cos(tht2)+omg3.^2.*r3.*cos(tht3))+(-1).*L5.*m6.* ...
  omg5.^2.*cos(tht5)+(-1).*L5.*m7.*omg5.^2.*cos(tht5)+(-1).*m5.* ...
  omg5.^2.*r5.*cos(tht5)+(-1).*L6.*m7.*omg6.^2.*cos(tht6)+(-1).*m6.* ...
  omg6.^2.*r6.*cos(tht6)+(-1).*m4.*omg4.^2.*r4.*cos(tht4+(-1).* ...
  thtac)+(-1).*m7.*omg7.^2.*r7.*cos(tht7+(-1).*thtac);

phi9 = (-1).*g.*m1+(-1).*g.*m3+(-1).*g.*m4+(-1).*g.*m5+(-1).*g.*m6+(-1).* ...
  g.*m7+lam1.*ny+lam3.*ny+lam2.*ty+lam4.*ty+(-1).*m3.*omg1.^2.*r1.* ...
  sin(tht1)+(-1).*m4.*omg1.^2.*r1.*sin(tht1)+(-1).*m5.*omg1.^2.*r1.* ...
  sin(tht1)+(-1).*m6.*omg1.^2.*r1.*sin(tht1)+(-1).*m7.*omg1.^2.*r1.* ...
  sin(tht1)+(-1).*L2.*m3.*omg2.^2.*sin(tht2)+(-1).*L2.*m4.*omg2.^2.* ...
  sin(tht2)+(-1).*m2.*(g+omg1.^2.*r1.*sin(tht1)+omg2.^2.*r2.*sin( ...
  tht2))+(-1).*L3.*m4.*omg3.^2.*sin(tht3)+(-1).*m3.*omg3.^2.*r3.* ...
  sin(tht3)+(-1).*L5.*m6.*omg5.^2.*sin(tht5)+(-1).*L5.*m7.*omg5.^2.* ...
  sin(tht5)+(-1).*m5.*omg5.^2.*r5.*sin(tht5)+(-1).*L6.*m7.*omg6.^2.* ...
  sin(tht6)+(-1).*m6.*omg6.^2.*r6.*sin(tht6)+(-1).*m4.*omg4.^2.*r4.* ...
  sin(tht4+(-1).*thtac)+(-1).*m7.*omg7.^2.*r7.*sin(tht7+(-1).*thtac) ...
  ;

phi = [phi1;phi2;phi3;phi4;phi5;phi6;phi7;phi8;phi9];
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cmat1 = [(-1).*ny.*r1.*cos(tht1)+nx.*r1.*sin(tht1), (-1).*L2.*ny.*cos(tht2)+ ...
  L2.*nx.*sin(tht2), (-1).*L3.*ny.*cos(tht3)+L3.*nx.*sin(tht3), (-1) ...
  .*ny.*Ram.*cos(tht4)+nx.*Ram.*sin(tht4), 0, 0, 0, nx, ny];

Cmat2 = [(-1).*r1.*ty.*cos(tht1)+r1.*tx.*sin(tht1), (-1).*L2.*ty.*cos(tht2)+ ...
  L2.*tx.*sin(tht2), (-1).*L3.*ty.*cos(tht3)+L3.*tx.*sin(tht3), (-1) ...
  .*Ram.*ty.*cos(tht4)+Ram.*tx.*sin(tht4), 0, 0, 0, tx, ty];

Cmat3 = [(-1).*ny.*r1.*cos(tht1)+nx.*r1.*sin(tht1), (-1).*L2.*ny.*cos(tht2)+ ...
  L2.*nx.*sin(tht2), (-1).*L3.*ny.*cos(tht3)+L3.*nx.*sin(tht3), (-1) ...
  .*ny.*Rah.*cos(tht4+(-1).*ththm)+nx.*Rah.*sin(tht4+(-1).*ththm), 0, ...
  0, 0, nx, ny];

Cmat4 = [(-1).*r1.*ty.*cos(tht1)+r1.*tx.*sin(tht1), (-1).*L2.*ty.*cos(tht2)+ ...
  L2.*tx.*sin(tht2), (-1).*L3.*ty.*cos(tht3)+L3.*tx.*sin(tht3), (-1) ...
  .*Rah.*ty.*cos(tht4+(-1).*ththm)+Rah.*tx.*sin(tht4+(-1).*ththm), 0,  ...
  0, 0, tx, ty];

Cmat = [Cmat1;Cmat2;Cmat3;Cmat4];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Gd1 = [(-1).*nx.*omg1.^2.*r1.*cos(tht1)+(-1).*L2.*nx.*omg2.^2.*cos(tht2)+(-1).*L3.*nx.*omg3.^2.*cos(tht3)+...
    (-1).*nx.*omg4.^2.*Ram.*cos(tht4)+(-1).*ny.*omg1.^2.*r1.*sin(tht1)+...
    (-1).*L2.*ny.*omg2.^2.*sin(tht2) + (-1).*L3.*ny.*omg3.^2.*sin(tht3) + (-1).*ny.*omg4.^2.*Ram.*sin(tht4) ];
  
 Gd2 =   [(-1).*omg1.^2.*r1.*tx.*cos(tht1)+(-1).*L2.*omg2.^2.*tx.* ...
  cos(tht2)+(-1).*L3.*omg3.^2.*tx.*cos(tht3)+(-1).*omg4.^2.*Ram.* ...
  tx.*cos(tht4)+(-1).*omg1.^2.*r1.*ty.*sin(tht1)+(-1).*L2.*omg2.^2.* ...
  ty.*sin(tht2)+(-1).*L3.*omg3.^2.*ty.*sin(tht3)+(-1).*omg4.^2.* ...
  Ram.*ty.*sin(tht4)];
  
  Gd3 = [(-1).*nx.*omg1.^2.*r1.*cos(tht1)+(-1).*L2.*nx.* ...
  omg2.^2.*cos(tht2)+(-1).*L3.*nx.*omg3.^2.*cos(tht3)+(-1).*nx.* ...
  omg4.^2.*Rah.*cos(tht4+(-1).*ththm)+(-1).*ny.*omg1.^2.*r1.*sin( ...
  tht1)+(-1).*L2.*ny.*omg2.^2.*sin(tht2)+(-1).*L3.*ny.*omg3.^2.*sin( ...
  tht3)+(-1).*ny.*omg4.^2.*Rah.*sin(tht4+(-1).*ththm)];
  
  Gd4 = [(-1).*omg1.^2.*r1.*tx.*cos(tht1)+(-1).*L2.*omg2.^2.*tx.*cos(tht2)+(-1).* ...
  L3.*omg3.^2.*tx.*cos(tht3)+(-1).*omg4.^2.*Rah.*tx.*cos(tht4+(-1).* ...
  ththm)+(-1).*omg1.^2.*r1.*ty.*sin(tht1)+(-1).*L2.*omg2.^2.*ty.* ...
  sin(tht2)+(-1).*L3.*omg3.^2.*ty.*sin(tht3)+(-1).*omg4.^2.*Rah.* ...
  ty.*sin(tht4+(-1).*ththm)];


  Gd = [Gd1;Gd2;Gd3;Gd4];

%%%%%%%%%%%%%%%%%%% rhs1  %%%%%%%%%%%%%%%%%%%

rhs1=[T1+(-1).*T5+g.*m2.*r1.*cos(tht1)+g.*m3.*r1.*cos(tht1)+g.*m4.*r1.* ...
  cos(tht1)+g.*m5.*r1.*cos(tht1)+g.*m6.*r1.*cos(tht1)+g.*m7.*r1.* ...
  cos(tht1)+(-1).*L2.*m3.*omg2.^2.*r1.*sin(tht1+(-1).*tht2)+(-1).* ...
  L2.*m4.*omg2.^2.*r1.*sin(tht1+(-1).*tht2)+(-1).*m2.*omg2.^2.*r1.* ...
  r2.*sin(tht1+(-1).*tht2)+(-1).*L3.*m4.*omg3.^2.*r1.*sin(tht1+(-1) ...
  .*tht3)+(-1).*m3.*omg3.^2.*r1.*r3.*sin(tht1+(-1).*tht3)+(-1).*L5.* ...
  m6.*omg5.^2.*r1.*sin(tht1+(-1).*tht5)+(-1).*L5.*m7.*omg5.^2.*r1.* ...
  sin(tht1+(-1).*tht5)+(-1).*m5.*omg5.^2.*r1.*r5.*sin(tht1+(-1).* ...
  tht5)+(-1).*L6.*m7.*omg6.^2.*r1.*sin(tht1+(-1).*tht6)+(-1).*m6.* ...
  omg6.^2.*r1.*r6.*sin(tht1+(-1).*tht6)+(-1).*m4.*omg4.^2.*r1.*r4.* ...
  sin(tht1+(-1).*tht4+thtac)+(-1).*m7.*omg7.^2.*r1.*r7.*sin(tht1+( ...
  -1).*tht7+thtac),T2+(-1).*T3+g.*L2.*m3.*cos(tht2)+g.*L2.*m4.*cos( ...
  tht2)+g.*m2.*r2.*cos(tht2)+L2.*m3.*omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht2)+L2.*m4.*omg1.^2.*r1.*sin(tht1+(-1).*tht2)+m2.*omg1.^2.*r1.* ...
  r2.*sin(tht1+(-1).*tht2)+(-1).*L2.*L3.*m4.*omg3.^2.*sin(tht2+(-1) ...
  .*tht3)+(-1).*L2.*m3.*omg3.^2.*r3.*sin(tht2+(-1).*tht3)+(-1).*L2.* ...
  m4.*omg4.^2.*r4.*sin(tht2+(-1).*tht4+thtac),T3+(-1).*T4+g.*L3.* ...
  m4.*cos(tht3)+g.*m3.*r3.*cos(tht3)+L3.*m4.*omg1.^2.*r1.*sin(tht1+( ...
  -1).*tht3)+m3.*omg1.^2.*r1.*r3.*sin(tht1+(-1).*tht3)+L2.*L3.*m4.* ...
  omg2.^2.*sin(tht2+(-1).*tht3)+L2.*m3.*omg2.^2.*r3.*sin(tht2+(-1).* ...
  tht3)+(-1).*L3.*m4.*omg4.^2.*r4.*sin(tht3+(-1).*tht4+thtac),T4+ ...
  m4.*omg1.^2.*r1.*r4.*sin(tht1+(-1).*tht4+thtac)+L2.*m4.*omg2.^2.* ...
  r4.*sin(tht2+(-1).*tht4+thtac)+L3.*m4.*omg3.^2.*r4.*sin(tht3+(-1) ...
  .*tht4+thtac),T5+(-1).*T6+g.*L5.*m6.*cos(tht5)+g.*L5.*m7.*cos( ...
  tht5)+g.*m5.*r5.*cos(tht5)+L5.*m6.*omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht5)+L5.*m7.*omg1.^2.*r1.*sin(tht1+(-1).*tht5)+m5.*omg1.^2.*r1.* ...
  r5.*sin(tht1+(-1).*tht5)+(-1).*L5.*L6.*m7.*omg6.^2.*sin(tht5+(-1) ...
  .*tht6)+(-1).*L5.*m6.*omg6.^2.*r6.*sin(tht5+(-1).*tht6)+(-1).*L5.* ...
  m7.*omg7.^2.*r7.*sin(tht5+(-1).*tht7+thtac),T6+(-1).*T7+g.*L6.* ...
  m7.*cos(tht6)+g.*m6.*r6.*cos(tht6)+L6.*m7.*omg1.^2.*r1.*sin(tht1+( ...
  -1).*tht6)+m6.*omg1.^2.*r1.*r6.*sin(tht1+(-1).*tht6)+L5.*L6.*m7.* ...
  omg5.^2.*sin(tht5+(-1).*tht6)+L5.*m6.*omg5.^2.*r6.*sin(tht5+(-1).* ...
  tht6)+(-1).*L6.*m7.*omg7.^2.*r7.*sin(tht6+(-1).*tht7+thtac),T7+g.* ...
  m4.*r4.*cos(tht7+(-1).*thtac)+g.*m7.*r7.*cos(tht7+(-1).*thtac)+ ...
  m7.*omg1.^2.*r1.*r7.*sin(tht1+(-1).*tht7+thtac)+L5.*m7.*omg5.^2.* ...
  r7.*sin(tht5+(-1).*tht7+thtac)+L6.*m7.*omg6.^2.*r7.*sin(tht6+(-1) ...
  .*tht7+thtac),(-1).*m2.*omg1.^2.*r1.*cos(tht1)+(-1).*m3.*omg1.^2.* ...
  r1.*cos(tht1)+(-1).*m4.*omg1.^2.*r1.*cos(tht1)+(-1).*m5.*omg1.^2.* ...
  r1.*cos(tht1)+(-1).*m6.*omg1.^2.*r1.*cos(tht1)+(-1).*m7.*omg1.^2.* ...
  r1.*cos(tht1)+(-1).*L2.*m3.*omg2.^2.*cos(tht2)+(-1).*L2.*m4.* ...
  omg2.^2.*cos(tht2)+(-1).*m2.*omg2.^2.*r2.*cos(tht2)+(-1).*L3.*m4.* ...
  omg3.^2.*cos(tht3)+(-1).*m3.*omg3.^2.*r3.*cos(tht3)+(-1).*L5.*m6.* ...
  omg5.^2.*cos(tht5)+(-1).*L5.*m7.*omg5.^2.*cos(tht5)+(-1).*m5.* ...
  omg5.^2.*r5.*cos(tht5)+(-1).*L6.*m7.*omg6.^2.*cos(tht6)+(-1).*m6.* ...
  omg6.^2.*r6.*cos(tht6)+(-1).*m4.*omg4.^2.*r4.*cos(tht4+(-1).* ...
  thtac)+(-1).*m7.*omg7.^2.*r7.*cos(tht7+(-1).*thtac),(-1).*g.*m1+( ...
  -1).*g.*m2+(-1).*g.*m3+(-1).*g.*m4+(-1).*g.*m5+(-1).*g.*m6+(-1).* ...
  g.*m7+(-1).*m2.*omg1.^2.*r1.*sin(tht1)+(-1).*m3.*omg1.^2.*r1.*sin( ...
  tht1)+(-1).*m4.*omg1.^2.*r1.*sin(tht1)+(-1).*m5.*omg1.^2.*r1.*sin( ...
  tht1)+(-1).*m6.*omg1.^2.*r1.*sin(tht1)+(-1).*m7.*omg1.^2.*r1.*sin( ...
  tht1)+(-1).*L2.*m3.*omg2.^2.*sin(tht2)+(-1).*L2.*m4.*omg2.^2.*sin( ...
  tht2)+(-1).*m2.*omg2.^2.*r2.*sin(tht2)+(-1).*L3.*m4.*omg3.^2.*sin( ...
  tht3)+(-1).*m3.*omg3.^2.*r3.*sin(tht3)+(-1).*L5.*m6.*omg5.^2.*sin( ...
  tht5)+(-1).*L5.*m7.*omg5.^2.*sin(tht5)+(-1).*m5.*omg5.^2.*r5.*sin( ...
  tht5)+(-1).*L6.*m7.*omg6.^2.*sin(tht6)+(-1).*m6.*omg6.^2.*r6.*sin( ...
  tht6)+(-1).*m4.*omg4.^2.*r4.*sin(tht4+(-1).*thtac)+(-1).*m7.* ...
  omg7.^2.*r7.*sin(tht7+(-1).*thtac)];

%{

Mmat=[MI1+(m2+m3+m4+m5+m6+m7).*r1.^2,r1.*(L2.*(m3+m4)+m2.*r2).*cos( ...
  tht1+(-1).*tht2),r1.*(L3.*m4+m3.*r3).*cos(tht1+(-1).*tht3),m4.* ...
  r1.*r4.*cos(tht1+(-1).*tht4+thtac),r1.*(L5.*(m6+m7)+m5.*r5).*cos( ...
  tht1+(-1).*tht5),r1.*(L6.*m7+m6.*r6).*cos(tht1+(-1).*tht6),m7.* ...
  r1.*r7.*cos(tht1+(-1).*tht7+thtac),(m2+m3+m4+m5+m6+m7).*r1.*sin( ...
  tht1),(-1).*(m2+m3+m4+m5+m6+m7).*r1.*cos(tht1);r1.*(L2.*(m3+m4)+ ...
  m2.*r2).*cos(tht1+(-1).*tht2),L2.^2.*(m3+m4)+MI2+m2.*r2.^2,L2.*( ...
  L3.*m4+m3.*r3).*cos(tht2+(-1).*tht3),L2.*m4.*r4.*cos(tht2+(-1).* ...
  tht4+thtac),0,0,0,(L2.*(m3+m4)+m2.*r2).*sin(tht2),(-1).*(L2.*(m3+ ...
  m4)+m2.*r2).*cos(tht2);r1.*(L3.*m4+m3.*r3).*cos(tht1+(-1).*tht3), ...
  L2.*(L3.*m4+m3.*r3).*cos(tht2+(-1).*tht3),L3.^2.*m4+MI3+m3.*r3.^2, ...
  L3.*m4.*r4.*cos(tht3+(-1).*tht4+thtac),0,0,0,(L3.*m4+m3.*r3).*sin( ...
  tht3),(-1).*(L3.*m4+m3.*r3).*cos(tht3);m4.*r1.*r4.*cos(tht1+(-1).* ...
  tht4+thtac),L2.*m4.*r4.*cos(tht2+(-1).*tht4+thtac),L3.*m4.*r4.* ...
  cos(tht3+(-1).*tht4+thtac),MI4+m4.*r4.^2,0,0,0,m4.*r4.*sin(tht4+( ...
  -1).*thtac),(-1).*m4.*r4.*cos(tht4+(-1).*thtac);r1.*(L5.*(m6+m7)+ ...
  m5.*r5).*cos(tht1+(-1).*tht5),0,0,0,L5.^2.*(m6+m7)+MI5+m5.*r5.^2, ...
  L5.*(L6.*m7+m6.*r6).*cos(tht5+(-1).*tht6),L5.*m7.*r7.*cos(tht5+( ...
  -1).*tht7+thtac),(L5.*(m6+m7)+m5.*r5).*sin(tht5),(-1).*(L5.*(m6+ ...
  m7)+m5.*r5).*cos(tht5);r1.*(L6.*m7+m6.*r6).*cos(tht1+(-1).*tht6), ...
  0,0,0,L5.*(L6.*m7+m6.*r6).*cos(tht5+(-1).*tht6),L6.^2.*m7+MI6+m6.* ...
  r6.^2,L6.*m7.*r7.*cos(tht6+(-1).*tht7+thtac),(L6.*m7+m6.*r6).*sin( ...
  tht6),(-1).*(L6.*m7+m6.*r6).*cos(tht6);m7.*r1.*r7.*cos(tht1+(-1).* ...
  tht7+thtac),0,0,0,L5.*m7.*r7.*cos(tht5+(-1).*tht7+thtac),L6.*m7.* ...
  r7.*cos(tht6+(-1).*tht7+thtac),MI7+m7.*r7.^2,m7.*r7.*sin(tht7+(-1) ...
  .*thtac),(-1).*m7.*r7.*cos(tht7+(-1).*thtac);(m2+m3+m4+m5+m6+m7).* ...
  r1.*sin(tht1),(L2.*(m3+m4)+m2.*r2).*sin(tht2),(L3.*m4+m3.*r3).* ...
  sin(tht3),m4.*r4.*sin(tht4+(-1).*thtac),(L5.*(m6+m7)+m5.*r5).*sin( ...
  tht5),(L6.*m7+m6.*r6).*sin(tht6),m7.*r7.*sin(tht7+(-1).*thtac),m1+ ...
  m2+m3+m4+m5+m6+m7,0;(-1).*(m2+m3+m4+m5+m6+m7).*r1.*cos(tht1),(-1) ...
  .*(L2.*(m3+m4)+m2.*r2).*cos(tht2),(-1).*(L3.*m4+m3.*r3).*cos(tht3) ...
  ,(-1).*m4.*r4.*cos(tht4+(-1).*thtac),(-1).*(L5.*(m6+m7)+m5.*r5).* ...
  cos(tht5),(-1).*(L6.*m7+m6.*r6).*cos(tht6),(-1).*m7.*r7.*cos(tht7+ ...
  (-1).*thtac),0,m1+m2+m3+m4+m5+m6+m7];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cmat1 = [(-1).*ny.*r1.*cos(tht1)+nx.*r1.*sin(tht1);(-1).*L2.*ny.*cos(tht2)+ ...
  L2.*nx.*sin(tht2);(-1).*L3.*ny.*cos(tht3)+L3.*nx.*sin(tht3);(-1).*ny.*Ram.*cos(tht4)+nx.*Ram.*sin(tht4);0;0;0;nx;ny];

Cmat2 = [(-1).*r1.*ty.*cos(tht1)+r1.*tx.*sin(tht1);(-1).*L2.*ty.*cos(tht2)+ ...
  L2.*tx.*sin(tht2);(-1).*L3.*ty.*cos(tht3)+L3.*tx.*sin(tht3);(-1).*Ram.*ty.*cos(tht4)+Ram.*tx.*sin(tht4);0;0;0;tx;ty];

Cmat3 = [(-1).*ny.*r1.*cos(tht1)+nx.*r1.*sin(tht1);(-1).*L2.*ny.*cos(tht2)+ ...
  L2.*nx.*sin(tht2);(-1).*L3.*ny.*cos(tht3)+L3.*nx.*sin(tht3);(-1)...
  .*ny.*Rah.*cos(tht4+(-1).*ththm)+nx.*Rah.*sin(tht4+(-1).*ththm);0; ...
  0;0;nx;ny];

Cmat4 = [(-1).*r1.*ty.*cos(tht1)+r1.*tx.*sin(tht1); (-1).*L2.*ty.*cos(tht2)+L2.*tx.*sin(tht2);
  (-1).*L3.*ty.*cos(tht3)+L3.*tx.*sin(tht3);(-1).*Rah.*ty.*cos(tht4+(-1).*ththm)+ Rah.*tx.*sin(tht4+(-1).*ththm);0; 0;0;tx;ty];

Cmat = [Cmat1';Cmat2';Cmat3';Cmat4'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Gd1 = [(-1).*nx.*omg1.^2.*r1.*cos(tht1)+(-1).*L2.*nx.*omg2.^2.*cos(tht2)+ ...
  (-1).*L3.*nx.*omg3.^2.*cos(tht3)+(-1).*nx.*omg4.^2.*Ram.*cos( ...
  tht4)+(-1).*ny.*omg1.^2.*r1.*sin(tht1)+(-1).*L2.*ny.*omg2.^2.*sin( ...
  tht2)+(-1).*L3.*ny.*omg3.^2.*sin(tht3)+(-1).*ny.*omg4.^2.*Ram.* ...
  sin(tht4)];
  
 Gd2 = [(-1).*omg1.^2.*r1.*tx.*cos(tht1)+(-1).*L2.*omg2.^2.*tx.*cos(tht2)+...
  (-1).*L3.*omg3.^2.*tx.*cos(tht3)+(-1).*omg4.^2.*Ram.*tx.*cos( ...
  tht4)+(-1).*omg1.^2.*r1.*ty.*sin(tht1)+(-1).*L2.*omg2.^2.*ty.*sin( ...
  tht2)+(-1).*L3.*omg3.^2.*ty.*sin(tht3)+(-1).*omg4.^2.*Ram.*ty.* ...
  sin(tht4)];
  
 Gd3 = [(-1).*nx.*omg1.^2.*r1.*cos(tht1)+(-1).*L2.*nx.*omg2.^2.*cos(tht2)+...
  (-1).*L3.*nx.*omg3.^2.*cos(tht3)+(-1).*nx.*omg4.^2.*Rah.*cos( ...
  tht4+(-1).*ththm)+(-1).*ny.*omg1.^2.*r1.*sin(tht1)+(-1).*L2.*ny.* ...
  omg2.^2.*sin(tht2)+(-1).*L3.*ny.*omg3.^2.*sin(tht3)+(-1).*ny.* ...
  omg4.^2.*Rah.*sin(tht4+(-1).*ththm)];
  
  Gd4 = [(-1).*omg1.^2.*r1.*tx.*cos(tht1)+(-1).*L2.*omg2.^2.*tx.*cos(tht2)+...
  (-1).*L3.*omg3.^2.*tx.*cos(tht3)+(-1).*omg4.^2.*Rah.*tx.*cos( ...
  tht4+(-1).*ththm)+(-1).*omg1.^2.*r1.*ty.*sin(tht1)+(-1).*L2.* ...
  omg2.^2.*ty.*sin(tht2)+(-1).*L3.*omg3.^2.*ty.*sin(tht3)+(-1).* ...
  omg4.^2.*Rah.*ty.*sin(tht4+(-1).*ththm)];


  Gd = [Gd1;Gd2;Gd3;Gd4];

%%%%%%%%%%%%%%%%%%% rhs1  %%%%%%%%%%%%%%%%%%%

rhs1=[T1+(-1).*T5+g.*m2.*r1.*cos(tht1)+g.*m3.*r1.*cos(tht1)+g.*m4.*r1.* ...
  cos(tht1)+g.*m5.*r1.*cos(tht1)+g.*m6.*r1.*cos(tht1)+g.*m7.*r1.* ...
  cos(tht1)+(-1).*L2.*m3.*omg2.^2.*r1.*sin(tht1+(-1).*tht2)+(-1).* ...
  L2.*m4.*omg2.^2.*r1.*sin(tht1+(-1).*tht2)+(-1).*m2.*omg2.^2.*r1.* ...
  r2.*sin(tht1+(-1).*tht2)+(-1).*L3.*m4.*omg3.^2.*r1.*sin(tht1+(-1) ...
  .*tht3)+(-1).*m3.*omg3.^2.*r1.*r3.*sin(tht1+(-1).*tht3)+(-1).*L5.* ...
  m6.*omg5.^2.*r1.*sin(tht1+(-1).*tht5)+(-1).*L5.*m7.*omg5.^2.*r1.* ...
  sin(tht1+(-1).*tht5)+(-1).*m5.*omg5.^2.*r1.*r5.*sin(tht1+(-1).* ...
  tht5)+(-1).*L6.*m7.*omg6.^2.*r1.*sin(tht1+(-1).*tht6)+(-1).*m6.* ...
  omg6.^2.*r1.*r6.*sin(tht1+(-1).*tht6)+(-1).*m4.*omg4.^2.*r1.*r4.* ...
  sin(tht1+(-1).*tht4+thtac)+(-1).*m7.*omg7.^2.*r1.*r7.*sin(tht1+( ...
  -1).*tht7+thtac),T2+(-1).*T3+g.*L2.*m3.*cos(tht2)+g.*L2.*m4.*cos( ...
  tht2)+g.*m2.*r2.*cos(tht2)+L2.*m3.*omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht2)+L2.*m4.*omg1.^2.*r1.*sin(tht1+(-1).*tht2)+m2.*omg1.^2.*r1.* ...
  r2.*sin(tht1+(-1).*tht2)+(-1).*L2.*L3.*m4.*omg3.^2.*sin(tht2+(-1) ...
  .*tht3)+(-1).*L2.*m3.*omg3.^2.*r3.*sin(tht2+(-1).*tht3)+(-1).*L2.* ...
  m4.*omg4.^2.*r4.*sin(tht2+(-1).*tht4+thtac),T3+(-1).*T4+g.*L3.* ...
  m4.*cos(tht3)+g.*m3.*r3.*cos(tht3)+L3.*m4.*omg1.^2.*r1.*sin(tht1+( ...
  -1).*tht3)+m3.*omg1.^2.*r1.*r3.*sin(tht1+(-1).*tht3)+L2.*L3.*m4.* ...
  omg2.^2.*sin(tht2+(-1).*tht3)+L2.*m3.*omg2.^2.*r3.*sin(tht2+(-1).* ...
  tht3)+(-1).*L3.*m4.*omg4.^2.*r4.*sin(tht3+(-1).*tht4+thtac),T4+ ...
  m4.*omg1.^2.*r1.*r4.*sin(tht1+(-1).*tht4+thtac)+L2.*m4.*omg2.^2.* ...
  r4.*sin(tht2+(-1).*tht4+thtac)+L3.*m4.*omg3.^2.*r4.*sin(tht3+(-1) ...
  .*tht4+thtac),T5+(-1).*T6+g.*L5.*m6.*cos(tht5)+g.*L5.*m7.*cos( ...
  tht5)+g.*m5.*r5.*cos(tht5)+L5.*m6.*omg1.^2.*r1.*sin(tht1+(-1).* ...
  tht5)+L5.*m7.*omg1.^2.*r1.*sin(tht1+(-1).*tht5)+m5.*omg1.^2.*r1.* ...
  r5.*sin(tht1+(-1).*tht5)+(-1).*L5.*L6.*m7.*omg6.^2.*sin(tht5+(-1) ...
  .*tht6)+(-1).*L5.*m6.*omg6.^2.*r6.*sin(tht5+(-1).*tht6)+(-1).*L5.* ...
  m7.*omg7.^2.*r7.*sin(tht5+(-1).*tht7+thtac),T6+(-1).*T7+g.*L6.* ...
  m7.*cos(tht6)+g.*m6.*r6.*cos(tht6)+L6.*m7.*omg1.^2.*r1.*sin(tht1+( ...
  -1).*tht6)+m6.*omg1.^2.*r1.*r6.*sin(tht1+(-1).*tht6)+L5.*L6.*m7.* ...
  omg5.^2.*sin(tht5+(-1).*tht6)+L5.*m6.*omg5.^2.*r6.*sin(tht5+(-1).* ...
  tht6)+(-1).*L6.*m7.*omg7.^2.*r7.*sin(tht6+(-1).*tht7+thtac),T7+g.* ...
  m4.*r4.*cos(tht7+(-1).*thtac)+g.*m7.*r7.*cos(tht7+(-1).*thtac)+ ...
  m7.*omg1.^2.*r1.*r7.*sin(tht1+(-1).*tht7+thtac)+L5.*m7.*omg5.^2.* ...
  r7.*sin(tht5+(-1).*tht7+thtac)+L6.*m7.*omg6.^2.*r7.*sin(tht6+(-1) ...
  .*tht7+thtac),fx+(-1).*m2.*omg1.^2.*r1.*cos(tht1)+(-1).*m3.* ...
  omg1.^2.*r1.*cos(tht1)+(-1).*m4.*omg1.^2.*r1.*cos(tht1)+(-1).*m5.* ...
  omg1.^2.*r1.*cos(tht1)+(-1).*m6.*omg1.^2.*r1.*cos(tht1)+(-1).*m7.* ...
  omg1.^2.*r1.*cos(tht1)+(-1).*L2.*m3.*omg2.^2.*cos(tht2)+(-1).*L2.* ...
  m4.*omg2.^2.*cos(tht2)+(-1).*m2.*omg2.^2.*r2.*cos(tht2)+(-1).*L3.* ...
  m4.*omg3.^2.*cos(tht3)+(-1).*m3.*omg3.^2.*r3.*cos(tht3)+(-1).*L5.* ...
  m6.*omg5.^2.*cos(tht5)+(-1).*L5.*m7.*omg5.^2.*cos(tht5)+(-1).*m5.* ...
  omg5.^2.*r5.*cos(tht5)+(-1).*L6.*m7.*omg6.^2.*cos(tht6)+(-1).*m6.* ...
  omg6.^2.*r6.*cos(tht6)+(-1).*m4.*omg4.^2.*r4.*cos(tht4+(-1).* ...
  thtac)+(-1).*m7.*omg7.^2.*r7.*cos(tht7+(-1).*thtac),fy+(-1).*g.* ...
  m1+(-1).*g.*m2+(-1).*g.*m3+(-1).*g.*m4+(-1).*g.*m5+(-1).*g.*m6+( ...
  -1).*g.*m7+(-1).*m2.*omg1.^2.*r1.*sin(tht1)+(-1).*m3.*omg1.^2.* ...
  r1.*sin(tht1)+(-1).*m4.*omg1.^2.*r1.*sin(tht1)+(-1).*m5.*omg1.^2.* ...
  r1.*sin(tht1)+(-1).*m6.*omg1.^2.*r1.*sin(tht1)+(-1).*m7.*omg1.^2.* ...
  r1.*sin(tht1)+(-1).*L2.*m3.*omg2.^2.*sin(tht2)+(-1).*L2.*m4.* ...
  omg2.^2.*sin(tht2)+(-1).*m2.*omg2.^2.*r2.*sin(tht2)+(-1).*L3.*m4.* ...
  omg3.^2.*sin(tht3)+(-1).*m3.*omg3.^2.*r3.*sin(tht3)+(-1).*L5.*m6.* ...
  omg5.^2.*sin(tht5)+(-1).*L5.*m7.*omg5.^2.*sin(tht5)+(-1).*m5.* ...
  omg5.^2.*r5.*sin(tht5)+(-1).*L6.*m7.*omg6.^2.*sin(tht6)+(-1).*m6.* ...
  omg6.^2.*r6.*sin(tht6)+(-1).*m4.*omg4.^2.*r4.*sin(tht4+(-1).* ...
  thtac)+(-1).*m7.*omg7.^2.*r7.*sin(tht7+(-1).*thtac)];




%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%%%%%%%%%%%%%%%%%%%%%%%
inv(Mmat);
qddot = Mmat\phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rhs1 = rhs1';
Cn  = Cmat;
rhs2 = Gd;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%rhs2 -gn
%%rhs1 - phi

invM = inv(Mmat);

Gmat = Cn*invM*Cn';
invG = inv(Gmat);



lam = Gmat\(rhs2 - Cn*invM*rhs1)

%lam = [80;30;80;70]
alp = invM*(Cn'*lam + rhs1);

%qddot = [omg1;omg2;omg3;omg4;omg5;omg6;omg7;vhx;vhy;alp]
 qddot = alp;
  
  
  
  
  



















