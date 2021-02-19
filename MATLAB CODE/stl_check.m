function tri_out = stl_check(tri_in)
%Initial options for face scan STL adjustments following import
%
%As the proect develops more may be required depending on the source/state
%of face scan data
%
%Curret Options:
% - Unit Change from m to mm
% - Z axis Inversion

%Loop until proceed selected
while (true)
    
    %Simple plot of file
    figure
    trimesh (tri_in);
    xlabel('mm')
    ylabel('mm')
    zlabel('mm')
    view (0,90);
    
    disp(' ')
    disp('STL File Check: Preprocessing Options:')
    disp('(M) - Convert from m to mm')
    disp('(I) - Invert in Z axis')
    disp('(Y) - Proceed to processing')
    disp(' ')
    opt = input ("Selection: ",'s');
    close
    
    if (opt == "m")||(opt == "M")
        %Convert from m to mm
        temppoints = tri_in.Points;
        temppoints = temppoints .* 1000;
        tri_in = triangulation (tri_in.ConnectivityList,temppoints);
        clear temppoints;
        
    elseif (opt == "i")||(opt == "I")
        %Invert in the Z-axis
        temppoints = tri_in.Points;
        temppoints (:,3)  = 0 -   temppoints (:,3);
        tri_in = triangulation (tri_in.ConnectivityList,temppoints);
        clear temppoints;
        
    elseif (opt == "y")||(opt == "Y")
        %Break and return triangulation
        break
    end
end

tri_out = tri_in;

end

