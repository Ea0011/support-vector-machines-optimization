filename = 'iris.txt';
delimiterIn = ',';
data = importdata(filename, delimiterIn, 1).data;

classes = data(:, 5);
important_predictors = [data(:, 1), data(:, 2)];

G = [];
e = ones(1, length(classes));

for i = 1:length(important_predictors)
  for j = 1:length(important_predictors)
    G(i, j) = kernel(important_predictors(i, :), important_predictors(j, :)) * classes(i) * classes(j);
  endfor
endfor

dual_objective = @(m) 1/2 * m * G * transpose(m) - dot(e, m);

optimal_start = ones(1, length(classes));
[optimal_barrier, barrier_time] = barrier(dual_objective, 10^2, 10^2, optimal_start, classes);
optimal_start = zeros(1, length(classes));
[optimal_penalty, penalty_time] = penalty(dual_objective, 10^20, 10^20, optimal_start, classes);
optimal_start = zeros(1, length(classes));
[optimal_lagrange, lagrange_time] = augmented_lagrange(dual_objective, optimal_start, classes);

w_penalty = normal(optimal_penalty, important_predictors, classes);
w_barrier = normal(optimal_barrier, important_predictors, classes);
w_lagrange = normal(optimal_lagrange, important_predictors, classes);

b_penalty = bias(classes, important_predictors, optimal_penalty, w_penalty);
b_barrier = bias(classes, important_predictors, optimal_barrier, w_barrier);
b_lagrange = bias(classes, important_predictors, optimal_lagrange, w_lagrange);

graph_data(important_predictors, classes, ['r', 'o'], ['b', '*']);
graph(important_predictors, [w_penalty, b_penalty], classes, 'r', 'Penalty');
graph(important_predictors, [w_barrier, b_barrier], classes, 'b', 'Barrier');
graph(important_predictors, [w_lagrange, b_lagrange], classes, 'g', 'Lagrange');
legend;

train_accuracy_penalty = accuracy(important_predictors, classes, w_penalty, b_penalty);
train_accuracy_barrier = accuracy(important_predictors, classes, w_barrier, b_barrier);
train_accuracy_lagrange = accuracy(important_predictors, classes, w_lagrange, b_lagrange);

test_file_name = 'iris_test.txt';
test_data = importdata(test_file_name, delimiterIn, 1).data;

test_classes = test_data(:, 5);
test_predictors = [test_data(:, 1), test_data(:, 2)];

graph_data(test_predictors, test_classes, ['m', 'x'], ['k', '+']);
graph(test_predictors, [w_penalty, b_penalty], test_classes, 'r', 'Penalty');
graph(test_predictors, [w_barrier, b_barrier], test_classes, 'b', 'Barrier');
graph(test_predictors, [w_lagrange, b_lagrange], test_classes, 'g', 'Lagrange');
legend

hold off;

test_accuracy_penalty = accuracy(test_predictors, test_classes, w_penalty, b_penalty);
test_accuracy_barrier = accuracy(test_predictors, test_classes, w_barrier, b_barrier);
test_accuracy_lagrange = accuracy(test_predictors, test_classes, w_lagrange, b_lagrange);

% performance of the methods
performane = [train_accuracy_barrier, train_accuracy_lagrange, train_accuracy_penalty;
              test_accuracy_barrier, test_accuracy_lagrange, test_accuracy_penalty];
              
figure

l = cell(1, 3);
l{1} = 'Barrier'; l{2} = 'Lagrange'; l{3} = 'Penalty';

bar_plot = bar(performane);
legend(bar_plot, l)
title('Train and Test Accuracies');

% speed of the methods
figure;
duration = [barrier_time, 0, 0; 0, lagrange_time, 0; 0, 0, penalty_time];
bar_plot = bar(duration);
legend(bar_plot, l);

kernel_results_barrier = [];
kernel_results_penalty = [];
kernel_results_lagrange = [];

for i=1:length(test_predictors)
  kernel_results_barrier(i) = kernelized_decision(test_predictors(i, :), important_predictors, classes, optimal_barrier);
  kernel_results_penalty(i) = kernelized_decision(test_predictors(i, :), important_predictors, classes, optimal_penalty);
  kernel_results_lagrange(i) = kernelized_decision(test_predictors(i, :), important_predictors, classes, optimal_lagrange);
endfor
