clc; clear all;
% % pøipravit pro rùzné datové koncovky
% % path to the data
% % 'In which folder are your data saved? ';
file = 'C:/Users/stefakla/Documents/git/data_test';
% % number of files
% % 'How many files will be smoothed? ';
% F = 10;
% % number of base pairs
N = 4361;
% % number of iterations
 p = 7;
% % scale between your measuring unit and nanometers
% scale = 10;
% pscale = scale*10;
% % path to the sequence of DNA
% % 'What is the path to your sequence of nucleobases?'
% seq = 'C:/Users/stefakla/Documents/git/atoms/pBR322.txt';
% sequence = loadSequence(seq);
% % loading pdb files of nucleobases into structure
% % 'What is the path to pdb file representing adenin?'
% way = 'C:/Users/stefakla/Documents/git/base_pairs_prep/adenin/adenin_t.pdb';
% bas.A = pdbread(way);
% % 'What is the path to pdb file representing cytosin?'
% way = 'C:/Users/stefakla/Documents/git/base_pairs_prep/cytosin/cytosin_g.pdb';
% bas.C = pdbread(way);
% % 'What is the path to pdb file representing guanin?'
% way = 'C:/Users/stefakla/Documents/git/base_pairs_prep/guanin/guanin_c.pdb';
% bas.G = pdbread(way);
% % 'What is the path to pdb file representing thymin?'
% way = 'C:/Users/stefakla/Documents/git/base_pairs_prep/thymin/thymin_a.pdb';
% bas.T = pdbread(way);
% % % path to the files for saving pdb files, upravit pro ukázku
% % mes = 'Into which folder you want to save generated pdb files?';
% % pdb = input(mes,'s');
% % matrix for controlling lenght and angles
% lenghts = zeros(F,3);
% min_cos = zeros(F,2);
% elengths = zeros(F,2);
% for i=0:F-1
    i = 177;
    filename = sprintf('%s/%04i.dat',file,i);
    incurve = dlmread(filename);
    % running programme puleni_py.m
    smoothpoint = puleni_py(p,incurve);
    % running programme skalovani.m
    scalepoint = skalovani(smoothpoint,N);
    % running programme ekvidistant.m
    ekvipoint = ekvidistant(scalepoint,N);
    v = ekvipoint([2:end 1],:)-ekvipoint;
    n = sqrt(sum(v.^2,2));
%     % saving minimum and maximum of distance between points on curve with
%     % equidistant points
%     lenghts (i+1,:) = [i min(n) max(n)];
    % running programme angles.m
    cos = angles(ekvipoint);
%     % saving minimum of cosinus of angle
%     min_cos (i+1,:) = [i min(cos)];
    % running programme delky.m
    space = delky(ekvipoint);
%     % saving position of point located too near
%     elengths(i+1,:) = [i max(space(:,3))];
%     % running programmme tr.m
%     pdb_array = tr(ekvipoint,pscale,sequence,bas);
%     % saving pdb file with positions of atoms on curve
%     ID = sprintf('%s/%s%03i.pdb',pdb,'pdb_info',i);
%     fileID = fopen(ID,'w');
%     [~,n] = size(pdb_array);
%     for l = 1:n
%         fprintf(fileID,'%s\n',pdb_array{l});
%     end
%     fclose(fileID);
% end
% % checking distance between base pairs
% [A,k] = min(lenghts(:,2));
% [B,l] = max(lenghts(:,3));
% if A>=0.32/scale && B<=0.34/scale
%     disp('distance between base pairs OK')
% else
%     X = ['problem with minimum distance in file',num2str(k-1),...
%         'and with maximum in file',num2str(l-1)];
%     disp(X)
% end
% % checking cosinus of angles
% [C,m] = min(min_cos(:,2));
% if C>=0.95
%     disp('angles OK')
% else
%     X = ['problem with angles in file', num2str(m-1)];
%     disp(X)
% end
% % checking too near points
% E = elengths(:,2);
% D = find(E>0.00001);
% disp('there is a problem with too near points in files')
% disp(D-1)
