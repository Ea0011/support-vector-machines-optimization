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
constraint_1 = @(m) (dot(classes, m)).^2;
constraint_2 = @(m) dot((max(0, -m)).^2, e);

c_first = 10^20;
c_second = 10^20;
optimal_start = ones(1, length(classes));

% optimal = barrier(dual_objective, c_first, c_second, optimal_start, classes);
optimal = penalty(dual_objective, c_first, c_second, optimal_start, classes);

w = [];

for i = 1:length(important_predictors(1, :))
  acc = 0;
  for j = 1:length(classes)
    acc = acc + optimal(j) * classes(j) * important_predictors(j, :)(i);
  endfor
  w(i) = acc;
  acc = 0;
endfor

w = w / norm(w);

# plotting for the second set of features.

plot_x = [];

for i = 1:length(classes)
  plot_x(i, :) = important_predictors(i, :)([1 2]);
endfor

scatter(plot_x(:, 1)(classes == 1), plot_x(:, 2)(classes == 1), '-o');

hold on;

scatter(plot_x(:, 1)(classes == -1), plot_x(:, 2)(classes == -1), '-*');

hold on;

b = 0;

for i = 1:length(classes)
  if optimal(i) != 0
     b = b + 1 / classes(i) - dot(important_predictors(i, :), w);
  end
end

b = b / length(classes);

hyperplane = @(n, x) -n(1) * x / n(2) - b / n(2);

plot_points = linspace(0, 6);

plot(plot_points, hyperplane(w(1:2), plot_points), 'r');

hold off;

results = [];

for i = 1:length(classes)
   results(i) = dot(w, important_predictors(i, :)) + b;
end

results
