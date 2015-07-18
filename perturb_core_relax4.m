function [info] = perturb_core_relax2(img_index,N_proj,img_sz,aux,type,info)

% this is the core of the code with perturbation

proj = num2str(N_proj);
img = num2str(img_index);
sz = num2str(img_sz);
address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';

M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
load(M_file);

P = img_read(img_index,img_sz);
P = reshape(P,img_sz^2,1);
P = double(P);
P = P/norm(P,inf); % only for binary images

Q = M*P;

if ~isempty(info.vari)
    var = num2str(info.vari);
    PQ_file = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',var,'.mat');
    load(PQ_file);
    delta2 = 0;%norm(Q-PQ,2);
    delta1 = 0;%norm(Q-PQ,1);
else
    PQ = Q;
    delta1 = info.delta*norm(Q,1);
    delta2 = info.delta*norm(Q,2);
end

zls_address = '/export/scratch1/fortes/PhD_files/Load/';
zls_filename = strcat(zls_address,'zls/zls-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',var,'.mat');
load(zls_filename)
xls_filename = strcat(zls_address,'xls/xls-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',var,'.mat');
load(xls_filename)
npix = length(zls);

% ------------ 1st stage -----------
% computing norm(xbin) from its projection: upper and lower bound
[uxbin,lxbin] = boundxbin_l1(PQ,delta1,N_proj);

%--------------------------------------------------------------------------
% Bound norm(x*) % Lemma 2 and 4

% lxls = max(norm(zls)-norm(xls-zls),0); % USES norm(xls-zls) ---------------
uxls = sqrt((norm(PQ,1)+delta1)/N_proj);
lxls = norm(zls);

% Bound the distance between 2 bin sol based on xbin(zbin)
[V1,sUR,sLR] = variabpert(lxbin,uxls,uxbin,lxls,npix);

% ------------ 2nd stage -----------
% obtain the rounded vector and the vector of increment b
[r, b, ordb, Ix, alpha] = round2binary(zls);
% Rr = norm(P-r,1)/npix; % Computes the % of wong pixels in r

normzls2 = norm(zls)^2;
sNR = (0.002-1)*normzls2+uxbin^2;
% true_sNR = norm(zls-P)^2;
% new_par = (true_sNR-uxbin^2)/normzls2;

parameter = sNR - dot(alpha,alpha);

% bound the number of wrong pixels
lim = 'notlimited'; % limited case: Bmaxs would have to be changed cause keeping the norm based on Q is not good
[s_aux] = bnwpixr(ordb,parameter,Ix,norm(P,1),r,lim);
s = s_aux/npix;
[V2,V3,V4,~,~] = variability(npix,sNR,s,ordb,parameter,Ix,norm(P,1),r,lim);
V=min(min(V2,V3),V4);
%-------------------------------------------------------------------------

% output structure
% info.Rr(aux,1) = Rr;
info.s(aux,1) = s;
info.V(aux,1) = V;
% info.V1(aux,1) = V1;
% info.new_par = new_par;
