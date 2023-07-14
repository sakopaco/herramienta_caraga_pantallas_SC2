;programa que carga una pantalla en SC2 para probar y ver pantallas como herramienta auxiliar
;usa 3 ficheros de datos
;mapa de los 3 bancos
;colores y patrones de un banco que se repite en los otros 2
;se modificará según necesidades

			OUTPUT 			"cargapantalla.rom"
		
;;CONSTANTES
;FUNCIONES BIOS
CHGET				equ		#009F	;espera a que se pulse una tecla
LDIRVM				equ		#005C	;RAM/ROM -> VRAM
SETGRP				equ		#007E	;cambia modo pantalla a SC2
CHGCLR  			equ		#0062	;cambia color de pantalla (toca A y direcciones)
FORCLR				equ		#F3E9	;zona memoria color foreground
BAKCLR  			equ		#F3EA	;zona memoria color background
BDRCLR 				equ		#F3EB	;zona memoria bordercolor

;MAPA VDP
CHRTBL				equ		#0000
TILMAP				equ		#1800
CLRTBL				equ		#2000

			
;;INICIO ROM		
			ORG				#4000


;;CABECERA FICHERO ROM
			DB 				"AB" ;#41,#42 Identificador de rom
			DW 				START,0,0,0,0,0,0  ;Inicio codigo. Puede ser qualquier dirección

		
START:		
			CALL			SETGRP

			;cargando banco 0
			;cargamos los patrones
			LD				HL, tiles_patrones
			LD				DE, CHRTBL
			LD				BC, 2048
			CALL			LDIRVM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL
			LD				BC, 2048
			CALL			LDIRVM
			;cargando banco 1
			;cargamos los patrones
			LD				HL, tiles_patrones
			LD				DE, CHRTBL + #0800
			LD				BC, 2048
			CALL			LDIRVM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL + #0800
			LD				BC, 2048
			CALL			LDIRVM
			;cargando banco 2
			;cargamos los patrones
			LD				HL, tiles_patrones
			LD				DE, CHRTBL + #1000
			LD				BC, 2048
			CALL			LDIRVM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL + #1000
			LD				BC, 2048
			CALL			LDIRVM
			
			;CARGAMOS MAPA (EN ESTE CASO EN LOS 3 BANCOS)
			LD				HL, tiles_mapa
			LD				DE, TILMAP			;destino en vram
			LD				BC, 768				;nº posiciones a pintar
			CALL			LDIRVM
			
			;ESPERA A QUE SE PULSE UNA TECLA
			CALL			CHGET
			
			;RETORNA AL BASIC
			RET		
END:		
		
		
;dejo esto por si me interesa cambiar color de fondo para que parezca más
;al resultado final
color_pantalla:
			XOR		 		 A					;color negro
			LD				(FORCLR), A
			LD				(BAKCLR), A
			LD				(BDRCLR), A
			JP				CHGCLR
;fin_color_pantalla_negro:
	

tiles_patrones:				incbin "prueba.til.bin"
tiles_color:				incbin "prueba.col.bin"
tiles_mapa:					incbin "prueba.map.todo.bin"

