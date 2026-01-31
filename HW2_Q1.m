% sampling 100
U1 = rand(100,1);
x1 = 10 ./ (1 - U1).^(1/3);
% sampling 1,000
U2 = rand(1000,1);
x2 = 10 ./ (1 - U2).^(1/3);
% sampling 10,000
U3 = rand(10000,1);
x3 = 10 ./ (1 - U3).^(1/3);

% common plotting range and bins
xmin = 10; xmax = 60; % f(x) >= 10 and the plot ends at 60
nbins = 50; % bin for each value
edges = linspace(xmin, xmax, nbins+1); % +1 for avoiding fencepost error

figure
hold on

% histograms with transparency
% of 100
h1 = histogram(x1,  'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.6, 'FaceColor','red'); % , [0 0.4470 0.7410]
% of 1000
h2 = histogram(x2, 'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.4, 'FaceColor', 'green'); % [0.8500 0.3250 0.0980]
% of 10000
h3 = histogram(x3, 'BinEdges', edges, 'Normalization', 'pdf', 'FaceAlpha', 0.25,'FaceColor', 'blue'); %  [0.9290 0.6940 0.1250]

% plotting pdf f(x)=3(10^3)x^(-4)=3000*x^(-4)
% making row vector of all the points
xplot = linspace(xmin, xmax, 1000);
% setting the points to all zeros for now
f = zeros(size(xplot));
% making row vector of whether the x-value is above 10
above10 = xplot>=10;
% using the row vector above10 to put f(x) as the pdf where x>=10
f(above10) = 3000.*xplot(above10).^(-4);
plot(xplot, f, 'k-', 'LineWidth', 1.5)

% Labelling and such.
% horizontal range from 0 to 60 although f(x) from 0 to 10 is 0
xlim([0 xmax])
xlabel('x value')
ylabel('f(x) and the histograms')
legend('N=100-sampled histogram','N=1000-sampled histogram','N=10000-sampled histogram','f(x)=3000 x^{-4}','Location','northeast')
grid on
hold off
