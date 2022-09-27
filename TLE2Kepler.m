function [KEPLER_TLE] = TLE2Kepler(esecTLE, GASTdeg, motion,anomaly,inclination,RA_AN,eccentricity,ArgP)

%Constants for compute
G = 6.67384e-11;
M = 5.972e+24;
EarthAngSpeed = 7.2921151467 * 10^(-5); 

%Formulas from PDF to compute
dtTLE = esecTLE;
nTLE = motion*((2*pi)/(24*60*60));
aTLE = ((G*M)/(nTLE^2))^(1/3);
LongAN0TLE = (RA_AN - GASTdeg) * ((2*pi)/360);
RARAN0TLE = 0;
i0TLE = inclination * ((2*pi)/360);
eTLE = eccentricity * 10^(-7);
wTLE = ArgP * ((2*pi)/360);
M0TLE = anomaly * ((2*pi)/360);
T_TLE = (2*pi)/nTLE;

%Filling the vector KeplerTLE for our specific case
KEPLER_TLE = zeros(1,10);
KEPLER_TLE(1, 1)=101;
KEPLER_TLE(1, 2)=eTLE;
KEPLER_TLE(1, 3)=i0TLE;
KEPLER_TLE(1, 4)=dtTLE;
KEPLER_TLE(1, 5)=aTLE;
KEPLER_TLE(1, 6)=nTLE;
KEPLER_TLE(1, 7)=LongAN0TLE;
KEPLER_TLE(1, 8)=RARAN0TLE;
KEPLER_TLE(1, 9)=wTLE;
KEPLER_TLE(1, 10)=M0TLE;
end