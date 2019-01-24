f = @(x1,x2) x1.^2 - x2.*(x2-2);

x = -10:0.1:10;
y = x;

[xx,yy] = meshgrid(x,y);
contour(xx,yy,f(xx,yy));

N = 6;

B = [1;3];
S = [4;5];
W = [1;-2];

for i = 1:N

    V = [B,S,W];
    id = [1,2,3];

    fb = f(B(1),B(2));
    fs = f(S(1),S(2));
    fr = f(W(1),W(2));
    F = [fb,fs,fr];

    % Orders the vertices based on values of f

    T = [id;F];
    [temp, order] = sort(T(2,:));
    T = T(:,order);

    B = V(:,T(1,1));    fb = T(2,1);
    S = V(:,T(1,2));    fs = T(2,2);
    W = V(:,T(1,3));    fw = T(2,3);

    hold on
    plot(B(1),B(2),'o')
    plot(S(1),S(2),'o')
    plot(W(1),W(2),'o')

    plot(polyshape([B,S,V]'))

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
        if fb < fr && fr < fs
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
end
hold off