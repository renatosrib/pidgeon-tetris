--Constantes
DIREITA = "direita"
ESQUERDA = "esquerda"
BORDA_DIRETA = 0
BORDA_ESQUERDA = 0
--incremento
velocidade = 2

--Informações de posição em relação ao pombo
pombo = {
  pombo = null,
  posx = 300,
  posy = 15,
  angulo = 0,
  tamanho = 1,
  offset = 0,
  direcao = DIREITA
}


--Frames
dtg = 0

--Variaveis de controle do jogo

function love.load()
  BORDA_DIREITA = love.graphics.getWidth()
  pombo_direita = love.graphics.newImage( "imgs/rsz_pidgeon_right.jpg")
  pombo_esquerda = love.graphics.newImage( "imgs/rsz_pidgeon_left.jpg")
  pombo.pombo = pombo_direita
end

function love.update( dt )
  dtg = dt

  if (math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and pombo.direcao == DIREITA) then
    pombo.posx = pombo.posx + velocidade
  else
    pombo.posx = pombo.posx - velocidade
  end

  if (pombo.posx >= (BORDA_DIREITA - pombo_direita:getWidth()) and pombo.direcao == DIREITA) then
    pombo.pombo = pombo_esquerda
    pombo.direcao = ESQUERDA
  end

  if (pombo.posx <= BORDA_ESQUERDA and pombo.direcao == ESQUERDA) then
    pombo.pombo = pombo_direita
    pombo.direcao = DIREITA
  end

end


function love.draw()
  love.graphics.draw(pombo.pombo, pombo.posx, pombo.posy, pombo.angulo, pombo.tamanho, pombo.tamanho, pombo.offset, pombo.offset)

end
