% Set up a LidarScanMap object
% map     = lidarscanmap(20, 8);
slamObj = lidarSLAM(20, 10);
slamObj.LoopClosureThreshold = 100;
slamObj.LoopClosureSearchRadius = 10;
hFigMap = figure;
axMap   = axes(Parent=hFigMap);
title(axMap,"Map of the Environment and Robot Trajectory")

% Set up additional parameters for this script
step_size    = 0.40;         % time set to 
t            = 0.0;          %
id           = 0;            % variable to hold 
pose         = [0, 0, 0, 0]; % initial pose estimate
counter      = 0;            % incremement a counter for map rendering
totalScans   = 500;          % number of scans to hold in the map
totalTime    = 750;          % seconds
updateFactor = 30;           % pose graph optimization every N scans
rendFactor   = 10;           % render every N scans

% Set up stream communication with the Simulink app (robot_driver.slx)
% using Quanser's Stream API
% uri       = 'tcpip://192.168.3.5:18465';
uri       = 'tcpip://192.168.5.3:18465';
stream    = quanser.communications.stream.connect(uri, false);

try
    % Main loop
    while ~qc_get_key_state(27) % while Esc key not pressed  

        % Send pose information back to Simulink app (robot_driver.slx)
        stream.send_double_array(pose);
        stream.flush;

        % Receive Lidar data from Simulink app (robot_driver.slx)
        % Note: this is a blocking stream and hence, handles timing
        value = stream.receive_double_array(841);
        if isempty(value) % Simulink app was terminated...
            fprintf(1, '\nServer has closed the connection.\n');
            break;
        end
        
        % Create a lidarScan from the range/angle data received
        scan = lidarScan(value(1:420,1), value(421:840,1));
        timeRecv = value(421,1);
        % Build map until condition elapses
        if id < totalScans || t < totalTime
 
            % Attempt adding scan to map
            [isScanAccepted, loopInfo, optimInfo] = addScan(slamObj, scan);
            if isScanAccepted % attempt successful
                id = id + 1;  % scan ID increment

                % Start Pose Graph optimization if atleast 10 scans have
                % been registered. Also do this for every 10th scan that is
                % added. 
                % if id > updateFactor && mod(id, updateFactor) == 0
                % 
                %     % Detect loop closure based on a decently large search
                %     % radius but a tight threshold. We are looking for 1
                %     % good match. 
                %     [relPose, matchScanId, score] =             ...
                %                         detectLoopClosure(map,  ...
                %                             MatchThreshold=300, ...
                %                             SearchRadius=25,     ...
                %                             NumMatches=1);
                % 
                %     % Check if a loop closure was found
                %     if ~isempty(relPose)
                %         % Check if the score was high enough
                %         if score > 250
                %             % Add loop closure to map object if relPose is estimated
                %             addLoopClosure(map, matchScanId, id, relPose);
                % 
                %             % Generate a poseGraph from the map and optimize it
                %             pGraph = poseGraph(map);
                %             updatedPGraph = optimizePoseGraph(pGraph);
                % 
                %             % Add the updated scans back to the map 
                %             optimizedScanPoses = nodeEstimates(updatedPGraph);
                %             updateScanPoses(map, optimizedScanPoses);
                %         end
                %     end
                % end            
                % Update the pose from the map
                % slamObj.
                % pose(1:3) = map.ScanAttributes{end, 'AbsolutePose'};
                % pose(4)   = timeRecv;

            end     
        else
            % Total scans exceeded and total time elapsed, exit loop
            break;
        end
        % Render the map at a slower rate to visualize SLAM
        if mod(counter, rendFactor) == 0
            show(slamObj);
            drawnow;
        end
        t       = t + step_size;
        counter = counter + 1;
    end
    % Either, 
    %   1. escape key was pressed
    %   2. total time elapsed & total scans exceeded
    
    % Save the map for later use.
    save map.mat map   
    fprintf(1, '\n Map saved, application terminating ...\n');

    % Close the stream connection.
    stream.close;
    fprintf(1, 'Connection closed\n');
    
catch err
    % Error handling
    fprintf(1, '\n');
    fprintf(2, '\n%s.\n Error... shutting down the client...\n', err.message);
    stream.close;
    fprintf(1, 'Connection closed\n');
    rethrow(err);

end
