function [LLA] = ECEF2LLA(ECEF)

for i=1:size(ECEF,1)
    aWGS84 = 6378137;
    eWGS84 = sqrt(0.00669437999014);
    x = ECEF(i,11);
    y = ECEF(i,12);
    z = ECEF(i,13);
    
    c = eWGS84 * aWGS84;
    b = sqrt(aWGS84^2 - c^2);
    eprima = c/b;
    
    r = sqrt(x^2 + y^2);
    Esqr = aWGS84^2 - b^2;
    F = (54*b^2)*z^2;
    GLLA = r^2 + (1-eWGS84^2)*z^2 - (eWGS84^2)*Esqr^2;
    C = ((eWGS84^4)*F*r^2)/(GLLA^3);
    s = (1 + C + sqrt(C^2 + 2*C))^(1/3);
    P = F/((3*GLLA^2)*((s + (1/s) + 1)^2));
    Q = sqrt(1 + 2*(eWGS84^4)*P);
    r0 = (-(P*(eWGS84^2)*r)/(1 + Q))+sqrt((0.5*aWGS84^2)*(1 + (1/Q)) - ((P*(1 - (eWGS84^2))*(z^2))/(Q*(1 + Q))) - 0.5*P*(r^2));
    U = sqrt((z^2) + (r - (r0*(eWGS84^2))^2));
    V = sqrt((z^2)*(1 - (eWGS84^2)) + (r - (r0*(eWGS84^2)))^2);
    z0 = ((b^2)*z)/(aWGS84*V);
    h = U*(1 - (b^2)/(aWGS84*V));
    lat = atan((z + ((eprima^2)*z0))/ r);
    long = atan2(y, x);
    LLA(i,1) = rad2deg(long);
    LLA(i,2) = rad2deg(lat); 
    LLA(i,3) = h;
    LLA(i,4) = ECEF(i,1);

end

end

