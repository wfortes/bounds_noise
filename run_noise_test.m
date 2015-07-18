clear all;
img_sz_set = 32;%[32,128];%,512];%[32,64,128,256,512];
img_index_set = 2;%[1,2,3,5];
data1 = initialize; data2 = initialize; data3 = initialize; data4 = initialize;
type_set = 1;%[0,1];%[0,1,2,3];
it=0;
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
            maxpert_set = 1;%[0.5,1,2];%[0.25,0.5,1,2];
            N_proj_set = [2,4,6,8,10,12,14,16];
        elseif img_sz==64
            maxpert_set = [1,2,4];%[0.5,1,2,4];
            N_proj_set = [2,4,8,12,16,20,24,28,32];
        elseif img_sz==128
            maxpert_set = 4;%[2,4,8];%[1,2,4,8];
            N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
        elseif img_sz==256
            maxpert_set = [4,8,16];%[2,4,8,16];
            N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
        elseif img_sz==512
            maxpert_set = [8,16,32];%[4,8,16,32];
            N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152];%,168,184,200];
        end
        
        for vari = maxpert_set
            for img_index = img_index_set;
                aux = 1;
                data1.vari = vari;
                data2.vari = vari;
                data3.vari = vari;
                data4.vari = vari;
                it2 = it+1;
                for N_proj = N_proj_set
                    %  data2.sv = 1;
                    data1.sv = [];
                    [data1] = perturb_core_relax(img_index,N_proj,img_sz,aux,type,data1);
                    data2.sv = [];
                    [data2] = perturb_core_relax2(img_index,N_proj,img_sz,aux,type,data2);
                    data3.sv = [];
                    [data3] = perturb_core_relax3(img_index,N_proj,img_sz,aux,type,data3);
                    data4.sv = [];
                    [data4] = perturb_core_relax4(img_index,N_proj,img_sz,aux,type,data4);
                    
                    proj = num2str(N_proj);
                    img = num2str(img_index);
                    sz = num2str(img_sz);
                    e = num2str(vari);
                                       
                    aux = aux+1;
%                     it = it + 1;
%                     new_par(it,1)=data2.new_par;
                end
%                 it_address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/graphs/new_par/';
%                 parameter = new_par(it2:it);
%                 it_filename = strcat(it_address,'para_mean-Im',img,'-sz',sz,'-n',e,'-mean',num2str(mean(parameter)),'.mat');
%                 save(it_filename,'parameter');
                % ---------- Graphics -------------
%                 figura =semilogy(N_proj_set,data1.V(:,1),'k-x','LineWidth',2,'MarkerSize',8);
              figura = semilogy(N_proj_set,data1.s(:,1),'k-+','LineWidth',2.5,'MarkerSize',9);
                hold on
%                 semilogy(N_proj_set,data2.V(:,1),'m-x','LineWidth',2,'MarkerSize',8);
%                 semilogy(N_proj_set,data3.V(:,1),'b-x','LineWidth',2,'MarkerSize',8);                
                semilogy(N_proj_set,data4.s(:,1),'m-o','LineWidth',2.5,'MarkerSize',9);
                semilogy(N_proj_set,data2.s(:,1),'b-d','LineWidth',2.5,'MarkerSize',9);
                semilogy(N_proj_set,data3.s(:,1),'g-x','LineWidth',2.5,'MarkerSize',9);                
                semilogy(N_proj_set,data1.Rr(:,1),'r-s','LineWidth',2.5,'MarkerSize',9);
                
%                 legend('V','br','error')
legend('B0.02F','B0.002','B0','True radius','True error')
                hold off;
                set(gca,'fontsize',18)
                xlabel('Number of proj. angles','fontsize',23)
                ylabel('Fraction of pixels','fontsize',23)
                %
                address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/graphs/';
                filename = strcat(address,'Noise_test-',type,'-Im',img,'-sz',sz,'-e',e,'.fig');
                saveas(figura,filename);
                clear figura;
                
            end
            data1=initialize; data2=initialize; data3=initialize; data4 = initialize;
        end
    end
end