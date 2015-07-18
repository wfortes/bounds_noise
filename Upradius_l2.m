function NR = Upradius_l2(sv,delta,sUR,q,k,zls)

% upperbound for the radius
% ||xbar-zls||<=NR

if isempty(sv)
    UB1 = inf;
else
    UB1 = sqrt(max(sv)^2*delta^2+sUR); % based on the pseudoinverse
end
normzbin = sqrt(norm(q,1)/k);
takesmaller = min(norm(zls),normzbin); % due to floating point error
UB2 = sqrt(sqrt(length(q))*(norm(q)+delta)/k)+takesmaller;
NR = min(UB1,sqrt(UB2^2+sUR));
