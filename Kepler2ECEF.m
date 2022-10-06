%%Nuria Gonzalez
%%Juan Martinez
function[ECEF] = Kepler2ECEF(KEPLER)

%Contant to use for the formulas
EarthAngSpeed = 7.2921151467e-5; 

ECEF = zeros(size(KEPLER,1), 13);
for i=1:size(KEPLER,1)
    
    ECEF(i,1) = KEPLER(i,1); %ID of the stallite
    ECEF(i,2) = KEPLER(i,4); %This variable is the current time for the begining of the GPS WEEK
    ECEF(i,3) = KEPLER(i,10) + KEPLER(i,6)*KEPLER(i,4); %Actual mean anomaly
    Ek = []; %Here start the calculate of eccentric anomaly
    Ek(1) = ECEF(i,3);
    
    for j=2:20
        Ek(j) = ECEF(i,3) + KEPLER(i,2)*sin(Ek(j-1));
        if (Ek(j) - Ek(j-1)) <= 10e-9
            break
        end
    end
    ECEF(i,4) = Ek(length(Ek));

    %True Anomaly
    Sinvk = ((sqrt(1-(KEPLER(i,2)^2))*sin(ECEF(i,4)))/(1-KEPLER(i,2)*cos(ECEF(i,4))));
    Cosvk = ((cos(ECEF(i,4))-KEPLER(i,2))/(1-KEPLER(i,2)*cos(ECEF(i,4))));
    ECEF(i,5) = angle(complex(Cosvk,Sinvk));
    ECEF(i,6) = ECEF(i,5) + KEPLER(i,9); %Argument of latitude
    ECEF(i,7) = KEPLER(i,5)*(1 - KEPLER(i,2)*cos(ECEF(i,4))); %Radius of the orbit
    %Longitude of The Ascending Node
    ECEF(i,8) = KEPLER(i,7) + KEPLER(i,8) * KEPLER(i,4) - EarthAngSpeed * KEPLER(i,4);
    ECEF(i,9) = ECEF(i,7) * cos(ECEF(i,6)); %X whitin the orbital plane
    ECEF(i,10) = ECEF(i,7) * sin(ECEF(i,6)); %Y within orbit plane
    ECEF(i,11) = ECEF(i,9) * cos(ECEF(i,8)) - ECEF(i,10) * cos(KEPLER(i,3)) * sin(ECEF(i,8)); %X coordinate
    ECEF(i,12) = ECEF(i,9) * sin(ECEF(i,8)) + ECEF(i,10) * cos(KEPLER(i,3)) * cos(ECEF(i,8)); %Y coordinate
    ECEF(i,13) = ECEF(i,10) * sin(KEPLER(i,3)); %Z coordinate
end

end


