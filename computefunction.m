function X = computefunction(t, theta, type)
    switch type
        case "1" %subamortiguado
            X = theta(1).*exp(-theta(2).*t).*cos(theta(3).*t)+theta(4).*exp(-theta(2).*t).*sin(theta(3).*t)+theta(5);
        case "2" %sobreamortiguado
            X = theta(1).*exp(-theta(2).*t)+theta(3).*exp(-theta(4).*t)+theta(5);
        case "3" %críticamente amortiguado
            X = theta(1).*exp(-theta(2).*t)+theta(3).*t.*exp(-theta(2).*t)+theta(4);
        case "4" %Marginalmente inestable (oscilador)
            X = theta(1).*cos(theta(2).*t)+theta(3).*sin(theta(2).*t)+theta(4);
        otherwise %No se, no respondo
            X = zeros(1, lenght(t));
    end
end
%Subamortiguado
%Sobreamortiguado
%Critico
%Oscilador