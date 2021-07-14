%	Counting positions of atoms of basepairs on curve with given sequence of
%	nucleobases
%
%   Description: script is running programmes for smoothing a curve and
%                counting positions of basepairs on curve with given sequence of
%                nucleobases and is checking the results
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, April
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   folder    place where files with measured points are saved
%   files .dat files with measured dat, their names' format is integer from
%              0 to 999 completed by zeros to have 3 digits
%   p         the number of iterations in programme puleni_py.m
%   seq       sequence of nucleobases
%
%   Output:
%   --------------------------------------------------------
%   pdb file  characteristics of atoms of basepairs on curve prepared for
%              being writen down to pdb file

function auto_skript_pdb(p,seq)
% input: How many files will be smoothed?
F = 1000;
% input: Which is the number of the beginning file?
B = 0;
% input: What is the path to your sequence of nucleobases
sequence = loadSequence(seq);
% number of basepairs
[~,N] = size(sequence);
% input: Structure created with pdb files representing adenin, cytosin, guanin and thymin
bas = load('bas.mat');
MetaParPool('open')
parfor i=B:B+F-1
    filename = sprintf('%04i.dat',i);
    incurve = dlmread(filename);
    [ekvipoint,cos,lenghts,elengths] = auto_smooth(p,incurve,N);
    a = auto_check(cos,lenghts,elengths);
    if a>0
        [ekvipoint,cos,lenghts,elengths] = auto_smooth(p-1,incurve,N);
        a = auto_check(cos,lenghts,elengths);
        if a>0
            [ekvipoint,cos,lenghts,elengths] = auto_smooth(p-2,incurve,N);
            a = auto_check(cos,lenghts,elengths);
            if a>0
		disp(i)
                disp('problem')
            end
        else
            % running programme tr.m
            pdb_array = tr(ekvipoint,sequence,bas);
            % saving pdb file with positions of atoms on curve
            ID = sprintf('%s%03i.pdb','pdb_',i);
            fileID = fopen(ID,'w');
            [~,n] = size(pdb_array);
            for l = 1:n
                fprintf(fileID,'%s\n',pdb_array{l});
            end
            fclose(fileID);
        end
    else
        % running programme tr.m
        pdb_array = tr(ekvipoint,sequence,bas);
        % saving pdb file with positions of atoms on curve
        ID = sprintf('%s%03i.pdb','pdb_',i);
        fileID = fopen(ID,'w');
        [~,n] = size(pdb_array);
        for l = 1:n
            fprintf(fileID,'%s\n',pdb_array{l});
        end
        fclose(fileID);
    end
end
MetaParPool('close')
