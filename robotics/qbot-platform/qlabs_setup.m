% caseNum = 1; % Twin-room
caseNum = 2; % Hex-room

% Stop previously running real-time (RT) applications gracefully
try
    qc_stop_model('tcpip://localhost:17000', 'qbot_platform_driver_virtual')
    pause(1)
    qc_stop_model('tcpip://localhost:17000', 'QBotPlatform_Workspace')
catch error
end
pause(1)

% Connect to QLabs
qlabs = QuanserInteractiveLabs();
connection_established = qlabs.open('localhost');
if connection_established == false
    disp("Failed to open connection.")
    return
end
disp('Connected to Quanser Interactive Labs')

% Build scenario based on caseNum
scenario_builder(qlabs, caseNum)

% Run RT applications for QBot Platform
pause(0.5)
quarc_cmd   = 'quarc_run -D -r -t tcpip://localhost:17000 ';
rtApp1      = 'QBotPlatform_Workspace.rt-win64';
rtApp2      = 'qbot_platform_driver_virtual.rt-win64';
options     = ' -uri tcpip://localhost:17098';
system([quarc_cmd, which(rtApp1)])
pause(2)
system([quarc_cmd, which(rtApp2), options])
pause(1)

% Close QLabs connection
qlabs.close()
