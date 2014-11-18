figure
i = 102;
bid = box_evolve_history(i,1);
m = box_evolve_history(i,3:5);
  m(3) = 0;  
    C = zeros(3,3);
    for j = 1:3,
        C(j,j) = box_evolve_history(j+5)^2;
    end
    plot_gaussian_ellipsoid_contouronly(m, C, 1, 4, colours(bid,:))
    
    hold on
    
    b = 2;
    box_para = boxes_para(b,:);
    m2 = box_para(1:3);
    m2(3) = 0;
    C2 = zeros(3,3);
    for i = 1:3,
        C2(i,i) = box_para(i+3)^2;
    end
    cr = 0.5;
    plot_gaussian_ellipsoid_contouronly(m2, C2, 1, 4, [cr cr cr])