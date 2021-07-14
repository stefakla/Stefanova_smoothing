%	Rounding numbers to have 8 characters in maximum
%
%   Description: programme is rounding numbers to have 8 characters in
%                maximum and transforming the numbers into string row array
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, July
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   matrix    matrix of numbers for being rounded to have 8 characters
%
%   Output:
%   --------------------------------------------------------
%   array     row array of numbers after being rounded to 8 characters and
%             transformed into string

function tvec = rounding(vec)
[a,b]=size(vec);
for c = 1:a
    for d = 1:b
        x=vec(c,d);
        y = abs(floor(x));
        n = 0;
        while (y-10^n>=0)
            n = n+1;
        end
        switch n
            case {0,1}
                z = sprintf('%8.5f',x);
            case 2
                z = sprintf('%8.4f',x);
            case 3
                z = sprintf('%8.3f',x);
            case 4
                z = sprintf('%8.2f',x);
            case 5
                z = sprintf('%8.1f',x);
            case 6
                z = sprintf('%8.0f',x);
            otherwise
                X = ['The number ',num2str(x),' is too big for being input'];
                disp(X)
        end
        if c ==1 && d ==1
            rvec = {z};
        else
            rvec = [rvec,z];
        end
    end
end
tvec = rvec{1};
tvec = [tvec,rvec{2},rvec{3}];
