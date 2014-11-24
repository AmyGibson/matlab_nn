colours = rand(box_index,3);

figure
box_to_plot = find(boxes_para(:,end) == max(boxes_para(:,end)),1);
% box_to_plot = 572;
for i = 1:bei,
    if box_evolve_history(i,1) == box_to_plot
        bid = box_evolve_history(i,1);
    else
        continue;
    end
%     bid = box_evolve_history(i,1);
    
    m = box_evolve_history(i,3:5);
    
    C = zeros(3,3);
    for j = 1:3,
        C(j,j) = box_evolve_history(i,j+5)^2;
    end
    
    plot_gaussian_ellipsoid_contouronly(m, C, 2, 4, colours(bid,:))
    
    
end
% 
hold on
plot3(temp(:,1), temp(:,2), temp(:,3), '.', 'MarkerSize', 1);

