function [pseudo_events] = shift_pseudo_event(pseudo_events, buffer_space)

[max_pe, no_field] = size(pseudo_events);
new_pe = zeros(max_pe, no_field);

first_used = find(pseudo_events(:,2)>0,1);
num_used = max_pe - first_used + 1;
new_pe(1:num_used,:) = pseudo_events(first_used:end,:);
pseudo_events = new_pe;

next_empty_pe = find(pseudo_events(:,1) == 0,1);
if isempty(next_empty_pe) || (max_pe - next_empty_pe + 1) < buffer_space    
    pseudo_events = doubling_matrix(pseudo_events);
end






