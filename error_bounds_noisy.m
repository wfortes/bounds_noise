function data = error_bounds_noisy(W, zls, Q, N_proj, data)
%ERROR_BOUNDS_NOISY for computing error bounds for binary tomography
%with constant column sum projection matrices with perturbed projection
%data as in the paper:
%   Practical error bounds for binary tomography
%   W. Fortes, J. Sijbers, K.J. Batenburg
%   1st ICTMS, 97-100, 2013
%
% Requires investigation to set an acceptable heuristic parameter alpha
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

if isempty(zls)
    zls = ls_solver(W, Q, data.solver, data.maxit, data.tol);
end

% obtain the rounded vector and the vector of increment b
[r, ~, ordb, ~] = round2binary(zls);

% Vector of diference between R and its rounded (to binary) vector r
dif_Rr = zls - r;

normx2 = norm(Q)/N_proj;

% -------------------------------------------------------------------------
% heuristic_alpha (needs calibration accord to data set)
heu_alpha = 1.2;
% squared radius 
squared_radius = (heu_alpha-1)*norm(zls)^2 + normx2;
parameter = squared_radius - dot(dif_Rr,dif_Rr);
%--------------------------------------------------------------------------
npix = length(zls);
data.r{data.aux} = r;

data.V1(data.aux,1) = error_bound4r(ordb, parameter)/npix;
%
data.U1(data.aux,1) = error_bound4r(ordb, 2*parameter)/npix;
%