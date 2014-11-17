function [total, pos, neg] = load_data(filename, cut_off_time)
filename = sprintf('%s.aedat', filename);
[allAddr, allTs] = loadaerdat(filename); %around 100s

%extracts all the information from the address matrices in the form
%[xcoordinate, ycoordinate, polarity]
[infomatrix1, infomatrix2, infomatrix3] = extractRetina128EventsFromAddr(allAddr);
%combines this to give a final matrix of the form [xcoordinate,
%ycoordinate, polarity, timestamp]

allTs = uint32(allTs);

allTs = double(allTs);

total = [infomatrix1, infomatrix2, infomatrix3 ,allTs];

total(:,4) = total(:,4) - total(1,4) + 1; % ref to first event
total(:,1) = total(:,1) + 1; % currently starting at 0, change it to 1 
total(:,2) = total(:,2) + 1; % currently starting at 0, change it to 1 
total(:,4) = total(:,4)/1000; %in ms

total = unique(total, 'rows');
total = sortrows(total, 4);

neg = total(total(:,3) == -1, :);
pos = total(total(:,3) == 1, :);

neg = neg(:, [1 2 4]);
pos = pos(:, [1 2 4]);

if cut_off_time ~= 0;
    cut_off_ind = find(pos(:,3) >= cut_off_time, 1);
    if ~isempty(cut_off_ind)
        pos = pos(1:cut_off_ind, :);
    end
    cut_off_ind = find(neg(:,3) >= cut_off_time, 1);
    if ~isempty(cut_off_ind)
        neg = neg(1:cut_off_ind, :);
    end
end

