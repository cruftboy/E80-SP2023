x = 1700;
y = 700;
theta = 0;
v = 40;
w = 0;
dt = 0.1;

I = imread("BFC.png");
imshow(I);
hold on;

for i=1:1000
    [v, w] = calcVelocities(v, w);
    [x, y, theta] = updateState(x, y, theta, v, w, dt);

    plot(x,y,'ro')
    %axis([1400, 2000, 400, 1000]);

    drawnow;
    hold on;

end

