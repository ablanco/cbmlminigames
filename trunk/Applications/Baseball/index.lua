--	Can't Believe my Luck - MiniGames!		Baseball minigame
--	http://incolors.proyectoanonimo.com
--	Copyright (C) 2007  Korosu Itai and Yprum
--
--	This program is free software; you can redistribute it and/or modify
--	it under the terms of the GNU General Public License as published by
--	the Free Software Foundation; either version 2 of the License.
--
--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
--	GNU General Public License for more details.
--
--	You should have received a copy of the GNU General Public License along
--	with this program; if not, write to the Free Software Foundation, Inc.,
--	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

--[[
ball = Image.createEmpty(12,12)
ball:clear(Color.new(255,255,255))]]
ball = ball or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/ball.png")
ball_width = ball:width()
ball_height = ball:height()

--[[
pja = Image.createEmpty(70,120)
pja:clear(Color.new(255,255,255))]]
pja = pja or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/pj1.png")
pja_width = pja:width()
pja_height = pja:height()

--[[
pjb = Image.createEmpty(70,120)
pjb:clear(Color.new(255,255,255))]]
pjb = pjb or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/pj2.png")
pjb_width = pjb:width()
pjb_height = pjb:height()

--[[
pjc = Image.createEmpty(70,120)
pjc:clear(Color.new(255,255,255))]]
pjc = pjc or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/pj3.png")
pjc_width = pjc:width()
pjc_height = pjc:height()

bbga = bbga or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/bg1.png")
bbgb = bbgb or Image.load("/psp/game/CBMLminiGames/Applications/Baseball/bg2.png")

highscore = 0
file = io.open("/psp/game/CBMLminiGames/Applications/Baseball/highscore.txt","r")
if file then
	highscore = tonumber(file:read("*a"))
	file:close()
end


function init()
	score = 0
	
	ballx = 130
	bally = 105

	bbgax = 0
	bbgay = 0

	bbgbx = 480
	bbgby = 0
	
	pjax = 33
	pjay = 132
	
	pjbx = 33
	pjby = 132

	pjcx = 33
	pjcy = 132

	resx = 480
	resy = 272
	
	hitx = 91
	hity = 157
	movb = 2

	t1 = os.time()
	
	margen = 20 --margen de error al batear en pixeles
	angle = 0 --angulo de bateo
	fuerzax = 0
	fuerzaxi = 0
	fuerzay = 0
	suelo = 250
	d = 0
	countnum = 3
	
	bateado = 0 -- 0=contando para lanzar, 1=preparado para golpear, 2=lanzado
	estadoParabola = 0
	gameover = 0 -- 0=starting, 1=hit ball, 2=gameover
	
	math.randomseed(os.time())
end

init()

function ballline()
	bally = bally + 2
	if movb % 2 == 0 then
		ballx = ballx - 1
		movb = movb + 1
	else
		ballx = ballx - 2
		movb = movb + 1
	end
	screen:blit(ballx, bally, ball)
end

function ballparabola()
	score = score + (fuerzax / 3)
	score = math.ceil(score)
		
	--MOVIMIENTO VERTICAL
	if fuerzay >= 0 then --está subiendo la bola
		if bally > (resy / 2) then --si la bola está en la mitad inferior de la pantalla (se mueve la bola)
			bally = bally - math.ceil(fuerzay / 3)
		else --si la bola está en la mitad superior de la pantalla (se mueve el fondo)
			bbgay = bbgay + math.ceil(fuerzay / 3)
			pjcy = pjcy + math.ceil(fuerzay / 3)
			bbgby = bbgby + math.ceil(fuerzay / 3)
		end
	else --la bola está bajando
		if bbgay <= 0 then --el fondo esta en el suelo, es decir, se mueve la bola
			bbgay = 0
			bbgby = 0
			bally = bally - math.ceil(fuerzay / 3)
		else --se mueve el fondo
			bbgay = bbgay + math.ceil(fuerzay / 3)
			pjcy = pjcy + math.ceil(fuerzay / 3)
			bbgby = bbgby + math.ceil(fuerzay / 3)
		end
	end
	--MOVIMIENTO HORIZONTAL
	if ballx < (resx / 2) then --si la bola está en la mitad izquierda de la pantalla (se mueve la bola)
		ballx = ballx + math.ceil(fuerzax / 3)
	else --sino, se mueve el fondo
		bbgax = bbgax - math.ceil(fuerzax / 3)
		pjcx = pjcx - math.ceil(fuerzax / 3)
		bbgbx = bbgbx - math.ceil(fuerzax / 3)
	end

	if estadoParabola == 0 then --¿se dibuja bbga o sólo bbgb?
		screen:blit(bbgax,bbgay,bbga)
	else
		screen:blit(bbgax,bbgay,bbgb)
	end
	screen:blit(bbgbx,bbgby,bbgb)
	screen:fillRect(0,0,272,bbgay,Color.new(162,214,254)) --dibuja un cuadro de color del cielo cuando la pelota supera cierta altura
	screen:blit(ballx, bally, ball)
	screen:blit(pjcx,pjcy,pjc)

	if (bbgbx <= 0) and (estadoParabola == 0) then --pasamos a modo "sólo bbgb"
		estadoParabola = 1
		bbgax = 480 + bbgbx
	elseif estadoParabola == 1 then
		if bbgbx <= -480 then
			bbgbx = 480 + bbgax --ajustamos el reinicio de bbgb
		end
		if bbgax <= -480 then
			bbgax = 480 + bbgbx --ajustamos el reinicio de bbga
		end
	end

	if bally >= suelo then --rebote
		fuerzay = (0-fuerzay) - 20 --cambiamos de signo y disminuimos la fuerza
		bally = suelo - 1 --ajustamos la pelota
		if fuerzax > 20 then --se pierde fuerza en el impacto sin quitarsela toda..
			fuerzax = fuerzax - 20
		end
		if fuerzay <= 0 then --ya no bota más
			gameover = 2 --fin del juego
		end
	end

	fuerzay = fuerzay - 3 --gravedad
end

function countdown()
	if os.difftime(os.time(), t1) < 1 then
		countnum = 3
	elseif os.difftime(os.time(), t1) < 2 then
		countnum = 2
	elseif os.difftime(os.time(), t1) < 3 then
		countnum = 1
	else
		bateado = 1
	end
	screen:print(151,103,countnum,Color.new(255,0,0))
	if countnum <= 1 then screen:blit(ballx, bally, ball) end
end

function draw()
	if bateado == 0 then -- Espera a la bola
		screen:blit(0,0,bbga)
		screen:blit(pjax, pjay, pja)
		countdown()
	elseif bateado == 1 then -- Se prepara a batear
		screen:blit(0,0,bbga)
		screen:blit(pjbx,pjby,pjb)
		ballline()
	elseif gameover ~= 2 then -- Ha bateado
		ballparabola()
	else
		if estadoParabola == 0 then
			screen:blit(bbgax,bbgay,bbga)
			screen:blit(pjcx,pjcy,pjc)
		else
			screen:blit(bbgax,bbgay,bbgb)
		end
		screen:blit(bbgbx,bbgby,bbgb)
		screen:blit(ballx, bally, ball)
	end
	
end

function dist(ax,ay,bx,by)
	difx = math.abs(bx - ax)
	dify = math.abs(by - ay)
	return math.sqrt(math.pow(difx,2) + math.pow(dify,2))
end

function distAngle(d)
	gradosPorPixel = 45 / margen
	if bally < hity then
		angle = 45 + (d * gradosPorPixel)
	else
		angle = 45 - (d * gradosPorPixel)
	end
	fuerzax = math.ceil(math.cos(math.rad(angle))^2*100) --La fuerza horizontal tomara valores desde el 0 hasta el 100 segun el angulo previamente calculado
	fuerzay = math.floor(math.sin(math.rad(angle))^2*100) --Igual pero para la vertical, siendo siempre el complementario del otro respecto 100
	fuerzax = fuerzax * ((math.random(7) * 0.1) + 1.6) --Esto es asi para que la pelota llegue mucho mas lejos y el juego sea menos predecible ^_^
	fuerzaxi = fuerzax
end

while true do
	binput = Controls.read()
	--if binput:start() then break end
	if binput:select() then dofile("/psp/game/CBMLminiGames/Applications/system.lua") end
	if binput:cross() and (bateado ~= 2) then
		d = dist(ballx,bally,hitx, hity)
		if d < margen then
			distAngle(d)
			gameover = 1
		else
			System.sleep(1)
			gameover = 2
		end
		bateado = 2
	end

	draw()

	if bally >= resy then gameover = 2 end --si la bola sale de la pantalla, gameover!

	if gameover == 2 then--game over
		System.sleep(1)
		screen:print(300-27,35,"Your Score:",Color.new(0,0,0))
		screen:print(300-string.len(score)*4,45,score,Color.new(0,0,0))
		screen:print(300-25,60,"Highscore:",Color.new(0,0,0))
		screen:print(300-string.len(highscore)*4,75,highscore,Color.new(0,0,0))
		if score > highscore then
			screen:print(300-28,90,"New Highscore!",Color.new(0,0,0))
		end
		screen:print(300-55,110,"Press [] to Play Again",Color.new(0,0,0))
		screen:drawLine(300-4,110,302,110,Color.new(0,0,0))
		screen:drawLine(300-4,116,302,116,Color.new(0,0,0))
		if binput:square() then
			if score > highscore then
				highscore = score;
				file = io.open("/psp/game/CBMLminiGames/Applications/Baseball/highscore.txt","w")
				if file then
					file:write(highscore)
					file:close()
				end
			end
			init()
		end
	end

	screen:print(1,1,score,Color.new(0,0,0))
	screen.waitVblankStart()
	screen.flip()
end