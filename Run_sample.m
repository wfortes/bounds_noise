%This example computes 2 types of error bounds for binary tomography
%with constant column sum projection matrices with perturbed projection
%data as in the paper:
%   Practical error bounds for binary tomography
%   W. Fortes, J. Sijbers, K.J. Batenburg
%   1st ICTMS, 97-100, 2013
%
%The bounds are on the difference between:
%   any 2 binary solutions of the reconstruction problem
%   the rounded (to binary) central reconstruction and any binary solution
%
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

% ------------- parameters:
img_index = 2; % select image index from 1 to 5
img_sz = 64; % select image dimension 32, 64, 128, 256, 512
N_proj_set = [2, 4 ,8, 16, 32]; %Set of number of projection angles from 1 to 200
maxpert = 1; % perturbation parameter
% -------------
data = initialize_data_str;
[dir_a, dir_b] = mkdirvecs(20); % create directions for projection matrix

P = img_read(img_sz, img_index);
P = reshape(P,img_sz^2,1);
P = double(P);
P = P/norm(P,inf); % only for binary images


% if img_sz==32
%     maxpert_set = [0.25,0.5,1,2,4];
%     N_proj_set = [2,4,6,8,10,12,14,16];
% elseif img_sz==64
%     maxpert_set = [0.5,1,2,4,8];
%     N_proj_set = [2,4,8,12,16,20,24,28,32];
% elseif img_sz==128
%     maxpert_set = [1,2,4,8,16];
%     N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
% elseif img_sz==256
%     maxpert_set = [2,4,8,16,32];
%     N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
% elseif img_sz==512
%     maxpert_set = [4,8,16,32,64];
%     N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
% elseif img_sz==610
%     maxpert_set = [4,8,16,32,64];
%     N_proj_set = [8,16,32,48,64,72,80];
% end

data.aux = 1;
for N_proj = N_proj_set
    
    % Projection matrix
    M = mkmatrix(img_sz, img_sz, dir_a(1:N_proj), dir_b(1:N_proj));
    % Projetion of image P
    Q = M*P;
    
    PQ = perturbation(Q, maxpert, [], []);
    central_R = ls_solver(M, PQ, [], [], []);
    data = error_bounds_noisy(M, central_R, PQ, N_proj, data); 
    
    % Difference between original image P and r, the rounded (to binary)
    % central recostruction, for comparison with bounds
    r = data.r{data.aux};
    npix = length(r);
    data.Pr(data.aux, 1) = norm(P-r, 1)/npix;
    
    data.aux = data.aux + 1;
end
% ---------- Graphics -------------
    build_graph_error_bounds_noisy(data, N_proj_set)
%
