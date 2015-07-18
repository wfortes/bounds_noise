% % to store data
% clear all
% a='started'
% img_set = [1,2,3,5];
% ratio_set = [32,16,8,4];
% img_sz_set = [128,256,512];
% type_set = [0,1];
% for typecod = type_set
%     if typecod==0
%         type = 'Grid';
%         typeshort = 'G';
%     else
%         type = 'Strip';
%         typeshort = 'S';
%     end
%     for img_index = img_set
%         for ratio = ratio_set
%             for img_sz = img_sz_set
%                 N_proj=img_sz/ratio;
%                 M = loadmatrix(img_index,img_sz,ratio,type,'Matrix'); % Strip or Grid
%                 P = img_read(img_index,img_sz);
%                 P = reshape(P,img_sz^2,1);
%                 P = double(P);
%
%                 P = P/norm(P,inf); % only for binary images
%                 % forward project
%                 Q = M * P;
%                 %                 [R, res, rez, sol] = pcgne(M, Q, 25, 1e-5);
%
%                 img = num2str(img_index);
%                 sz = num2str(img_sz);
%                 rat = num2str(ratio);
%
%                 M = full(M);
%                 pinvM = pinv(M);
%                 sv = svd(pinvM);
%                 R = pinvM*Q;
%
%                 varname = strcat('pinvM');
%                 filename = strcat(varname,typeshort,'-Im',img,'-sz',sz,'-r',rat);
%                 save(filename,varname);
%
%                 varname = strcat('sv');
%                 filename = strcat(varname,typeshort,'-Im',img,'-sz',sz,'-r',rat);
%                 save(filename,varname);
%
%                 varname = strcat('R');
%                 filename = strcat(varname,typeshort,'-Im',img,'-sz',sz,'-r',rat);
%                 save(filename,varname);
%
%                 clear M
%                 clear sv
%                 %             %             filename = strcat('QS','-Im',img,'-sz',sz,'-r',rat);
%                 %             %             save(filename,'Q');
%                 %             R = loadmatrix(img_index,img_sz,ratio,'Grid','Minsol');
%                 %             Q = loadmatrix(img_index,img_sz,ratio,'Grid','Rightside');
%
%             end
%         end
%     end
% end
% a='finished'
% %%
% %
% %  Save the perturbed right ahnd side
%
% clear all
% a='started'
% img_set = 1;%[1,2,3,5];
% ratio_set = [32,16,8,4];
% img_sz_set = [32,64,128,256,512];
% type_set = 1;%[0,1];
% for typecod = type_set
%     if typecod==0
%         type = 'Grid';
%         typeshort = 'G';
%     else
%         type = 'Strip';
%         typeshort = 'S';
%     end
%     for img_index = img_set
%         for ratio = ratio_set
%             for img_sz = img_sz_set
%                 N_proj=img_sz/ratio;
%                 img = num2str(img_index);
%                 sz = num2str(img_sz);
%                 rat = num2str(ratio);
%
%                 Q = loadmatrix(img_index,img_sz,ratio,type,'Rightside');
%                 randfactor = -1+2.*rand(size(Q,1),1); %[-1,1]
%                 varname = strcat('randfactor');
%                 filename = strcat(varname,'-',typeshort,'-sz',sz,'-r',rat);
%                 save(filename,varname);
%                 % randfactor = a + (b-a).*rand(100,1); % [-1,1]
%                 % QP = Q+randfactor*maxpert*Q;
%             end
%         end
%     end
% end
% a='finished'
%%
% Save the perturbed right ahnd side

clear all
a='started'
img_set = 10;%[1,2,3,5];
img_sz_set = 610;%[32,64,128,256,512];
type_set = 1;%[0,1];
it = 0;
for typecod = type_set
    if typecod==0
        type = 'grid';
    else
        type = 'strip';
    end
    for img_sz = img_sz_set
        if img_sz==32
            maxpert_set = [0.25,0.5,1,2,4];
            N_proj_set = [2,4,6,8,10,12,14,16];
        elseif img_sz==64
            maxpert_set = [0.5,1,2,4,8];
            N_proj_set = [2,4,8,12,16,20,24,28,32];
        elseif img_sz==128
            maxpert_set = [1,2,4,8,16];
            N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
        elseif img_sz==256
            maxpert_set = [2,4,8,16,32];
            N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
        elseif img_sz==512
            maxpert_set = [4,8,16,32,64];
            N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
            elseif img_sz==610
            maxpert_set = [4,8,16,32,64];
            N_proj_set = [8,16,32,48,64,72,80];
        end
        for maxpert = maxpert_set
            for img_index = img_set
                it2 = it+1;
                for N_proj = N_proj_set
                    
                    
                    img = num2str(img_index);
                    sz = num2str(img_sz);
                    proj = num2str(N_proj);
                    e = num2str(maxpert);
                    
                    address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';
%                     M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
                    M_file = strcat(address,'matrix_angle_eq_distr/M-',type,'-sz',sz,'-proj',proj,'.mat');
                    load(M_file);
                    P = rgb2gray(imread('open_ring2.png'));
%                     P = img_read(img_index,img_sz);
                    P = reshape(P,img_sz^2,1);
                    P = double(P);
                    P = P/norm(P,inf); % only for binary images
                    Q = M*P;
                    %                     randfactor = loadmatrix(address,img_sz,N_proj,type,'randfactor');
                    %                     PQ = Q + maxpert*randfactor.*Q;
                    %                     PQ = Q + imnoise(Q,'gaussian',0,maxpert);
                    PQ = Q + maxpert*normrnd(0,1,[length(Q),1]);
                    %                     PQ = astra_add_noise_to_sino_fixed_scaling(Q,maxpert);
                    idx = find(PQ < 0);
                    PQ(idx) = 0;
                    filename = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',e,'.mat');
                    save(filename,'PQ');
                    
                    [xls, res, sol] = cgls_W(M, Q, [], 500, 1e-10);
                    address = '/export/scratch1/fortes/PhD_files/Load/';
                    filename = strcat(address,'xls/xls-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',e,'.mat');
                    save(filename,'xls');
                    
                    [zls, res, sol] = cgls_W(M, PQ, [], 100, 1e-10);
                    address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/sol/';
                    sol_name = strcat(address,sz,'/sol-',type,'-Im',img,'-sz',sz,'-p',proj,'-n',e,'.mat');
                    save(sol_name,'sol');
                    
                    min_error_norm = inf;
                    for i = 1:size(sol,2)
                        error_norm = norm(sol(:,i)-xls);
                        if error_norm < min_error_norm
                            min_error_norm = error_norm;
                            iteration = i;
                        end
                    end
                    it = it + 1;
                    it_vector(it,1) = iteration;
                    zls = sol(:,iteration);
                    address = '/export/scratch1/fortes/PhD_files/Load/';
                    filename = strcat(address,'zls/zls-',type,'-img',img,'-sz',sz,'-proj',proj,'-n',e,'.mat');
                    save(filename,'zls');
                end
                it_address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/cgls_data/';
                it_vec = it_vector(it2:it);
                it_filename = strcat(it_address,'It_mean-Im',img,'-sz',sz,'-n',e,'-mean',num2str(mean(it_vec)),'.mat');
                save(it_filename,'it_vec');
            end
        end
    end
end
it_filename = strcat(it_address,'ITERATIONS.mat');
save(it_filename,'it_vector');
a='finished'
%%
%  Check existence of negative entries in the projection vector

% clear all
% a='started'
% img_set = [1,2,3,5];
% img_sz_set = [32,64,128,256,512];
% type_set = 1;%[0,1];
% for typecod = type_set
%     if typecod==0
%         type = 'grid';
%     else
%         type = 'strip';
%     end
%     for img_sz = img_sz_set
%         for img_index = img_set
%             if img_sz==32
%                 maxpert_set = [0.25,0.5,1,2,4];
%                 N_proj_set = [2,4,6,8,10,12,14,16];
%             elseif img_sz==64
%                 maxpert_set = [0.5,1,2,4,8];
%                 N_proj_set = [2,4,8,12,16,20,24,28,32];
%             elseif img_sz==128
%                 maxpert_set = [1,2,4,8,16];
%                 N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
%             elseif img_sz==256
%                 maxpert_set = [2,4,8,16,32];
%                 N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
%             elseif img_sz==512
%                 maxpert_set = [4,8,16,32,64];
%                 N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
%             end
%             for N_proj = N_proj_set
%                 for maxpert = maxpert_set
%                     img = num2str(img_index);
%                     sz = num2str(img_sz);
%                     proj = num2str(N_proj);
%                     var = num2str(maxpert);
%
%                     address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';
%                     M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
%                     load(M_file);
%                     P = img_read(img_index,img_sz);
%                     P = reshape(P,img_sz^2,1);
%                     P = double(P);
%                     P = P/norm(P,inf); % only for binary images
%                     Q = M*P;
%
%                     filename = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',var,'.mat');
%                     load(filename);
%
%                     norm(Q-PQ,inf)
%                     if min(PQ)<0
%                         min(PQ)
%                     end
%                 end
%             end
%         end
%     end
% end
% a='finished'