function u = boundxlszls(singv,delta)

% Compute an upper bound for the l2 norm of the difference between the
% least square solutions of Wx=p and Wz=q, where p is unkown. 
% 
% delta is a given upper bound for the euclidean distance between p and a 
% given q.
% 
% singv id the maximum singular value of the pseudoinverse of W
% norm(xls-zls)<=max(svd((pinv(W))))*delta

u = max(singv)*delta; 
