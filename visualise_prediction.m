start_point = max(1,pre_output_index -1000);
end_point = pre_output_index;

max_sample = 10000;
output_sample_pt = zeros(max_sample,4);
output_sample_pt_i = 0;

no_sample_per_prediction = 10;

for po = start_point:end_point
    cur_dist_pre = prediction_output{po,1};
   [no_dist, ~] = size(cur_dist_pre);
   for d = 1:no_dist
        dist_m = boxes_para(cur_dist_pre(d,1),1:3);
        dist_m(3) = cur_dist_pre(d,2);
        dist_C = zeros(3,3);
        for i = 1:3
            dist_C(i,i) = boxes_para(cur_dist_pre(d,1),i+3)^2;
        end
        gobj = gmdistribution(dist_m, dist_C);
        samples = random(gobj, no_sample_per_prediction);
        si = output_sample_pt_i + 1;
        ei = output_sample_pt_i + no_sample_per_prediction;
        if ei > max_sample
            new_sample = zeros(2*max_sample, 4);
            new_sample(1:max_sample,:) = output_sample_pt(:,:);
            output_sample_pt = new_sample;
            max_sample = 2*max_sample;
        end
        output_sample_pt(si:ei,1:3) = samples(:,:);
        output_sample_pt(si:ei,4) = cur_dist_pre(d,3);
        output_sample_pt_i = ei;
   end
end
output_sample_pt = output_sample_pt(1:output_sample_pt_i,:);


cur_e = prediction_output_e(start_point,1);
figure
plot3(temp(1:cur_e,1),temp(1:cur_e,2), temp(1:cur_e,3),'b*', 'MarkerSize', 2);
hold on
plot3(output_sample_pt(:,1),output_sample_pt(:,2), output_sample_pt(:,3),'r*', 'MarkerSize', 2);

return

output_sample_pt = sortrows(output_sample_pt,3);
output_sample_pt(:,3) = output_sample_pt(:,3) - output_sample_pt(1,3);
time_dur = output_sample_pt(end,3) - output_sample_pt(1,3);
tbin = 100;
xmax = 128;
xbin = 1;
ymax = 128;
ybin = 1;


output_cube = zeros(ceil(xmax/xbin), ceil(ymax/ybin), ...
    ceil(time_dur/tbin));

for os = 1:output_sample_pt_i
    x = ceil(output_sample_pt(os,1)/xbin);
    x = max(x, 1);
    x = min(x,xmax);
    
    y = ceil(output_sample_pt(os,2)/ybin);
    y = max(y, 1);
    y = min(y,ymax);
    
    
    t = ceil(output_sample_pt(os,3)/tbin);
    t = max(t, 1);
    t = min(t,ceil(time_dur/tbin));
    
    output_cube(x,y,t) = max(output_cube(x,y,t), output_sample_pt(os,4));
    
end


figure
for f = 1:ceil(time_dur/tbin)
    imagesc(squeeze(output_cube(:,:,f)));
    caxis([0 1])
    pause(0.1);
end





