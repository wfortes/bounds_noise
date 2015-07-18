function [info] = perturb_core(img_index,N_proj,img_sz,aux,type,info)

% this is the core of the code with perturbation

proj = num2str(N_proj);
img = num2str(img_index);
sz = num2str(img_sz);
                    
%     [dir_a,dir_b]=mkdirvecs(20);
%     M = mkmatrix(img_sz,img_sz,dir_a(1:N_proj),dir_b(1:N_proj));
%     M = loadmatrix(address,img_sz,N_proj,type,'matrix');
      address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';
      M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
      load(M_file);

P = img_read(img_index,img_sz);
P = reshape(P,img_sz^2,1);
P = double(P);
P = P/norm(P,inf); % only for binary images

Q = M*P;

% Creating the perturbed right hand side

if ~isempty(info.vari)
    var = num2str(info.vari);
    PQ_file = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',var,'.mat');
    load(PQ_file);
%     PQ_aux = loadmatrix(address,img_sz,N_proj,type,'PQ',img_index,info.vari);
%     PQ = PQ_aux(1:size(M,1),1);
    delta2 = norm(Q-PQ,2);
    delta1 = norm(Q-PQ,1);
else
    PQ = Q;
    delta1 = info.delta*norm(Q,1);
    delta2 = info.delta*norm(Q,2);
end

if ~isempty(info.sv) && delta2 ~= 0
    sv = loadmatrix(address,img_sz,N_proj,type,'sv');
    sv = 1/min(sv);
elseif delta2 ~= 0
    sv = loadmatrix(address,img_sz,N_proj,type,'sv_pinv');
    sv = max(sv);
end
if (img_sz == 32 || img_sz == 64) && delta1 ~= 0
    pinvM = loadmatrix(address,img_sz,N_proj,type,'pinvM');
    l1pinv = norm(pinvM,1);
    clear pinvM
else
    l1pinv = 300000; % just to make a huge bound (if there is an error) and then I can identify
end
if delta2 == 0
    sv = 300000;
end
%--------------------------------------------------------------------------
% M = full(M);
% pinvM = pinv(M);
% sv = svd(pinvM);
% R_1 = pinvM*Q;
% to be used with the Moore-Penrose pseudoinverse
% R = pinvM*PQ; % Least square solution of the perturbed system
% clear pinvM
% sv = loadmatrix(img_index,img_sz,ratio,type,'sv');
% sv = max(sv);

[R, res, sol] = cgls_W(M, PQ, [], 1000, 1e-10);
npix = size(R,1); % number of pixels
% rel_error_noiseless = norm(P-R)/npix;

% ------------ 1st stage -----------
% computing norm(xbin) from its projection: upper and lower bound
[uxbin,lxbin] = boundxbin_l1(PQ,delta1,N_proj);

%-------------------------------------------------------------------------
% Bound norm(x*) % Lemma 2 and 4
[uxls,lxls] = boundxls_l1_l2(sv,l1pinv,delta1,delta2,R,PQ,N_proj);

% Bound the distance between 2 bin sol based on xbin(zbin)
[V,sUR,sLR] = variabpert(lxbin,uxls,uxbin,lxls,npix);

% ------------ 2nd stage -----------
% New radius based on z*
NR = Upradius_l1_l2(sv,l1pinv,delta1,delta2,sUR,PQ,N_proj,R);

% obtain the rounded vector and the vector of increment b
[r, b, ordb, Ix, alpha] = round2binary(R);

Rr = norm(P-r,1)/npix; % Computes the % of wong pixels in r

parameter = NR^2 - dot(alpha,alpha);

% bound the number of wrong pixels
lim = 'notlimited'; % limited case: Bmaxs would have to be changed cause keeping the norm based on Q is not good
[s_aux] = bnwpixr(ordb,parameter,Ix,norm(PQ,1)/N_proj,r,lim); 
s = s_aux/npix;
[~,V3,V4,~,~] = variability(npix,NR^2,s,ordb,parameter,Ix,[],r,lim);
V=min(V3,min(V4,V));
% %-------------------------------------------------------------------------

% output structure
info.R = R;
% info.M = M;
% info.rel_error_noiseless(aux,1) = rel_error_noiseless;
info.Rr(aux,1) = Rr;
info.s(aux,1) = s;
info.V(aux,1) = V;
% info.V1(aux,1) = V1;
% info.V2(aux,1) = V2;
% info.wpix(aux,1) = wpix;
info.sol = sol;
info.npix = npix;
info.delta_abs(aux,1) = max(delta1,delta2);
info.delta_rel(aux,1) = max(delta1/norm(Q,1),delta2/norm(Q,2));
