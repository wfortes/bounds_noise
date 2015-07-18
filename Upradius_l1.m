function NR = Upradius_l1(l1pinv,delta,sUR,q,k,zls)

% upperbound for the radius
% ||xbar-zls||<=NR

UB1 = sqrt(l1pinv^2*delta^2+sUR); % based on the pseudoinverse

normzbin = sqrt(norm(q,1)/k);
takesmaller = min(norm(zls),normzbin); % due to floating point error
UB2 = sqrt((norm(q,1)+delta)/k)+takesmaller;
NR = min(UB1,sqrt(UB2^2+sUR));
