function y_val = point_int(x1,x2,y1,y2,tx)
%funtion to do quick linear interpolationbetween points to output y value

dx = x2 - x1;
dy = y2 - y1;
px = (tx - x1)/dx;
y_val = y1 + (px*dy);

end

