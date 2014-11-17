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
    if b == 377
        plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [1 0 0])
    else
        plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [cr cr cr])
    end
    
    
end

hold on
% plot3(temp(:,1), temp(:,2), temp(:,3), '*', 'MarkerSize', 1);
grid on
xlim([0 128])
ylim([0 128])
return

figure
for b = 1:temp_history_i
    hold on
%     if count(b) == 0
%         continue;
%     end
    box_para = temp_history(b,:);
    m = box_para(1:3);
    C = zeros(3,3);
    for i = 1:3,
        C(i,i) = box_para(i+3)^2;
    end
    cr = rand(1);
    cb = rand(1);
    cg = rand(1);
    plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [cr cb cg])
    hold on
    mem = temp_memory{b,1};
    plot3(mem(:,1), mem(:,2), mem(:,3), '*', 'MarkerSize', 1, 'Color', [cr cb cg]);
    
end

% hold on
% plot3(temp(:,1), temp(:,2), temp(:,3), '*', 'MarkerSize', 1);
grid on
xlim([0 128])
ylim([0 128])

