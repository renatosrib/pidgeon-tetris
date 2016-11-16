--Constantes
DIREITA = "direita"
ESQUERDA = "esquerda"
BORDA_DIRETA = 0
BORDA_ESQUERDA = 0
--incremento
velocidade = 2
GTETRIS = "TETRIS"
GPECAS = "PECAS"

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


PECAS = {
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
modo = GTETRIS


function love.load()
  BORDA_DIREITA = love.graphics.getWidth()
  pombo_direita = love.graphics.newImage( "imgs/rsz_pidgeon_right.jpg")
  pombo_esquerda = love.graphics.newImage( "imgs/rsz_pidgeon_left.jpg")
  pombo.pombo = pombo_direita
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



end


function love.draw()
  if(modo == GTETRIS) then
    love.graphics.draw(pombo.pombo, pombo.posx, pombo.posy, pombo.angulo, pombo.tamanho, pombo.tamanho, pombo.offset, pombo.offset)
  end

end
