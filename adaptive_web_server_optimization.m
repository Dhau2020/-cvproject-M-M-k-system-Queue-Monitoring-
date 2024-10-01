clc;
clear;

% Parameters
lambda_initial = 10; % initial arrival rate
mu = 5; % service rate
initialServers = 15; % initial number of servers
simulationTime = 1000; % total time for simulation

% Generate synthetic data for traffic intensity
time = (1:simulationTime)';
baseTrafficIntensity = lambda_initial + 5 * sin(0.05 * time); % Increased frequency of sine wave pattern % checking here for high and low frequency a

% Randomly fluctuate the base traffic intensity
randomFluctuations = 20 * randn(simulationTime, 1); % Increased random fluctuations % changing of fluctuations to lower and higher in place of constant 
trafficIntensity = baseTrafficIntensity + randomFluctuations;

% Ensure traffic intensity stays within reasonable bounds
trafficIntensity(trafficIntensity < 0) = 0;

% Initialize variables for simulation
numServers = initialServers * ones(simulationTime, 1); % initially set all servers to the initial value
blockingProbability = zeros(simulationTime, 1);

% Loop over each time step to adaptively change the number of servers
%for t = 1:simulationTime
 %   E = trafficIntensity(t) / mu; % calculate traffic intensity
  %  numServers(t) = max(3, ceil(E)); % ensure at least 3 servers, adapt number of servers based on traffic intensity
   % blockingProbability(t) = erlangB(E, numServers(t)); % calculate blocking probability
%end
% Threshold-based server adaptation
for t = 1:simulationTime
    E = trafficIntensity(t) / mu;
    if E > 2
        numServers(t) = max(3, ceil(E * 1.2)); % Add more servers if traffic is high
    else
        numServers(t) = max(3, ceil(E * 0.8)); % Reduce servers if traffic is low
    end
    blockingProbability(t) = erlangB(E, numServers(t));
end
% Train a neural network model
net = feedforwardnet(10); % Define a feedforward neural network with 10 hidden neurons
net = train(net, time', trafficIntensity'); % Train the neural network

% Predict future traffic
futureTime = (simulationTime+1:simulationTime+100)';
predictedTraffic = net(futureTime')';

% Adapt the number of servers based on predicted traffic
predictedE = predictedTraffic / mu;
adaptiveServers = max(3, ceil(predictedE)); % ensure at least 3 servers

% Calculate new blocking probability using adaptive number of servers
adaptiveBlocking = arrayfun(@(e, s) erlangB(e, s), predictedE, adaptiveServers);

% Visualize results
figure;

% Plot actual and predicted traffic intensity
subplot(3, 1, 1);
plot(time, trafficIntensity, 'b', 'LineWidth', 1.5);
hold on;
plot(futureTime, predictedTraffic, 'r', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Traffic Intensity');
title('Traffic Intensity and Predicted Traffic');
legend('Actual Traffic', 'Predicted Traffic');
grid on;
hold off;

% Plot number of servers in use over time
subplot(3, 1, 2);
stairs(time, numServers, 'g', 'LineWidth', 1.5);
hold on;
stairs(futureTime, adaptiveServers, 'r', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Number of Servers');
title('Number of Servers in Use');
legend('Actual Servers', 'Predicted Servers');
grid on;
hold off;

% Plot blocking probability over time
subplot(3, 1, 3);
plot(time, blockingProbability, 'b', 'LineWidth', 1.5);
hold on;
plot(futureTime, adaptiveBlocking, 'r', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Blocking Probability');
title('Blocking Probability');
legend('Actual Blocking', 'Predicted Blocking');
grid on;
hold off;

% Display mean blocking probability
meanBlockingProbability = mean(blockingProbability);
disp(['Mean Blocking Probability: ', num2str(meanBlockingProbability)]);

% Erlang B Formula
function B = erlangB(E, m)
    numerator = (E^m) / factorial(m);
    denominator = sum(arrayfun(@(k) (E^k) / factorial(k), 0:m));
    B = numerator / denominator;
end

