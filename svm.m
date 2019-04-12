filename = 'iris.txt';
delimiterIn = ',';
data = importdata(filename, delimiterIn, 1).data;

classes = data(:, 5);
important_predictors = [data(:, 1), data(:, 2), data(:, 3), data(:, 4)];

G = [];
e = ones(1, length(classes));

for i = 1:length(important_predictors)
  for j = 1:length(important_predictors)
    G(i, j) = dot(important_predictors(i, :), important_predictors(j, :)) * classes(i) * classes(j);
  endfor
endfor

dual_objective = @(m) 1/2 * m * G * transpose(m) - dot(e, m);
constraint_1 = @(m) abs(dot(classes, m));
constraint_2 = @(m) abs((max(0, -m)));

c_first = 100;
c_rest = 100 * ones(1, length(classes));
optimal_start = zeros(1, length(classes));
optimal = ones(1, length(classes));

err = 10^-3;
max_count = 10;
cnt = 1;

penalty_objective = @(c1, c2) @(m) dual_objective(m) + c1 * constraint_1(m) + dot(c2, constraint_2(m)); 

while(cnt <= max_count)
  optimal_start = optimal;
  c_first = 100 * c_first;
  c_rest = 100 * c_rest;

  func = penalty_objective(c_first, c_rest);
  optimal = fminsearch(func, optimal);
  cnt = cnt + 1;
endwhile

optimal

w = [];

for i = 1:length(important_predictors(1, :))
  acc = 0;
  for j = 1:length(classes)
    acc = acc + optimal(j) * classes(j) * important_predictors(j, :)(i);
  endfor
  w(i) = acc;
endfor

w
optimal

# plotting for the first set of features

plot_x = [];

for i = 1:length(classes)
  plot_x(i, :) = important_predictors(i, :)([1 2]);
endfor

scatter(plot_x(:, 1)(classes == 1), plot_x(:, 2)(classes == 1), '-o');

hold on;

scatter(plot_x(:, 1)(classes == -1), plot_x(:, 2)(classes == -1), '-*');

hold on;

b = classes(1) * dot(important_predictors(1, :), w) - 1;

hyperplane = @(n, x) -n(1) * x / n(2) - b / n(2);

plot_points = linspace(0, 10);

plot(plot_points, hyperplane(w(1:2), plot_points), 'r');

# plotting for the second set of features.

plot_x = [];

for i = 1:length(classes)
  plot_x(i, :) = important_predictors(i, :)([3 4]);
endfor

scatter(plot_x(:, 1)(classes == 1), plot_x(:, 2)(classes == 1), '-o');

hold on;

scatter(plot_x(:, 1)(classes == -1), plot_x(:, 2)(classes == -1), '-*');

hold on;

b = classes(1) * dot(important_predictors(1, :), w) - 1;

hyperplane = @(n, x) -n(1) * x / n(2) - b / n(2);

plot_points = linspace(0, 6);

plot(plot_points, hyperplane(w(3:4), plot_points), 'r');

w
b

