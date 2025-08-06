%% Setup script for virtual QBot Platform in the Open Warehouse QLabs env.

%% Setup
% select case number for application (1 by default)
caseNum = 2; % 1, 2, 3, or 4
location = [ 0.00,  0.00,  0.00; ...
             0.00,  0.00,  0.00; ...
            -1.50,  0.00,  0.00; ...
            -1.50,  0.00,  0.00];
rotation = [ 0.00,   0.00,  90.00; ...
             0.00,   0.00,  90.00; ...
             0.00,   0.00,  90.00; ...
             0.00,   0.00, -90.00];

% Stop previously running real-time (RT) applications gracefully
try
    qc_stop_model('tcpip://localhost:17000', 'qbot_platform_driver_virtual')
    pause(1)
    qc_stop_model('tcpip://localhost:17000', 'QBotPlatform_Workspace')
catch error
end
pause(1)

%% Quanser Interactive Labs setup
% Connect to QLabs
qlabs = QuanserInteractiveLabs();
connection_established = qlabs.open('localhost');

if connection_established == false
    disp("Failed to open connection.")
    return
end
disp('Connected')
verbose = true;

% Reset by deleting all existing objects
num_destroyed = qlabs.destroy_all_spawned_actors();

if caseNum == 2
    % Setup floor tiles
    hFloor0 = QLabsQBotPlatformFlooring(qlabs);
    
    hFloor0.spawn_id(0, [-0.6, 0.6,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(1, [ 0.6, 1.8,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(2, [ 1.8,-0.6,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(3, [-0.6,-1.8,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(4, [-1.8, 0.6,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(5, [-0.6, 0.6,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(6, [ 0.6, 0.6,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(7, [ 0.6,-0.6,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(8, [-0.6,-0.6,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = 3.6; dy = 0;
    hFloor0.spawn_id(9, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(10, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(11, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(12, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(13, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(14, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(15, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(16, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(17, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = -3.6; dy = 0;
    hFloor0.spawn_id(18, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(19, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(20, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(21, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(22, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(23, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(24, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(25, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(26, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = 0; dy = 3.6;
    hFloor0.spawn_id(27, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(28, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(29, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(30, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(31, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(32, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(33, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(34, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(35, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = 3.6; dy = 3.6;
    hFloor0.spawn_id(36, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(37, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(38, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(39, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(40, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(41, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(42, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(43, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(44, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = -3.6; dy = 3.6;
    hFloor0.spawn_id(45, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(46, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(47, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(48, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(49, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(50, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(51, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(52, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(53, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    %% Walls
    wall0 = QLabsBasicShape(qlabs);
    % Outer walls
    wall0.spawn_id(54, [0, -1.8, 0], [0, 0, 0], [10.8, 0.1, 1]);
    wall0.spawn_id(55, [0, 1.8+3.6, 0], [0, 0, 0], [10.8, 0.1, 1]);
    wall0.spawn_id(56, [-1.8-3.6, 1.8, 0], [0, 0, pi/2], [7.2, 0.1, 1]);
    wall0.spawn_id(57, [ 1.8+3.6, 1.8, 0], [0, 0, pi/2], [7.2, 0.1, 1]);
    
    % Middle walls
    wall0.spawn_id(58, [ 4.8, 1.8, 0], [0, 0, 0], [1.2, 0.1, 1]);
    wall0.spawn_id(59, [-4.8, 1.8, 0], [0, 0, 0], [1.2, 0.1, 1]);
    wall0.spawn_id(60, [ 1.8, 1.8, 0], [0, 0, 0], [2.4, 0.1, 1]);
    wall0.spawn_id(61, [-1.8, 1.8, 0], [0, 0, 0], [2.4, 0.1, 1]);
    wall0.spawn_id(62, [ 1.8,-1.2, 0], [0, 0, pi/2], [1.2, 0.1, 1]);
    wall0.spawn_id(63, [-1.8,-1.2, 0], [0, 0, pi/2], [1.2, 0.1, 1]);
    wall0.spawn_id(64, [ 1.8, 4.8, 0], [0, 0, pi/2], [1.2, 0.1, 1]);
    wall0.spawn_id(65, [-1.8, 4.8, 0], [0, 0, pi/2], [1.2, 0.1, 1]);
    wall0.spawn_id(66, [ 1.8, 1.8, 0], [0, 0, pi/2], [2.4, 0.1, 1]);
    wall0.spawn_id(67, [-1.8, 1.8, 0], [0, 0, pi/2], [2.4, 0.1, 1]);
    
    %% Objects & Obstacles
    
    object0 = QLabsBasicShape(qlabs);
    
    % Cylinders
    object0.spawn_id(68, [1.5, -1.5, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(69, [1.5+3.6, 1.5, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(70, [-2.1, 1.5, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(71, [1.5, 5.1, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(72, [1.5+3.6, 2.1, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(73, [-5.1, 5.1, 0], [0, 0, 0], [0.1, 0.1, 1], object0.SHAPE_CYLINDER);
    
    % Obstacles
    object0.spawn_id(74, [ 5.1, 3.6, 0], [0, 0, 0], [0.6, 0.1, 1]);
    object0.spawn_id(75, [ 3.6, 4.5, 0], [0, 0, pi/2], [0.6, 0.1, 1]);
    object0.spawn_id(76, [-3.3, 4.2, 0], [0, 0, 0], [0.6, 0.1, 1]);
    object0.spawn_id(77, [-3.6, 4.5, 0], [0, 0, pi/2], [0.6, 0.1, 1]);
    object0.spawn_id(78, [-5.1, 3.6, 0], [0, 0, 0], [0.6, 0.1, 1]);
    object0.spawn_id(79, [-4.8, 3.9, 0], [0, 0, pi/2], [0.6, 0.1, 1]);
    object0.spawn_id(80, [ 0.0, 3.6, 0], [0, 0, 0], [1.2, 1.2, 1], object0.SHAPE_CUBE)
    object0.spawn_id(81, [-3.6, 0.0, 0], [0, 0, 0], [1.2, 1.2, 1], object0.SHAPE_CYLINDER);
    object0.spawn_id(82, [ 3.6, 0.0, 0], [0, 0, pi/4], [1.2, 0.1, 1]);
    object0.spawn_id(83, [ 3.6, 0.0, 0], [0, 0,-pi/4], [1.2, 0.1, 1]);
elseif caseNum == 1
    hFloor0 = QLabsQBotPlatformFlooring(qlabs);
    
    hFloor0.spawn_id(0, [-0.6, 0.6,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(1, [ 0.6, 1.8,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(2, [ 1.8,-0.6,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(3, [-0.6,-1.8,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(4, [-1.8, 0.6,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(5, [-0.6, 0.6,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(6, [ 0.6, 0.6,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(7, [ 0.6,-0.6,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(8, [-0.6,-0.6,   0], [0,0, pi/2], [1,1,1], 5, false);
    
    dx = 3.6; dy = 0;
    hFloor0.spawn_id(9, [-0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(10, [ 0.6+dx, 1.8+dy,   0], [0,0,-pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(11, [ 1.8+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 0, false);
    hFloor0.spawn_id(12, [-0.6+dx,-1.8+dy,   0], [0,0, pi/2], [1,1,1], 0, false);
    hFloor0.spawn_id(13, [-1.8+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 0, false);
    hFloor0.spawn_id(14, [-0.6+dx, 0.6+dy,   0], [0,0,    0], [1,1,1], 5, false);
    hFloor0.spawn_id(15, [ 0.6+dx, 0.6+dy,   0], [0,0,-pi/2], [1,1,1], 5, false);
    hFloor0.spawn_id(16, [ 0.6+dx,-0.6+dy,   0], [0,0, pi  ], [1,1,1], 5, false);
    hFloor0.spawn_id(17, [-0.6+dx,-0.6+dy,   0], [0,0, pi/2], [1,1,1], 5, false);

    wall0 = QLabsBasicShape(qlabs);
    % Outer walls
    wall0.spawn_id(18, [ 1.8, -1.8, 0], [0, 0, 0], [ 7.2, 0.1, 1]);
    wall0.spawn_id(19, [ 1.8,  1.8, 0], [0, 0, 0], [ 7.2, 0.1, 1]);
    wall0.spawn_id(20, [-1.8, 0, 0], [0, 0, pi/2], [3.6, 0.1, 1]);
    wall0.spawn_id(21, [ 1.8+3.6, 0, 0], [0, 0, pi/2], [3.6, 0.1, 1]);
    
    % Middle walls
    wall0.spawn_id(22, [ 1.8-0.3/sqrt(2), -1.5, 0], [0, 0, pi/4], [0.6, 0.1, 1]);
    wall0.spawn_id(23, [ 1.8+0.3/sqrt(2), -1.5, 0], [0, 0,-pi/4], [0.6, 0.1, 1]);
    wall0.spawn_id(24, [ 2.1,  1.5, 0], [0, 0, pi/2], [0.6, 0.1, 1]);
    wall0.spawn_id(25, [ 1.5,  1.5, 0], [0, 0, pi/2], [0.6, 0.1, 1]);
    wall0.spawn_id(26, [ 1.8,  1.2, 0], [0, 0, 0], [0.6, 0.1, 1]);
    
end

%% QBot Platform setup

% Spawn QBot Platform
hQBot = QLabsQBotPlatform(qlabs, verbose);
hQBot.spawn_id_degrees(0, location(caseNum, :), rotation(caseNum, :), [1, 1, 1], 1) ;
hQBot.possess(hQBot.VIEWPOINT_TRAILING);

% Run RT applications for QBot Platform
pause(0.5)
system(['quarc_run -D -r -t tcpip://localhost:17000 ', which('QBotPlatform_Workspace.rt-win64')])
pause(2)
system(['quarc_run -D -r -t tcpip://localhost:17000 ', which('qbot_platform_driver_virtual.rt-win64'), ' -uri tcpip://localhost:17098'])
pause(0.5)

%% Close QLabs connection
qlabs.close()
