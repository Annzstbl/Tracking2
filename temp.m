k;
K00 = zeros(20,8);
i = 1;%位移次数应为 i ip j jp减去1
ip = 1;
for j = 1 :20
    for jp = 1:8
        cirrow = mod(j - i, 20) + 1;
        circol = mod(jp - ip, 8) + 1;
        K00(j, jp) = k(cirrow, circol);
    end
end

% K i. j, i', j' :K ij-block i'j'-index
% i j size is m;  i' j' size is n
m = 20;
n = 8;
K11 = zeros(n, n);
i = 1;%from 1 to 20 
j = 1;
cirrow = mod(j - i, 20) + 1;
for ip = 1 : 8
    for jp = 1 : 8
        circol = mod(jp - ip, 8) + 1;
        K11(ip, jp) = k(cirrow, circol);
    end
end

K12 = zeros(n, n);
i = 1;
j = 2;
cirrow = mod(j - i, 20) + 1;
for ip = 1 : 8
    for jp = 1 : 8
        circol = mod(jp - ip, 8) + 1;
        K12(ip, jp) = k(cirrow, circol);
    end
end

K21 = zeros(n, n);
i = 2;
j = 1;
cirrow = mod(j - i, 20) + 1;
for ip = 1 : 8
    for jp = 1 : 8
        circol = mod(jp - ip, 8) + 1;
        K21(ip, jp) = k(cirrow, circol);
    end
end
