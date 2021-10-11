%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Função mérito - ErroQMDMT(Km, pm) = sum_0^Np (y-ym).^2
%%
%%  MD - Modelo
%%  MT - Motor
%%
%%  Referências: https://youtu.be/Q832jvYdnzY

%%% Criando a função: 
function [ErroQ] = ErroQMDMT(X, velocidade, entrada, tempo)
%%% O nome do arquivo deve ser ErroQMDMT -> sintaxe do matlab para função

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Dados coletados em laboratório: 
%%  velocidade, entrada e tempo
%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Gerando dados a partir do modelo matemático 
%%

%%% Receber os valores de Km e pm
Km = X(1);      % Valor do ganho
pm = X(2);      % Valor do polo

%%% Crio a função de transferência
Gm = tf(Km, [1 pm]);

%%% Visualizar o resultado do modelo comparado aos dados
SYS = Gm;                       % sistema a ser simulado
U   = entrada;                  % entrada do sistema
T   = tempo;                    % vetor tempo

%%%% ym - saída
%%
%%%% CI - condição inicial

[ym, T, CI] = lsim (SYS, U, T);

%%% Calculando o erro quadrático

ErroQ = sum((ym - velocidade).^2)

end

