function z_val = find_z_coord(x1,y1,z1,x2,y2,z2,x3,y3,z3,x,y)
%find z value for plane defined by three points given x and y

%ax + by + cz = d
%   p1, p2, p3 eg, p1 = [x y z]
% normal: it contains a,b,c coeff , normal = [a b c]
% d : coeff

p1 = [x1 y1 z1];
p2 = [x2 y2 z2];
p3 = [x3 y3 z3];
normal = cross(p1 - p2, p1 - p3);
d = p1(1)*normal(1) + p1(2)*normal(2) + p1(3)*normal(3);
z_val = (d - (normal (1)*x) - (normal (2)*y))/normal (3);

end

