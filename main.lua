--Constantes
DIREITA = "direita"
ESQUERDA = "esquerda"
BORDA_DIRETA = 0
BORDA_ESQUERDA = 0
--incremento
velocidade = 2

--Informações de posição em relação ao pombo
posx = 300
posy = 15
angulo = 0
tam = 1
offset = 0
direcao = DIREITA

--Frames
dtg = 0





function love.load()
  BORDA_DIREITA = love.graphics.getWidth()
  pombo_direita = love.graphics.newImage( "imgs/rsz_pidgeon_right.jpg")
  pombo_esquerda = love.graphics.newImage( "imgs/rsz_pidgeon_left.jpg")
end

function love.update( dt )
  dtg = dt

  if (math.fmod(dt * 1000, 2) >= 0 and math.fmod(dt * 1000000, velocidade) <= 2 and direcao == DIREITA) then
    posx = posx + velocidade
  else
    posx = posx - velocidade
  end

  if (posx >= (BORDA_DIREITA - pombo_direita:getWidth()) and direcao == DIREITA) then
    direcao = ESQUERDA
  end

  if (posx <= BORDA_ESQUERDA and direcao == ESQUERDA) then
    direcao = DIREITA
  end

end


function love.draw()
  if(direcao == DIREITA) then
    love.graphics.draw(pombo_direita, posx, posy, angulo, tam, tam, offset, offset)
  else
    love.graphics.draw(pombo_esquerda, posx, posy, angulo, tam, tam, offset, offset)
  end

end
