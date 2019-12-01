function [Num,Den,Response_ID]=Resp2tf(y,t)
    YMax=max(y);
    Ymin=min(y);
    

    % Respuesta De Segundo Orden Negativa 
    if abs(Ymin) > abs(YMax)
        Response_ID=2;
        sp = abs(YMax);
        Max = abs(Ymin);
        i=find(y==sp);
        tp = t(i);

        %Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
        %positivos de la respuesta sobre o criticamente amoritugada

        if(YMax >= (-0.02*Ymin))
            %Encuentra el tiempo de estabilizacion
            ultimo_i=1;
            iden_ts=0;
            ts=0;
            i=0;
            while iden_ts~=1

                if  y(ultimo_i+4) <= 0
                    i=ultimo_i;
                    iden_ts=1;
                    while y(i)<=y(ultimo_i)
                        if abs(y(i))>0.05*Max
                            iden_ts=0;
                        end
                        i=i+1;
                        if i>=length(y)
                            iden_ts=0;
                            y(i)=1;
                            break
                        end

                    end
                    if iden_ts==1
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
                    iden_ts=1;
                    while y(i)>=y(ultimo_i)
                        if abs(y(i))>0.05*Max
                            iden_ts=0;
                        end
                        i=i+1;
                        if i>=length(y)
                            iden_ts=0;
                            y(i)=-1;
                            break
                        end

                    end
                    if iden_ts==1
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
                OS=sp/Max;
                z=sqrt(((-log(OS))^2)/((pi^2)+((-log(OS))^2)));
                Wn=4/(z*ts);
                Num=[-(Wn.^(2))];
                Den=[1 2*Wn*z Wn.^(2)];
                Gs=tf(Num,Den)
            else

                Wd=pi/tp;
                OS=sp/Max;
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
    if abs(YMax) > abs(Ymin)
        Response_ID=2;
        sp = Ymin;
        Max = abs(YMax);
        i=find(y==sp);
        tp = t(i);
        sp=abs(sp);

        %Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
        %negativos de la respuesta sobre o criticamente amoritugada
        if abs(Ymin) >= (0.02*YMax) && YMax > 0
            %Encuentra el tiempo de estabilizacion
            ultimo_i=1;
            iden_ts=0;
            ts=0;
            i=0;
            while iden_ts~=1

                if  y(ultimo_i+4) <= 0
                    i=ultimo_i;
                    iden_ts=1;
                    while y(i)<=y(ultimo_i)
                        if abs(y(i))>0.05*Max
                            iden_ts=0;
                        end
                        i=i+1;
                        if i>=length(y)
                            iden_ts=0;
                            y(i)=1;
                            break
                            break
                        end
                    end
                    if iden_ts==1
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
                    iden_ts=1;
                    while y(i)>=y(ultimo_i)
                        if abs(y(i))>0.05*Max
                            iden_ts=0;
                        end
                        i=i+1;
                        %Si se pasa de la longitud de Y
                        if i>=length(y)
                            iden_ts=0;
                            y(i)=-1;
                            break
                        end
                    end
                    if iden_ts==1
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
                OS=sp/Max;
                z=sqrt(((-log(OS))^2)/((pi^2)+((-log(OS))^2)));
                Wn=4/(z*ts);
                Num=[(Wn.^(2))];
                Den=[1 2*Wn*z Wn.^(2)];
                Gs=tf(Num,Den)
            else

                Wd=pi/tp;
                OS=sp/YMax;
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
    if abs(Ymin) <= (0.02*YMax) && YMax > 0
        Response_ID=1;
        Max=YMax;
        for i=find(y==YMax):1:size(y)-1
            if y(i)<=(0.368*YMax)
                T=t(i);
                break
            end
        end
        Num=[Max];
        Den=[1 1/T];
        Gs=tf(Num,Den)
        disp(T)
        disp(Max)
    end

    % Respuesta De Primer Orden Negativa
    %Ajustar 0.02(2%) dependiendo de que tanta sea la amplitud en numeros
    %positivos de la respuesta sobre o criticamente amoritugada
    if Ymin < 0 && YMax <= (-0.02*Ymin)
        Response_ID=1;
        Max=Ymin;
        for i=find(y==Ymin):1:size(y)-1
            if y(i)>=(0.368*Ymin)
                T=t(i);
                break
            end
        end
        Num=[Max];
        Den=[1 1/T];
        Gs=tf(Num,Den)
        disp(T)
        disp(Max)
    end
end
