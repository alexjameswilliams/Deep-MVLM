function profile_out = add_grad(profile, d)
%Adds a numerical gradient and 2nd derivatve column to the XY profile coordinates 
%Uses simple gradient calculation between points
%d = take 1 or 2 derivatives 

if nargin == 1
    d = 1;
end

p_len = length (profile);
profile (:,3:4) = nan;

p_next = (profile (2,2) - profile (1,2))/(profile (2,1) - profile (1,1)); 

for i = 2:(p_len-1)
    p_last = p_next;
    p_next = (profile (i+1,2) - profile (i,2))/(profile (i+1,1) - profile (i,1));
    profile (i,3) = (p_next + p_last) / 2;
end

%... and 2nd derivative
if d > 1
    p_next = (profile (3,3) - profile (2,3))/(profile (3,1) - profile (2,1));
    
    for i = 3:(p_len-2)
        p_last = p_next;
        p_next = (profile (i+1,3) - profile (i,3))/(profile (i+1,1) - profile (i,1));
        profile (i,4) = (p_next + p_last) / 2;
    end
end

profile_out = profile;

end

