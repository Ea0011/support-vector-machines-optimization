function [g] = graph_data(dataset, classes, opts1, opts2)  plot_x = [];  for i = 1:length(dataset)    plot_x(i, :) = dataset(i, :)([1 2]);  endfor  scatter(plot_x(:, 1)(classes == 1), plot_x(:, 2)(classes == 1), opts1(1), opts1(2));  hold on;  scatter(plot_x(:, 1)(classes == -1), plot_x(:, 2)(classes == -1), opts2(1), opts2(2));
endfunction
