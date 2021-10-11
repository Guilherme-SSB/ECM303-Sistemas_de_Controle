%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  1 - Preparação do código 
%% 
%%  Boas práticas: limpeza de variáveis; variáveis globais
%%  Constantes; carregar bibliotecas;...
%%
%%% Limpeza

clc;          % limpa visual da tela de comandos
close all;    % limpa as figuras
clear all;    % limpa as variáveis

disp('1 - Preparando o código ...')

%%% Omite mensagens de warning
warning('off')   % Não mostra eventos de warning

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nma1 = [22 22*50];
Dma1 = [1 28 0];

Gma1 = tf(Nma1, Dma1)

% Calculando o Lugar das Raízes para o G_malha_aberta
figure(1)
rlocus(Gma1) 
%% Como o G_MA tem ordem 2, a Figure(1) vai ter duas cores, uma para cada polo
%% x -> polo; bolinha -> zero

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nma2 = [22];
Dma2 = [1 28 0];

Gma2 = tf(Nma2, Dma2)

% Lugar das Raízes
figure(2)
rlocus(Gma2) 



