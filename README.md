# Impact of environment parameters on the plasmid DNA damage induced by ionizing radiation #

This code is a part of master thesis "Impact of environment parameters on the plasmid DNA damage induced by ionizing radiation" written by Klára Stefanová, Faculty of Nuclear Sciences and Physical Engineering at the Czech Technical University in Prague, 2021.

This work was based on the code which was developed as a part of bachelor thesis "Development of detailed dynamic models of plasmid DNA" written by Klára Stefanová, Faculty of Nuclear Sciences and Physical Engineering at the Czech Technical University in Prague, 2019. In this repository we present the automatization of smoothing process. The reason for this was the fact that we wanted to use this code for computing on grids.

This work is pending publication, therefore at this moment this repository is considered confidential by the authors.

### Prerequistes ###

The code is provided in the form of source code. To run the code a computer with Matlab software is needed. The code has been tested with versions 2018a and 201(5/6)b on a Windows system and with version 2020b on a Linux system.

Detailed instructions how to get a Matlab software is described on [Matlab webside](https://www.mathworks.com/products/matlab.html).

## auto_skript_pdb ##

The auto_skript_ekvi.m is an application which can smooth points in accordance with Kummerle and Pumplon, 2005, Eur Biophys J 34: 13-18 and compute positions of atoms on DNA loop with given sequence.

To run this application you must go to the file where your code is saved, for example (~/Documents/).

The lines starting with % are comments.

Further decription of used codes is located in repository wiki.

### Input ###

```
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
```

This part of the code is meant to be changed by a user. Following data can be modified:

* p ... number of iterations in smoothing loop. We recommend using 7 or 8 iterations of smoothing process. The reason is described in repository which presents the smoothing code itself.

* seq ... sequence of base pairs of plasmid whos atomic structure is simulated

* F,B ... number of file which will be smoothed and placing of the first file to be smoothed

* bas.mat ... structure with model of base pairs, loaded from PDB files. There is no need for using Bioinformatics toolbox with this structure.



### Running the smoothing process ###

```
[ekvipoint,cos,lenghts,elengths] = auto_smooth(p,incurve,N);
```

This line of the code is running the smoothing process. It begins with iterative smoothing and ends with computing positions of points which represent location of base pairs.

If the line's center isn't placed in [0,0,0], function curve_centering can be used for it. It counts a center of the structure and moves it to [0,0,0]. An exemple of using this function is shown on following lines. We recommend to use it before computing positions of atoms with function tr.

```
[ekvipoint,cos,lenghts,elengths] = auto_smooth(p,incurve,N);
ekvi_center = curve_centering(ekvipoint);
```

### Checking correctness of smoothing process and computing positions of atoms ###

```
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
```

This part of the code is running a check of correctness of the smoothing process with function auto_check.

If the structure of points representing positions of base pairs passes the check of corrertness, position of each atom in molecule with be calcuted and written down in pdb file with programme tr.m.

If the structure doesn't pass the check, there the number of iterations is reduced once or twice and the whole process of smoothing and checking is running again. If structure calcuted during this process is correct, programme tr.m will be apllied. In case of the fact that the structure doesn't pass the criteria again, it will remote from the whole process.

### Contacts ###
If you have any comments or suggestions, we'll be glad to hear them.

Klára Stefanová, stefakla@fjfi.cvut.cz

Václav Štěpán, stepan@ujf.cas.cz
