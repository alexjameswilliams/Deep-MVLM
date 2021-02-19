function points = take_cprofile(tri_in,y_chin, res, dist)
%take a profile @ x=zero from y_chin to y_chin - 30 (or dist)

if nargin == 3
    dist = 30;
end

z_view_p = [tri_in.Points(:,1), tri_in.Points(:,2)];
z_view_t = tri_in.ConnectivityList;
z_view = triangulation (z_view_t, z_view_p);

points (:,2)= [y_chin-dist:res:(y_chin)];
points (:,1)= 0;

tri_ID = pointLocation (z_view, points);

for i = 1 : length (points)
    if ~isnan (tri_ID(i))
        
    p_ID1 = z_view_t (tri_ID(i),1); 
    p_ID2 = z_view_t (tri_ID(i),2);
    p_ID3 = z_view_t (tri_ID(i),3); 
    
    x1 = tri_in.Points (p_ID1,1);
    y1 = tri_in.Points (p_ID1,2);
    z1 = tri_in.Points (p_ID1,3);
    x2 = tri_in.Points (p_ID2,1);
    y2 = tri_in.Points (p_ID2,2);
    z2 = tri_in.Points (p_ID2,3);
    x3 = tri_in.Points (p_ID3,1);
    y3 = tri_in.Points (p_ID3,2);
    z3 = tri_in.Points (p_ID3,3);
    points (i,3) = find_z_coord(x1,y1,z1,x2,y2,z2,x3,y3,z3,points (i,1),points (i,2));
    else 
        points (i,3) = nan;
    end
end

end



