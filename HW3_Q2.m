% matrix p
p = [9/10 1/10 0; 0 7/8 1/8; 2/5 0 3/5];
B=p^50 %the matrix raised to the 50th power


%Below is the simulation of the markov process. I use the fact that
% P(U\leq x) for U\sim U(0, 1) and x\in (0, 1) is x.
state = 1; % continuing that 1 = G, 2 = S, 3 = D.
timeInG = 0;
for i=1:1000
    u=rand;
%if in state 1
if state==1
    timeInG = timeInG+1;
    if u <= 1/10 %so with probability 1/10
        state = 2;
    end %No need for else, it'll just stay in 1.
elseif state==2
    if u <= 1/8 %so, with probability 1/8
        state = 3;
    end
else %state must be 3
    if u <= 2/5
        state = 1;
    end
end
end
fracTime = timeInG/1000
