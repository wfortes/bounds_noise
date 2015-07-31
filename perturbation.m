function PQ = perturbation(Q, maxpert, mu, sigma)
% Additive noise from uniform distribution with mean MU and standard
% deviation SIGMA
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

if isempty(mu)
    mu = 0;
end
if isempty(sigma)
    sigma = 1;
end
PQ = Q + maxpert*normrnd(mu, sigma,[length(Q),1]);
PQ(PQ < 0) = 0;