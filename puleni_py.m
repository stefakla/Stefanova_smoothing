%   Smothing points in accordance with Kummerle and Pumplon, 2005, Eur Biophys J
%   34: 13-18
%
%   Description: programme is smoothing points in accordance with algoithm
%                described in Kummerle and Pumplon, 2005, Eur Biophys J 34:
%                13-18
%
%   Author.....: Klara Stefanova, Martin Sefl
%
%   Created.........: 2018, March
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix    matrix of positions of measured points
%   number    number of iterations
%
%   Output:
%   --------------------------------------------------------
%   matrix    matrix of positions of smoothed points

function [new] = puleni_py(p,point)
% size of matrix with positions measured points
[m,n]=size(point);
% creating matrix for saving points avec each iteration

curve=zeros((2^(p+1)-1)*m,n);
curve(1:m,:) = point(:,:);
for l = 1:p
    % matrix with points for the interation
    ncurve = curve([(2^(l-1)-1)*m+1:(2^l-1)*m],:);
    forward = ncurve([end 1:end-1],:);
    % centers between points
    centers = 0.5*(forward+ncurve);
    % vectors between points (connector)
    vec1 = forward-ncurve;
    % norm of connectors
    len1 = sqrt(sum(vec1.^2,2));
    len = [len1 len1 len1];
    % unitary vector characterizing connectors
    vec = vec1./len;
    vbw = vec([2:end 1],:);
    % norm of vector describing angle axis created by connectors with crossing
    % in k point
    na = sqrt(sum((-vbw+vec).^2,2));
    % reset of too small norms of angles axis (3 points not defining a plane),
    % trying to avoid numerical mistakes
    for k=1:((2^(l-1))*m)
        if na(k)<10^(-5)
            na(k) = 0;
        end
    end
    % unitary vector of angle axis created by connectors with crossing in k point
    na1 = [na na na];
    a = (-vbw+vec)./na1;
    % dot product of shitfed matrix of connectors and matrix of vector characterizing
    % connectors centers-points
    help0 = dot(vbw,centers([2:end 1],:)-ncurve,2);
    % dot product of shitfed matrix of connectors and unitary matrix of angle axis
    help1 = dot(vbw,a,2);
    t0 = help0./help1;
    % finding crossing between plane going through center between k and k-1 point
    P0 = ncurve+[t0 t0 t0].*a;
    % vector charakterizing connectors centers-points
    v = centers-ncurve;
    help0 = dot(vec,v,2);
    help1 = dot(vec,a,2);
    t1 = help0./help1;
    % finding crossing between plane going through centers between k and k+1 point
    P1 = ncurve+[t1 t1 t1].*a;
    % calculation directional vector between k center and P0
    dir0 = P0 - centers([2:end 1],:);
    ndir10 = sqrt(sum(dir0.^2,2));
    ndir0 = [ndir10 ndir10 ndir10];
    d0 = dir0./ndir0;
    % calculation directional vector between k+1 center and P1
    dir1 = P1 - centers;
    ndir11 = sqrt(sum(dir1.^2,2));
    ndir1 = [ndir11 ndir11 ndir11];
    d1 = dir1./ndir1;
    % calculation of angles between vectors d0 and angle axis and vectors d1
    % and angle axis
    cos0 = dot(d0,a,2);
    cos1 = dot(d1,a,2);
    sin0 = sqrt(0.5*(1-cos0));
    sin1 = sqrt(0.5*(1-cos1));
    t3 = 0.25*len([2:end 1],:)./sin0;
    t4 = 0.25*len./sin1;
    % calculation of smoothed center in plane of k center
    A0 = zeros((2^(l-1))*m,3);
    A0(isfinite(t3)== 1);
    for k=1:((2^(l-1))*m)
        if isfinite(t3(k))== 1
            A0(k,:) = P0(k,:)-t3(k)*d0(k,:);
        else
            if k~=m
                A0(k,:) = centers(k+1,:);
            else
                A0(k,:) = centers(1,:);
            end
        end
    end
    % calculation of point replacing the original point in plane of k center
    A1 = zeros((2^(l-1))*m,3);
    for k=1:((2^(l-1))*m)
        if isfinite(t3(k))== 1
            A1(k,:) = P0(k,:)-t3(k)*a(k,:);
        else
            A1(k,:) = ncurve(k,:);
        end
    end
    % calculation of smoothed center in plane of k+1 center
    A2a = zeros((2^(l-1))*m,3);
    for k=1:((2^(l-1))*m)
        if isfinite(t3(k))== 1
            A2a(k,:) = P1(k,:)-t4(k)*d1(k,:);
        else
            A2a(k,:) = centers(k,:);
        end
    end
    A2 = A2a([2:end 1],:);
    % calculation of point replacing the original point in plane of k+1 center
    A3 = zeros((2^(l-1))*m,3);
    for k=1:((2^(l-1))*m)
        if isfinite(t3(k))== 1
            A3(k,:) = P1(k,:)-t4(k)*a(k,:);
        else
            A3(k,:) = ncurve(k,:);
        end
    end
    % calculation of smoothed point
    A = 0.5*(A0+A2);
    % calculation of point rpelacing the original points
    B = 0.5*(A1+A3);
    % writing down into matrix
    newpoints=zeros((2^l)*m,3);
    newpoints(1:2:end,:) = B(:,:);
    newpoints(2:2:end,:) = A(:,:);
    curve(((2^l)-1)*m+1:((2^(l+1))-1)*m,:) = newpoints(:,:);
end
% writing down into matrix for output
new = curve(((2^p)-1)*m+1:(2^(p+1)-1)*m,:);
