function [x, y, theta] = updateState(x_prev, y_prev, theta_prev, v, w, dt)
x = x_prev + v*cos(theta_prev)*dt;
y = y_prev + v*sin(theta_prev)*dt;
theta = theta_prev + w*dt;
end