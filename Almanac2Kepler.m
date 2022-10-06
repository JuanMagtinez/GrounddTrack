%%Nuria Gonzalez
%%Juan Martinez
function [KEPLER] = Almanac2Kepler(esec, Eph)

%Constants to use in te formulas below
M = 5.972e+24;
G = 6.67384e-11;
EarthAngSpeed = 7.2921151467 * 10^(-5); 

KEPLER = zeros(length(Eph),10);

for i=1:31
    e = Eph(i,3);
    i0 = Eph(i,5);
    t = esec; 
    dt = t - Eph(i,4);
    a = Eph(i,7)^2;
    n = sqrt((G*M)/(a^3));
    LongAN0 = Eph(i,8) - (EarthAngSpeed * Eph (i,4));
    RARAN0 = Eph(i,6);
    w = Eph(i,9);
    M0 = Eph(i,10);

    %Here we are going to fill the VECTOR Kepler
    KEPLER(i, 1)=Eph(i,1);
    KEPLER(i, 2)=e;
    KEPLER(i, 3)=i0;
    KEPLER(i, 4)=dt;
    KEPLER(i, 5)=a;
    KEPLER(i, 6)=n;
    KEPLER(i, 7)=LongAN0;
    KEPLER(i, 8)=RARAN0;
    KEPLER(i, 9)=w;
    KEPLER(i, 10)=M0;

end
end
