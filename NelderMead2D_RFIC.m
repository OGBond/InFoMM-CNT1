x = -1:0.1:1;
y = -2:0.1:2;

[xx,yy] = meshgrid(x,y);

contour(xx,yy,f(xx,yy),100);
hold on;

N = 20;

B = [1;1];
S = [0;0];
W = [1+sqrt(33);1-sqrt(33)]/8;

for i = 1:N

    V = [B,S,W];
    id = [1,2,3];

    fb = f(B(1),B(2));
    fs = f(S(1),S(2));
    fw = f(W(1),W(2));
    F = [fb,fs,fw];

    % Orders the vertices based on values of f

    T = [id;F];
    [temp, order] = sort(T(2,:));
    T = T(:,order);

    B = V(:,T(1,1));    fb = T(2,1);
    S = V(:,T(1,2));    fs = T(2,2);
    W = V(:,T(1,3));    fw = T(2,3);

    hold on

    plot(polyshape([B,S,V]'),'FaceColor',[1-i/N, i/N,0])

    M = 0.5*(B + S);    
    R = M + M - W;      fr = f(R(1),R(2));

    if fr < fb
        E = M + 2*(M - W);
        fe = f(E(1),E(2));
        if fe < fb
            W = E;
        else 
            W = R;
        end
    elseif fb < fr && fr < fs
            W = R;
    elseif fs < fr && fr < fw
            C = M + 0.5*(M - W);
            fc = f(C(1),C(2));
            if fc <= fr
                W = C;
            else
                S = (S + B)/2;
                W = (W + B)/2;
            end
    end
        if fr >= fw
            C = M - 0.5*(M - W);
            fc = f(C(1),C(2));
            if fc <= fw
                W = C;
            else
                S = (S + B)/2;
                W = (W + B)/2;
            end
        end
end

xlim([min(x),max(x)]);
ylim([min(y),max(y)]);
xlabel('$x$','Interpreter','LaTeX','FontSize',15)
ylabel('$y$','Interpreter','LaTeX','FontSize',15)
title('Nelder-Mead method, minimising $g(x,y)$','Interpreter','LaTeX','FontSize',13)
hold off
function z = f(x,y)

a = 6;  b = 60; t = 2;

z = a * b.^(x < 0).*sqrt(x.^2).^t + y + y.^2;

end