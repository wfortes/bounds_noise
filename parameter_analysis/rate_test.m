clear all;
img_sz_set = [32,64,128,256,512];
img_index_set = [1,2,3,5];
vari_set = [0.25,0.5,1,2,4];
data1 = initialize; data2 = initialize;
type_set = 1;

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
        for img_index = img_index_set;
            it=0;
            parameter = zeros(length(N_proj_set),length(vari_set));
            for vari = vari_set
                it = it + 1;
                current_proj = 0;
                for N_proj = N_proj_set
                    current_proj = current_proj +1;
                    
                    proj = num2str(N_proj);
                    img = num2str(img_index);
                    sz = num2str(img_sz);
                    var = num2str(vari);
                    
                    zls_address = '/export/scratch1/fortes/PhD_files/Load/';
                    zls_filename = strcat(zls_address,'zls/zls-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',var,'.mat');
                    load(zls_filename)
                    xls_filename = strcat(zls_address,'xls/xls-',type,'-img',img,'-sz',sz,'-proj',proj,'-var',var,'.mat');
                    load(xls_filename)

                    parameter(current_proj,it) = dot(zls,xls)/norm(zls)^2;
                end
            end
            % ---------- Graphics -------------
            figura = plot(N_proj_set,parameter(1:length(N_proj_set),1),'b','LineWidth',2,'MarkerSize',8);
            hold on
            plot(N_proj_set,parameter(1:length(N_proj_set),2),'k','LineWidth',2,'MarkerSize',8);
            plot(N_proj_set,parameter(1:length(N_proj_set),3),'m','LineWidth',2,'MarkerSize',8);
            plot(N_proj_set,parameter(1:length(N_proj_set),4),'r','LineWidth',2,'MarkerSize',8);
            plot(N_proj_set,parameter(1:length(N_proj_set),5),'g','LineWidth',2,'MarkerSize',8);
            
            legend('noise 1','noise 2','noise 3','noise 4','noise 5')
            hold off;
            set(gca,'fontsize',15)
            xlabel('Number of proj. angles','fontsize',20)
            ylabel('Fraction of pixels','fontsize',20)
            %
            address = '/ufs/fortes/Desktop/PhD_m_files/tomography/noise_new/parameter_analysis/';
            filename = strcat(address,'rate_test-',type,'-Im',img,'-sz',sz,'.fig');
            saveas(figura,filename);
            clear figura;
        end
    end
end