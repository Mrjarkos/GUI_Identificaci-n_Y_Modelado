function [order Gs] = IdentifyResponse(t, y)
Ymax=max(y);
Ymin=min(y);

% Respuesta De Segundo Orden Negativa 
if abs(Ymin) > abs(Ymax)
    sp = abs(Ymax);
    max = abs(Ymin);
    i=find(y==sp);
    tp = t(i);
    
    %Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
    %positivos de la respuesta sobre o criticamente amoritugada
    
    if(Ymax >= (-0.02*Ymin))
        %Encuentra el tiempo de estabilizacion
        ultimo_i=1;
        its=0;
        ts=0;
        i=0;
        while its~=1

            if  y(ultimo_i+4) <= 0
                i=ultimo_i;
                its=1;
                while y(i)<=y(ultimo_i)
                    if abs(y(i))>0.05*max
                        its=0;
                    end
                    i=i+1;
                    if i>=length(y)
                        its=0;
                        y(i)=1;
                        break
                    end

                end
                if its==1
                    ts=t(i);
                end
                if y(i)<0
                    u=0;
                    while u<100
                        if y(i+u)>0
                            i=i+u;
                            u=100;
                        end
                        u=u+1;
                    end
                    i=i+1;
                end

            end

            if y(ultimo_i+4) >= 0
                i=ultimo_i;
                its=1;
                while y(i)>=y(ultimo_i)
                    if abs(y(i))>0.05*max
                        its=0;
                    end
                    i=i+1;
                    if i>=length(y)
                        its=0;
                        y(i)=-1;
                        break
                    end

                end
                if its==1
                    ts=t(i);
                end
                if y(i)>0
                    u=0;
                    while u<100
                        if y(i+u)<0
                            i=i+u;
                            u=100;
                            disp(y(i))
                        end
                        u=u+1;
                    end
                    i=i+1;
                end
            end
            ultimo_i=find(t==t(i));
            if i>=length(y)
                break
            end
        end
    
        if ts~=0
            OS=sp/max;
            z=sqrt(((-log(OS))^2)/((pi^2)+((-log(OS))^2)));
            Wn=4/(z*ts);
            Num=[-(Wn.^(2))];
            Den=[1 2*Wn*z Wn.^(2)];
            Gs=tf(Num,Den)
        else

            Wd=pi/tp;
            OS=sp/max;
            alpha=(-Wd*log(OS))/pi;
            Wn=sqrt((alpha.^2)+(Wd.^2));
            z=alpha/Wn;

            Num=[-Wn.^(2)];
            Den=[1 2*Wn*z Wn.^(2)];
            Gs=tf(Num,Den)
        end
    end
end

% Respuesta De Segundo Orden Positiva
if abs(Ymax) > abs(Ymin)
    sp = Ymin;
    max = abs(Ymax);
    i=find(y==sp);
    tp = t(i);
    sp=abs(sp);
    
    %Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
    %negativos de la respuesta sobre o criticamente amoritugada
    if abs(Ymin) >= (0.02*Ymax) && Ymax > 0
        %Encuentra el tiempo de estabilizacion
        ultimo_i=1;
        its=0;
        ts=0;
        i=0;
        while its~=1
    
            if  y(ultimo_i+4) <= 0
                i=ultimo_i;
                its=1;
                while y(i)<=y(ultimo_i)
                    if abs(y(i))>0.05*max
                        its=0;
                    end
                    i=i+1;
                    if i>=length(y)
                        its=0;
                        y(i)=1;
                        break
                        break
                    end
                end
                if its==1
                    ts=t(i);
                end
                if y(i)<0
                    u=0;
                    while u<100
                        if y(i+u)>0
                            i=i+u;
                            u=100;
                        end
                        u=u+1;
                    end
                    i=i+1;
                end

            end

            if y(ultimo_i+4) >= 0
                i=ultimo_i;
                its=1;
                while y(i)>=y(ultimo_i)
                    if abs(y(i))>0.05*max
                        its=0;
                    end
                    i=i+1;
                    %Si se pasa de la longitud de Y
                    if i>=length(y)
                        its=0;
                        y(i)=-1;
                        break
                    end
                end
                if its==1
                    ts=t(i);
                end
                if y(i)>0
                    u=0;
                    while u<100
                        if y(i+u)<0
                            i=i+u;
                            u=100;
                            disp(y(i))
                        
                        end
                        u=u+1;
                    end
                    i=i+1;
                end
            end
            ultimo_i=find(t==t(i));
            if i>=length(y)
                break
            end

        end
    
        if ts~=0
            OS=sp/max;
            z=sqrt(((-log(OS))^2)/((pi^2)+((-log(OS))^2)));
            Wn=4/(z*ts);
            Num=[(Wn.^(2))];
            Den=[1 2*Wn*z Wn.^(2)];
            Gs=tf(Num,Den)
        else

            Wd=pi/tp;
            OS=sp/Ymax;
            alpha=(-Wd*log(OS))/pi;
            Wn=sqrt((alpha.^2)+(Wd.^2));
            z=alpha/Wn;

            Num=[Wn.^(2)];
            Den=[1 2*Wn*z Wn.^(2)];
            Gs=tf(Num,Den)
        end
    end
end

% Respuesta De Primer Orden Positiva
%Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
%negativos de la respuesta sobre o criticamente amoritugada
if abs(Ymin) <= (0.02*Ymax) && Ymax > 0
    max=Ymax;
    for i=find(y==Ymax):1:size(y)-1
        if y(i)<=(0.368*Ymax)
            T=t(i);
            break
        end
    end
    Num=[max];
    Den=[1 1/T];
    Gs=tf(Num,Den)
    disp(T)
    disp(max)
end

% Respuesta De Primer Orden Negativa
%Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
%positivos de la respuesta sobre o criticamente amoritugada
if Ymin < 0 && Ymax <= (-0.02*Ymin)
    max=Ymin;
    for i=find(y==Ymin):1:size(y)-1
        if y(i)>=(0.368*Ymin)
            T=t(i);
            break
        end
    end
    Num=[max];
    Den=[1 1/T];
    Gs=tf(Num,Den)
    disp(T)
    disp(max)
end

%Gs funcion Generada por el programa
%GsP funcion Generada en los vectores t,y
figure (7)
impulse(Gs)

hold on

impulse(GsP)
end
