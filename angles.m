%   Calculation of cosinus of angles between vectors
%
%   Description: programme calculate cosinus of angles between vectors
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, March
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on curve
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of cosinus of angles between vectors

function [cos] = angles(point)
% norm of point vectors
normp1 = sqrt(sum(point.^2,2));
% normed point vectors
normp = [normp1 normp1 normp1];
npoint = point./normp;
cos = dot(npoint,npoint([end 1:end-1],:),2);
