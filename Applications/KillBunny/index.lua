--	Can't Believe my Luck - MiniGames!		KillBunny minigame
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

--Carga de Imagenes
----Intro
textoa = texto1 or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/texto1.png")
textob = texto2 or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/texto2.png")
----Background
bga = bga or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/fondo.png")
bgb = bgb or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/fondo.png")
tree = tree or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/tree.png")
cloud = cloud or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/cloud.png")
----Character
bunny1 = bunny1 or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/bunny1.png")
bunny1_width = bunny1:width()
bunny1_height = bunny1:height()

bunny2 = bunny2 or Image.load("/psp/game/CBMLminiGames/Applications/KillBunny/graphics/bunny2.png")
bunny2_width = bunny2:width()
bunny2_height = bunny2:height()

--highscores data
highscoreDist = 0
highscoreKills = 0
file = io.open("/psp/game/CBMLminiGames/Applications/KillBunny/highscore.txt","r")
if file then
	highscoreDist = tonumber(file:read("*l"))
	highscoreKills = tonumber(file:read("*l"))
	file:close()
end

prej = 0 --nos indica si es la primera ejecucion (para reproducir la intro)

--Funciones
function intro()
	t = Timer.new()
	t:start()
	while (t:time() < 10000) do
		screen:blit(0,0,textoa)
		screen.waitVblankStart()
		screen.flip()
		System.sleep(100)
		input2 = Controls.read()
		if input2:cross() then break end
		if input2:select() then dofile("/psp/game/CBMLminiGames/Applications/system.lua") end
	end
	t:stop()
	t:reset()
	t:start()
	while (t:time() < 10000) do
		screen:blit(0,0,textob)
		screen.waitVblankStart()
		screen.flip()
		System.sleep(150)
		input2 = Controls.read()
		if input2:cross() then break end
		if input2:select() then dofile("/psp/game/CBMLminiGames/Applications/system.lua") end
	end
	t:stop()
	t:reset()
	prej = 1
end

function init()
	resx = 480 --resolucion de la psp horizontal
	resy = 272 --resolucion de la psp vertical

	scoreK = 0 --puntuacion de conejos asesinados
	scoreD = 0 --puntuacion de distancia recorrida en la pantalla

	bgax = 0 --posicion del fondo 1
	bgbx = 480 --posicion del fondo 2
	treesa = {0,0,0,0,0} --para dibujar arboles y nubes en el fondo 1 de manera aleatoria
	cloudsa = {{0,0},{0,0},{0,0},{0,0},{0,0}}
	treesb = {0,0,0,0,0} --para dibujar arboles y nubes en el fondo 2 de manera aleatoria
	cloudsb = {{0,0},{0,0},{0,0},{0,0},{0,0}}

	direccionbunny = 1 --hacia que lado apunta la cabeza del conejo, 1 a la derecha, 2 a la izquierda
	imgbunny = {bunny1, bunny2} --imagenes que representan al conejo
	posbunnyx = 100 --posicion horizontal del conejo rosa
	posbunnyy = (240-bunny1_height) --posicion vertical del conejo rosa

	salta = 0 --indica el estado del conejo, 0 si no salta, 1 si salta
	fuerzaVertical = 0 --el numero de turnos que sube el conejo 3 pixeles

	gameover = 0 --estado de la partida, 0 en juego, 1 game over
	pause = 0 --estado del pause
	prej = 0 --es la primera ejecucion de la partida
--al principio del programa obtenemos los primeros numeros aleatorios de los objetos del fondo
	for i = 1,5 do -- bucle para hacer cinco elementos de cada
		treesa[i] = math.random(480) --numero aleatorio para la posicion horizontal de los arboles
		treesb[i] = math.random(480)+bgbx --igual pero para el fondo 2
		cloudsa[i] = {math.random(480),math.random(140)} --posicion vertical y horizontal de las nubes
		cloudsb[i] = {math.random(480)+bgbx,math.random(140)} --igual para el fondo 2
	end
end

init()

function drawBG()
	if bgbx <= 0 then --cada vez que el fondo 1 desaparece por la izquierda, el fondo 2 se convierte en el 1 y creamos uno nuevo para el 2 con nuevo contenido en arboles y demas
		bgax = bgbx
		bgbx = bgbx + 480
		for i = 1,5 do
			treesa[i] = treesb[i]
			treesb[i] = math.random(480)+bgbx
			cloudsa[i] = cloudsb[i]
			cloudsb[i] = {math.random(480)+bgbx,math.random(140)}
		end
	end
	screen:blit(bgax,0,bga) --dibujamos los fondos
	screen:blit(bgbx,0,bgb)
	for i = 1,5 do --dibujamos las nubes
		if cloudsa[i][1] >= (0 - cloud:width()) then --solo si aparece en la pantalla se dibujan
			screen:blit(cloudsa[i][1],cloudsa[i][2],cloud) --las nubes para el fondo 1
		end
		if cloudsb[i][1] <= 480 then --solo si aparece en la pantalla se dibujan
			screen:blit(cloudsb[i][1],cloudsb[i][2],cloud) --las nubes para el fondo 2
		end
	end
	for i = 1,5 do --dibujamos los arboles (despues de las nubes para que se sobrepongan)
		if treesa[i] >= (0 - tree:width()) then --solo si aparece en la pantalla se dibujan
			screen:blit(treesa[i],240-tree:height(),tree) --los arboles para el fondo 1
		end
		if treesb[i] <= 480 then --solo si aparece en la pantalla se dibujan
			screen:blit(treesb[i],240-tree:height(),tree) --los arboles para el fondo 2
		end
	end
	screen:blit(posbunnyx,posbunnyy,imgbunny[direccionbunny]) --dibujamos el personaje
	moverlaHorizontal()
end

function moverlaHorizontal()
	if gameover == 0 then
		scoreD = scoreD + 1
	end
	bgax = bgax-2
	bgbx = bgbx-2
	posbunnyx = posbunnyx-2
	for i = 1,5 do
		treesa[i] = treesa[i]-2
		treesb[i] = treesb[i]-2
		cloudsa[i][1] = cloudsa[i][1]-2
		cloudsb[i][1] = cloudsb[i][1]-2
	end
end

function moverDer()
	if posbunnyx <= (478 - bunny1_width) then
		posbunnyx = posbunnyx + 4
	end
end

function moverIzq()
	if posbunnyx >= 2 then
		posbunnyx = posbunnyx - 2
	end
end

function movVertical()
	if fuerzaVertical > 0 then
		posbunnyy = posbunnyy - 3
		fuerzaVertical = fuerzaVertical - 1
	end
	if ((fuerzaVertical == 0) and noSuelo()) then
		posbunnyy = posbunnyy + 3
	end
end

function noSuelo()
	if (posbunnyy <= (240-bunny1_height)) then
		return true
	else
		salta = 0
		return false
	end
end


--Bucle infinito del programa
while true do
	--if pause == 0 then
		input = Controls.read()
		if prej == 0 then intro() end
		--if input:start() then pause = 1 end
		if input:select() then dofile("/psp/game/CBMLminiGames/Applications/system.lua") end
		drawBG()
		if input:right() then
			moverDer()
			direccionbunny = 1
		end
		if input:left() then
			moverIzq()
			direccionbunny = 2
		end
		if input:up() and salta == 0 then
			fuerzaVertical = 21
			salta = 1
		end
		if salta == 1 then movVertical() end
		if posbunnyx < 0-bunny1_width then gameover = 1 end
		if gameover == 1 then--game over
			System.sleep(1)
			screen:print(300-34,35,"Your Distance:",Color.new(0,0,0))
			screen:print(300-string.len(scoreD)*4,45,scoreD,Color.new(0,0,0))
			screen:print(300-40,60,"Highscore in Distance:",Color.new(0,0,0))
			screen:print(300-string.len(highscoreDist)*4,75,highscoreDist,Color.new(0,0,0))
			if scoreD > highscoreDist then
				screen:print(300-28,90,"New Highscore!",Color.new(0,0,0))
			end
			screen:print(300-55,110,"Press [] to Play Again",Color.new(0,0,0))
			screen:drawLine(300-4,110,302,110,Color.new(0,0,0))
			screen:drawLine(300-4,116,302,116,Color.new(0,0,0))
			if input:square() then if scoreD > highscoreDist then highscoreDist = scoreD; end init() end
		end
		screen:print(1,1,scoreD,Color.new(0,0,0))
		screen:print(1,10,scoreK,Color.new(0,0,0))
		screen.waitVblankStart()
		screen.flip()
	--end
	--if pause == 1 then
	--	screen:print(230,90,"PAUSE",Color.new(255,0,0)) --dibuja "pause"
	--	screen.waitVblankStart()
	--	screen.flip()
	--	input3= Controls.read() --control de botones
	--	if input3:start() then pause = 0 end --comprueba si start es pulsado y sale del bucle
	--	if input3:select() then dofile("/psp/game/CBMLminiGames/Applications/system.lua") end --salir del juego al menu principal
	--end
end
