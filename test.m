%%%% test the learning algorithm separately

% noa = 50;
% nob = 10;
% a = rand(noa,1)+10;
% b = rand(nob,1)+5;
% c = vertcat(a,b);
% 
% 
% ma = mean(a);
% mb = mean(b);
% mc = mean(c);
% 
% sa = std(a);
% sb = std(b);
% sc = std(c);
% 
% mab = (noa*ma + nob*mb)/(noa + nob);
% part1 = noa*(sa^2 + ma^2);
% part2 = nob*(sb^2 + mb^2);
% sab = sqrt((part1 + part2)/(noa+nob) - mab^2);


noa = 30;
nob = 90;

m_ax = 67.3333;
m_ay = 18.6667;
m_at = 0;

s_ax = sqrt(104.7816);
s_ay = sqrt(6.5057);
s_at = sqrt(6.0749);


m_bx = 67.7708;
m_by = 18.75;
m_bt = 0;

s_bx = sqrt(158.2417);
s_by = sqrt(4.7789);
s_bt = sqrt(3.0806);

mabx = (noa*m_ax + nob*m_bx)/(noa + nob);
maby = (noa*m_ay + nob*m_by)/(noa + nob);
mabt = (noa*m_at + nob*m_bt)/(noa + nob);

part1x = noa*(s_ax^2 + m_ax^2);
part2x = nob*(s_bx^2 + m_bx^2);
sabx = sqrt((part1x + part2x)/(noa+nob) - mabx^2);

part1y = noa*(s_ay^2 + m_ay^2);
part2y = nob*(s_by^2 + m_by^2);
saby = sqrt((part1y + part2y)/(noa+nob) - maby^2);

part1t = noa*(s_at^2 + m_at^2);
part2t = nob*(s_bt^2 + m_bt^2);
sabt = sqrt((part1t + part2t)/(noa+nob) - mabt^2);

[mabx maby mabt]
[sabx^2 saby^2 sabt^2]


