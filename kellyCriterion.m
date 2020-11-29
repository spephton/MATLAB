% coin lands on heads 60% of the time
headsRate = 0.6;

% bettors:
bettor1rate = 0.5;
bettor2rate = 1;
bettor3rate = 0.25;
bettorKellyRate = 2 * headsRate - 1;
bettorFiniteOptimalRate = 0.12; % kelly criterion only optimal in inf. game

bettorRates = [ bettor1rate, bettor2rate, bettor3rate, bettorKellyRate, ...
    bettorFiniteOptimalRate ]';



% bettors were given 30 minutes of even odds betting on the weighted coin.
% They win if it lands heads. Since there's a 60% chance of heads, they
% should be able to make money. Right?!
%
% We can assume that 30 minutes is enough for 300 bets to be made, unless
% the bettor goes bust early. Let's assume that only whole-number bets can
% be made.

% average return over 1000 runs per strategy
players = size(bettorRates, 1);
totalWinnings = zeros(players, 1);
for i = 1 : 100000
    [ winnings ] = simulateGame(bettorRates, 300, headsRate, 25);
    totalWinnings = totalWinnings + winnings;
end
avg = totalWinnings/1000000

function [ winnings ] = simulateGame(bettorRates, n, ...
                                            coinHeadsChance, initialStake)
    % Runs a finite coin flip betting game of maximum n rounds, with
    % bettors who start with initialStake credits. bettorRates is a column
    % vector describing the number of players and their behaviour: the nth
    % player will bet bettorRates(n) of their current holdings each round.
    
    
    players = size(bettorRates, 1);
    winnings = ones(players, 1) * initialStake;
    outcomes = rand(n, 1);
    
    for i = 1 : n
        if outcomes(i) < coinHeadsChance % heads, everybody wins!
            winnings = winnings + bettorRates .* winnings;
        else
            winnings = winnings - bettorRates .* winnings;
        end
    end
end