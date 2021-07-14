function [ekvipoint,cos,lenghts,elengths] = auto_smooth(p,incurve,N)
% running programme puleni_py.m
[smoothpoint] = puleni_py(p,incurve);
% running programme skalovani.m
[scalepoint] = skalovani(smoothpoint,N);
% running programme ekvidistant.m
ekvipoint = ekvidistant(scalepoint,N);
v = ekvipoint([2:end 1],:)-ekvipoint;
n = sqrt(sum(v.^2,2));
% saving minimum and maximum of distance between points on curve with
% equidistant points
lenghts = [min(n) max(n)];
% running programme angles.m
cos = angles(ekvipoint);
% running programme delky.m
space = delky(ekvipoint);
% saving position of point located too near
elengths = max(space(:,3));