function [V1 V2 wpix] = variabilities(npix,s,ordb,parameter,Ix,normPbyQ,r,lim,R)

% Compute an upper bound for the maximum number of different pixels between
% two binary solutions and its fraction with respect to 

% 1st version
V1 = 2*s;

% 2nd version and most accurate

% upper bound error and number of wrong pixels
[wpix] = bnwpixr(ordb,2*parameter,Ix,normPbyQ,r,lim,R); % ---- Bmaxs must change here

V2 = wpix/npix;