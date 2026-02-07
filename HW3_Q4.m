% matrix
p = [
sym('1/2') sym('1/2') 0 0 0 0;
0 sym('1/2') sym('1/2') 0 0 0;
sym('1/3') 0 sym('1/3') sym('1/3') 0 0;
0 0 0 sym('1/2') sym('1/2') 0;
0 0 0 0 0 1;
0 0 0 0 1 0]

% matrix to the power of 5, then p^5(1, 4)
B = p^5;
B(1, 4)

% Markov Chain simulation
% I have the matrix p to draw from, so I will.
fours=0;
for i=1:10000
state = 1;
for l=1:5
    u=rand;
    if state == 1
       if u <= 1/2
           state = 2;
       end
    elseif state == 2
        if u <= 1/2
            state = 3;
        end
    elseif state == 3
        if u <= 1/3
            state = 1;
        elseif u <= 2/3 % running this elseif implies u>1/2
            state = 4;
        end
    elseif state == 4
        if u <= 1/2
            state = 5;
        end
    elseif state == 5
        state = 6;
    else
        state = 5;
    end
end
if state==4
   fours=fours+1;
end
end

fracFours = fours/10000

