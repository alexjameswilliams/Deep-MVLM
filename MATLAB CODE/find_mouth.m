function mouth = find_mouth(tri_in, nt_ind, ch, res)
%Finds mouth X,Y,Z co-ordinates from tip of nose (index) and chin xyz

points = take_cprofile(tri_in,tri_in.Points (nt_ind,2)-10, res, abs(tri_in.Points (nt_ind,2)-ch(2)-10));
profile = points (:,2:3);
profile = add_grad (profile);

profile (:,5) = islocalmin (profile (:,2));

d_grad = 0;
m_ind = nan;

for i = 1 : length (profile)
    if profile (i,5) == 1
        c_grad = abs(profile (i-1,3) - profile (i+1,3));
        if c_grad > d_grad
            d_grad = c_grad;
            m_ind = i;
        end       
    end
end

if isnan(m_ind)
    mouth = [nan nan nan];
else
    mouth = points (m_ind, :);
end

end

