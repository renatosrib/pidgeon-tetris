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
BORDA_CENTRAL = 400
BORDA_ESQUERDA = 0
BORDA_PECAS = 8
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

function desenha_f(x, y)
  GAME_GRID_TABELA:set_cell(x,y,3)
  GAME_GRID_TABELA:set_cell(x,y-1, 3)
  GAME_GRID_TABELA:set_cell(x, y+1, 3)
  GAME_GRID_TABELA:set_cell(x-1, y, 3)
end

function desenha_s(x, y)
  GAME_GRID_TABELA:set_cell(x,y,2)
  GAME_GRID_TABELA:set_cell(x,y-1, 2)
  GAME_GRID_TABELA:set_cell(x, y+1, 2)
  GAME_GRID_TABELA:set_cell(x +1, y +1, 2)
end

function desenha_5(x, y)
  GAME_GRID_TABELA:set_cell(x,y,2)
  GAME_GRID_TABELA:set_cell(x,y+1, 2)
  GAME_GRID_TABELA:set_cell(x+1, y, 2)
  GAME_GRID_TABELA:set_cell(x-1, y-1, 2)
end

function desenha_5(x, y)
  GAME_GRID_TABELA:set_cell(x,y,2)
  GAME_GRID_TABELA:set_cell(x,y+1, 2)
  GAME_GRID_TABELA:set_cell(x+1, y, 2)
  GAME_GRID_TABELA:set_cell(x-1, y-1, 2)
end

function desenha_traco(x, y)
  GAME_GRID_TABELA:set_cell(x,y,3)
  GAME_GRID_TABELA:set_cell(x,y-1, 3)
  GAME_GRID_TABELA:set_cell(x, y-2, 3)
  GAME_GRID_TABELA:set_cell(x, y+1, 3)
end

function desenha_quadrado(x, y)
  GAME_GRID_TABELA:set_cell(x,y,4)
  GAME_GRID_TABELA:set_cell(x,y+1, 4)
  GAME_GRID_TABELA:set_cell(x+1, y, 4)
  GAME_GRID_TABELA:set_cell(x+1, y+1, 4)
end

function desenha_Pl(x, y)
  GAME_GRID_TABELA:set_cell(x,y,5)
  GAME_GRID_TABELA:set_cell(x,y+1, 5)
  GAME_GRID_TABELA:set_cell(x, y-1, 5)
  GAME_GRID_TABELA:set_cell(x+1, y+1, 5)
end

function desenha_plinv(x, y )
  GAME_GRID_TABELA:set_cell(x,y,5)
  GAME_GRID_TABELA:set_cell(x,y+1, 5)
  GAME_GRID_TABELA:set_cell(x, y-1, 5)
  GAME_GRID_TABELA:set_cell(x+1, y-1, 5)

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
  drawPieces()


end

function drawPieces()
  for current in range(2, 20, 5) do
    peca = tetris.pecas[math.random(1,7)]
    if peca == tetris.pecas[1] then
      desenha_f(BORDA_PECAS,current)
    elseif peca == tetris.pecas[2] then
      desenha_s(BORDA_PECAS, current)
    elseif peca == tetris.pecas[3] then
      desenha_5(BORDA_PECAS, current)
    elseif peca == tetris.pecas[4] then
      desenha_traco(BORDA_PECAS, current)
    elseif peca == tetris.pecas[5] then
      desenha_quadrado(BORDA_PECAS, current)
    elseif peca == tetris.pecas[6] then
      desenha_Pl(BORDA_PECAS, current)
    elseif peca == tetris.pecas[7] then
      desenha_Pl(BORDA_PECAS, current)
    end

  end
end



function get_random_piece()
  return tetris.pecas[math.random(1,7)]
end

function love.update( dt )
  dtg = dt
  --Caso o usuário pressione espaço o pombo sobe um pouco
  if(love.keyboard.isDown("space")) then
    efeito_queda_livre_peca()
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
  if (pombo.posx >= (BORDA_CENTRAL - pombo_direita:getWidth()) and pombo.direcao == DIREITA) then
    pombo.pombo = pombo_esquerda
    pombo.direcao = ESQUERDA
  end
--Troca a direção do pombo para a direita caso ele alcance a borda esquerda
  if (pombo.posx <= BORDA_ESQUERDA and pombo.direcao == ESQUERDA) then
    pombo.pombo = pombo_direita
    pombo.direcao = DIREITA
  end

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
