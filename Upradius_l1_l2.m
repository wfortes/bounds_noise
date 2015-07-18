function NR = Upradius_l1_l2(sv,l1pinv,delta1,delta2,sUR,q,k,zls)

% upperbound for the radius
% ||xbar-zls||<=NR

if isempty(sv)
    uppl2 = inf;
else
    uppl2 = sqrt(max(sv)^2*delta2^2+sUR); % based on the pseudoinverse
end

if isempty(l1pinv)
    uppl1 = inf;
else
    uppl1 = sqrt(l1pinv^2*delta1^2+sUR); % based on the pseudoinverse
end

normzbin = sqrt(norm(q,1)/k);
takesmaller = min(norm(zls),normzbin); 
% due to numerical error, it may happen that norm(zls) is bigger than
% normzbin, which should not be possible

upp = sqrt((norm(q,1)+delta1)/k)+takesmaller;
NR = min(sqrt(upp^2+sUR),min(uppl1,uppl2));
