% x\geq 0, I'll graph until 60.
x = linspace(0,60,1000);

a=sqrt(3)-1;
c=((42-24*sqrt(3))*exp(a))^(-1);
% using matlab functions,
f = @(x) (1/3) .* x .* (1 + x) .* exp(-x);
g = @(x) (a^2) .* x .* exp(-a .* x);
% into vectors to plot 
yf = f(x);
yg = c .* g(x);
% plots
figure;
h1=plot(x,yf,'-k','LineWidth',1.5); hold on;
h2=plot(x,yg,'-r','LineWidth',1.5);
legend([h1 h2],{'f(x)','cg(x)'},'Location','best');
hold off;

% Labels
xlabel('x');
ylabel('f(x) and cg(x)');
grid on;
xlim([0 60]);