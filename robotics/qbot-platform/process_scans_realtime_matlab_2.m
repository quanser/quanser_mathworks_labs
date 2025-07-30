useOptimization = 1;
maxLidarRange = 8;
gridResolution = 20;
loopClosureThreshold = 50;
loopClosureSearchRadius = 15;
loopClosureNumMatches = 1;
mapObj = lidarscanmap(gridResolution,maxLidarRange);

% URI used to connect to the server model.
uri = 'tcpip://192.168.5.3:18000';
%uri = 'udp://localhost:18000';

% Use blocking I/O. Do not change this value.
nonblocking = false;

% Step size of the server
server_step_size = 0.40;   % 200 milliseconds

% Initial time
t = 0.0;

hFigMap = figure;
axMap = axes(Parent=hFigMap);
title(axMap,"Map of the Environment and Robot Trajectory")

% Connecting to the server using the specified URI
fprintf(1, 'Connecting to the server at URI: %s\n', uri);
stream = stream_connect(uri, nonblocking);

fprintf(1, 'Connected to server.\n\n');
fprintf(1, 'Press Esc to exit this script. Do NOT press Ctrl+C.\n');
fprintf(1, 'received: 0');
i = 0;
message = '0';
pose = [0, 0, 0];
try
    while ~qc_get_key_state(27) % while Esc key not pressed  

        %% Sends
        stream_send_double_array(stream, pose);
        stream_flush(stream);

        %% Receives
        value = stream_receive_double_array(stream, 840);
        if isempty(value) % then the server closed the connection gracefully
            fprintf(1, '\nServer has closed the connection.\n');
            break;
        end
        
        % Create a lidarScan from the data received
        scan = lidarScan(value(1:420,1), value(421:end,1));
        isScanAccepted = addScan(mapObj,scan);

        % if the scan is accepted and you have enough scans, run loop
        % closure on the scans
        if isScanAccepted && i > 10 && useOptimization
        
        % TODO: Once loop closure is detected, think of a way to find
        % optimal scans to keep storing in the mapObj and/or ignore recent
        % scans if the robot is not physically moving. This should prevent
        % errorneous scans when only rotating. This might require you to
        % also stream over robot velocities for added logic on this end.

             % Detect if there is loop closure
             [relPose,matchScanId, score] = detectLoopClosure(mapObj, ...
                 MatchThreshold=loopClosureThreshold, ...
                 SearchRadius=loopClosureSearchRadius, ...
                 NumMatches=loopClosureNumMatches);
             
             % Add loop closure to map object if relPose is estimated
             if ~isempty(relPose)
                 addLoopClosure(mapObj,matchScanId,i,relPose);
             end

             % generate a poseGraph from the map and optimize it
             pGraph = poseGraph(mapObj);
             updatedPGraph = optimizePoseGraph(pGraph);

             % Add the updated scans back to the map 
             optimizedScanPoses = nodeEstimates(updatedPGraph);
             updateScanPoses(mapObj,optimizedScanPoses);
        end
        i = i+1; % i is the current scan ID
        pose = mapObj.ScanAttributes.AbsolutePose(end,:);
        % render the map 
        show(mapObj,Parent=axMap);
        drawnow;

        % % Delete the previous value printed (if any)
        % fprintf(1, '%s', char(8 * ones(size(message))));

        % % Print out the value received
        % message = sprintf('%6.3f', isScanAccepted);
        % fprintf(1, message);

        % Increment timer
        t = t + server_step_size;
    end
    
    % Once the Esc key is pressed, close the stream handle used for
    % communications.
    fprintf(1, '\nShutting down the client...\n');
    stream_close(stream);
    fprintf(1, 'Connection closed\n');
    
catch err
    fprintf(1, '\n');
    fprintf(2, '\n%s.\nShutting down the client...\n', err.message);
    stream_close(stream);
    fprintf(1, 'Connection closed\n');

    rethrow(err);
end
