%	Counting positions of atoms of basepairs on curve with given sequence of
%	nucleobases
%
%   Description: programme is counting positions of atoms of base pairs on
%                curve with given sequence of nucleobases, output structure
%                is ready for being writen down into a pdb file
%
%   Author.....: Klara Stefanova, Martin Sefl
%
%   Created.........: 2018, June
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix    matrix of positions of base pairs
%   seq       loaded sequence of nucleobases for counting on curve
%   structure loaded pdb files for nucleobase
%
%   Output:
%   --------------------------------------------------------
%   cell array characteristics of atoms of basepairs on curve prepared for
%              being writen down to pdb file

function [pdb_array] = tr(line,sequence,bas)
% move 3 values forward/backward to get the next of prevous vector
forw = line([2:end 1],:);
back = line([end 1:end-1],:);
% from the next point subtract previous point - you will get a vector of direction at pos "i"
% x' axis
u = forw - back;
t = forw - line;
% z'
w = cross(u,t,2);
% y' axis
v = cross(w,u,2);
[n,~] = size(line);
if sum(w(1,:))<=10^(-7)
    w(1,:) = [0 0 1];
    if sum(v(1,:)) <= 10^(-7)
        v(1,:) = [0 1 0];
        u(1,:) = [1 0 0];
    end
end
if sum(v(1,:)) <= 10^(-7)
    v(1,:) = [0 1 0];
end
for k = 2:n
    if sum(w(k,:)) <= 10^(-7)
        w(k,:) = w(k-1,:);
    end
    if sum(v(k,:)) <= 10^(-7)
        v(k,:) = v(k-1,:);
    end
end
% norm of vectors u, v, w
nu = sqrt(sum(u.^2,2));
vu = sqrt(sum(v.^2,2));
wu = sqrt(sum(w.^2,2));
% norming vectors u, v, w
M1 = u./nu;
M2 = v./vu;
M3 = w./wu;
counter = 0;
enum = 0;
por = 0;
for k = 1:n
    if vu(k) == 0
        if k == 1
            continue
        else
            M2(k,:) = M2(k-1,:);
        end
    end
    if wu(k) == 0
        if k == 1
            M3(k,:) = M3(end,:);
        else
            M3(k,:) = M3(k-1,:);
        end
    end
    counter = counter+1;
    % nucleobase on k point on equidistant curve
    a = sequence(k);
    switch a
        case {'A','T'}
            m = 64;
        case {'C','G'}
            m = 63;
        otherwise
            disp('There is a mistake in loading sequence')
    end
    % vectors for rotating around x' axis 
    vec = [bas.(a).Model.Atom.X;bas.(a).Model.Atom.Y;bas.(a).Model.Atom.Z];
    rm = [M1(k,:);M2(k,:);M3(k,:)]';
    for l = 1:m
        por = por+1;
        pvec = vec(:,l);
        % rotating around x' axis
        r = RotateAroundX(pvec,counter*360./10.5);
        % displacement of positions of atoms on the equidistant curve
        tvec1 = (rm*r)'+line(k,:);
        tvec = rounding(tvec1);
        % numbering for pdb file
        enum = enum+1;
        if enum >99999
            enum = 0;
        end
        % atom name
        helpname = bas.(a).Model.Atom(l).AtomName;
        % preparing element and charge for pdb file
        if bas.(a).Model.Atom(l).charge =='1-'
            ele = [' ',bas.(a).Model.Atom(l).element,'1-'];
        else
            ele = [' ',bas.(a).Model.Atom(l).element,'  '];
        end
        % line for atom of pdb file
        pdbline = ['ATOM  ',sprintf('%5.i',enum),' ',sprintf('%-4s',helpname),...
            ' ', bas.(a).Model.Atom(l).resName,'  ',...
            bas.(a).Model.Atom(l).chainID,sprintf('%4.i',counter),'    ',...
            tvec,'  1.00  0.00          ',ele];
        % checking length of pdbline
        if max(size(pdbline))>81
            X = ['WARNING: line ',num2str(enum),' is too long - pdb file will',...
                ' not be correct.'];
            disp(X)
        end
        % writing down pdbline into pdb structure
        if bas.(a).Model.Atom(l).chainID =='A'
            pdb_list.(['x',num2str(por)]).a = 'A';
            pdb_list.(['x',num2str(por)]).b = pdbline;
        elseif bas.(a).Model.Atom(l).chainID == 'B'
            pdb_list.(['x',num2str(por)]).a = 'B';
            pdb_list.(['x',num2str(por)]).b = pdbline;
        end
    end
end
% writing down pdb structure into cell array
pdb_array{1} = 'HEADER    DNA                      ';
l = 2;
for k = 1:por
    if pdb_list.(['x',num2str(k)]).a == 'A'
        pdb_array{l} = pdb_list.(['x',num2str(k)]).b;
        l = l+1;
    else
        continue
    end
end
pdb_array{l} = 'TER    ';
l = l+1;
for k = por:-1:1
    if pdb_list.(['x',num2str(k)]).a == 'B'
        pdb_array{l} = pdb_list.(['x',num2str(k)]).b;
        l = l+1;
    else
        continue
    end
end
pdb_array{l} = 'TER    ';
pdb_array{l+1} = 'END    ';