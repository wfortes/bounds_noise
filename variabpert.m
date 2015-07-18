function [V,sUR,sLR] = variabpert(lxbin,uxls,uxbin,lxls,npix)

% Computes an upper bound for the number of pixel differences between any 2
% binary solutions of Wx=p, with unkown p, which gives the most basic 
% variability.
%
% Also computes an upper and lower bound for the radius of hypersphere of the
% perturbed system Wz=q.
%
% lxbar = lower bound of the l2 norm of any binary solution of Wx=p
% uxls =
% uxbar =
% lxls =
%

sLR = max(lxbin^2-uxls^2,0);
sUR = uxbin^2-lxls^2;
V = 4*sUR/npix;