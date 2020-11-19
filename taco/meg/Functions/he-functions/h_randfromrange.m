function r = h_randfromrange(min_val,max_val)

a   = min_val;
b   = max_val;
c   = (b-a).*rand(50,1) + a;
d   = randi(length(c));
r   = c(d);