function [u,l] = boundxls_l1_l2(singv,l1pinv,delta1,delta2,z,q,k)

% Compute an upper and lower bound for the l2 norm of the least square
% solution of Wx=p, where p is unkown.
%
% delta is a given upper bound for the euclidean distance between p and a
% given q.
%
% k is the number of projection angles
% singv is the vector of the singular values of a given matrix W
% z is the least square solution of Wz=q

if isempty(singv)
    lowl2 = 0;
    uppl2 = inf;
else
    lowl2 = max(norm(z)-max(singv)*delta2,0);
    uppl2 = max(singv)*(norm(q)+delta2);
end
if isempty(l1pinv)
    lowl1 = 0;
    uppl1 = inf;
else
    lowl1 = max(norm(z)-l1pinv*delta1,0);
    uppl1 = l1pinv*(norm(q,1)+delta1);
end

l = max(lowl1,lowl2);
% upp = min(sqrt(sqrt(length(q))*(norm(q)+delta)/k),sqrt((norm(q,1)+delta))/k));
upp = sqrt((norm(q,1)+delta1)/k);

u = min(upp,min(uppl1,uppl2));