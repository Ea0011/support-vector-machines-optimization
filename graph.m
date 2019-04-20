function [g] = graph(data, params, classes, cl, label)
  hyperplane = @(n, x, b) -n(1) * x / n(2) - b / n(2);

  plot_points = linspace(-5, 10);

  normal = params(1:2);
  bias = params(3);

  plot(plot_points, hyperplane(normal, plot_points, bias), cl, 'DisplayName', label);
endfunction