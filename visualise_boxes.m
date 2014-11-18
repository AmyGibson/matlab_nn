% close all
% addpath ./plot_gaussian_ellipsoid
figure
for b = 1:box_index
    hold on
%     if count(b) == 0
%         continue;
%     end
    box_para = boxes_para(b,:);
    m = box_para(1:3);
    C = zeros(3,3);
    for i = 1:3,
        C(i,i) = box_para(i+3)^2;
    end
    cr = 0.5;
    plot_gaussian_ellipsoid_contouronly(m, C, 2, 4, [cr cr cr])
    
    
end

hold on
plot3(temp(:,1), temp(:,2), temp(:,3), '*', 'MarkerSize', 1);
grid on
xlim([0 128])
ylim([0 128])

