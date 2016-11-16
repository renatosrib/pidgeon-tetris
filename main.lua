require "grid"

tetris = {}

LARGURA_TELA = love.graphics.getWidth()
ALTURA_TELA = love.graphics.getHeight()

--Toda a grid é preenchida com "zeros"
GAME_GRID_TABELA = grid.Grid(LARGURA_TELA, ALTURA_TELA, 0)

--Constantes
DIREITA = "direita"
ESQUERDA = "esquerda"
BORDA_DIRETA = 0
BORDA_ESQUERDA = 0
--incremento
velocidade = 2
GTETRIS = "TETRIS"
GPECAS = "PECAS"
LARGURA_PECA = 20
ALTURA_PECA = 20
METADE_DA_TELA_X = love.window.getWidth
COR_DIVISOR_TELA = {255, 255, 255}
COR_DE_FUNDO_PRETA = {0 , 0, 0, 0.5}
--[[a tabela abaixo representa as cores das pecas do jogo...]]--
tetris.cores = {
  [1] = {215, 40, 40},
  [2] = {255, 255, 0},
  [3] = {0, 0, 255},
	[4] = {0, 255, 0},
  [5] = {128, 128, 0}
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
  F,
  S,
  P5,
  PTRACO,
  PQUADRADO,
  PLINV,
  PL
}


--Informações de posição em relação ao pombo
pombo = {
  pombo = null,
  posx = 300,
  posy = 15,
  angulo = 0,
  tamanho = 1,
  offset = 0,
  direcao = DIREITA,
  flyUp=function()
    pombo.posy = pombo.posy - 20
    pombo.tempoPavaVoarNovamente = 10
  end,
  tempoPavaVoarNovamente = 0
}

--Frames
dtg = 0

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
  pombo_direita = love.graphics.newImage( "imgs/rsz_pidgeon_right.jpg")
  pombo_esquerda = love.graphics.newImage( "imgs/rsz_pidgeon_left.jpg")
  pombo.pombo = pombo_direita

  --desenha o delimitador no centro da tela
  for y in range(130, LARGURA_TELA) do
    GAME_GRID_TABELA:set_cell(LARGURA_TELA /2 , y , "|")
  end

  --DESENHA A PARTE NA QUAL AS PEÇAS "REPOUSAM"
  for x in range(0, LARGURA_TELA/2) do
    GAME_GRID_TABELA:set_cell(x, ALTURA_TELA*0.3, "_")
  end

  GAME_GRID_TABELA:set_cell(1,10,3)
  GAME_GRID_TABELA:set_cell(2,9,3)
  GAME_GRID_TABELA:set_cell(2,10,3)
  GAME_GRID_TABELA:set_cell(2,11,3)

end

function put_random_piece()
end

function love.update( dt )
  dtg = dt
  --Caso o usuário pressione espaço o pombo sobe um pouco
  if(love.keyboard.isDown("space")) then
    if(pombo.tempoPavaVoarNovamente == 0) then
      pombo.flyUp()
    end
  end
  if(pombo.tempoPavaVoarNovamente > 0) then
    pombo.tempoPavaVoarNovamente = pombo.tempoPavaVoarNovamente - 1
  end
  --Faz o movimento do pombo para a DIREITA ou para a ESQUERDA
  if (math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and pombo.direcao == DIREITA) then
    pombo.posx = pombo.posx + velocidade
  else
    pombo.posx = pombo.posx - velocidade
  end

  --Troca a direção do pombo para a esquerda caso ele alcance a borda direita
  if (pombo.posx >= (BORDA_DIREITA - pombo_direita:getWidth()) and pombo.direcao == DIREITA) then
    pombo.pombo = pombo_esquerda
    pombo.direcao = ESQUERDA
  end
--Troca a direção do pombo para a direita caso ele alcance a borda esquerda
  if (pombo.posx <= BORDA_ESQUERDA and pombo.direcao == ESQUERDA) then
    pombo.pombo = pombo_direita
    pombo.direcao = DIREITA
  end
  efeito_queda_livre_peca()
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


function love.draw()
  love.graphics.setBackgroundColor(COR_DE_FUNDO_PRETA)




  love.graphics.draw(pombo.pombo, pombo.posx, pombo.posy, pombo.angulo, pombo.tamanho, pombo.tamanho, pombo.offset, pombo.offset)
  for x in range(0,LARGURA_TELA) do
      for y in range(0, ALTURA_TELA) do
        if GAME_GRID_TABELA:get_cell(x,y) == 1 then
          love.graphics.setColor(tetris.cores[1])
          love.graphics.rectangle("fill", y * 20 , x * 20 , LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 2 then
          love.graphics.setColor(tetris.cores[2])
          love.graphics.rectangle("fill", y * 20  , x * 20,LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 3 then
          love.graphics.setColor(tetris.cores[3])
          love.graphics.rectangle("fill",y * 20 , x * 20, LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 4 then
          love.graphics.setColor(tetris.cores[4])
          love.graphics.rectangle("fill",y * 20 , x * 20, LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 5 then
          love.graphics.setColor(tetris.cores[5])
          love.graphics.rectangle("fill", y * 20 , x * 20, LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 6 then
          love.graphics.setColor(tetris.cores[5])
          love.graphics.rectangle("fill",y * 20 , x * 20, LARGURA_PECA, ALTURA_PECA)
        elseif GAME_GRID_TABELA:get_cell(x,y) == 7 then
          love.graphics.setColor(tetris.cores[5])
          love.graphics.rectangle("fill",y * 20 , x * 20, LARGURA_PECA, ALTURA_PECA)
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
end
