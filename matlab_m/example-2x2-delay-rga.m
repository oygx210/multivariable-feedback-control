clear all
clc
 s=tf('s');

% Here is a very simple 2x2 example
% G = [e-s 0.5; 1 e-s]
% We want to use PI control (with integral action)
% The steady-state RGA is [2 -1; -1 2] so the diagonal pairing is required to have failure tolerance
% Furthermore, the plant has a RHP-zero at about s=0.3 (computed using 1st order Pade) so tight control at high frequencies is not possible 
% Note that the socalled "relative energy array", REA = [0 1; 1 0] so it recommends the wrong pairing

% exact: use delay
g(1,1) = tf([1],[1],'iodelay',1);
g(1,2) = tf([0.5],[1]);
g(2,1) = tf([1],[1]);
g(2,2) = tf([1],[1],'iodelay',1);

%------------
% Now compute frequency-depende RGA (or rather; RGA-number)
omega = logspace(-2,2,100);   % frequency range
for i=1:length(omega)
    Gf = freqresp(g,omega(i));
    RGA_w(:,:,i) = Gf.*inv(Gf)';
    RGA_diag(i) = sum(sum(abs(RGA_w(:,:,i)-[1 0;0 1]))) ;
    RGA_off_diag (i) = sum(sum(abs(RGA_w(:,:,i)-[0 1;1 0]))); 
end
figure(1);
semilogx(omega, RGA_diag);
hold on
semilogx(omega, RGA_off_diag,'r'); grid, xlabel('omega'), legend('RGA-number Diag','OffDiag')

% From the RGA-number we see that the off-diagonal pairing is better in the
% frequency range from 0.6 to 2.5 (approx.), but this does not help since the 
% RHP-zero limits the bandwidth to about 0.3 or less

% ----------
% Now do closed-loop simulations with diagonal and off-diagonal pairings...

% First enter the same model using Pade approximation
% Reason: delay does not seem to work in Matlab when doing the things below
% pade = (-theta/2n s+1)^n/(theta/2n s+1)^n
% use 4th order Pade (n=4)
n=4;
G(1,1) = tf([1],[1])*padetf(1,n); 
G(1,2) = tf([0.5],1);
G(2,1) = tf([1],[1]);
G(2,2) = tf([1],[1])*padetf(1,n);

% Tune controllers using SIMC-rules
% Select tauc=2*theta (robust tuning) and set tau1=0.1 to avoid pure I-controller:
k=1;tau1=0.1;theta=1;
tauc=2*theta; Kc=(1/k)*(tau1/(tauc+theta)); taui=min(tau1,4*(tauc+theta));
c1=Kc*(1+1/(taui*s));

% diagonal pairing
c2=c1;
K=[c1 0; 0 c2];
L=G*K;S=inv(eye(2)+L);T1=eye(2)-S;
%step(T1);

% reverse pairingi (on off-diagonal)
c2=-0.5*c1; % one of the loops needs negative sign because pairing on negative RGA
K=[0 c1; c2 0];
L=G*K;S=inv(eye(2)+L);T2=eye(2)-S;
figure(2);
step(T1,T2); legend('diagonal pairing','off-diagonal');

