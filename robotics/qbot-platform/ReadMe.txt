Documentation still under progress.

Start 2x MATLAB sessions for this demo. 

You will need:
- Logitech F710 Wireless Gamepad connected to your PC.
- Virtual QBot Platform license.

In MATLAB 1:
- Open matlab_1_robot_app.slx
- Follow instructions in that model to pick the QBot Platform Warehouse environment. 
- Run this model. Move on to matlab_2A_slam.m in MATLAB 2.  

In MATLAB 2:
- Run matlab_2A_slam.m.
- Use the joystick to drive the virtual QBot around The slam application generates a map. 
- When done driving, hit the Right Button to stop the Simulink app in MATLAB 1. 
- matlab_2A_slam saves the map and stops. 
- In MATLAB 1, run matlab_1_app.slx again. Run matlab_2B_localize.m in MATLAB 2. 
- The QBot's position estimate based on the saved map and lidar data is sent back to Simulink. 