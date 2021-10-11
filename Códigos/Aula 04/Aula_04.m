%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 0 - Boas práticas
%%
%%   Referências: https://youtu.be/Q832jvYdnzY

clc;
clear all;
close all;

%%% carregando o pacote de controle e sinais

% pkg load control;
% pkg load signal;

%%% dados = load("-ascii", "exp7.txt");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 1 - Leitura e investigação dos dados
%%
%% coluna 3 refere-se a entrada

dados = load("-ascii", "exp7.txt");

%%% Renomeando as colunas

entrada    = dados(:,3);           % entrada aplicada ao motor
velocidade = dados(:,1);           % entrada aplicada ao motor
posicao    = dados(:,2);           % entrada aplicada ao motor

%%% Criando o vetor tempo

Np         = length(entrada);     % número de pontos coletados
Ts         = 1/1000;              % tempo de amostragem
tempo      = [0:Ts:(Np-1)*Ts];    % vetor tempo

%%% tempo  =  linspace(0,(Np-1)*Ts,Np);

%%% Visualização dos dados

figure()

subplot(3,1,1);
plot(tempo,entrada(1:end),'linewidth',3);
grid;
title('Entrada');
xlabel('Tempo em segundos');
ylabel('Tensao');

subplot(3,1,2);
plot(tempo,velocidade(1:end),'linewidth',3);
grid;
title('Velocidade');
xlabel('Tempo em segundos');
ylabel('Tensao');

subplot(3,1,3);
plot(tempo,posicao(1:end),'linewidth',3)
grid;
title('Posicao');
xlabel('Tempo em segundos');
ylabel('Tensao');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 2 - Qual a função de transferência em Laplace que relaciona a entrada 
%%     e a velocidade? Gm(s) = Nm(s)/Dm(s)
%%
%%     Plotar de forma sobreposta os dados (real) e o modelo matemático
%%

%%% Pólo e ganho = Gm(s) = ganho/ (s + polo) --> primeira ordem --> exp(-polo*tempo)

ganho =  22.478;          % ganho do sistema
polo  =  28.094;          % polo do sistema

%%% quanto maior o valor do polo mais rápido o sistema é


Nm    = ganho;      % numerador da função de laplace
Dm    = [1 polo];   % denominador de laplace

%%% Função de transferência - modelo matemático

Gm    = tf(Nm,Dm);

% ##Transfer function 'Gm' from input 'u1' to output ...
% ##
% ##        1
% ## y1:  -----
% ##      s + 1
% ##
% ##Continuous-time model.

%%% Visualizar o resultado do modelo comparado aos dados

SYS = Gm;                       % sistema a ser simulado
U   = entrada;                  % entrada do sistema
T   = tempo;                    % vetor tempo

%%%% ym - saída
%%
%%%% CI - condição inicial

[ym, T, CI] = lsim (SYS, U, T);

figure()

plot(tempo,velocidade(1:end),'linewidth',3)
grid;
hold;
plot(tempo,ym,'linewidth',3)
title('Dados e resposta do modelo');
xlabel('Tempo em segundos');
ylabel('Tensao');

%%%%%%% Modelando os sensores e a malha de posição
%%
%%% K * Komega = 22.478 <-- 
%%
%%%%%%% Malha de velocidade

% ##Transfer function 'Gm' from input 'u1' to output ...
% ##
% ##        22.48
% ## y1:  ---------
% ##      s + 28.09
% ##
% ##Continuous-time model.

%%%% Para uma volta de 2pi radianos temos uma variação de tempo de 0.35 - 0.25

Omega  = 2*pi/(0.35-0.25);   %%% rd/s

%%% Ganho do sensor de velocidade

Komega = 3/Omega;

%%% Ganho do motor - K * Komega = 22.478 <-- 

K = 22.478/Komega;

%%% Ganho do sensor de posição

Ktheta = 20/(2*pi);


%%%% Modelo completo

pm           = polo;

%% 1 - Malha de velocidade

NumVel       = [K];
NumVelTensao = [K*Komega];
DenVel       = [1 pm];

%%% Resposta em velocidade
Gvel = tf(NumVel, DenVel);

%%% Resposta em tensão - sensor
GvelTensao = tf(NumVelTensao, DenVel);


%% 2 - Malha de posição

NumPos       = [K];
NumPosTensao = [K*Ktheta];
DenPos       = [1 pm 0];

%%% Resposta em posição
Gpos         = tf(NumPos, DenPos);

%%% Resposta em posição - sensor
GposTensao   = tf(NumPosTensao, DenPos);

%%% Aplicando o sinal de entrada

[yvel, T, CI]       = lsim(Gvel, entrada, tempo);
[yvelTensao, T, CI] = lsim(GvelTensao, entrada, tempo);
[ypos, T, CI]       = lsim(Gpos, entrada, tempo);
[yposTensao, T, CI] = lsim(GposTensao, entrada, tempo);

%%% Modelar o sensor de posição

yposTensao = mod(yposTensao, 2*pi);


%%% Visualização dos dados

figure()

subplot(3,1,1);
plot(tempo,entrada(1:end),'linewidth',3);
grid;
title('Entrada');
xlabel('Tempo em segundos');
ylabel('Tensao');

subplot(3,1,2);
plot(tempo,velocidade(1:end),'linewidth',3);
hold;
plot(tempo,yvelTensao,'linewidth',3);
grid;
title('Velocidade');
xlabel('Tempo em segundos');
ylabel('Tensao');

subplot(3,1,3);
plot(tempo,posicao(1:end),'linewidth',3)
hold;
plot(tempo,yposTensao,'linewidth',3);
grid;
title('Posicao');
xlabel('Tempo em segundos');
ylabel('Tensao');


