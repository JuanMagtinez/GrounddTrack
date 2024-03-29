% Computes elapsed time from ToA [s] and GAST [deg] at ToA
% ToA must be given in days of current year
% If called with a single argument (ToA) the target date is current time
% 'tgdate' contains the date+time string corresponding to the target date

function [esec, GASTdeg, tgdate] = time2toa(ToA, DD, MM, YYYY, hh, mm, ss) % OPTIONAL arguments to override current time (hh must be UTC !)

% Find Julian Date at time target
if (nargin == 1)                                          % target time is current time
   unixepoch = 2440587.5;                                % JD at unix epoch: 0h (UTC) 1/1/1970
   %if (isOctave)
   %  tnow = time();									  % tnow = seconds from unix epoch (linux clock is UTC)
   %  JD = unixepoch + tnow / 86400;					  % Julian Date now in UTC
   %else
     unixmillis = java.lang.System.currentTimeMillis;    % milliseconds from unix epoch
     JD = unixepoch + unixmillis / 1000 / 86400;         % Julian Date now in UTC
   %end
else
   JD = JDfromUTC(hh, mm, ss, DD, MM, YYYY);			  % OVERRIDE CURRENT TIME
end

% Compute current time in secs. from ToA
MJ2022 = 59580;                 % MJD on 1/1/2022 at 00:00 UTC (see http://leapsecond.com/java/cal.htm)
J2022 = MJ2022 + 2400000.5;     % JD on 1/1/2022 at 00:00 UTC
JToA = J2022 + ToA - 1;         % ToA in JD
esec = 86400 * (JD - JToA);     % temps transcorregut des de'l ToA en segons
%[HH, mm, ss, secfrac, dow, DD, MM, YYYY] = UTCfromJD(JToA);  % UTC time and date of ToA
%fprintf("ToA:                 %02.0f/%02.0f/%4.0f, %02.0f:%02.0f:%02.0f UTC\n", DD, MM, YYYY, HH, mm, round(ss+secfrac));
[HH, mm, ss, secfrac, ~, DD, MM, YYYY] = UTCfromJD(JD);    % UTC time and date at target time
tgdate = sprintf(" %02.0f/%02.0f/%4.0f, %02.0f:%02.0f:%02.0f UTC\n", DD, MM, YYYY, HH, mm, round(ss+secfrac));
%fprintf("Target time:        %02.0f/%02.0f/%4.0f, %02.0f:%02.0f:%02.0f UTC\n", DD, MM, YYYY, HH, mm, round(ss+secfrac));
%fprintf("Seconds from/to ToA: %.2f\n", esec);

% Greenwich Mean Sidereal Time (GMST) is the hour angle of the average position of the vernal equinox,
% neglecting short term motions of the equinox due to nutation. GAST is GMST corrected for
% the shift in the position of the vernal equinox due to nutation.
% GAST at a given epoch is the RA of the Greenwich meridian at that epoch (usually in time units).

% Find GAST in degrees at ToA
J2000 = 2451545.0;                                   % epoch is 1/1/2000 at 12:00 UTC
midnight = round(JToA) - 0.5;                        % midnight of JToA
days_since_midnight = JToA - midnight;
hours_since_midnight = days_since_midnight * 24;
days_since_epoch = JToA - J2000;
centuries_since_epoch = days_since_epoch / 36525;
whole_days_since_epoch = midnight - J2000;
GAST = 6.697374558 + 0.06570982441908 * whole_days_since_epoch + 1.00273790935 * hours_since_midnight + 0.000026 * centuries_since_epoch^2;  % GAST in hours from ?
GASTh = mod(GAST, 24);                 % GAST in hours at ToA
GASTdeg = 15 * 1.0027855 * GASTh;      % GAST in degrees at ToA (approx. 361º/24h)

end
