;programa que carga una pantalla en SC2 para probar y ver pantallas como herramienta auxiliar
;usa 3 ficheros de datos
;mapa de los 3 bancos
;colores y patrones de un banco que se repite en los otros 2
;se modificará según necesidades

			OUTPUT 			"cargapantallaplet.rom"
		
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
			CALL			depack_VRAM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL
			CALL			depack_VRAM
			;cargando banco 1
			;cargamos los patrones
			LD				HL, tiles_patrones
			LD				DE, CHRTBL + #0800
			CALL			depack_VRAM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL + #0800
			CALL			depack_VRAM
			;cargando banco 2
			;cargamos los patrones
			LD				HL, tiles_patrones
			LD				DE, CHRTBL + #1000
			CALL			depack_VRAM
			;cargamos los colores de los patrones
			LD				HL, tiles_color
			LD				DE, CLRTBL + #1000
			CALL			depack_VRAM
			
			;CARGAMOS MAPA (EN ESTE CASO EN LOS 3 BANCOS)
			LD				HL, tiles_mapa
			LD				DE, TILMAP			;destino en vram
			CALL			depack_VRAM
			
			;ESPERA A QUE SE PULSE UNA TECLA
			CALL			CHGET
			
			;RETORNA AL BASIC
			RET		
;END: (main)
		
		
;dejo esto por si me interesa cambiar color de fondo para que parezca más
;al resultado final
color_pantalla:
			XOR		 		 A					;color negro
			LD				(FORCLR), A
			LD				(BAKCLR), A
			LD				(BDRCLR), A
			JP				CHGCLR
;fin_color_pantalla_negro:
	

tiles_patrones:				incbin "prueba.bin.plet5.til"
tiles_color:				incbin "prueba.bin.plet5.col"
tiles_mapa:					incbin "prueba.map.bin.plet5"


;;=====================================================
;;DEFINICIÓN DE SUBRUTINAS DE FERNANDO PARA COMPRESIÓN
;;=====================================================
;Este include lleva la rutina de descompresión de ROM/RAM a VRAM de pletter
;Está adaptada de la original a sjasm
;	HL = RAM/ROM source	; DE = VRAM destination
depack_VRAM:
	include "PL_VRAM_Depack_SJASM.asm"

