% close all

figure

for b = 1:10
    hold on
    box_para = specific_box_history{b,1};
    m = box_para(1:3);
    C = zeros(3,3);
    m(3) = b *500;
    for i = 1:3,
        C(i,i) = box_para(i+3)^2;
    end
    
    plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [1 0 0])
    
    
    
    hold on
    box_para = specific_box_history{b,2};
    m = box_para(1:3);
    C = zeros(3,3);
    m(3) = b *500;
    for i = 1:3,
        C(i,i) = box_para(i+3)^2;
    end
    
    plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [0 1 0])
    
    hold on
    box_para = specific_box_history{b,3};
    m = box_para(1:3);
    C = zeros(3,3);
    m(3) = b *500;
    for i = 1:3,
        C(i,i) = box_para(i+3)^2;
    end
    
    plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, [0 0 1])
    
    
end

% hold on
% plot3(temp(:,1), temp(:,2), temp(:,3), '*', 'MarkerSize', 1);
% grid on
% xlim([0 128])
% ylim([0 128])


