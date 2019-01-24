clear all;
close all;

fullbag = rosbag('../0124_kv_4_ki_0_3.bag');
bag_starttime = fullbag.StartTime + 20;

desired_pose_bag = select(fullbag,'Topic','/desire_pose','Time',[bag_starttime fullbag.EndTime]);
real_pose_bag = select(fullbag,'Topic','/pos_vel_mocap/odom_TA','Time',[bag_starttime fullbag.EndTime]);
ctrlvalue_bag = select(fullbag,'Topic','/n1ctrl/ctrl_dbg/value','Time',[bag_starttime fullbag.EndTime]);
desired_pose_msg = readMessages(desired_pose_bag,'DataFormat','struct');
real_pose_msg = readMessages(real_pose_bag,'DataFormat','struct');
ctrlvalue_msg = readMessages(ctrlvalue_bag,'DataFormat','struct');

% pose errors
desired_pose.sec = cellfun(@(m) double(m.Header.Stamp.Sec-bag_starttime),desired_pose_msg);
desired_pose.nsec = cellfun(@(m) double(m.Header.Stamp.Nsec),desired_pose_msg);
desired_pose.t = desired_pose.sec+desired_pose.nsec*10^-9;
desired_pose.x = cellfun(@(m) double(m.Pose.Position.X),desired_pose_msg);
desired_pose.y = cellfun(@(m) double(m.Pose.Position.Y),desired_pose_msg);
desired_pose.z = cellfun(@(m) double(m.Pose.Position.Z),desired_pose_msg);

% real pose
real_pose.sec = cellfun(@(m) double(m.Header.Stamp.Sec-bag_starttime),real_pose_msg);
real_pose.nsec = cellfun(@(m) double(m.Header.Stamp.Nsec),real_pose_msg);
real_pose.t = real_pose.sec + real_pose.nsec*10^-9;
real_pose.x = cellfun(@(m) double(m.Pose.Pose.Position.X),real_pose_msg);
real_pose.y = cellfun(@(m) double(m.Pose.Pose.Position.Y),real_pose_msg);
real_pose.z = cellfun(@(m) double(m.Pose.Pose.Position.Z),real_pose_msg);
real_pose.vx = cellfun(@(m) double(m.Twist.Twist.Linear.X),real_pose_msg);
real_pose.vy = cellfun(@(m) double(m.Twist.Twist.Linear.Y),real_pose_msg);
real_pose.vz = cellfun(@(m) double(m.Twist.Twist.Linear.Z),real_pose_msg);

% control values
ctrl_values.sec = cellfun(@(m) double(m.Header.Stamp.Sec-bag_starttime),ctrlvalue_msg);
ctrl_values.nsec = cellfun(@(m) double(m.Header.Stamp.Nsec),ctrlvalue_msg);
ctrl_values.t = ctrl_values.sec + ctrl_values.nsec*10^-9;
ctrl_values.dvx = cellfun(@(m) double(m.DesV.X),ctrlvalue_msg);
ctrl_values.dvy = cellfun(@(m) double(m.DesV.Y),ctrlvalue_msg);
ctrl_values.dvz = cellfun(@(m) double(m.DesV.Z),ctrlvalue_msg); 
ctrl_values.upx = cellfun(@(m) double(m.UP.X),ctrlvalue_msg); 
ctrl_values.upy = cellfun(@(m) double(m.UP.Y),ctrlvalue_msg); 
ctrl_values.upz = cellfun(@(m) double(m.UP.Z),ctrlvalue_msg); 
ctrl_values.uvx = cellfun(@(m) double(m.UV.X),ctrlvalue_msg); 
ctrl_values.uvy = cellfun(@(m) double(m.UV.Y),ctrlvalue_msg); 
ctrl_values.uvz = cellfun(@(m) double(m.UV.Z),ctrlvalue_msg); 

%% plot
pos_ax = subplot(2,2,1);
plot(pos_ax,desired_pose.t,desired_pose.x,real_pose.t,real_pose.x,'--');
hold on;
plot(pos_ax,desired_pose.t,desired_pose.y,real_pose.t,real_pose.y,'--');
hold on;
plot(pos_ax,desired_pose.t,desired_pose.z,real_pose.t,real_pose.z,'--');
legend('x_d','x_r','y_d','y_r','z_d','z_r');
grid on;
title('desired pose Vs real pose');

err_pos_ax = subplot(2,2,3);
plot(err_pos_ax,ctrl_values.t,ctrl_values.upx);
hold on;
plot(err_pos_ax,ctrl_values.t,ctrl_values.upy);
hold on;
plot(err_pos_ax,ctrl_values.t,ctrl_values.upz);
grid on;
legend('ux','uy','uz');
title('pose:control states');

vel_ax = subplot(2,2,2);
plot(ctrl_values.t,ctrl_values.dvx,real_pose.t,real_pose.vx,'--');
hold on;
plot(ctrl_values.t,ctrl_values.dvy,real_pose.t,real_pose.vy,'--');
hold on;
plot(ctrl_values.t,ctrl_values.dvz,real_pose.t,real_pose.vz,'--');
title('desired vel Vs real vel')
grid on;

err_vel_ax = subplot(2,2,4);
plot(err_vel_ax,ctrl_values.t,ctrl_values.uvx);
hold on;
plot(err_vel_ax,ctrl_values.t,ctrl_values.uvy);
hold on;
plot(err_vel_ax,ctrl_values.t,ctrl_values.uvz);
grid on;
title('vel:control states');
