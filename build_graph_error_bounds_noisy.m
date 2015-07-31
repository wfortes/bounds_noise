function build_graph_error_bounds_noisy(data,proj)
% Build graphs
%
%--------------------------------------------------------------------------
%

figure;
semilogy(proj,data.V1(:,1),'b-s','LineWidth',2,'MarkerSize',8);
hold on
semilogy(proj,data.U1(:,1),'m-+','LineWidth',2,'MarkerSize',8);
semilogy(proj,data.Pr(:,1),'k-o','LineWidth',2,'MarkerSize',8);

legend('V1','U1','Pr')
hold off;
set(gca,'fontsize',18)
xlabel('Number of proj. angles','fontsize',23)
ylabel('Fraction of pixels','fontsize',23)
title('Error bounds for reconstruction from noisy data','fontsize',12)

%
%--------------------------------------------------------------------------
%

