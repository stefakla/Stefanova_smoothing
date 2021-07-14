%	Loading a sequence of nucleobases into array
%
%   Description: programme is loading a sequence of nucleobases form given
%                path into array
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, July
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   filename    path to the sequence of nucleobases for loading and 
%               writing down into array
%
%   Output:
%   --------------------------------------------------------
%   array       array of sequence of nucleobases prepared for determinated 
%               to be counted on equidistant curve

function radky = loadSequence(fname)
X = importdata(fname);
[n,~] = size(X);
radky = sprintf(X{1});
for k = 2:n
    radky = [radky,X{k}];
end

