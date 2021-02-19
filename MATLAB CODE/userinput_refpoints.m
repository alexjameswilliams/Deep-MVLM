function [re, le, ch] = userinput_refpoints(tri_in)
%Grab user input for three reference points in XYZ
%Right Eye
%Left Eye
%Chin

while (true)
fig = figure;
trimesh (tri_in);
xlabel('mm')
ylabel('mm')
zlabel('mm')
view (0,90);

% Enable data cursor mode
%datacursormode on
dcm_obj = datacursormode(fig);

% Wait while the user to click
disp (' ')
disp('Using Datatips, select Right Eye inside corner then press "Return"')
pause 
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);
re (1) = info_struct.Position (1);
re (2) = info_struct.Position (2);
re (3) = info_struct.Position (3);

% Wait while the user to click
disp (' ')
disp('Using Datatips, select Left Eye inside corner then press "Return"')
pause 
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);
le (1) = info_struct.Position (1);
le (2) = info_struct.Position (2);
le (3) = info_struct.Position (3);

% Wait while the user to click
disp (' ')
disp('Using Datatips, select chin then press "Return"')
pause 
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);
ch (1) = info_struct.Position (1);
ch (2) = info_struct.Position (2);
ch (3) = info_struct.Position (3);

disp (' ')
disp ("Right Eye")
disp ("X: " + re (1))
disp ("Y: " + re (2))
disp ("Z: " + re (3))
disp (" ")
disp ("Left Eye")
disp ("X: " + le (1))
disp ("Y: " + le (2))
disp ("Z: " + le (3))
disp (" ")
disp ("Chin")
disp ("X: " + ch (1))
disp ("Y: " + ch (2))
disp ("Z: " + ch (3))
disp (" ")

x = input ("Proceed? (Y/N)",'s');
if (x == "y")||(x == "Y")
    close
    break
end
close
end
end

