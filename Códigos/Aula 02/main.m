%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  0 - Boas práticas
%%  https://www.youtube.com/watch?v=Q832jvYdnzY&ab_channel=VanderleiParro
%% 

clc;
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  1 - Leitura e investigação dos dados
%% 
%% Coluna 3 refere-se a entrada

dados = load("-ascii", "exp7.txt");

% Renomeando as colunas
coluna1 = dados(:, 1);
coluna2 = dados(:, 2);
entrada = dados(:, 3);

% Visualizando os dados
figure()
subplot(3, 1, 1);
plot(entrada, 'linewidth', 3)
title('Entrada')

subplot(3, 1, 2);
plot(coluna1, 'linewidth', 2)
title('Coluna 1')

subplot(3, 1, 3);
plot(coluna2, 'linewidth', 2)
title('Coluna 2')

% A partir da análise dos gráficos, conclui-se que
velocidade = coluna1;
posicao    = coluna2;

% Criando o vetor tempo
Np    = length(entrada);    % Número de pontos coletados
Ts    = 1e-3;               % Tempo de amostragem
tempo = [0:Ts:(Np-1)*Ts];   % Vetor tempo

% Visualizando os dados
close(1)
figure()
subplot(3, 1, 1);
plot(tempo, entrada, 'linewidth', 3)
grid;
title('Entrada')
xlabel('Tempo [s]')
ylabel('Tensão')

subplot(3, 1, 2);
plot(tempo, velocidade, 'linewidth', 2)
title('Velocidade')
xlabel('Tempo [s]')
ylabel('')

subplot(3, 1, 3);
plot(tempo, posicao, 'linewidth', 2)
title('Posição')
xlabel('Tempo [s]')
ylabel('')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  2 - Qual a função de transferência, em Laplace, que relaciona a entrada
%%      e a velocidade? Gm(s) = Nm(s) / Dm(s)
%%
%%  Plotar a forma sobreposta os dados (real) e o modelo matemático

%%% Pólo e Ganho = Gm(s) = ganho/(s + polo) --> primeira ordem --> resposta
%%% exponencial exp(-polo*tempo)

ganho = 1;          % Ganho do sistema
polo  = 1;          % Polo do sistema

%%% quanto maior o valor do polo, mais rápido o sistema é


Nm    = ganho;      % Numerador da função de Laplace
Dm    = [1 polo];   % Denominador da função de Laplace

%%% Função de transferência - modelo matemático
Gm = tf(Nm, Dm);
% Gm =
%  
%     1
%   -----
%   s + 1
%  
% Continuous-time transfer function.


%%% Visualizar o resultado do modelo comparado aos dados
SYS = Gm;       % Sistema a ser simulado
U   = entrada;  % Entrada do sistema
T   = tempo;    % Vetor tempo

%%% ym - saída
%%
%%% CI - condição inicial

[ym, T, X] = lsim(SYS, U, T);

%%% Calculando o erro quadrático
Erro = sum((ym - velocidade).^2);

figure()
plot(tempo, velocidade, 'linewidth', 3)
grid;
hold;
plot(tempo, ym, 'linewidth', 3)
title('Dados e resposta do modelo')
xlabel('Tempo [s]')
ylabel('Tensão')

%%% Criando uma simulação para avaliar o erro em diferentes valores de polo
polo = [1:1:100];

for n = 1:100
    
    Nm = ganho;
    Dm = [1 polo(n)];
    
    Gm = tf(Nm, Dm);
    
    SYS = Gm;
    U = entrada;
    T = tempo;
    
    [ym, T, CI] = lsim(SYS, U, T);
    
    Erro(n) = sum((ym-velocidade).^2);
    
end

%%% Visualizando a variação do erro em função do polo
% figure()
% plot(polo, Erro, 'linewidth', 3)

