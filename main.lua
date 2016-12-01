require "grid"

tetris = {}

LARGURA_TELA = love.graphics.getWidth()
ALTURA_TELA = love.graphics.getHeight()

--Toda a grid é preenchida com "zeros"
GAME_GRID_TABELA = grid.Grid(LARGURA_TELA, ALTURA_TELA, 0)

--Constantes
DIREITA = "direita"
ESQUERDA = "esquerda"
BORDA_DIRETA = love.graphics.getWidth()
BORDA_CENTRAL = 400
BORDA_ESQUERDA = 0
BORDA_PECAS = ALTURA_TELA*0.3
--incremento
velocidade = 2
SOLTANDO_PECAS = "TETRIS"
PEGANDO_PECAS = "PECAS"
DESCENDO = "DESCENDO"
LARGURA_PECA = 20
ALTURA_PECA = 20
METADE_DA_TELA_X = love.window.getWidth
COR_DIVISOR_TELA = {255, 255, 255}
COR_DE_FUNDO_PRETA = {0 , 0, 0, 0.5 }
COR_DE_FUNDO_VERMELHA = {255 , 0, 0, 0.5}
--[[a tabela abaixo representa as cores das pecas do jogo...]]--
tetris.cores = {
  [1] = {215, 40, 40},
  [2] = {255, 255, 0},
  [3] = {0, 0, 255},
  [4] = {0, 255, 0},
  [5] = {128, 128, 0 },
  [6] = {128, 0, 128 },
  [7] = {128, 128, 128}
}

pombostatus = {
  voando = "voando",
  descendo = "descendo",
  acido = "acido"
}

PF = {
  { 0, 1, 0 },
  { 1, 1, 1 }
}

PS = {
    { 0, 2, 2 },
    { 2, 2, 0 }
}

P5 = {
    { 2, 2, 0 },
    { 0, 2, 2 }
}

PTRACO = {
    { 3, 3, 3, 3 }
}

PQUADRADO = {
    { 4, 4 },
    { 4, 4 }
}

PL = {
    { 0, 0, 5 },
    { 5, 5, 5 }
}

PLINV = {
      { 5, 0, 0 },
      { 5, 5, 5 }
}

tetris.pecas = {
  PF,
  PS,
  P5,
  PTRACO,
  PQUADRADO,
  PLINV,
  PL
}


--Informações de posição em relação ao pombo
pombo = {
  status = pombostatus.voando,
  pombo = null,
  posx = 300,
  posy = 0,
  angulo = 0,
  tamanho = 1,
  offset = 0,
  direcao = DIREITA,
  peca = null,
}

--Frames
dtg = 0

--Controle do jogo
vivo = true
modo = PEGANDO_PECAS

function desenha_f(x, y)
  GAME_GRID_TABELA:set_cell(x,y,1)
  GAME_GRID_TABELA:set_cell(x,y-20, 1)
  GAME_GRID_TABELA:set_cell(x, y+20, 1)
  GAME_GRID_TABELA:set_cell(x-20, y, 1)
end

function desenha_s(x, y)
  GAME_GRID_TABELA:set_cell(x,y,2)
  GAME_GRID_TABELA:set_cell(x,y-20, 2)
  GAME_GRID_TABELA:set_cell(x+20, y-20, 2)
  GAME_GRID_TABELA:set_cell(x+20, y-40, 2)
end

function desenha_5(x, y)
--    { 2, 2, 0 },
--    { 0, 2, 2 }
  GAME_GRID_TABELA:set_cell(x,y,3)
  GAME_GRID_TABELA:set_cell(x,y+20, 3)
  GAME_GRID_TABELA:set_cell(x+20, y+40, 3)
  GAME_GRID_TABELA:set_cell(x+20, y+20, 3)
end

function desenha_traco(x, y)
  GAME_GRID_TABELA:set_cell(x,y,4)
  GAME_GRID_TABELA:set_cell(x,y-20, 4)
  GAME_GRID_TABELA:set_cell(x, y-40, 4)
  GAME_GRID_TABELA:set_cell(x, y+20, 4)
end

function desenha_quadrado(x, y)
  GAME_GRID_TABELA:set_cell(x,y,5)
  GAME_GRID_TABELA:set_cell(x,y+20, 5)
  GAME_GRID_TABELA:set_cell(x+20, y, 5)
  GAME_GRID_TABELA:set_cell(x+20, y+20, 5)
end

function desenha_Pl(x, y)
  GAME_GRID_TABELA:set_cell(x,y,6)
  GAME_GRID_TABELA:set_cell(x,y+20, 6)
  GAME_GRID_TABELA:set_cell(x, y-20, 6)
  GAME_GRID_TABELA:set_cell(x+20, y+20, 6)
end

function desenha_plinv(x, y )
  GAME_GRID_TABELA:set_cell(x,y,7)
  GAME_GRID_TABELA:set_cell(x,y+20, 7)
  GAME_GRID_TABELA:set_cell(x, y-20, 7)
  GAME_GRID_TABELA:set_cell(x+20, y-20, 7)
end

function desenhar(x, y, peca)
  if(peca == 1) then
    desenha_f(x, y)
  elseif(peca==2) then
    desenha_s(x, y)
  elseif(peca==3) then
    desenha_5(x, y)
  elseif(peca==4) then
    desenha_traco(x, y)
  elseif(peca==5) then
    desenha_quadrado(x, y)
  elseif(peca==6) then
    desenha_Pl(x, y)
  elseif(peca==7) then
    desenha_plinv(x, y)
  end
end

function limparPecasEsquerda()
  for current in range(100, 300, 100) do
    GAME_GRID_TABELA:set_cell(BORDA_PECAS,current,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS + 20,current,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS - 20,current,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS + 40,current,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS - 40,current,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS,current +20,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS,current -20,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS,current +40,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS,current -40,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS +20,current +20,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS -20,current -20,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS +40,current +20,0)
    GAME_GRID_TABELA:set_cell(BORDA_PECAS -40,current -20,0)
  end
end

function limparPecaSelecionada()
  GAME_GRID_TABELA:set_cell(20,40,0)
  GAME_GRID_TABELA:set_cell(20 + 20,40,0)
  GAME_GRID_TABELA:set_cell(20 - 20,40,0)
  GAME_GRID_TABELA:set_cell(20 + 40,40,0)
  GAME_GRID_TABELA:set_cell(20 - 40,40,0)
  GAME_GRID_TABELA:set_cell(20,40 +20,0)
  GAME_GRID_TABELA:set_cell(20,40 -20,0)
  GAME_GRID_TABELA:set_cell(20,40 +40,0)
  GAME_GRID_TABELA:set_cell(20,40 -40,0)
  GAME_GRID_TABELA:set_cell(20 +20,40 +20,0)
  GAME_GRID_TABELA:set_cell(20 -20,40 -20,0)
  GAME_GRID_TABELA:set_cell(20 +40,40 +20,0)
  GAME_GRID_TABELA:set_cell(20 -40,40 -20,0)
end

function desenharPecasAcido()
  peca = gerarPecaRandomica()
  for current in range(100, 300, 100) do
    if peca == tetris.pecas[1] then
      desenha_f(ALTURA_TELA*0.3,current)
    elseif peca == tetris.pecas[2] then
      desenha_s(ALTURA_TELA*0.3, current)
    elseif peca == tetris.pecas[3] then
      desenha_5(ALTURA_TELA*0.3, current)
    elseif peca == tetris.pecas[4] then
      desenha_traco(ALTURA_TELA*0.3, current)
    elseif peca == tetris.pecas[5] then
      desenha_quadrado(ALTURA_TELA*0.3, current)
    elseif peca == tetris.pecas[6] then
      desenha_Pl(ALTURA_TELA*0.3, current)
    elseif peca == tetris.pecas[7] then
      desenha_plinv(ALTURA_TELA*0.3, current)
    end
  end
end

function gerarPecaRandomica()
  return tetris.pecas[math.random(1, 7)]
end


function efeito_queda_livre_peca()
  for x in range(0,LARGURA_TELA) do
    for y in range(0, ALTURA_TELA) do
      if GAME_GRID_TABELA:get_cell(x,y) == 1 then
        --limpa a celula anterior
        GAME_GRID_TABELA:set_cell(x, y, 0)

        GAME_GRID_TABELA:set_cell(x ,y, 1)
      end
    end
  end
end

--Variaveis de controle do jogo
--[[tabela representa o local no qual as peças se posicionam...]]--
tetris.tabela = {}

function range(from, to, step)
  step = step or 1
  return function(_, lastvalue)
    local nextvalue = lastvalue + step
    if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or
       step == 0
    then
      return nextvalue
    end
  end, nil, from - step
end





function love.load()
  BORDA_DIREITA = love.graphics.getWidth()
  pombo_direita = love.graphics.newImage( "imgs/rsz_pidgeon_right_4.jpg")
  pombo_esquerda = love.graphics.newImage( "imgs/rsz_pidgeon_left_4.jpg")
  som = love.audio.newSource("sound/LemGen_Ending.mp3")
  pombo.pombo = pombo_direita

  for x in range(0,LARGURA_TELA) do
    for y in range(0, ALTURA_TELA) do
      GAME_GRID_TABELA:set_cell(x , y , "0")
    end
  end

  --desenha o delimitador no centro da tela
  for y in range(130, LARGURA_TELA) do
    GAME_GRID_TABELA:set_cell(LARGURA_TELA /2 , y , "|")
  end

  --DESENHA A PARTE NA QUAL AS PEÇAS "REPOUSAM"
  for x in range(0, LARGURA_TELA/2) do
    GAME_GRID_TABELA:set_cell(x, ALTURA_TELA*0.3, "_")
  end
  desenharPecasAcido()


end

function love.update( dt )
  dtg = dt
  if(vivo) then
    if(modo == PEGANDO_PECAS) then
      --Faz o movimento do pombo para a DIREITA ou para a ESQUERDA
      if (math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and pombo.direcao == DIREITA) then
        pombo.posx = pombo.posx + velocidade
      else
        pombo.posx = pombo.posx - velocidade
      end

      --Troca a direção do pombo para a esquerda caso ele alcance a borda direita
      if (pombo.posx >= (BORDA_CENTRAL - pombo_direita:getWidth()) and pombo.direcao == DIREITA) then
        pombo.pombo = pombo_esquerda
        pombo.direcao = ESQUERDA
      end
      --Troca a direção do pombo para a direita caso ele alcance a borda esquerda
      if (pombo.posx <= BORDA_ESQUERDA and pombo.direcao == ESQUERDA) then
        pombo.pombo = pombo_direita
        pombo.direcao = DIREITA
      end
      if(love.keyboard.isDown("space") and pombo.posx <= BORDA_CENTRAL) then
        pombo.status = pombostatus.descendo
        modo = DESCENDO
      end
    end

    if(modo == DESCENDO) then
      if(math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and pombo.status == pombostatus.descendo) then
        if(pombo.posy <= BORDA_PECAS + 1 - pombo_direita:getWidth()) then
          if(pombo.direcao == DIREITA) then
            pombo.angulo = 0.5
            pombo.posy = pombo.posy + 1
            pombo.posx = pombo.posx + 1
          else
            pombo.angulo = 1
            pombo.posy = pombo.posy + 1
            pombo.posx = pombo.posx - 1
          end
          if(pombo.posx == BORDA_PECAS - pombo_direita:getWidth()) then
            print("posx>", pombo.posx)
            print("posy", pombo.posy)
            if(pombo.posy < 170) then
              print("pombo.posy", pombo.posy)
              posicao = 100
            elseif(pombo.posy >= 170 and pombo.posy < 250) then
              print('200')
              posicao = 200
            elseif (pombo.posy >= 250) then
              print('300')
              posicao = 300
            end
            celula = GAME_GRID_TABELA:get_cell(BORDA_PECAS, posicao)
            if(celula ~= 0 and celula ~= nil) then
              conteudoDaCelula = celula
            end
          end
        else
          if(conteudoDaCelula ~= nil and conteudoDaCelula ~= 0) then
            print(conteudoDaCelula)
            pombo.status = pombostatus.voando
            pombo.peca = conteudoDaCelula
          else
            pombo.status = pombostatus.acido
          end

          if(pombo.status == pombostatus.acido) then
            if(pombo.peca == null) then
              modo = SOLTANDO_PECAS
              vivo = false
            end
          else
            limparPecasEsquerda()
            desenharPecasAcido()
            modo = SOLTANDO_PECAS
          end
        end
      end

    end

    if(modo == SOLTANDO_PECAS) then
      --Sobe até chegar novamente ao topo
      if (pombo.posy > 0) then
        pombo.posy = pombo.posy - 2
      end
      --Faz o movimento do pombo para a DIREITA ou para a ESQUERDA
      if (math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and pombo.direcao == DIREITA) then
        pombo.posx = pombo.posx + velocidade
      else
        pombo.posx = pombo.posx - velocidade
      end
      pombo.angulo = 0
      --Troca a direção do pombo para a esquerda caso ele alcance a borda direita
      if (pombo.posx >= (BORDA_DIRETA - pombo_direita:getWidth()) and pombo.direcao == DIREITA) then
        pombo.pombo = pombo_esquerda
        pombo.direcao = ESQUERDA
      end
      --Troca a direção do pombo para a direita caso ele alcance a borda esquerda
      if (pombo.posx <= BORDA_CENTRAL and pombo.direcao == ESQUERDA) then
        pombo.pombo = pombo_direita
        pombo.direcao = DIREITA
      end

      if(love.keyboard.isDown("space") and pombo.posx >= BORDA_CENTRAL) then
        pombo.peca = nil
        pombo.status = pombostatus.voando
        limparPecaSelecionada()
        modo = PEGANDO_PECAS
      end
    end
  end
end

function love.draw()
  if(vivo) then
    som:play()
    if(modo == SOLTANDO_PECAS) then
      love.graphics.print("Peça atual: ",2,5,0,1,1)
      desenhar(20, 40, pombo.peca)
    end
    love.graphics.setBackgroundColor(COR_DE_FUNDO_PRETA)
    love.graphics.draw(pombo.pombo, pombo.posx, pombo.posy, pombo.angulo, pombo.tamanho, pombo.tamanho, pombo.offset, pombo.offset)
    for x in range(0,LARGURA_TELA) do
        for y in range(0, ALTURA_TELA) do
          if GAME_GRID_TABELA:get_cell(x,y) == 1 then
            love.graphics.setColor(tetris.cores[1])
            love.graphics.rectangle("fill", y , x , LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 2 then
            love.graphics.setColor(tetris.cores[2])
            love.graphics.rectangle("fill", y  , x,LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 3 then
            love.graphics.setColor(tetris.cores[3])
            love.graphics.rectangle("fill",y, x, LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 4 then
            love.graphics.setColor(tetris.cores[4])
            love.graphics.rectangle("fill",y , x, LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 5 then
            love.graphics.setColor(tetris.cores[5])
            love.graphics.rectangle("fill", y , x, LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 6 then
            love.graphics.setColor(tetris.cores[6])
            love.graphics.rectangle("fill",y , x, LARGURA_PECA, ALTURA_PECA)
          elseif GAME_GRID_TABELA:get_cell(x,y) == 7 then
            love.graphics.setColor(tetris.cores[7])
            love.graphics.rectangle("fill", y, x, LARGURA_PECA, ALTURA_PECA)
          --desenha as partes delimitadoras
          elseif GAME_GRID_TABELA:get_cell(x,y) == "_" then
            love.graphics.setColor(COR_DIVISOR_TELA)
            love.graphics.rectangle("line", x , y , 1, 1)
          elseif GAME_GRID_TABELA:get_cell(x,y) == "|" then
            love.graphics.setColor(COR_DIVISOR_TELA)
            love.graphics.rectangle("line", x , y , 1, 1)
          end
        end
    end
  else
    som:stop()
    love.graphics.setBackgroundColor(COR_DE_FUNDO_VERMELHA)
    love.graphics.print("Você perdeu!",280,250,0,3,3)
  end
end
