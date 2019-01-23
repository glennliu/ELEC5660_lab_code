clear all;

fullbag = rosbag('../2019-01-22-21-23-23.bag');
bag_starttime = fullbag.StartTime + 20;

desired_pose_bag = select(fullbag,'Topic','/desire_pose','Time',[bag_starttime fullbag.EndTime]);
real_pose_bag = select(fullbag,'Topic','/pos_vel_mocap/odom_TA','Time',[bag_starttime fullbag.EndTime]);
desired_pose_msg = readMessages(desired_pose_bag,'DataFormat','struct');
real_pose_msg = readMessages(real_pose_bag,'DataFormat','struct');

desired.sec = cellfun(@(m) double(m.Header.Stamp.Sec-bag_starttime),desired_pose_msg);
desired.nsec = cellfun(@(m) double(m.Header.Stamp.Nsec),desired_pose_msg);
desired.t = desired.sec+desired.nsec*10^-9;
desired.x = cellfun(@(m) double(m.Pose.Position.X),desired_pose_msg);
desired.y = cellfun(@(m) double(m.Pose.Position.Y),desired_pose_msg);
desired.z = cellfun(@(m) double(m.Pose.Position.Z),desired_pose_msg);

real_pose.sec = cellfun(@(m) double(m.Header.Stamp.Sec-bag_starttime),real_pose_msg);
real_pose.nsec = cellfun(@(m) double(m.Header.Stamp.Nsec),real_pose_msg);
real_pose.t = real_pose.sec + real_pose.nsec*10^-9;
real_pose.x = cellfun(@(m) double(m.Pose.Pose.Position.X),real_pose_msg);
real_pose.y = cellfun(@(m) double(m.Pose.Pose.Position.Y),real_pose_msg);
real_pose.z = cellfun(@(m) double(m.Pose.Pose.Position.Z),real_pose_msg);

%% plot
plot(desired.t,desired.x,real_pose.t,real_pose.x,'--');
hold on;
plot(desired.t,desired.y,real_pose.t,real_pose.y,'--');
hold on;
plot(desired.t,desired.z,real_pose.t,real_pose.z,'--');
legend('x_desired','x_real','y_desired','y_real','z_desired','z_real');
grid on;
