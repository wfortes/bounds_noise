% clear all;
% img_sz_set = [32,64];%,128,256,512];
% img_index_set = [1,2,3,5];
% vari_set = [0.5,1,0.5*1e+1,1e+1,0.5*1e+2,1e+2];%[1e+3,1e+4,1e+5,1e+6,1e+7];
% data1 = initialize; data2 = initialize;
% type_set = 1;%[0,1];%[0,1,2,3];
%
% for typecod = type_set
%     if typecod==0
%         type = 'grid';
%     elseif typecod==1
%         type = 'strip';
%     elseif typecod==2
%         type = 'line';
%     elseif typecod==3
%         type = 'linear';
%     end
%     for img_sz = img_sz_set
%         if img_sz==32
%             N_proj_set = [2,4,6,8,10,12,14,16];
%         elseif img_sz==64
%             N_proj_set = [2,4,8,12,16,20,24,28,32];
%         elseif img_sz==128
%             N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
%         elseif img_sz==256
%             N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
%         elseif img_sz==512
%             N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
%         end
%
%         for vari = vari_set
%             for img_index = img_index_set;
%                 for N_proj = N_proj_set
%
% %                     address = '/export/scratch1/fortes/PhD_files/Load/';
% %                     M = loadmatrix(address,img_sz,N_proj,type,'matrix');
%                     proj = num2str(N_proj);
%                     img = num2str(img_index);
%                     sz = num2str(img_sz);
%                     e = num2str(vari);
%                     address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';
%                     M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
%                     load(M_file);
%
%                     P = img_read(img_index,img_sz);
%                     P = reshape(P,img_sz^2,1);
%                     P = double(P);
%                     P = P/norm(P,inf); % only for binary images
%
%                     PQ_file = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',e,'.mat');
%                     load(PQ_file);
%
%                     address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/cgls_data/';
%                     sol_name = strcat(address,'sol/sol-',type,'-Im',img,'-sz',sz,'-p',proj,'-e',e,'.mat');
%                     load(sol_name)
%
%                     sol_norm = zeros(size(sol,2),1);
%                     error_norm = zeros(size(sol,2),1);
%                     res_norm = zeros(size(sol,2),1);
%                     for i = 1:size(sol,2)
%                         error_norm(i,1) = norm(sol(:,i)-P)/norm(P);
%                         res_norm(i,1) = norm(M*sol(:,i)-PQ)/norm(PQ);
%                         sol_norm(i,1) = norm(sol(:,i));
%                     end
%
%                     % ---------- Graphics -------------
%                     figura =semilogy(1:size(sol,2),error_norm,'b-s','LineWidth',2,'MarkerSize',8);
%                     hold on
%                     semilogy(1:size(sol,2),res_norm,'r-x','LineWidth',2,'MarkerSize',8);
%                     semilogy(1:size(sol,2),sol_norm,'k--','LineWidth',2,'MarkerSize',8);
%
%                     legend('rel-error','rel-res','sol-norm')
%                     hold off;
%                     set(gca,'fontsize',15)
%                     xlabel('Number of iterations','fontsize',20)
%                     ylabel('Relative difference','fontsize',20)
%                     %
%                     filename = strcat(address,'graph/graphs_cgls-',type,'-Im',img,'-sz',sz,'-e',e,'p',proj,'.fig');
%                     saveas(figura,filename);
%                     clear figura;
%                 end
%             end
%             data1=initialize; data2=initialize;
%         end
%     end
% end
%%

clear all;
img_sz_set = [32,64,128,256,512];
img_index_set = [1,2,3,5];
vari_set = [0.25,0.5,1,2,4];
data1 = initialize; data2 = initialize;
type_set = 1;%[0,1];%[0,1,2,3];
it = 0;

for typecod = type_set
    if typecod==0
        type = 'grid';
    elseif typecod==1
        type = 'strip';
    elseif typecod==2
        type = 'line';
    elseif typecod==3
        type = 'linear';
    end
    for img_sz = img_sz_set
        if img_sz==32
            N_proj_set = [2,4,6,8,10,12,14,16];
        elseif img_sz==64
            N_proj_set = [2,4,8,12,16,20,24,28,32];
        elseif img_sz==128
            N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
        elseif img_sz==256
            N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
        elseif img_sz==512
            N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
        end
        
        for vari = vari_set
            for img_index = img_index_set;
                it2 = it+1;
                for N_proj = N_proj_set
                    
                    %                     address = '/export/scratch1/fortes/PhD_files/Load/';
                    %                     M = loadmatrix(address,img_sz,N_proj,type,'matrix');
                    proj = num2str(N_proj);
                    img = num2str(img_index);
                    sz = num2str(img_sz);
                    e = num2str(vari);
                    %
                    %                     address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/';
                    %                     M_file = strcat(address,'matrix_angle_eq_distr/strip/M-',type,'-sz',sz,'-proj',proj,'.mat');
                    %                     load(M_file);
                    %
                    %                     P = img_read(img_index,img_sz);
                    %                     P = reshape(P,img_sz^2,1);
                    %                     P = double(P);
                    %                     P = P/norm(P,inf); % only for binary images
                    %
                    %                     Q = M*P;
                    %                     PQ_file = strcat(address,'PQ_a_eq_distr/PQ-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',e,'.mat');
                    %                     load(PQ_file);
                    %                     [xls, res, sol] = cgls_W(M, Q, [], 500, 1e-10);
                    %                     [zls, res, sol] = cgls_W(M, PQ, [], 100, 1e-10);
                    %
                    address = '/export/scratch1/fortes/PhD_files/Load/';
                    filename = strcat(address,'xls/xls-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',e,'.mat');
                    %                     save(filename,'xls');
                    load(filename)
                    
                    address = '/export/scratch1/fortes/PhD_files/Load/gaussian_noise/sol/';
                    sol_name = strcat(address,sz,'/sol-',type,'-Im',img,'-sz',sz,'-p',proj,'-e',e,'.mat');
                    load(sol_name)
                    %                     save(sol_name,'sol');
                    
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
                    
                    %                 address = '/export/scratch1/fortes/PhD_files/Load/';
                    %                 zls = sol(:,iteration);
                    %                 filename = strcat(address,'zls/zls-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',e,'.mat');
                    %                 save(filename,'zls');
                end
                it_address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/cgls_data/';
                it_vec = it_vector(it2:it);
                it_filename = strcat(it_address,'It_mean-Im',img,'-sz',sz,'-e',e,'-mean',num2str(mean(it_vec)),'.mat');
                save(it_filename,'it_vec');
            end
            data1=initialize; data2=initialize;
        end
    end
end
it_filename = strcat(it_address,'ITERATIONS.mat');
save(it_filename,'it_vector');