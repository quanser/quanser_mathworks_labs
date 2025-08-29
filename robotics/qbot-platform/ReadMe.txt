Documentation still under progress.

Start 2x MATLAB sessions for this demo. 

You will need:
- Logitech F710 Wireless Gamepad connected to your PC.
- Virtual QBot Platform license.

In MATLAB 1:
- Open robot_app.slx
- Follow instructions in that model to pick the QBot Platform Warehouse environment. 
- Run this model. Move on to MATLAB 2 below.  

In MATLAB 2:
- Run ex_slam.mlx.
- The example loads a MATLAB figure as the map is generated.
- Use the joystick to drive the virtual QBot around.
- When done driving, tap the joystick's Right Button (RB) to stop the Simulink app in MATLAB 1. 
- ex_slam.mlx saves the map and stops automatically. 

In MATLAB 1:
- Run robot_app.slx again.
- Move on to MATLAB 2 below.  

In MATLAB 2:
- Run ex_localize.mlx.
- This application uses the saved map and new lidar scans from robot_app.slx to localize.
- The robot's pose is sent back to robot_app.slx to monitor.