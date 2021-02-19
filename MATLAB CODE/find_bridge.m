function x_bridge = find_bridge(profile)
%finds the bridge of the nose from 3 column matrix (x,y,grad) profile
%returns x_coordinate

[~,min_index] = min (profile (:,3));
[~,max_index] = max (profile (:,3));

for i = max_index:min_index
    if profile (i,3)<=0
        if profile(i,3) == 0
            x_bridge = profile (i,1);
        else
            delta_x = profile (i,1) - profile (i-1,1);
            delta_y = abs(profile (i,3) - profile (i-1,3));
            prop = abs(profile (i,3))/delta_y;
            x_bridge = profile (i,1) - (prop * delta_x);
        end
        break
    end
end

end

