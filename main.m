close all

G = 6.67384e-11;
M = 5.972e+24;
EarthAngSpeed = 7.2921151467 * 10^(-5); 

% Here is the conversion from almmanc to kepler
[~, esec, ~, Eph] = almanac();
[KEPLER] = Almanac2Kepler(esec,Eph);


% Here is the converiosn from tle to  keplers from our case
time = 261.36220946;
[esecTLE, GASTdeg,tgdate] = time2toa(time,18,09,2022,09,41,53);

motion = 14.34218537274896; 
anomaly = 279.6997; 
inclination = 86.4026;
RA_AN = 205.2231;
eccentricity = 0001985;
ArgP = 80.4424;

[KEPLER_TLE] = TLE2Kepler(esecTLE, GASTdeg, motion, anomaly, inclination, RA_AN, eccentricity, ArgP);

% Here we are going to passs from kepler to ecef
[ECEF] = Kepler2ECEF(KEPLER);
[ECEF_TLE] = Kepler2ECEF(KEPLER_TLE);



%%Here is the conversionfrom ecef to lla

[LLA] = ECEF2LLA(ECEF);
[LLA_TLE] = ECEF2LLA(ECEF_TLE);


%% Here we are going to plot the differents plots

%Plot of all the sats
figure(211)
map = load('world_110m.txt');
scatter (map(:,1),map(:,2),7.5,'.');
hold on;
for k_2=1:length(LLA)
    text(LLA(k_2,1) + 2, LLA(k_2,2) + 1, sprintf('%d', Eph(k_2,1)));
end
hold on
scatter (LLA(:,1),LLA(:,2),'filled');
hold on
[baseweek, esec, NS, Eph] = almanac();
t = esec + 5*60;
timer = 1;
while t < esec + 1*3600
    [KEPLER] = Almanac2Kepler(t,Eph);
    [ECEF] = Kepler2ECEF(KEPLER);
    [LLA] = ECEF2LLA(ECEF);
    scatter (LLA(:,1),LLA(:,2), 15,'.');
    hold on
    t = t + 5*60;
    timer=timer+1;
end

%% Plot ONLY ONE SATTELITE
figure(221)
map = load('world_110m.txt');
scatter (map(:,1),map(:,2),7.5,'.');
hold on;

text(LLA(2,1) + 2, LLA(2,2) + 1, sprintf('%d', Eph(2,1)));

hold on
scatter (LLA(2,1),LLA(2,2),'filled');
hold on
[baseweek, esec, NS, Eph] = almanac();
t = esec - 5*60;
timer = 1;
while t > esec - 24*3600
    [KEPLER] = Almanac2Kepler(t,Eph);
    [ECEF] = Kepler2ECEF(KEPLER);
    [LLA] = ECEF2LLA(ECEF);
    scatter (LLA(2,1),LLA(2,2),15,'.');
    hold on
    t = t - 5*60;
    timer=timer+1;
end

%% Plot IRIDIUM 118
figure(231)
map = load('world_110m.txt');
scatter (map(:,1),map(:,2),7.5,'.');
hold on
scatter (LLA_TLE(1,1), LLA_TLE(1,2),'filled');
hold on
text(LLA_TLE(1,1) + 2, LLA_TLE(1,2) + 1, cellstr('IRIDIUM 118'));
hold on
t_TLE = esecTLE;
while (esecTLE < t_TLE + 1.545*60*60)
    [KEPLER_TLE] = TLE2Kepler(esecTLE, GASTdeg, motion,anomaly,inclination,RA_AN,eccentricity,ArgP);
    [ECEF_TLE] = Kepler2ECEF(KEPLER_TLE);
    [LLA_TLE] = ECEF2LLA(ECEF_TLE);
    scatter (LLA_TLE(1,1), LLA_TLE(1,2), 15, '.');
    hold on
    esecTLE = esecTLE + 1*60;
end