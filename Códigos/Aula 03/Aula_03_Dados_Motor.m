%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 0 - Boas práticas
%%
%%   Referências: https://youtu.be/Q832jvYdnzY

clc;
clear all;
close all;

%%% carregando o pacote de controle e sinais -> somente para octave

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

