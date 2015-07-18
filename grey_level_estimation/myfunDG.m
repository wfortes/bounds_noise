function y = myfunDG(M1,M2,g,Q) % WRONG

x =  = fminbnd(@(x) myfun_DG(x,M1,M2,x,Q),0,1);

function f = myfun_DG(x,M1,M2,g,Q)

f = norm(Q-M1*g-M2*x)^2;
