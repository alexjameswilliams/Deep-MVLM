function tri_out = tri_rotate (tri_in, angle, ax)
%function to rotate a trianglation about an axis
%angle in deg

%axis defaults to z
if ax == "x"
    ax_1 = 2;
    ax_2 = 3;
elseif ax == "y"
    ax_1 = 1;
    ax_2 = 3;
else 
    ax_1 = 1;
    ax_2 = 2;
end

s_angle = sind(angle);
c_angle = cosd(angle);

points = tri_in.Points;

for i = 1:length (points)
    p_1 = (points (i,ax_1)*c_angle) - (points (i,ax_2)*s_angle);
    points (i,ax_2) = (points (i,ax_2)*c_angle) + (points (i,ax_1)*s_angle);
    points (i,ax_1) = p_1;
    
end

tri_out = triangulation (tri_in.ConnectivityList,points);

end

