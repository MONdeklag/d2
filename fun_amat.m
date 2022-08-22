function A = fun_amat(x,u,dt)

%%% For finding A matrix 

global A B Nx Nu pert MI L m nx ny tx ty g ra   


for i = 1:Nx
        
        for j = 1:(Nx)
           % fun_xdot(x,u,dt)
            xnew = x + fun_xdot(x,u,dt)*dt/2; % is this constant ??
            xplus = x;
            xplus(j) =  x(j) + pert; %%% pert if iside diffferentiations
           

            if i<= Nx/2

          
                    %%% Jacobian of  Velocity with  q  and qdot
                    f = xnew((Nx/2)+i);
                    F = x(i) + f*dt;
                    qddot = fun_qddot(xplus,u,dt);
                    fplus = xplus((Nx/2)+i) + qddot(i)*dt/2;  
                    Fplus = xplus(i) + fplus*dt; 
                    A(i,j) = (Fplus - F)/pert;


           
            elseif i>Nx/2
    
                %%%  Jacobian of acceleration  with  q  and qdot

                        if j<=Nx/2
                                %%% pert in q for jac with acceleration
                                xplusr =    xnew;
                                xplusr(j) = xnew(j) + pert; 
                                
                        elseif j > Nx/2        
                
                            %%% pert in qdot for jac with acceleration
                            xplusr = xnew;
                            xplusr(j) =  xnew(j) + pert; 
                            xplusr(j-(Nx/2)) =  xnew(j-(Nx/2)) + pert*dt/2;
                        end


                    
                fr = fun_qddot(xnew,u,dt);
                Fr = x(i) + fr(i-(Nx/2))*dt;
                fplusr = fun_qddot(xplusr,u,dt); 
                Fplusr = xplus(i) + fplusr(i-(Nx/2))*dt; 
                A(i,j) = (Fplusr - Fr)/pert;

            end    
                
        end  

   

end