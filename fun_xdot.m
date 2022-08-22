function xdot = fun_xdot(x,u,dt)

xdot = [x(10:18); fun_qddot(x,u,dt)];
