clear;
%% plant transfer function
tau = 0.05; % [s]
K = 5; % [rad/s/V]
G = tf( [ K ], [ tau 1 ] );
%% input signal
Av = 4;     % signal amplitude (V)
u_off = 1;  % signal offset (V)
f = 2;      % signal frequency (Hz)
ti = 0.7;   % initial time for plotting
tf = 0.99;   % final time (s)
dt = 1e-3;  % simulation step size (s)
% generate square wave
[u,t] = gensig('square',1/f,tf,dt);
% input signal
u = Av * u + u_off;
u_max = max(u);
t0 = 0.75; % step time (s)
%
%% Simulate signal
[y,t] = lsim(G,u,t);
y0 = y(t0/dt);          % input signal offset
y_ss = max(y);          % steady-state output
y1 = y0 + (1-exp(-1))*(y_ss-y0);    % first-delay output
y_crop = y(ceil(ti/dt):tf/dt);
t_crop = t(ceil(ti/dt):tf/dt);
% i1 = max( find(y_crop < y1) ); 
i1 = find(y_crop < y1, 1, 'last');
t1 = t_crop(i1);
tau_exp = t1-t0;

%
%% Plot
txt_x0 = 0.705;
ln_x0 = 0.72;
subplot(2,1,1);
plot(t,y,'linewidth',2);
xlabel('time');
ylabel('y');
axis([ti tf -2.5 30]);
% y0
text( txt_x0, y0+3, 'y_0', 'FontSize', 12  )
% Delta y
text( 1.02*txt_x0, (y0+y_ss)/2, '\Deltay', 'FontSize', 12 );
% y1
line( [0.77 t1], [y1 y1], 'LineStyle', ':', 'Color', 'k' );
text( 0.75, y1, 'y(t_1)', 'FontSize', 12  );
% y_ss
line( [ln_x0 tf], [y_ss y_ss], 'LineStyle', ':', 'Color', 'k' );
text( txt_x0, y_ss, 'y_{ss}', 'FontSize', 12  );
% t0
line( [t0 t0], [-5 y0], 'LineStyle', ':', 'Color', 'k' );
text( t0+0.002, 1, 't_0', 'FontSize', 12  );
% t1
line( [t1 t1], [-5 y1], 'LineStyle', ':', 'Color', 'k' );
text( t1+0.002, 1, 't_1', 'FontSize', 12  );

subplot(2,1,2)
plot(t,u,'linewidth',2);
line( [ln_x0 t0], [u_max u_max], 'LineStyle', ':', 'Color', 'k' );
text( txt_x0, u_off+0.6, 'u_{min}', 'FontSize', 12  );
text( txt_x0, u_max, 'u_{max}', 'FontSize', 12  );
text( 1.02*txt_x0, (u_off+u_max)/2, '\Deltau', 'FontSize', 12  );
axis([ti tf -0.5 6]);
xlabel('time (s)', 'FontSize', 12 );
ylabel('u', 'FontSize', 12 );

% export()
saveas(1,'step_response.png')