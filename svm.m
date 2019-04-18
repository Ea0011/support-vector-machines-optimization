filename = 'iris.txt';
delimiterIn = ',';
data = importdata(filename, delimiterIn, 1).data;

classes = data(:, 5);
important_predictors = [data(:, 3), data(:, 4)];

G = [];
e = ones(1, length(classes));

for i = 1:length(important_predictors)
  for j = 1:length(important_predictors)
    G(i, j) = dot(important_predictors(i, :), important_predictors(j, :)) * classes(i) * classes(j);
  endfor
endfor

dual_objective = @(m) 1/2 * m * G * transpose(m) - dot(e, m);

c_first = 10;
c_second = 10;
optimal_start = 0.001 * ones(1, length(classes));
optimal_barrier = barrier(dual_objective, c_first, c_second, optimal_start, classes);
optimal_start = ones(1, length(classes));
optimal_penalty = penalty(dual_objective, c_first, c_second, optimal_start, classes);
optimal_lagrange = augmented_lagrange(dual_objective, optimal_start, classes);

w_penalty = normal(optimal_penalty, important_predictors, classes);
w_barrier = normal(optimal_barrier, important_predictors, classes);
w_lagrange = normal(optimal_lagrange, important_predictors, classes);

b_penalty = bias(classes, important_predictors, optimal_penalty, w_penalty);
b_barrier = bias(classes, important_predictors, optimal_barrier, w_barrier);
b_lagrange = bias(classes, important_predictors, optimal_lagrange, w_lagrange);

graph(important_predictors, [w_penalty, b_penalty], [w_barrier, b_barrier], [w_lagrange, b_lagrange], classes);

results = [];

for i = 1:length(classes)
  results(i) = dot(w_penalty, important_predictors(i, :)) + b_penalty;
endfor
