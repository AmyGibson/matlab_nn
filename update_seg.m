function [means, stds, weights, th, counts] = update_seg(fire_src, ...
    currents, src, th)

cur_id = squeeze(src(:,1));
means = squeeze(src(:,2));
stds = squeeze(src(:,3));
weights = squeeze(src(:,4));
counts = squeeze(src(:,5));

seg_len = length(cur_id);


for s = 1:seg_len
    if cur_id(s) == 0
        break;
    end
   if currents(s) == 0
       weights(s) = weights(s) * 0.99;
       continue;
   end
       
   new_sam = find(fire_src(:,1) == cur_id(s));
   for i = 1:length(new_sam)
        old_mu = means(s);
        means(s) = (counts(s)*means(s) + (fire_src(new_sam(i),2))) / (counts(s)+1);        
        part1 = counts(s)*(stds(s)^2 + old_mu^2);
        part2 = (0 + fire_src(new_sam(i),2)^2);
        stds(s) = sqrt((part1 + part2)/(1+counts(s)) - means(s)^2); 
        counts(s) = counts(s) + 1;
   end
end