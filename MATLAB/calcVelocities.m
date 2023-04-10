function [v, w] = calcVelocities(v_prev, w_prev)
v = v_prev + 30*randn();
w = w_prev + 0.5*randn();
v = max(min(v, 50), 30);
w = max(min(pi, w), -pi);

end