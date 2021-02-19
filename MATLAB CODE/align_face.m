function [tri_out, re, le, ch] = align_face(tri_in, re, le, ch)
%Align face data using rotations and 3 reference points
%Inner corner of eyes (right then left) and chin
%re = RIGHT EYE
%le = LEFT EYE
%ch = CHIN

%First rotation
%about y axis 
%make z constant for eyes
theta = 360-atand ((le (3) - re (3))/(le (1) - re (1)));
tri_in = tri_rotate (tri_in, theta, "y");
%update reference point locations
[re(3), re(1)] = point_transl(theta, re(3), re(1));
[le(3), le(1)] = point_transl(theta, le(3), le(1));
[ch(3), ch(1)] = point_transl(theta, ch(3), ch(1));

%Second rotation
%about z axis 
%make y constant for eyes
theta = 360 - atand ((le (2) - re (2))/(le (1) - re (1)));
tri_in = tri_rotate (tri_in, theta, "z");
%update necessary reference point locations
[re(2), re(1)] = point_transl(theta, re(2), re(1));
[le(2), le(1)] = point_transl(theta, le(2), le(1));
[ch(2), ch(1)] = point_transl(theta, ch(2), ch(1));

%Third rotation
%about x axis 
%make z constant for eyes and chin
theta = 360 - atand ((le (3) - ch (3))/(le (2) - ch (2)));
tri_in = tri_rotate (tri_in, theta, "x");
%update necessary reference point locations 
[re(3), re(2)] = point_transl(theta, re(3), re(2));
[le(3), le(2)] = point_transl(theta, le(3), le(2));
[ch(3), ch(2)] = point_transl(theta, ch(3), ch(2));

%Translate to y = 0 for eyeline
%Eye midpoint x = 0
points = tri_in.Points;
points (:,2) = points (:,2) - re (2);
ch (2) = ch (2) - re (2);
le (2) = le (2) - re (2);
re (2) = 0;
x_shift = (re(1) + ((le(1) - re(1))/2));
points (:,1) = points (:,1) - x_shift;
re (1) = re (1) - x_shift;
le (1) = le (1) - x_shift;
ch (1) = ch (1) - x_shift;

tri_out = triangulation (tri_in.ConnectivityList,points);

end

