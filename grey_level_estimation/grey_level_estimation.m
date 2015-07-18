load diamond_reconstruction.mat
img_sz = 1024;
N_proj = 500;

% type = 'strip';
% address = '/export/scratch1/fortes/PhD_files/Load/angles_eq_distr/';
% M = loadmatrix(address,img_sz,N_proj,type,'matrix');
load diam.mat
Q = reshape(sinogram,1024*500,1);

P = double(reshape(reconstruction,1024^2,1));
P1 = P/norm(P,inf);
Pbin = round2binary(P1);
PP = reshape(Pbin,img_sz,img_sz);

SE = strel('disk',round(img_sz/25));
IM = imerode(reshape(Pbin,img_sz,img_sz),SE);
im = reshape(IM,img_sz^2,1);
IM2 = imdilate(reshape(Pbin,img_sz,img_sz),SE);
im2 = reshape(IM2,img_sz^2,1);

idx = find(im);
average_DG1 = mean(P(idx));
idx2 = find(im2==0);
average_DG2 = mean(P(idx2));

n1_DG1 = abs((norm(Q,1)/N_proj-average_DG2*1024^2)/(average_DG1-average_DG2));
n1_DG2 = abs((norm(Q,1)/N_proj-average_DG1*1024^2)/(average_DG1-average_DG2));
n2_DG1 = 1024^2-n1_DG2;
n2_DG2 = 1024^2-n1_DG1;
average_nDG1 = round((n1_DG1+n2_DG1)/2);
average_nDG2 = round((n1_DG2+n2_DG2)/2);

norm2_xbin = average_nDG1*average_DG1+average_nDG2*average_DG2;