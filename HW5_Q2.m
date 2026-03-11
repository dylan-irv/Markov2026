% First I'll find the eigenvector through MatLab's eig() solver.
a=0.04;
b=0.16;
K=0.1;
p = [1-K*exp(a), K*exp(a), 0, 0, 0; K*exp(b), 1-K*(exp(b)+exp(2*a)), K*exp(2*a), 0, 0; 0, K*exp(2*b), 1-K*(exp(2*b)+exp(3*a)), K*exp(3*a), 0; 0, 0, K*exp(3*b), 1-K*(exp(3*b)+exp(4*a)), K*exp(4*a); 0, 0, 0, K*exp(4*b), 1-K*exp(4*b)]
% V will be the column vector eigenvectors and D will be the diagonal
% matrix of eigenvalues. I'll output them visually to see them and get an answer.
[V, D]=eig(p');
V
D

% The 4th eigenvector has eigenvalue 1. To normalize it,
v=V(:, 4)
normalizedv=v/sum(v)

% Now, I'll simulate the Markov Chain. It's not an efficient loop but it
% was very easy to think about and program for me. It may not be readable.
X = 0;
U=rand;
N=10^6;
xone=0;
xtwo=0;
xthree=0;
xfour=0;
xfive=0;
if U<=0.2
    X=1;
    xone=1;
elseif U<=0.4
        X=2;
        xtwo=1;
elseif U<=0.6
        X=3;
        xthree=1;
elseif U<=0.8
        X=4;
        xfour=1;
else
    X=5;
    xfive=1;
end

% Now, to actually start the simulation: I'll use the probability
% transition matrix calculated before to make the cumulative threshholds
for t=1:N
    U = rand;
    if X==1
        if U<= p(1, 1)
            xone=xone+1;
        else
            X=2;
            xtwo=xtwo+1;
        end
    elseif X==2
        if U <= p(2, 1)
            X=1;
            xone=xone+1;
        elseif U<= p(2, 1)+p(2, 3)
            X=3;
            xthree=xthree+1;
        else
            xtwo=xtwo+1;
        end
    elseif X==3
        if U<=p(3, 2)
            X=2;
            xtwo=xtwo+1;
        elseif U<=p(3, 2)+p(3, 4)
            X=4;
            xfour=xfour+1;
        else
            xthree=xthree+1;
        end
    elseif X==4
        if U<=p(4, 3)
            X=3;
            xthree=xthree+1;
        elseif U<=p(4, 3)+p(4, 5)
            X=5;
            xfive=xfive+1;
        else
            xfour=xfour+1;
        end
    elseif X==5
        if U<=p(5, 4)
            X=4;
            xfour=xfour+1;
        else
            xfive=xfive+1;
        end
    end
end

simulatedv=[xone/N, xtwo/N, xthree/N, xfour/N, xfive/N]'

% One thing left for me is to "import" my detailed-balance calculated
% answer:
analysisv=[exp(10*(b-a))/(1+exp(4*(b-a))+exp(7*(b-a))+exp(9*(b-a))+exp(10*(b-a)));
    exp(9*(b-a))/(1+exp(4*(b-a))+exp(7*(b-a))+exp(9*(b-a))+exp(10*(b-a)));
    exp(7*(b-a))/(1+exp(4*(b-a))+exp(7*(b-a))+exp(9*(b-a))+exp(10*(b-a)));
    exp(4*(b-a))/(1+exp(4*(b-a))+exp(7*(b-a))+exp(9*(b-a))+exp(10*(b-a)));
    1/(1+exp(4*(b-a))+exp(7*(b-a))+exp(9*(b-a))+exp(10*(b-a)))]

% Now, plotting them all on the same histogram figure: (I didn't know how
% to put pre-calculated probabilities on a histogram, so I just made a bar
% chart)

b=bar({'1', '2', '3', '4', '5'}, [normalizedv, simulatedv, analysisv], 'grouped');
hold on
b(1).FaceColor = "red";
b(2).FaceColor = "green";
b(3).FaceColor = "blue";
ylim([0, 0.4]);
xlabel('State'); ylabel('Probability/Fraction of Time');
legend({'Numerical calculation', 'Simulation', 'Analytical calculation'});
