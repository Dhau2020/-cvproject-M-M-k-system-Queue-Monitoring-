# Adaptive Web Server Optimization Using Traffic Prediction

This project focuses on optimizing a web server to improve system performance in an adaptive and efficient manner based on real-time demand. The provided solution dynamically adjusts server resources by predicting future traffic and adjusting the number of servers in use. The solution is implemented in the file *adaptive_web_server_optimization.m*.

## Features

- *Adaptive Server Scaling*: Dynamically adjusts the number of servers based on real-time traffic intensity, ensuring enough resources are available during high traffic and conserving resources during low demand.
- *Traffic Prediction*: Uses a neural network to predict future traffic intensity, allowing for proactive scaling of server resources.
- *Blocking Probability Calculation*: Implements the Erlang B formula to calculate the blocking probability, which is the likelihood that incoming traffic will not be served due to insufficient resources.
- *Simulated Traffic*: Generates synthetic traffic data with random fluctuations, simulating real-world traffic scenarios.

## Solution

The solution in *adaptive_web_server_optimization.m* includes the following key components:
1. *Traffic Simulation*: Creates synthetic traffic data by applying a sine wave pattern with random fluctuations to simulate real-world traffic demand.
2. *Server Adjustment*: Dynamically adjusts the number of servers based on the calculated traffic intensity and service rate using a threshold-based approach.
3. *Neural Network Training*: A feedforward neural network is trained to predict future traffic, enabling more efficient server scaling in response to predicted demand.
4. *Blocking Probability*: Calculates blocking probability using the Erlang B formula to ensure that the system is optimally provisioned.
5. *Visualization*: The results are visualized through plots that show traffic intensity, the number of servers in use, and blocking probability over time.

## Usage

1. *Prerequisites*: 
   - MATLAB or any environment capable of executing .m files is required to run the solution.
   
2. *Running the Script*:
   - Place the *adaptive_web_server_optimization.m* file in your MATLAB environment and run the script:
   
     matlab
     adaptive_web_server_optimization.m
     

3. *Visualizations*: 
   - The script will generate visualizations of:
     - Actual and predicted traffic intensity.
     - The number of servers required over time.
     - Blocking probability over time, showing the probability that service requests will be blocked due to insufficient resources.

### Example

When you run the script, it adaptively adjusts the number of servers based on the current and predicted traffic intensity. The predictions help ensure that the web server remains efficient by scaling up during high demand and scaling down during low demand.

Three key plots are displayed:
1. Actual vs. predicted traffic intensity.
2. Number of servers in use vs. predicted server requirement.
3. Actual and predicted blocking probability.

## Key Components

- *Traffic Intensity Calculation*: 
   - Traffic intensity is simulated using a combination of sine waves and random fluctuations to mimic real-world traffic conditions.
   
   matlab
   baseTrafficIntensity = lambda_initial + 5 * sin(0.05 * time);
   randomFluctuations = 20 * randn(simulationTime, 1);
   trafficIntensity = baseTrafficIntensity + randomFluctuations;
   

- *Erlang B Formula*: 
   - Used to calculate the blocking probability based on traffic intensity and the number of servers. The Erlang B formula ensures efficient handling of varying traffic loads.

   matlab
   function B = erlangB(E, m)
       numerator = (E^m) / factorial(m);
       denominator = sum(arrayfun(@(k) (E^k) / factorial(k), 0:m));
       B = numerator / denominator;
   end
   

- *Neural Network for Traffic Prediction*: 
   - A neural network is trained on traffic data to predict future traffic, allowing the system to adapt server resources in advance.

   matlab
   net = feedforwardnet(10); % Define the neural network
   net = train(net, time', trafficIntensity'); % Train the network
   

## Output

- *Traffic Intensity Plot*: Shows both actual and predicted traffic over time.
- *Number of Servers Plot*: Displays the number of servers being used in real-time vs. the predicted server count.
- *Blocking Probability Plot*: Visualizes the probability of requests being blocked due to insufficient server resources.

## License

This project is licensed under the MIT License.
