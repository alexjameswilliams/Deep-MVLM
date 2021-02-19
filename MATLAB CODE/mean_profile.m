function profile_out = mean_profile(profile,res)
%Taking the corrected profile, generate a mean half profile that has been
%resampled as specified resolution (res)

%interpolate between data points and average for regions where both 'sides'
%exist

p_len = length (profile);
n = fix(min(max(profile (:,1)),abs(min(profile (:,1))))/res);

profile_out = nan(n+1,2);
profile_out (:,1) = 0:res:(n*res);

%find zero point value
for i = 1:p_len
    if profile (i,1) >= 0
        if profile (i,1) == 0
            profile_out (1,2) = profile (i,2);
        else
            profile_out (1,2) = point_int(profile (i-1,1),profile (i,1), profile (i-1,2),profile (i,2),0);
        end
        
        break
    end
end

%Loop for all other points
for i = 2 : (n+1)
    flag = 0;
    for j = 1 : p_len
        if flag == 0
            %less than zero
            if abs (profile (j,1)) <= profile_out (i,1)
                if abs (profile (j,1)) == profile_out (i,1)
                    y_low = profile (j,1);
                else
                    y_low = point_int(profile (j-1,1),profile (j,1), profile (j-1,2),profile (j,2),0 - profile_out (i,1));
                end
                flag = 1;
            end
        else
            %greater than zero
            if profile (j,1) >= profile_out (i,1)
                if profile (j,1) == profile_out (i,1)
                    y_high = profile (j,1);
                else
                    y_high = point_int(profile (j-1,1),profile (j,1), profile (j-1,2),profile (j,2), profile_out (i,1));
                end
                break;
            end
            
        end
    end
    profile_out (i,2) = (y_low + y_high)/2;
end

profile_out = add_grad(profile_out);

end

