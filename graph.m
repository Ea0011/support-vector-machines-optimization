function [g] = graph(data, params_1, params_2, params_3, classes)
  hyperplane = @(n, x, b) -n(1) * x / n(2) - b / n(2);

  plot_x = [];

  for i = 1:length(data)
    plot_x(i, :) = data(i, :)([1 2]);
  endfor

  scatter(plot_x(:, 1)(classes == 1), plot_x(:, 2)(classes == 1), 'o');
  hold on;
  scatter(plot_x(:, 1)(classes == -1), plot_x(:, 2)(classes == -1), '*');

  plot_points = linspace(-5, 10);

  normal_1 = params_1(1:2);
  bias_1 = params_1(3);
  normal_2 = params_2(1:2);
  bias_2 = params_2(3);
  normal_3 = params_3(1:2);
  bias_3 = params_3(3);

  plot(plot_points, hyperplane(normal_1, plot_points, bias_1), 'r', 'DisplayName', 'Penalty');
  plot(plot_points, hyperplane(normal_2, plot_points, bias_2), 'b', 'DisplayName', 'Barrier');
  plot(plot_points, hyperplane(normal_3, plot_points, bias_3), 'g', 'DisplayName', 'Lagrange');
  
  legend

  hold off;
endfunction