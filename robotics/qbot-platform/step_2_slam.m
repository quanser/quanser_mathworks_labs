%% Initialization & setup
mapObj  = lidarscanmap(20, 10); 
hFigMap = figure;
axMap   = axes(Parent=hFigMap);
title(axMap,"Map of the Environment and Robot Trajectory")

uri       = 'tcpip://localhost:18465';
step_size = 0.80;   
stream    = stream_connect(uri, false);
t         = 0.0;
id        = 0;
pose      = [0, 0, 0];

%% Main 
% Build and map and localize
try
    while ~qc_get_key_state(27) % while Esc key not pressed  

        %% Stream comms w/ Simulink App
        % Sends
        stream_send_double_array(stream, pose);
        stream_flush(stream);

        % Receives
        value = stream_receive_double_array(stream, 420);
        if isempty(value) % then the server closed the connection gracefully
            fprintf(1, '\nServer has closed the connection.\n');
            break;
        end
        
        %% SLAM
        % Create a lidarScan from the data received
        scan = lidarScan(value(1:210,1), value(211:420,1));

        % Build map for about 500 scans
        if id < 500
            isScanAccepted = addScan(mapObj, scan);
            if isScanAccepted
                id = id + 1;
                if id > 10 && mod(id, 10) == 0
                    [relPose,matchScanId, score] = detectLoopClosure(mapObj, ...
                                                        MatchThreshold=50, ...
                                                        SearchRadius=15, ...
                                                        NumMatches=1);
                    
                    if score > 175
                        % Add loop closure to map object if relPose is estimated
                        if ~isempty(relPose)
                            addLoopClosure(mapObj,matchScanId,id,relPose);
                        end
                        
                        % generate a poseGraph from the map and optimize it
                        pGraph = poseGraph(mapObj);
                        updatedPGraph = optimizePoseGraph(pGraph);
                        
                        % Add the updated scans back to the map 
                        optimizedScanPoses = nodeEstimates(updatedPGraph);
                        updateScanPoses(mapObj,optimizedScanPoses);
                    end
                end            
            end     
        else
            id = id - 1;
            break;
        end
        % render the map 
        mapObj.show;
        drawnow;
        t = t + step_size;
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
