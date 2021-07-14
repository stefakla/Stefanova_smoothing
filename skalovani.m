%   Scalling length of smoothed curve on length corresponding to the number
%   of basepairs
%
%   Description: programme recalcutale lenght of smoothed curve on legnth
%                corresponding to the number of basepairs
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, February
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on smoothed curve
%   number   number of basepairs
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on scalled and smoothed curve

function [body_skalovani] = skalovani(vstup,N)

% size of input matrix
[m,~]=size(vstup);
% vectors represeting connection between points
vektor = vstup([2:m 1],:)-vstup;
% matrix of norms of vectors
norma = sqrt(sum(vektor.^2,2));
% lenght of smoothed curve
delka_puvodni = sum(norma);
% lenght of curve based on the number of basepairs
delka_baze = N*3.4;
% ratio of lenghts
pomer = delka_baze/delka_puvodni;
% scalling coordinates
body_skalovani = pomer*vstup;
