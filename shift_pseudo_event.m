function [pseudo_events] = shift_pseudo_event(pseudo_events)

[max_pe, no_field] = size(pseudo_events);
new_pe = zeros(max_pe, no_field);

first_used = find(pseudo_events(:,2)>0,1);
if first_used == 1
    fprintf('max out pseudo_events doubling the size\n');
    new_pe = zeros(max_pe*2, no_field);    
end
num_used = max_pe - first_used + 1;

new_pe(1:num_used,:) = pseudo_events(first_used:end,:);
pseudo_events = new_pe;


