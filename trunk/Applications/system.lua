--	Can't Believe my Luck - Sports!		Menu
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

--Fondo
background = background or Image.load("/psp/game/CBMLminiGames/Applications/cbmlsMenu.png")

--[[
baseball = Image.createEmpty(315,34)
baseball:clear(Color.new(255,255,255))]]
baseball = baseball or Image.load("/psp/game/CBMLminiGames/Applications/baseball.png")
baseball_width = baseball:width()
baseball_height = baseball:height()
--[[
bowling = Image.createEmpty(315,34)
bowling:clear(Color.new(255,255,255))]]
bowling = bowling or Image.load("/psp/game/CBMLminiGames/Applications/bowling.png")
bowling_width = bowling:width()
bowling_height = bowling:height()
--[[
killbunny = Image.createEmpty(315,34)
killbunny:clear(Color.new(255,255,255))]]
killbunny = killbunny or Image.load("/psp/game/CBMLminiGames/Applications/killbunny.png")
killbunny_width = killbunny:width()
killbunny_height = killbunny:height()


--Variables
indice = 1 --es la posicion en la lista del juego que mostramos por pantalla
games = {"/psp/game/CBMLminiGames/Applications/Baseball/index.lua", "/psp/game/CBMLminiGames/Applications/Bowling/index.lua", "/psp/game/CBMLminiGames/Applications/KillBunny/index.lua"}
gamesIMG = {baseball, bowling, killbunny} --Aqui tenemos la lista de las imagenes de los juegos disponibles
numJuegos = # games --numero de juegos disponibles

function Atras()
	indice = indice - 1
	if indice <= 0 then indice = numJuegos end
	System.sleep(150)
end

function Adelante()
	indice = indice + 1
	if indice > numJuegos then indice = 1 end
	System.sleep(150)
end


while true do
	screen:blit(0,0,background)
	screen:blit(79,119,gamesIMG[indice])
	
	input = Controls.read()
	if input:start() then break end
	
	if input:l() then Atras() end
	if input:r() then Adelante() end
	
	if input:circle() then dofile(games[indice]) end
	
	screen.waitVblankStart()
	screen.flip()
end
