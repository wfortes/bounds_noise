function [u,l] = boundxbin_l2(q,delta,k)

% Compute a lower and upper bound for the l2 norm of any binary solution of
% Wx=p for an unkown p. 
% delta is a given upper bound for the euclidean distance between p and a 
% given q.
% k is the number of projecton angles.

l = sqrt((norm(q)-delta)/k);
u = sqrt(sqrt(size(q,1))*(norm(q)+delta)/k);
