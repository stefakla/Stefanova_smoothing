%	  Rotating vector around x axis by a given angle
%
%   Description: programme is rotating a vector around x axis by a given
%                angle
%
%   Author.....: Klara Stefanova, Martin Sefl
%
%   Created.........: 2018, July
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   number    rotation angle in degrees
%   vector    vector to be rotated around x axis
%
%   Output:
%   --------------------------------------------------------
%   vector    rotated vector by a given angle around x axis

function rotated = RotateAroundX(vec,degr)
angle = deg2rad(degr);
RM = [1 0 0; 0 cos(angle) sin(angle); 0 -sin(angle) cos(angle)];
rotated = RM*vec;
