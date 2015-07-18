function [u,l,ub1,ub2] = boundxls_l1(l1pinv,delta,z,q,k)

% Compute an upper and lower bound for the l2 norm of the least square
% solution of Wx=p, where p is unkown.
%
% delta is a given upper bound for the euclidean distance between p and a
% given q.
%
% k is the number of projection angles
% singv is the vector of the singular values of a given matrix W
% z is the least square solution of Wz=q

unormp = norm(q,1)+delta;
if isempty(l1pinv)
    lowl1 = 0;
    uppl1 = inf;
else
l = max(norm(z)-l1pinv*delta,0);
ub1 = l1pinv*unormp;
end
ub2 = sqrt(unormp/k);

u = min(ub1,ub2);

