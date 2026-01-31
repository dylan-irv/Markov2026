tic %a bit "unfair" to the first count, I took the first time to generate the uniform random variable and
% configure other things. Throughout this

% Generating N=10^6 uniform samples
N = 1000000;
U=rand(N, 1);
% If F(x)=U, then F(x)-U=0. So, I'll use Newton's method
% F(x) = 1-exp(-x)*(x+1) but to work as a vector it'll be done with
% (column vector) ex=exp(-x), (column vector) F = 1-ex.*(x+1),
% (column vector) deltax = (F-U)./(dF) and so on

% initial guesses = E[X] = 2
x = zeros(N, 1)+2;

% tolerances loosely based on histogram bins
xmin = 0; xmax = 60; NumBins = 200; % Rice's rule 2*N^(1/3) bins
binWidth = (xmax-xmin)/NumBins;
tolerance = binWidth/10;

maxSteps = 300;
dontDiv0 = 10^(-20); % to not divide by zero

% to cut down on calculations without nested loops, I'll mask x with
% "mask". If an x was calculated with deltax<tolerance, the index is skipped
% over for the rest of the calculation. (since it should then be "masked
% out".) But I'm not much into programming so it may not be working in the
% intended way. No matter, the times don't even come close and I found this
% to be several times faster than nested for loops.
mask = true(N, 1);
calcdeltax = zeros(N, 1);
% indices that are being calculated are given "calc" in the code


deltax = zeros(N, 1);

for k = 1:300 % max steps 300 is sort of arbitrary, but with the million samples, a good amount probably hit this.
    if ~any(mask)
        disp("break") %rarely happens.
        break
    end
    calcx = x(mask);
    calcU = U(mask);
    ex = exp(-calcx);
    F = 1-ex.*(calcx+1);
    dF = calcx.*ex;
% using x_n+1 = x_n - (F(x)/F'(x))
    calcdeltax= (F-calcU)./max(dF, dontDiv0);
    calcx = calcx-calcdeltax;
   % updating things that were calculated
    x(mask) = calcx;
%    deltax(mask)=calcdeltax; % this is a sort of debug logging of the dx
    % updating mask if a certain entry is done being calculated
    done = abs(calcdeltax)<tolerance;
    indexdone = find(mask);
    mask(indexdone(done)) = false;
end

x1 = x.'; %turn into row vector for histogram
toc

edges = linspace(xmin, xmax, NumBins+1); % +1 for fencepost error
hold on
h1 = histogram(x1,  'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.3, 'FaceColor','red');

tic
% I'll use acceptance-rejection with exponential proposal given in the HW.
accepted = zeros(N, 1);
numAccept = 0;
% I'll loop this in 
while numAccept < N
    % Inverse sample exponential
    u = rand;
    proposal = -2*log(u); %Using 1-W~U(0, 1)
    % Accept proposal (or not)
    u = rand;
    if u<=((proposal*exp(-proposal))/(4*exp(-1)*(1/2)*exp(-(proposal/2))))
        accepted(numAccept+1)=proposal;
        numAccept=numAccept+1;
    end
end
toc
x2 = accepted.';
h2 = histogram(x2,  'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.3, 'FaceColor','blue');
tic
% Generating samples from the sum of two independent exponentials. I also
% use that -log(1-W)= -log(U) where 1-W~U(0, 1) so U~U(0, 1)
firstU=rand(1, N);
secondU=rand(1, N);
x3=-log(firstU)+(-log(secondU));
toc
h3 = histogram(x3,  'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.3, 'FaceColor','green');
% making row vector of all the points
xplot = linspace(xmin, xmax, 1000);
ex=exp(-xplot);
f = xplot.*ex;
plot(xplot, f, 'k-', 'LineWidth', 1.5)

% Labelling and such.
% horizontal range from 0 to 60 (I wasn't exactly sure of this, but my
% tolerances were based on accommodating this range
xlim([0 xmax])
xlabel('x value')
ylabel('f(x) and the histograms')
legend('Newtons root-finding method','Acceptance-rejection sampling','sampling as a sum of two exponentials','f(x)=xe^{-x}','Location','northeast')
grid on
hold off
