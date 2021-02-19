function profile_out = correct_profile(profile)
%tweaks angle of profile after gradient columns added
%Moves Profile to Origin (formerly seperate function)

p_len = length (profile);

%Find front mean point
x_tot = 0;
y_tot = 0;
for i = 1: p_len
    if profile (i,4) > 0.25
        front_x = x_tot/(i-1);
        front_y = y_tot/(i-1);
        break
    else
        x_tot = x_tot + profile (i,1);
        y_tot = y_tot + profile (i,2);
    end
end

%Find back mean point
x_tot = 0;
y_tot = 0;
for i = 1: p_len
    if profile (p_len - i,4) > 0.25
        back_x = x_tot/(i-1);
        back_y = y_tot/(i-1);
        break
    else
        x_tot = x_tot + profile (p_len - i,1);
        y_tot = y_tot + profile (p_len - i,2);
    end
end

delta_x = abs(back_x - front_x);
delta_y = abs(back_y - front_y);

theta = atand(delta_y/delta_x);

if back_y > front_y
    theta = 360 - theta;
end

s_theta = sind(theta);
c_theta = cosd(theta);

profile_out (:,1) = (profile (:,1).*c_theta) - (profile (:,2).*s_theta);
profile_out (:,2) = (profile (:,2).*c_theta) + (profile (:,1).*s_theta);

profile_out = add_grad(profile_out,2);

% Moves profile to origin with base of nose and bridge at zero respectivly 
% baseline taken using same method as the rotational correction
% Input 4 column profile matrix (ie. with gradients calculated)

%X axis correction
x_bridge = find_bridge(profile_out);
profile_out (:,1) = profile_out (:,1) - x_bridge;

%Find front mean point
y_tot = 0;
for i = 1: p_len
    if profile_out (i,4) > 0.25
        front_y = y_tot/(i-1);
        break
    else
        y_tot = y_tot + profile_out (i,2);
    end
end

%Find back mean point
y_tot = 0;
for i = 1: p_len
    if profile_out (p_len - i,4) > 0.25
        back_y = y_tot/(i-1);
        break
    else
        y_tot = y_tot + profile_out (p_len - i,2);
    end
end

%calculate mean y offset and apply 
y_offset = (front_y + back_y)/2;
profile_out (:,2) = profile_out (:,2) - y_offset;

end

