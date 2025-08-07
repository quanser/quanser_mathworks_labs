% Start by loading the map saved from the previous session.
load("map.mat");

% Set up additional parameters for this script
step_size  = 0.20;      % time set to 
t          = 0.0;       %
id         = 0;         % variable to hold 
pose       = [0, 0, 0]; % initial pose estimate
counter    = 0;         % incremement a counter for map rendering
totalScans = 400;       % number of scans to hold in the map
totalTime  = 150;       % seconds
rendFactor = 10;        % render everything N scans

% Set up stream communication with the Simulink app (robot_driver.slx)
% using Quanser's Stream API
uri       = 'tcpip://localhost:18465';
stream    = stream_connect(uri, false);

try
    % Main loop
    while ~qc_get_key_state(27) % while Esc key not pressed  
        
        % Send pose information back to Simulink app (robot_driver.slx)
        stream_send_double_array(stream, pose);
        stream_flush(stream);
        
        % Receive Lidar data from Simulink app (robot_driver.slx)
        % Note: this is a blocking stream and hence, handles timing
        value = stream_receive_double_array(stream, 420);
        if isempty(value) % Simulink app was terminated...
            fprintf(1, '\nServer has closed the connection.\n');
            break;
        end

        % Create a lidarScan from the data received
        scan = lidarScan(value(1:210,1), value(211:420,1));

        % Estimate the pose from previously generated Map
        pose = findPose(map, scan, [pose(1), pose(2)]);
        
        t = t + step_size;
    end

    % Once the Esc key is pressed, close the stream handle used for
    % communications.
    fprintf(1, '\n Esc key pressed, application terminating ...\n');

    % Close the stream connection.
    stream_close(stream);
    fprintf(1, 'Connection closed\n');
    
catch err
    % Error handling
    fprintf(1, '\n');
    fprintf(2, '\n%s.\nShutting down the client...\n', err.message);
    stream_close(stream);
    fprintf(1, 'Connection closed\n');
    rethrow(err);
    
end
