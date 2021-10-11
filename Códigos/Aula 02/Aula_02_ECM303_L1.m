%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 0 - Boas práticas%%%%   Referências: https://youtu.be/Q832jvYdnzYclc;clear all;close all;%%% carregando o pacote de controle e sinais% pkg load control;% pkg load signal;%%% dados = load("-ascii", "exp7.txt");%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1 - Leitura e investigação dos dados%%%% coluna 3 refere-se a entradadados = load("-ascii", "exp7.txt");%%% Renomeando as colunasentrada    = dados(:,3);           % entrada aplicada ao motorvelocidade = dados(:,1);           % entrada aplicada ao motorposicao    = dados(:,2);           % entrada aplicada ao motor%%% Criando o vetor tempoNp         = length(entrada);     % número de pontos coletadosTs         = 1/1000;              % tempo de amostragemtempo      = [0:Ts:(Np-1)*Ts];    % vetor tempo%%% tempo  =  linspace(0,(Np-1)*Ts,Np);%%% Visualização dos dadosfigure(1)subplot(3,1,1);plot(tempo,entrada(1:end),'linewidth',3);grid;title('Entrada');xlabel('Tempo em segundos');ylabel('Tensao');subplot(3,1,2);plot(tempo,velocidade(1:end),'linewidth',3)grid;title('Velocidade');xlabel('Tempo em segundos');ylabel('Tensao');subplot(3,1,3);plot(tempo,posicao(1:end),'linewidth',3)grid;title('Posicao');xlabel('Tempo em segundos');ylabel('Tensao');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2 - Qual a função de transferência em Laplace que relaciona a entrada %%     e a velocidade? Gm(s) = Nm(s)/Dm(s)%%%%     Plotar de forma sobreposta os dados (real) e o modelo matemático%%%%% Pólo e ganho = Gm(s) = ganho/ (s + polo) --> primeira ordem --> exp(-polo*tempo)ganho = 1;          % ganho do sistemapolo  = 1;          % polo do sistema%%% quanto maior o valor do polo mais rápido o sistema éNm    = ganho;      % numerador da função de laplaceDm    = [1 polo];   % denominador de laplace%%% Função de transferência - modelo matemáticoGm    = tf(Nm,Dm);##Transfer function 'Gm' from input 'u1' to output ...####        1## y1:  -----##      s + 1####Continuous-time model.%%% Visualizar o resultado do modelo comparado aos dadosSYS = Gm;                       % sistema a ser simuladoU   = entrada;                  % entrada do sistemaT   = tempo;                    % vetor tempo%%%% ym - saída%%%%%% CI - condição inicial[ym, T, CI] = lsim (SYS, U, T);%%% Calculando o erro quadráticoErro = sum((ym - velocidade).^2)%%% Visualizaçãofigure(2)plot(tempo,velocidade(1:end),'linewidth',3)grid;hold;plot(tempo,ym,'linewidth',3)title('Dados e resposta do modelo');xlabel('Tempo em segundos');ylabel('Tensao');%%% Varia o valor do polopolo = [1:1:100];for n = 1:100    Nm    = ganho;      % numerador da função de laplace  Dm    = [1 polo(n)];   % denominador de laplace%%% Função de transferência - modelo matemático  Gm    = tf(Nm,Dm);  %%% Visualizar o resultado do modelo comparado aos dadosSYS = Gm;                       % sistema a ser simuladoU   = entrada;                  % entrada do sistemaT   = tempo;                    % vetor tempo%%%% ym - saída%%%%%% CI - condição inicial[ym, T, CI] = lsim (SYS, U, T);%%% Calculando o erro quadráticoErro(n) = sum((ym - velocidade).^2);endfigure(3)plot(polo,Erro,'linewidth',3)