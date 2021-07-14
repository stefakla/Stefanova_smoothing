%   Position calculation of basepirs on smoothed and scalled curve
%
%   Destription: programme calcalates position of basepairs on smoothed
%                and scalled curve based on distance between basepairs
%
%   Author.....: Klara Stefanova
%
%   Created..........: 2018, February
%   Last change......: 2018, August
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on smoothed and scalled curve
%   number   number of basepairs on curve
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of positions of basepairs

function body_ekvidistant = ekvidistant(vstup,N)
% matrix of calculated positiions of basepairs
body_e = zeros(N+1,3);
% first point of input same with position of first basepair
body_e(1,:) = vstup(1,:);
[m,~] = size(vstup);
% vectors reprezenting connection between points
vektor1 = vstup([2:end 1],:)-vstup;
% matrix of vectors' norms
norma1 = sqrt(sum(vektor1.^2,2));
% beginnimg index of matrix of basepairs for for loop
l = 2;
% distance betweein basepairs
d = 3.4;
r = d;
vektor = [vektor1; vektor1];
norma = [norma1; norma1];
vstup1 = [vstup;vstup];
while (l<N+2)
    for k = 2:2*m
        % reduction of distance d for next if in loop
        if norma(k) < r
            r = r-norma(k);
            % norm same with distance between two points, basepair located on the last point of vector
        elseif norma(k) == r
            body_e(l,:) = vstup1(k+1,:);
            % increase of index of matrix of basepairs (could lead to transcriptions)
            l = l+1;
            % restart of distance r to original value
            r = d;
            % necessary to calculate point between k and k+1 point of input
            % with distance d from presivious basepair
        else
            % recalculation of norm necessary because of unnormed vector
            r1 = (1/norma(k))*r;
            % calcution of point on curve with given distance from first point
            % on vector
            body_e(l,:) = vstup1(k,:)+r1*vektor(k,:);
            % increase of index of matrix of basepairs (could lead to transcriptions)
            l = l+1;
            % restart of distance r to original value
            a = norma(k)-r;
            r = d-a;
        end
    end
end
% writing down poisitions of calculated positions of basepairs
body_ekvidistant = body_e([N+1 2:N],:);
