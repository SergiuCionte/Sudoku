.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 640
area_height EQU 480
area DD 0

culoare EQU 0FFFFFFh
counter DD 0 ; numara evenimentele de tip timer
poz_x dd 110
poz_y dd 100
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

matrix dd 5,3,0,0,7,0,0,0,0
	   dd 6,0,0,1,9,5,0,0,0
	   dd 0,9,8,0,0,0,0,6,0
	   dd 8,0,0,0,6,0,0,0,3
	   dd 4,0,0,8,0,3,0,0,1
	   dd 7,0,0,0,2,0,0,0,6
	   dd 0,6,0,0,0,0,2,8,0
	   dd 0,0,0,4,1,9,0,0,5
	   dd 0,0,0,0,8,0,0,7,9

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], culoare-000FFFFh
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], culoare
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_text1 proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], culoare-0FFFFFFh
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], culoare
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text1 endp

make_text2 proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], culoare-0F001F2h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], culoare
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text2 endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_text_macro1 macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text1
	add esp, 16
endm
make_text_macro2 macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text2
	add esp, 16
endm
; un macro ca sa apelam mai usor desenarea simbolului


;make_line proc
;push ebp
;mov ebp,esp
;pusha

;mov eax,[ebp+8]
;mov ebx,area_width
;mul ebx
;add eax,[ebp+12]
;shl eax,2
;add eax,area
;mov ecx,200
;bucla_linie:
;mov dword ptr[eax],0FFFFFFh
;add eax,4
;loop bucla_linie

;popa
;mov esp,ebp
;pop ebp
;ret
;make_line endp

;make_line_macro macro lungime,drawArea,x,y
;push y
;push x
;push drawArea
;push lungime
;call make_line
;add esp,16
;endm 
;make_line_macro  200,area,100,150



line_horizontal macro x,y,color
local bucla_line
mov eax,y
mov ebx,area_width
mul ebx
add eax,x
shl eax,2
add eax,area
mov ecx,180
bucla_line:
mov dword ptr[eax],color
add eax,4
loop bucla_line
endm

line_vertical macro x,y,color
local bucla_line
mov eax,y
mov ebx,area_width
mul ebx
add eax,x
shl eax,2
add eax,area
mov ecx,180
bucla_line:
mov dword ptr[eax],color
add eax,area_width*4
loop bucla_line
endm



; un macro ca sa apelam mai usor desenarea liniei

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	


	
evt_timer:
	inc counter
	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 30
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 30
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 30
	;text
	make_text_macro 'S', area, 10, 10
	make_text_macro 'C', area, 20, 10
	make_text_macro 'O', area, 30, 10
	make_text_macro 'R', area, 40, 10
	make_text_macro 'E', area, 50, 10

	;titlu
	make_text_macro 'S', area, 400, 160
	make_text_macro 'U', area, 420, 160
	make_text_macro 'D', area, 440, 160
	make_text_macro 'O', area, 460, 160
	make_text_macro 'K', area, 480, 160
	make_text_macro 'U', area, 500, 160


	
	;scriem un mesaj


	
	mov eax,matrix[4*0]
	add eax,'0'	
	make_text_macro eax, area, 110, 100
	
	

	mov eax,matrix[4*1]
	add eax,'0'
	make_text_macro eax,area,130,100	


	
	

	
		mov eax,matrix[4*4]
	add eax,'0'
	make_text_macro eax,area,190,100	
	
	
	

	

	
	
	
		mov eax,matrix[4*1+(4*8*1)]
	add eax,'0'
	make_text_macro eax,area,110,120	
	


	

	mov eax,matrix[4*4+(4*8*1)]
	add eax,'0'
	make_text_macro eax,area,170,120	

	mov eax,matrix[4*5+(4*8*1)]
	add eax,'0'
	make_text_macro eax,area,190,120	

	mov eax,matrix[4*6+(4*8*1)]
	add eax,'0'
	make_text_macro eax,area,210,120	



	




	mov eax,matrix[4*3+(4*8*2)]
	add eax,'0'
	make_text_macro eax,area,130,140	

	mov eax,matrix[4*4+(4*8*2)]
	add eax,'0'
	make_text_macro eax,area,150,140	

	

	
	

	
		mov eax,matrix[4*1+(4*8*3)]
	add eax,'0'
	make_text_macro eax,area,250,140	
	

	
		mov eax,matrix[4*3+(4*8*3)]
	add eax,'0'
	make_text_macro eax,area,110,160
	

	
		mov eax,matrix[4*7+(4*8*3)]
	add eax,'0'
	make_text_macro eax,area,190,160
	

	
		mov eax,matrix[140]
	add eax,'0'
	make_text_macro eax,area,270,160

	mov eax,matrix[144]
	add eax,'0'
	make_text_macro eax,area,110,180	



	mov eax,matrix[156]
	add eax,'0'
	make_text_macro eax,area,170,180

	
	
		mov eax,matrix[164]
	add eax,'0'
	make_text_macro eax,area,210,180



	mov eax,matrix[176]
	add eax,'0'
	make_text_macro eax,area,270,180

	mov eax,matrix[180]
	add eax,'0'
	make_text_macro eax,area,110,200



	mov eax,matrix[196]
	add eax,'0'
	make_text_macro eax,area,190,200


	
		mov eax,matrix[212]
	add eax,'0'
	make_text_macro eax,area,270,200
	
	
	mov eax,matrix[220]
	add eax,'0'
	make_text_macro eax,area,130,220


	
		mov eax,matrix[240]
	add eax,'0'
	make_text_macro eax,area,230,220

	mov eax,matrix[244]
	add eax,'0'
	make_text_macro eax,area,250,220
	

	


	mov eax,matrix[264]
	add eax,'0'
	make_text_macro eax,area,170,240

	mov eax,matrix[268]
	add eax,'0'
	make_text_macro eax,area,190,240

	mov eax,matrix[272]
	add eax,'0'
	make_text_macro eax,area,210,240



	mov eax,matrix[284]
	add eax,'0'
	make_text_macro eax,area,270,240


	
		mov eax,matrix[304]
	add eax,'0'
	make_text_macro eax,area,190,260


	
		mov eax,matrix[316]
	add eax,'0'
	make_text_macro eax,area,250,260	
	
		mov eax,matrix[320]
	add eax,'0'
	make_text_macro eax,area,270,260
	
	


	evt_click:
mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat
cmp eax,150+20
jg nu_este_in_patrat
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat
cmp eax,100+20
jg nu_este_in_patrat
mov eax,matrix[8]
verificare:
add eax,1
cmp eax,matrix[0]
je verificare
cmp eax,matrix[4]
je verificare
cmp eax,matrix[12]
je verificare
cmp eax,matrix[16]
je verificare
cmp eax,matrix[20]
je verificare
cmp eax,matrix[24]
je verificare
cmp eax,matrix[28]
je verificare
cmp eax,matrix[32]
je verificare
cmp eax,matrix[8+9*1*4]
je verificare
cmp eax,matrix[8+9*2*4]
je verificare
cmp eax,matrix[8+9*3*4]
je verificare
cmp eax,matrix[8+9*4*4]
je verificare
cmp eax,matrix[8+9*5*4]
je verificare
cmp eax,matrix[8+9*6*4]
je verificare
cmp eax,matrix[8+9*7*4]
je verificare
cmp eax,matrix[8+9*8*4]
je verificare
cmp eax,matrix[36]
je verificare
cmp eax,matrix[40]
je verificare
cmp eax,matrix[72]
je verificare
cmp eax,matrix[76]
je verificare
mov matrix[8],eax
add eax,'0'
make_text_macro1 eax,area,150,100


nu_este_in_patrat:




mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat1
cmp eax,170+20
jg nu_este_in_patrat1
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat1
cmp eax,100+20
jg nu_este_in_patrat1
mov eax,matrix[12]
verificare1:
add eax,1
cmp eax,matrix[0]
je verificare1
cmp eax,matrix[4]
je verificare1
cmp eax,matrix[8]
je verificare1
cmp eax,matrix[16]
je verificare1
cmp eax,matrix[20]
je verificare1
cmp eax,matrix[24]
je verificare1
cmp eax,matrix[28]
je verificare1
cmp eax,matrix[32]
je verificare1
cmp eax,matrix[12+9*1*4]
je verificare1
cmp eax,matrix[12+9*2*4]
je verificare1
cmp eax,matrix[12+9*3*4]
je verificare1
cmp eax,matrix[12+9*4*4]
je verificare1
cmp eax,matrix[12+9*5*4]
je verificare1
cmp eax,matrix[12+9*6*4]
je verificare1
cmp eax,matrix[12+9*7*4]
je verificare1
cmp eax,matrix[12+9*8*4]
je verificare1
cmp eax,matrix[52]
je verificare1
cmp eax,matrix[54]
je verificare1
cmp eax,matrix[88]
je verificare1
cmp eax,matrix[92]
je verificare1

mov matrix[12],eax
add eax,'0'
make_text_macro1 eax,area,170,100


nu_este_in_patrat1:


mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat2
cmp eax,210+20
jg nu_este_in_patrat2
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat2
cmp eax,100+20
jg nu_este_in_patrat2
mov eax,matrix[20]
verificare2:
add eax,1
cmp eax,matrix[0]
je verificare2
cmp eax,matrix[4]
je verificare2
cmp eax,matrix[8]
je verificare2
cmp eax,matrix[12]
je verificare2
cmp eax,matrix[16]
je verificare2
cmp eax,matrix[24]
je verificare2
cmp eax,matrix[28]
je verificare2
cmp eax,matrix[32]
je verificare2
cmp eax,matrix[20+9*1*4]
je verificare2
cmp eax,matrix[20+9*2*4]
je verificare2
cmp eax,matrix[20+9*3*4]
je verificare2
cmp eax,matrix[20+9*4*4]
je verificare2
cmp eax,matrix[20+9*5*4]
je verificare2
cmp eax,matrix[20+9*6*4]
je verificare2
cmp eax,matrix[20+9*7*4]
je verificare2
cmp eax,matrix[20+9*8*4]
je verificare2
cmp eax,matrix[52]
je verificare2
cmp eax,matrix[48]
je verificare2
cmp eax,matrix[84]
je verificare2
cmp eax,matrix[88]
je verificare2

mov matrix[20],eax

add eax,'0'
make_text_macro1 eax,area,210,100


nu_este_in_patrat2:


mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat3
cmp eax,230+20
jg nu_este_in_patrat3
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat3
cmp eax,100+20
jg nu_este_in_patrat3
mov eax,matrix[24]
verificare3:
add eax,1
cmp eax,matrix[0]
je verificare3
cmp eax,matrix[4]
je verificare3
cmp eax,matrix[8]
je verificare3
cmp eax,matrix[12]
je verificare3
cmp eax,matrix[16]
je verificare3
cmp eax,matrix[20]
je verificare3
cmp eax,matrix[28]
je verificare3
cmp eax,matrix[32]
je verificare3
cmp eax,matrix[24+9*1*4]
je verificare3
cmp eax,matrix[24+9*2*4]
je verificare3
cmp eax,matrix[24+9*3*4]
je verificare3
cmp eax,matrix[24+9*4*4]
je verificare3
cmp eax,matrix[24+9*5*4]
je verificare3
cmp eax,matrix[24+9*6*4]
je verificare3
cmp eax,matrix[24+9*7*4]
je verificare3
cmp eax,matrix[24+9*8*4]
je verificare3
cmp eax,matrix[64]
je verificare3
cmp eax,matrix[68]
je verificare3
cmp eax,matrix[104]
je verificare3
cmp eax,matrix[100]
je verificare3

mov matrix[24],eax

add eax,'0'
make_text_macro1 eax,area,230,100

nu_este_in_patrat3:

mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat4
cmp eax,250+20
jg nu_este_in_patrat4
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat4
cmp eax,100+20
jg nu_este_in_patrat4
mov eax,matrix[28]
verificare4:
add eax,1
cmp eax,matrix[0]
je verificare4
cmp eax,matrix[4]
je verificare4
cmp eax,matrix[8]
je verificare4
cmp eax,matrix[12]
je verificare4
cmp eax,matrix[16]
je verificare4
cmp eax,matrix[20]
je verificare4
cmp eax,matrix[24]
je verificare4
cmp eax,matrix[32]
je verificare4
cmp eax,matrix[28+9*1*4]
je verificare4
cmp eax,matrix[28+9*2*4]
je verificare4
cmp eax,matrix[28+9*3*4]
je verificare4
cmp eax,matrix[28+9*4*4]
je verificare4
cmp eax,matrix[28+9*5*4]
je verificare4
cmp eax,matrix[28+9*6*4]
je verificare4
cmp eax,matrix[28+9*7*4]
je verificare4
cmp eax,matrix[28+9*8*4]
je verificare4
cmp eax,matrix[68]
je verificare4
cmp eax,matrix[60]
je verificare4
cmp eax,matrix[96]
je verificare4
cmp eax,matrix[108]
je verificare4

mov matrix[28],eax

add eax,'0'
make_text_macro1 eax,area,250,100

nu_este_in_patrat4:

mov eax,[ebp+arg2]
cmp eax,270
jl nu_este_in_patrat5
cmp eax,270+20
jg nu_este_in_patrat5
mov eax,[ebp+arg3]
cmp eax,100
jl nu_este_in_patrat5
cmp eax,100+20
jg nu_este_in_patrat5
mov eax,matrix[32]
verificare5:
add eax,1
cmp eax,matrix[0]
je verificare5
cmp eax,matrix[4]
je verificare5
cmp eax,matrix[8]
je verificare5
cmp eax,matrix[12]
je verificare5
cmp eax,matrix[16]
je verificare5
cmp eax,matrix[20]
je verificare5
cmp eax,matrix[24]
je verificare5
cmp eax,matrix[28]
je verificare5
cmp eax,matrix[32+9*1*4]
je verificare5
cmp eax,matrix[32+9*2*4]
je verificare5
cmp eax,matrix[32+9*3*4]
je verificare5
cmp eax,matrix[32+9*4*4]
je verificare5
cmp eax,matrix[32+9*5*4]
je verificare5
cmp eax,matrix[32+9*6*4]
je verificare5
cmp eax,matrix[32+9*7*4]
je verificare5
cmp eax,matrix[32+9*8*4]
je verificare5
cmp eax,matrix[60]
je verificare5
cmp eax,matrix[64]
je verificare5
cmp eax,matrix[96]
je verificare5
cmp eax,matrix[100]
je verificare5

mov matrix[32],eax

add eax,'0'
make_text_macro1 eax,area,270,100

nu_este_in_patrat5:
	
	

mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat6
cmp eax,130+20
jg nu_este_in_patrat6
mov eax,[ebp+arg3]
cmp eax,120
jl nu_este_in_patrat6
cmp eax,120+20
jg nu_este_in_patrat6
mov eax,matrix[40]
verificare6:
add eax,1
cmp eax,matrix[36]
je verificare6
cmp eax,matrix[44]
je verificare6
cmp eax,matrix[48]
je verificare6
cmp eax,matrix[52]
je verificare6
cmp eax,matrix[56]
je verificare6
cmp eax,matrix[60]
je verificare6
cmp eax,matrix[64]
je verificare6
cmp eax,matrix[68]
je verificare6
cmp eax,matrix[40-9*1*4]
je verificare6
cmp eax,matrix[40+9*1*4]
je verificare6
cmp eax,matrix[40+9*2*4]
je verificare6
cmp eax,matrix[40+9*3*4]
je verificare6
cmp eax,matrix[40+9*4*4]
je verificare6
cmp eax,matrix[40+9*5*4]
je verificare6
cmp eax,matrix[40+9*6*4]
je verificare6
cmp eax,matrix[40+9*7*4]
je verificare6
cmp eax,matrix[0]
je verificare6
cmp eax,matrix[12]
je verificare6
cmp eax,matrix[72]
je verificare6
cmp eax,matrix[80]
je verificare6

mov matrix[40],eax

add eax,'0'
make_text_macro1 eax,area,130,120

nu_este_in_patrat6:



mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat7
cmp eax,150+20
jg nu_este_in_patrat7
mov eax,[ebp+arg3]
cmp eax,120
jl nu_este_in_patrat7
cmp eax,120+20
jg nu_este_in_patrat7
mov eax,matrix[44]
verificare7:
add eax,1
cmp eax,matrix[36]
je verificare7
cmp eax,matrix[40]
je verificare7
cmp eax,matrix[48]
je verificare7
cmp eax,matrix[52]
je verificare7
cmp eax,matrix[56]
je verificare7
cmp eax,matrix[60]
je verificare7
cmp eax,matrix[64]
je verificare7
cmp eax,matrix[68]
je verificare7
cmp eax,matrix[44-9*1*4]
je verificare7
cmp eax,matrix[44+9*1*4]
je verificare7
cmp eax,matrix[44+9*2*4]
je verificare7
cmp eax,matrix[44+9*3*4]
je verificare7
cmp eax,matrix[44+9*4*4]
je verificare7
cmp eax,matrix[44+9*5*4]
je verificare7
cmp eax,matrix[44+9*6*4]
je verificare7
cmp eax,matrix[44+9*7*4]
je verificare7
cmp eax,matrix[0]
je verificare7
cmp eax,matrix[4]
je verificare7
cmp eax,matrix[72]
je verificare7
cmp eax,matrix[76]
je verificare7

mov matrix[44],eax

add eax,'0'
make_text_macro1 eax,area,150,120

nu_este_in_patrat7:

mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat8
cmp eax,230+20
jg nu_este_in_patrat8
mov eax,[ebp+arg3]
cmp eax,120
jl nu_este_in_patrat8
cmp eax,120+20
jg nu_este_in_patrat8
mov eax,matrix[60]
verificare8:
add eax,1
cmp eax,matrix[36]
je verificare8
cmp eax,matrix[40]
je verificare8
cmp eax,matrix[44]
je verificare8
cmp eax,matrix[48]
je verificare8
cmp eax,matrix[52]
je verificare8
cmp eax,matrix[56]
je verificare8
cmp eax,matrix[64]
je verificare8
cmp eax,matrix[68]
je verificare8
cmp eax,matrix[60-9*1*4]
je verificare8
cmp eax,matrix[60+9*1*4]
je verificare8
cmp eax,matrix[60+9*2*4]
je verificare8
cmp eax,matrix[60+9*3*4]
je verificare8
cmp eax,matrix[60+9*4*4]
je verificare8
cmp eax,matrix[60+9*5*4]
je verificare8
cmp eax,matrix[60+9*6*4]
je verificare8
cmp eax,matrix[60+9*7*4]
je verificare8
cmp eax,matrix[28]
je verificare8
cmp eax,matrix[32]
je verificare8
cmp eax,matrix[64]
je verificare8
cmp eax,matrix[68]
je verificare8

mov matrix[60],eax

add eax,'0'
make_text_macro1 eax,area,230,120

nu_este_in_patrat8:


mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat9
cmp eax,250+20
jg nu_este_in_patrat9
mov eax,[ebp+arg3]
cmp eax,120
jl nu_este_in_patrat9
cmp eax,120+20
jg nu_este_in_patrat9
mov eax,matrix[64]
verificare9:
add eax,1
cmp eax,matrix[36]
je verificare9
cmp eax,matrix[40]
je verificare9
cmp eax,matrix[44]
je verificare9
cmp eax,matrix[48]
je verificare9
cmp eax,matrix[52]
je verificare9
cmp eax,matrix[56]
je verificare9
cmp eax,matrix[60]
je verificare9
cmp eax,matrix[68]
je verificare9
cmp eax,matrix[64-9*1*4]
je verificare9
cmp eax,matrix[64+9*1*4]
je verificare9
cmp eax,matrix[64+9*2*4]
je verificare9
cmp eax,matrix[64+9*3*4]
je verificare9
cmp eax,matrix[64+9*4*4]
je verificare9
cmp eax,matrix[64+9*5*4]
je verificare9
cmp eax,matrix[64+9*6*4]
je verificare9
cmp eax,matrix[64+9*7*4]
je verificare9
cmp eax,matrix[24]
je verificare9
cmp eax,matrix[32]
je verificare9
cmp eax,matrix[96]
je verificare9
cmp eax,matrix[104]
je verificare9

mov matrix[64],eax

add eax,'0'
make_text_macro1 eax,area,250,120






nu_este_in_patrat9:


mov eax,[ebp+arg2]
cmp eax,270
jl nu_este_in_patrat10
cmp eax,270+20
jg nu_este_in_patrat10
mov eax,[ebp+arg3]
cmp eax,120
jl nu_este_in_patrat10
cmp eax,120+20
jg nu_este_in_patrat10
mov eax,matrix[68]
verificare10:
add eax,1
cmp eax,matrix[36]
je verificare10
cmp eax,matrix[40]
je verificare10
cmp eax,matrix[44]
je verificare10
cmp eax,matrix[48]
je verificare10
cmp eax,matrix[52]
je verificare10
cmp eax,matrix[56]
je verificare10
cmp eax,matrix[60]
je verificare10
cmp eax,matrix[64]
je verificare10
cmp eax,matrix[68-9*1*4]
je verificare10
cmp eax,matrix[68+9*1*4]
je verificare10
cmp eax,matrix[68+9*2*4]
je verificare10
cmp eax,matrix[68+9*3*4]
je verificare10
cmp eax,matrix[68+9*4*4]
je verificare10
cmp eax,matrix[68+9*5*4]
je verificare10
cmp eax,matrix[68+9*6*4]
je verificare10
cmp eax,matrix[68+9*7*4]
je verificare10
cmp eax,matrix[24]
je verificare10
cmp eax,matrix[32]
je verificare10
cmp eax,matrix[96]
je verificare10
cmp eax,matrix[104]
je verificare10

mov matrix[68],eax

add eax,'0'
make_text_macro1 eax,area,270,120

nu_este_in_patrat10:	




mov eax,[ebp+arg2]
cmp eax,110
jl nu_este_in_patrat11
cmp eax,110+20
jg nu_este_in_patrat11
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat11
cmp eax,140+20
jg nu_este_in_patrat11
mov eax,matrix[72]
verificare11:
add eax,1
cmp eax,matrix[76]
je verificare11
cmp eax,matrix[80]
je verificare11
cmp eax,matrix[84]
je verificare11
cmp eax,matrix[88]
je verificare11
cmp eax,matrix[92]
je verificare11
cmp eax,matrix[96]
je verificare11
cmp eax,matrix[100]
je verificare11
cmp eax,matrix[104]
je verificare11
cmp eax,matrix[72-9*1*4]
je verificare11
cmp eax,matrix[72-9*2*4]
je verificare11
cmp eax,matrix[72+9*1*4]
je verificare11
cmp eax,matrix[72+9*2*4]
je verificare11
cmp eax,matrix[72+9*3*4]
je verificare11
cmp eax,matrix[72+9*4*4]
je verificare11
cmp eax,matrix[72+9*5*4]
je verificare11
cmp eax,matrix[72+9*6*4]
je verificare11
cmp eax,matrix[4]
je verificare11
cmp eax,matrix[8]
je verificare11
cmp eax,matrix[40]
je verificare11
cmp eax,matrix[44]
je verificare11

mov matrix[72],eax

add eax,'0'
make_text_macro1 eax,area,110,140

nu_este_in_patrat11:

mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat12
cmp eax,170+20
jg nu_este_in_patrat12
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat12
cmp eax,140+20
jg nu_este_in_patrat12
mov eax,matrix[84]
verificare12:
add eax,1
cmp eax,matrix[72]
je verificare12
cmp eax,matrix[76]
je verificare12
cmp eax,matrix[80]
je verificare12
cmp eax,matrix[88]
je verificare12
cmp eax,matrix[92]
je verificare12
cmp eax,matrix[96]
je verificare12
cmp eax,matrix[100]
je verificare12
cmp eax,matrix[104]
je verificare12
cmp eax,matrix[84-9*1*4]
je verificare12
cmp eax,matrix[84-9*2*4]
je verificare12
cmp eax,matrix[84+9*1*4]
je verificare12
cmp eax,matrix[84+9*2*4]
je verificare12
cmp eax,matrix[84+9*3*4]
je verificare12
cmp eax,matrix[84+9*4*4]
je verificare12
cmp eax,matrix[84+9*5*4]
je verificare12
cmp eax,matrix[84+9*6*4]
je verificare12
cmp eax,matrix[16]
je verificare12
cmp eax,matrix[20]
je verificare12
cmp eax,matrix[52]
je verificare12
cmp eax,matrix[56]
je verificare12

mov matrix[84],eax

add eax,'0'
make_text_macro1 eax,area,170,140

nu_este_in_patrat12:

mov eax,[ebp+arg2]
cmp eax,190
jl nu_este_in_patrat13
cmp eax,190+20
jg nu_este_in_patrat13
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat13
cmp eax,140+20
jg nu_este_in_patrat13
mov eax,matrix[88]
verificare13:
add eax,1
cmp eax,matrix[72]
je verificare13
cmp eax,matrix[76]
je verificare13
cmp eax,matrix[80]
je verificare13
cmp eax,matrix[84]
je verificare13
cmp eax,matrix[92]
je verificare13
cmp eax,matrix[96]
je verificare13
cmp eax,matrix[100]
je verificare13
cmp eax,matrix[104]
je verificare13
cmp eax,matrix[88-9*1*4]
je verificare13
cmp eax,matrix[88-9*2*4]
je verificare13
cmp eax,matrix[88+9*1*4]
je verificare13
cmp eax,matrix[88+9*2*4]
je verificare13
cmp eax,matrix[88+9*3*4]
je verificare13
cmp eax,matrix[88+9*4*4]
je verificare13
cmp eax,matrix[88+9*5*4]
je verificare13
cmp eax,matrix[88+9*6*4]
je verificare13
cmp eax,matrix[12]
je verificare13
cmp eax,matrix[20]
je verificare13
cmp eax,matrix[48]
je verificare13
cmp eax,matrix[56]
je verificare13

mov matrix[88],eax

add eax,'0'
make_text_macro1 eax,area,190,140

nu_este_in_patrat13:

mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat14
cmp eax,210+20
jg nu_este_in_patrat14
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat14
cmp eax,140+20
jg nu_este_in_patrat14
mov eax,matrix[92]
verificare14:
add eax,1
cmp eax,matrix[72]
je verificare14
cmp eax,matrix[76]
je verificare14
cmp eax,matrix[80]
je verificare14
cmp eax,matrix[84]
je verificare14
cmp eax,matrix[88]
je verificare14
cmp eax,matrix[96]
je verificare14
cmp eax,matrix[100]
je verificare14
cmp eax,matrix[104]
je verificare14
cmp eax,matrix[92-9*1*4]
je verificare14
cmp eax,matrix[92-9*2*4]
je verificare14
cmp eax,matrix[92+9*1*4]
je verificare14
cmp eax,matrix[92+9*2*4]
je verificare14
cmp eax,matrix[92+9*3*4]
je verificare14
cmp eax,matrix[92+9*4*4]
je verificare14
cmp eax,matrix[92+9*5*4]
je verificare14
cmp eax,matrix[92+9*6*4]
je verificare14
cmp eax,matrix[12]
je verificare14
cmp eax,matrix[16]
je verificare14
cmp eax,matrix[48]
je verificare14
cmp eax,matrix[52]
je verificare14

mov matrix[92],eax

add eax,'0'
make_text_macro1 eax,area,210,140

nu_este_in_patrat14:

mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat15
cmp eax,230+20
jg nu_este_in_patrat15
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat15
cmp eax,140+20
jg nu_este_in_patrat15
mov eax,matrix[96]
verificare15:
add eax,1
cmp eax,matrix[72]
je verificare15
cmp eax,matrix[76]
je verificare15
cmp eax,matrix[80]
je verificare15
cmp eax,matrix[84]
je verificare15
cmp eax,matrix[88]
je verificare15
cmp eax,matrix[92]
je verificare15
cmp eax,matrix[100]
je verificare15
cmp eax,matrix[104]
je verificare15
cmp eax,matrix[96-9*1*4]
je verificare15
cmp eax,matrix[96-9*2*4]
je verificare15
cmp eax,matrix[96+9*1*4]
je verificare15
cmp eax,matrix[96+9*2*4]
je verificare15
cmp eax,matrix[96+9*3*4]
je verificare15
cmp eax,matrix[96+9*4*4]
je verificare15
cmp eax,matrix[96+9*5*4]
je verificare15
cmp eax,matrix[96+9*6*4]
je verificare15
cmp eax,matrix[28]
je verificare15
cmp eax,matrix[32]
je verificare15
cmp eax,matrix[64]
je verificare15
cmp eax,matrix[68]
je verificare15

mov matrix[96],eax

add eax,'0'
make_text_macro1 eax,area,230,140

nu_este_in_patrat15:

mov eax,[ebp+arg2]
cmp eax,270
jl nu_este_in_patrat16
cmp eax,270+20
jg nu_este_in_patrat16
mov eax,[ebp+arg3]
cmp eax,140
jl nu_este_in_patrat16
cmp eax,140+20
jg nu_este_in_patrat16
mov eax,matrix[104]
verificare16:
add eax,1
cmp eax,matrix[72]
je verificare16
cmp eax,matrix[76]
je verificare16
cmp eax,matrix[80]
je verificare16
cmp eax,matrix[84]
je verificare16
cmp eax,matrix[88]
je verificare16
cmp eax,matrix[92]
je verificare16
cmp eax,matrix[100]
je verificare16
cmp eax,matrix[104]
je verificare16
cmp eax,matrix[104-9*1*4]
je verificare16
cmp eax,matrix[104-9*2*4]
je verificare16
cmp eax,matrix[104+9*1*4]
je verificare16
cmp eax,matrix[104+9*2*4]
je verificare16
cmp eax,matrix[104+9*3*4]
je verificare16
cmp eax,matrix[104+9*4*4]
je verificare16
cmp eax,matrix[104+9*5*4]
je verificare16
cmp eax,matrix[104+9*6*4]
je verificare16
cmp eax,matrix[24]
je verificare16
cmp eax,matrix[28]
je verificare16
cmp eax,matrix[60]
je verificare16
cmp eax,matrix[64]
je verificare16

mov matrix[104],eax

add eax,'0'
make_text_macro1 eax,area,270,140

nu_este_in_patrat16:

mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat17
cmp eax,130+20
jg nu_este_in_patrat17
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat17
cmp eax,160+20
jg nu_este_in_patrat17
mov eax,matrix[112]
verificare17:
add eax,1
cmp eax,matrix[108]
je verificare17
cmp eax,matrix[116]
je verificare17
cmp eax,matrix[120]
je verificare17
cmp eax,matrix[124]
je verificare17
cmp eax,matrix[128]
je verificare17
cmp eax,matrix[132]
je verificare17
cmp eax,matrix[136]
je verificare17
cmp eax,matrix[140]
je verificare17
cmp eax,matrix[112-9*1*4]
je verificare17
cmp eax,matrix[112-9*2*4]
je verificare17
cmp eax,matrix[112-9*3*4]
je verificare17
cmp eax,matrix[112+9*1*4]
je verificare17
cmp eax,matrix[112+9*2*4]
je verificare17
cmp eax,matrix[112+9*3*4]
je verificare17
cmp eax,matrix[112+9*4*4]
je verificare17
cmp eax,matrix[112+9*5*4]
je verificare17
cmp eax,matrix[144]
je verificare17
cmp eax,matrix[180]
je verificare17
cmp eax,matrix[152]
je verificare17
cmp eax,matrix[188]
je verificare17

mov matrix[112],eax

add eax,'0'
make_text_macro1 eax,area,130,160

nu_este_in_patrat17:


mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat18
cmp eax,150+20
jg nu_este_in_patrat18
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat18
cmp eax,160+20
jg nu_este_in_patrat18
mov eax,matrix[116]
verificare18:
add eax,1
cmp eax,matrix[108]
je verificare18
cmp eax,matrix[112]
je verificare18
cmp eax,matrix[120]
je verificare18
cmp eax,matrix[124]
je verificare18
cmp eax,matrix[128]
je verificare18
cmp eax,matrix[132]
je verificare18
cmp eax,matrix[136]
je verificare18
cmp eax,matrix[140]
je verificare18
cmp eax,matrix[116-9*1*4]
je verificare18
cmp eax,matrix[116-9*2*4]
je verificare18
cmp eax,matrix[116-9*3*4]
je verificare18
cmp eax,matrix[116+9*1*4]
je verificare18
cmp eax,matrix[116+9*2*4]
je verificare18
cmp eax,matrix[116+9*3*4]
je verificare18
cmp eax,matrix[116+9*4*4]
je verificare18
cmp eax,matrix[116+9*5*4]
je verificare18
cmp eax,matrix[144]
je verificare18
cmp eax,matrix[180]
je verificare18
cmp eax,matrix[148]
je verificare18
cmp eax,matrix[184]
je verificare18

mov matrix[116],eax

add eax,'0'
make_text_macro1 eax,area,150,160

nu_este_in_patrat18:


mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat19
cmp eax,170+20
jg nu_este_in_patrat19
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat19
cmp eax,160+20
jg nu_este_in_patrat19
mov eax,matrix[120]
verificare19:
add eax,1
cmp eax,matrix[108]
je verificare19
cmp eax,matrix[112]
je verificare19
cmp eax,matrix[116]
je verificare19
cmp eax,matrix[124]
je verificare19
cmp eax,matrix[128]
je verificare19
cmp eax,matrix[132]
je verificare19
cmp eax,matrix[136]
je verificare19
cmp eax,matrix[140]
je verificare19
cmp eax,matrix[120-9*1*4]
je verificare19
cmp eax,matrix[120-9*2*4]
je verificare19
cmp eax,matrix[120-9*3*4]
je verificare19
cmp eax,matrix[120+9*1*4]
je verificare19
cmp eax,matrix[120+9*2*4]
je verificare19
cmp eax,matrix[120+9*3*4]
je verificare19
cmp eax,matrix[120+9*4*4]
je verificare19
cmp eax,matrix[120+9*5*4]
je verificare19
cmp eax,matrix[160]
je verificare19
cmp eax,matrix[164]
je verificare19
cmp eax,matrix[196]
je verificare19
cmp eax,matrix[200]
je verificare19

mov matrix[120],eax

add eax,'0'
make_text_macro1 eax,area,170,160

nu_este_in_patrat19:


mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat20
cmp eax,230+20
jg nu_este_in_patrat20
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat20
cmp eax,160+20
jg nu_este_in_patrat20
mov eax,matrix[132]
verificare20:
add eax,1
cmp eax,matrix[108]
je verificare20
cmp eax,matrix[112]
je verificare20
cmp eax,matrix[116]
je verificare20
cmp eax,matrix[120]
je verificare20
cmp eax,matrix[124]
je verificare20
cmp eax,matrix[128]
je verificare20
cmp eax,matrix[136]
je verificare20
cmp eax,matrix[140]
je verificare20
cmp eax,matrix[132-9*1*4]
je verificare20
cmp eax,matrix[132-9*2*4]
je verificare20
cmp eax,matrix[132-9*3*4]
je verificare20
cmp eax,matrix[132+9*1*4]
je verificare20
cmp eax,matrix[132+9*2*4]
je verificare20
cmp eax,matrix[132+9*3*4]
je verificare20
cmp eax,matrix[132+9*4*4]
je verificare20
cmp eax,matrix[132+9*5*4]
je verificare20
cmp eax,matrix[172]
je verificare20
cmp eax,matrix[176]
je verificare20
cmp eax,matrix[208]
je verificare20
cmp eax,matrix[212]
je verificare20

mov matrix[132],eax

add eax,'0'
make_text_macro1 eax,area,230,160

nu_este_in_patrat20:


mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat21
cmp eax,210+20
jg nu_este_in_patrat21
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat21
cmp eax,160+20
jg nu_este_in_patrat21
mov eax,matrix[128]
verificare21:
add eax,1
cmp eax,matrix[108]
je verificare21
cmp eax,matrix[112]
je verificare21
cmp eax,matrix[116]
je verificare21
cmp eax,matrix[120]
je verificare21
cmp eax,matrix[124]
je verificare21
cmp eax,matrix[132]
je verificare21
cmp eax,matrix[136]
je verificare21
cmp eax,matrix[140]
je verificare21
cmp eax,matrix[128-9*1*4]
je verificare21
cmp eax,matrix[128-9*2*4]
je verificare21
cmp eax,matrix[128-9*3*4]
je verificare21
cmp eax,matrix[128+9*1*4]
je verificare21
cmp eax,matrix[128+9*2*4]
je verificare21
cmp eax,matrix[128+9*3*4]
je verificare21
cmp eax,matrix[128+9*4*4]
je verificare21
cmp eax,matrix[128+9*5*4]
je verificare21
cmp eax,matrix[156]
je verificare21
cmp eax,matrix[160]
je verificare21
cmp eax,matrix[192]
je verificare21
cmp eax,matrix[196]
je verificare21

mov matrix[128],eax

add eax,'0'
make_text_macro1 eax,area,210,160

nu_este_in_patrat21:

mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat22
cmp eax,250+20
jg nu_este_in_patrat22
mov eax,[ebp+arg3]
cmp eax,160
jl nu_este_in_patrat22
cmp eax,160+20
jg nu_este_in_patrat22
mov eax,matrix[136]
verificare22:
add eax,1
cmp eax,matrix[108]
je verificare22
cmp eax,matrix[112]
je verificare22
cmp eax,matrix[116]
je verificare22
cmp eax,matrix[120]
je verificare22
cmp eax,matrix[124]
je verificare22
cmp eax,matrix[128]
je verificare22
cmp eax,matrix[132]
je verificare22
cmp eax,matrix[140]
je verificare22
cmp eax,matrix[136-9*1*4]
je verificare22
cmp eax,matrix[136-9*2*4]
je verificare22
cmp eax,matrix[136-9*3*4]
je verificare22
cmp eax,matrix[136+9*1*4]
je verificare22
cmp eax,matrix[136+9*2*4]
je verificare22
cmp eax,matrix[136+9*3*4]
je verificare22
cmp eax,matrix[136+9*4*4]
je verificare22
cmp eax,matrix[136+9*5*4]
je verificare22
cmp eax,matrix[168]
je verificare22
cmp eax,matrix[176]
je verificare22
cmp eax,matrix[204]
je verificare22
cmp eax,matrix[212]
je verificare22

mov matrix[136],eax

add eax,'0'
make_text_macro1 eax,area,250,160

nu_este_in_patrat22:

mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat23
cmp eax,130+20
jg nu_este_in_patrat23
mov eax,[ebp+arg3]
cmp eax,180
jl nu_este_in_patrat23
cmp eax,180+20
jg nu_este_in_patrat23
mov eax,matrix[148]
verificare23:
add eax,1
cmp eax,matrix[144]
je verificare23
cmp eax,matrix[152]
je verificare23
cmp eax,matrix[156]
je verificare23
cmp eax,matrix[160]
je verificare23
cmp eax,matrix[164]
je verificare23
cmp eax,matrix[168]
je verificare23
cmp eax,matrix[172]
je verificare23
cmp eax,matrix[176]
je verificare23
cmp eax,matrix[148-9*1*4]
je verificare23
cmp eax,matrix[148-9*2*4]
je verificare23
cmp eax,matrix[148-9*3*4]
je verificare23
cmp eax,matrix[148-9*4*4]
je verificare23
cmp eax,matrix[148+9*1*4]
je verificare23
cmp eax,matrix[148+9*2*4]
je verificare23
cmp eax,matrix[148+9*3*4]
je verificare23
cmp eax,matrix[148+9*4*4]
je verificare23
cmp eax,matrix[108]
je verificare23
cmp eax,matrix[116]
je verificare23
cmp eax,matrix[180]
je verificare23
cmp eax,matrix[188]
je verificare23

mov matrix[148],eax

add eax,'0'
make_text_macro1 eax,area,130,180

nu_este_in_patrat23:






mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat24
cmp eax,150+20
jg nu_este_in_patrat24
mov eax,[ebp+arg3]
cmp eax,180
jl nu_este_in_patrat24
cmp eax,180+20
jg nu_este_in_patrat24
mov eax,matrix[152]
verificare24:
add eax,1
cmp eax,matrix[144]
je verificare24
cmp eax,matrix[148]
je verificare24
cmp eax,matrix[156]
je verificare24
cmp eax,matrix[160]
je verificare24
cmp eax,matrix[164]
je verificare24
cmp eax,matrix[168]
je verificare24
cmp eax,matrix[172]
je verificare24
cmp eax,matrix[176]
je verificare24
cmp eax,matrix[152-9*1*4]
je verificare24
cmp eax,matrix[152-9*2*4]
je verificare24
cmp eax,matrix[152-9*3*4]
je verificare24
cmp eax,matrix[152-9*4*4]
je verificare24
cmp eax,matrix[152+9*1*4]
je verificare24
cmp eax,matrix[152+9*2*4]
je verificare24
cmp eax,matrix[152+9*3*4]
je verificare24
cmp eax,matrix[152+9*4*4]
je verificare24
cmp eax,matrix[108]
je verificare24
cmp eax,matrix[112]
je verificare24
cmp eax,matrix[180]
je verificare24
cmp eax,matrix[184]
je verificare24

mov matrix[152],eax

add eax,'0'
make_text_macro1 eax,area,150,180

nu_este_in_patrat24:



mov eax,[ebp+arg2]
cmp eax,190
jl nu_este_in_patrat25
cmp eax,190+20
jg nu_este_in_patrat25
mov eax,[ebp+arg3]
cmp eax,180
jl nu_este_in_patrat25
cmp eax,180+20
jg nu_este_in_patrat25
mov eax,matrix[160]
verificare25:
add eax,1
cmp eax,matrix[144]
je verificare25
cmp eax,matrix[148]
je verificare25
cmp eax,matrix[152]
je verificare25
cmp eax,matrix[156]
je verificare25
cmp eax,matrix[164]
je verificare25
cmp eax,matrix[168]
je verificare25
cmp eax,matrix[172]
je verificare25
cmp eax,matrix[176]
je verificare25
cmp eax,matrix[160-9*1*4]
je verificare25
cmp eax,matrix[160-9*2*4]
je verificare25
cmp eax,matrix[160-9*3*4]
je verificare25
cmp eax,matrix[160-9*4*4]
je verificare25
cmp eax,matrix[160+9*1*4]
je verificare25
cmp eax,matrix[160+9*2*4]
je verificare25
cmp eax,matrix[160+9*3*4]
je verificare25
cmp eax,matrix[160+9*4*4]
je verificare25
cmp eax,matrix[120]
je verificare25
cmp eax,matrix[128]
je verificare25
cmp eax,matrix[192]
je verificare25
cmp eax,matrix[200]
je verificare25

mov matrix[160],eax

add eax,'0'
make_text_macro1 eax,area,190,180

nu_este_in_patrat25:


mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat26
cmp eax,230+20
jg nu_este_in_patrat26
mov eax,[ebp+arg3]
cmp eax,180
jl nu_este_in_patrat26
cmp eax,180+20
jg nu_este_in_patrat26
mov eax,matrix[168]
verificare26:
add eax,1
cmp eax,matrix[144]
je verificare26
cmp eax,matrix[148]
je verificare26
cmp eax,matrix[152]
je verificare26
cmp eax,matrix[156]
je verificare26
cmp eax,matrix[160]
je verificare26
cmp eax,matrix[164]
je verificare26
cmp eax,matrix[172]
je verificare26
cmp eax,matrix[176]
je verificare26
cmp eax,matrix[168-9*1*4]
je verificare26
cmp eax,matrix[168-9*2*4]
je verificare26
cmp eax,matrix[168-9*3*4]
je verificare26
cmp eax,matrix[168-9*4*4]
je verificare26
cmp eax,matrix[168+9*1*4]
je verificare26
cmp eax,matrix[168+9*2*4]
je verificare26
cmp eax,matrix[168+9*3*4]
je verificare26
cmp eax,matrix[168+9*4*4]
je verificare26
cmp eax,matrix[136]
je verificare26
cmp eax,matrix[140]
je verificare26
cmp eax,matrix[208]
je verificare26
cmp eax,matrix[212]
je verificare26

mov matrix[168],eax

add eax,'0'
make_text_macro1 eax,area,230,180

nu_este_in_patrat26:


mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat27
cmp eax,250+20
jg nu_este_in_patrat27
mov eax,[ebp+arg3]
cmp eax,180
jl nu_este_in_patrat27
cmp eax,180+20
jg nu_este_in_patrat27
mov eax,matrix[172]
verificare27:
add eax,1
cmp eax,matrix[144]
je verificare27
cmp eax,matrix[148]
je verificare27
cmp eax,matrix[152]
je verificare27
cmp eax,matrix[156]
je verificare27
cmp eax,matrix[160]
je verificare27
cmp eax,matrix[164]
je verificare27
cmp eax,matrix[168]
je verificare27
cmp eax,matrix[176]
je verificare27
cmp eax,matrix[172-9*1*4]
je verificare27
cmp eax,matrix[172-9*2*4]
je verificare27
cmp eax,matrix[172-9*3*4]
je verificare27
cmp eax,matrix[172-9*4*4]
je verificare27
cmp eax,matrix[172+9*1*4]
je verificare27
cmp eax,matrix[172+9*2*4]
je verificare27
cmp eax,matrix[172+9*3*4]
je verificare27
cmp eax,matrix[172+9*4*4]
je verificare27
cmp eax,matrix[132]
je verificare27
cmp eax,matrix[140]
je verificare27
cmp eax,matrix[204]
je verificare27
cmp eax,matrix[212]
je verificare27

mov matrix[172],eax

add eax,'0'
make_text_macro1 eax,area,250,180

nu_este_in_patrat27:

mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat28
cmp eax,130+20
jg nu_este_in_patrat28
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat28
cmp eax,200+20
jg nu_este_in_patrat28
mov eax,matrix[184]
verificare28:
add eax,1
cmp eax,matrix[180]
je verificare28
cmp eax,matrix[188]
je verificare28
cmp eax,matrix[192]
je verificare28
cmp eax,matrix[196]
je verificare28
cmp eax,matrix[200]
je verificare28
cmp eax,matrix[204]
je verificare28
cmp eax,matrix[208]
je verificare28
cmp eax,matrix[212]
je verificare28
cmp eax,matrix[184-9*1*4]
je verificare28
cmp eax,matrix[184-9*2*4]
je verificare28
cmp eax,matrix[184-9*3*4]
je verificare28
cmp eax,matrix[184-9*4*4]
je verificare28
cmp eax,matrix[184-9*5*4]
je verificare28
cmp eax,matrix[184+9*1*4]
je verificare28
cmp eax,matrix[184+9*2*4]
je verificare28
cmp eax,matrix[184+9*3*4]
je verificare28
cmp eax,matrix[108]
je verificare28
cmp eax,matrix[144]
je verificare28
cmp eax,matrix[116]
je verificare28
cmp eax,matrix[152]
je verificare28

mov matrix[184],eax

add eax,'0'
make_text_macro1 eax,area,130,200




nu_este_in_patrat28:




mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat29
cmp eax,150+20
jg nu_este_in_patrat29
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat29
cmp eax,200+20
jg nu_este_in_patrat29
mov eax,matrix[188]
verificare29:
add eax,1
cmp eax,matrix[180]
je verificare29
cmp eax,matrix[184]
je verificare29
cmp eax,matrix[192]
je verificare29
cmp eax,matrix[196]
je verificare29
cmp eax,matrix[200]
je verificare29
cmp eax,matrix[204]
je verificare29
cmp eax,matrix[208]
je verificare29
cmp eax,matrix[212]
je verificare29
cmp eax,matrix[188-9*1*4]
je verificare29
cmp eax,matrix[188-9*2*4]
je verificare29
cmp eax,matrix[188-9*3*4]
je verificare29
cmp eax,matrix[188-9*4*4]
je verificare29
cmp eax,matrix[188-9*5*4]
je verificare29
cmp eax,matrix[188+9*1*4]
je verificare29
cmp eax,matrix[188+9*2*4]
je verificare29
cmp eax,matrix[188+9*3*4]
je verificare29
cmp eax,matrix[108]
je verificare29
cmp eax,matrix[144]
je verificare29
cmp eax,matrix[112]
je verificare29
cmp eax,matrix[148]
je verificare29

mov matrix[188],eax

add eax,'0'
make_text_macro1 eax,area,150,200

nu_este_in_patrat29:



mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat30
cmp eax,170+20
jg nu_este_in_patrat30
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat30
cmp eax,200+20
jg nu_este_in_patrat30
mov eax,matrix[192]
verificare30:
add eax,1
cmp eax,matrix[180]
je verificare30
cmp eax,matrix[184]
je verificare30
cmp eax,matrix[188]
je verificare30
cmp eax,matrix[196]
je verificare30
cmp eax,matrix[200]
je verificare30
cmp eax,matrix[204]
je verificare30
cmp eax,matrix[208]
je verificare30
cmp eax,matrix[212]
je verificare30
cmp eax,matrix[192-9*1*4]
je verificare30
cmp eax,matrix[192-9*2*4]
je verificare30
cmp eax,matrix[192-9*3*4]
je verificare30
cmp eax,matrix[192-9*4*4]
je verificare30
cmp eax,matrix[192-9*5*4]
je verificare30
cmp eax,matrix[192+9*1*4]
je verificare30
cmp eax,matrix[192+9*2*4]
je verificare30
cmp eax,matrix[192+9*3*4]
je verificare30
cmp eax,matrix[160]
je verificare30
cmp eax,matrix[164]
je verificare30
cmp eax,matrix[124]
je verificare30
cmp eax,matrix[128]
je verificare30

mov matrix[192],eax

add eax,'0'
make_text_macro1 eax,area,170,200
nu_este_in_patrat30:



mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat31
cmp eax,210+20
jg nu_este_in_patrat31
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat31
cmp eax,200+20
jg nu_este_in_patrat31
mov eax,matrix[200]
verificare31:
add eax,1
cmp eax,matrix[180]
je verificare31
cmp eax,matrix[184]
je verificare31
cmp eax,matrix[188]
je verificare31
cmp eax,matrix[192]
je verificare31
cmp eax,matrix[196]
je verificare31
cmp eax,matrix[204]
je verificare31
cmp eax,matrix[208]
je verificare31
cmp eax,matrix[212]
je verificare31
cmp eax,matrix[200-9*1*4]
je verificare31
cmp eax,matrix[200-9*2*4]
je verificare31
cmp eax,matrix[200-9*3*4]
je verificare31
cmp eax,matrix[200-9*4*4]
je verificare31
cmp eax,matrix[200-9*5*4]
je verificare31
cmp eax,matrix[200+9*1*4]
je verificare31
cmp eax,matrix[200+9*2*4]
je verificare31
cmp eax,matrix[200+9*3*4]
je verificare31
cmp eax,matrix[160]
je verificare31
cmp eax,matrix[156]
je verificare31
cmp eax,matrix[124]
je verificare31
cmp eax,matrix[120]
je verificare31

mov matrix[200],eax

add eax,'0'
make_text_macro1 eax,area,210,200
nu_este_in_patrat31:



mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat32
cmp eax,230+20
jg nu_este_in_patrat32
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat32
cmp eax,200+20
jg nu_este_in_patrat32
mov eax,matrix[204]
verificare32:
add eax,1
cmp eax,matrix[180]
je verificare32
cmp eax,matrix[184]
je verificare32
cmp eax,matrix[188]
je verificare32
cmp eax,matrix[192]
je verificare32
cmp eax,matrix[196]
je verificare32
cmp eax,matrix[204]
je verificare32
cmp eax,matrix[208]
je verificare32
cmp eax,matrix[212]
je verificare32
cmp eax,matrix[204-9*1*4]
je verificare32
cmp eax,matrix[204-9*2*4]
je verificare32
cmp eax,matrix[204-9*3*4]
je verificare32
cmp eax,matrix[204-9*4*4]
je verificare32
cmp eax,matrix[204-9*5*4]
je verificare32
cmp eax,matrix[204+9*1*4]
je verificare32
cmp eax,matrix[204+9*2*4]
je verificare32
cmp eax,matrix[204+9*3*4]
je verificare32
cmp eax,matrix[176]
je verificare32
cmp eax,matrix[172]
je verificare32
cmp eax,matrix[140]
je verificare32
cmp eax,matrix[136]
je verificare32

mov matrix[204],eax

add eax,'0'
make_text_macro1 eax,area,230,200
nu_este_in_patrat32:



mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat33
cmp eax,250+20
jg nu_este_in_patrat33
mov eax,[ebp+arg3]
cmp eax,200
jl nu_este_in_patrat33
cmp eax,200+20
jg nu_este_in_patrat33
mov eax,matrix[208]
verificare33:
add eax,1
cmp eax,matrix[180]
je verificare33
cmp eax,matrix[184]
je verificare33
cmp eax,matrix[188]
je verificare33
cmp eax,matrix[192]
je verificare33
cmp eax,matrix[196]
je verificare33
cmp eax,matrix[204]
je verificare33
cmp eax,matrix[208]
je verificare33
cmp eax,matrix[212]
je verificare33
cmp eax,matrix[208-9*1*4]
je verificare33
cmp eax,matrix[208-9*2*4]
je verificare33
cmp eax,matrix[208-9*3*4]
je verificare33
cmp eax,matrix[208-9*4*4]
je verificare33
cmp eax,matrix[208-9*5*4]
je verificare33
cmp eax,matrix[208+9*1*4]
je verificare33
cmp eax,matrix[208+9*2*4]
je verificare33
cmp eax,matrix[208+9*3*4]
je verificare33
cmp eax,matrix[176]
je verificare33
cmp eax,matrix[168]
je verificare33
cmp eax,matrix[140]
je verificare33
cmp eax,matrix[132]
je verificare33

mov matrix[208],eax

add eax,'0'
make_text_macro1 eax,area,250,200
nu_este_in_patrat33:


mov eax,[ebp+arg2]
cmp eax,110
jl nu_este_in_patrat34
cmp eax,110+20
jg nu_este_in_patrat34
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat34
cmp eax,220+20
jg nu_este_in_patrat34
mov eax,matrix[216]
verificare34:
add eax,1
cmp eax,matrix[220]
je verificare34
cmp eax,matrix[224]
je verificare34
cmp eax,matrix[228]
je verificare34
cmp eax,matrix[232]
je verificare34
cmp eax,matrix[236]
je verificare34
cmp eax,matrix[240]
je verificare34
cmp eax,matrix[244]
je verificare34
cmp eax,matrix[248]
je verificare34
cmp eax,matrix[216-9*1*4]
je verificare34
cmp eax,matrix[216-9*2*4]
je verificare34
cmp eax,matrix[216-9*3*4]
je verificare34
cmp eax,matrix[216-9*4*4]
je verificare34
cmp eax,matrix[216-9*5*4]
je verificare34
cmp eax,matrix[216-9*6*4]
je verificare34
cmp eax,matrix[216+9*1*4]
je verificare34
cmp eax,matrix[216+9*2*4]
je verificare34
cmp eax,matrix[256]
je verificare34
cmp eax,matrix[260]
je verificare34
cmp eax,matrix[292]
je verificare34
cmp eax,matrix[296]
je verificare34

mov matrix[216],eax

add eax,'0'
make_text_macro1 eax,area,110,220
nu_este_in_patrat34:



mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat35
cmp eax,150+20
jg nu_este_in_patrat35
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat35
cmp eax,220+20
jg nu_este_in_patrat35
mov eax,matrix[224]
verificare35:
add eax,1
cmp eax,matrix[216]
je verificare35
cmp eax,matrix[220]
je verificare35
cmp eax,matrix[228]
je verificare35
cmp eax,matrix[232]
je verificare35
cmp eax,matrix[236]
je verificare35
cmp eax,matrix[240]
je verificare35
cmp eax,matrix[244]
je verificare35
cmp eax,matrix[248]
je verificare35
cmp eax,matrix[224-9*1*4]
je verificare35
cmp eax,matrix[224-9*2*4]
je verificare35
cmp eax,matrix[224-9*3*4]
je verificare35
cmp eax,matrix[224-9*4*4]
je verificare35
cmp eax,matrix[224-9*5*4]
je verificare35
cmp eax,matrix[224-9*6*4]
je verificare35
cmp eax,matrix[224+9*1*4]
je verificare35
cmp eax,matrix[224+9*2*4]
je verificare35
cmp eax,matrix[248]
je verificare35
cmp eax,matrix[244]
je verificare35
cmp eax,matrix[284]
je verificare35
cmp eax,matrix[280]
je verificare35

mov matrix[224],eax

add eax,'0'
make_text_macro1 eax,area,150,220
nu_este_in_patrat35:



mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat36
cmp eax,170+20
jg nu_este_in_patrat36
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat36
cmp eax,220+20
jg nu_este_in_patrat36
mov eax,matrix[228]
verificare36:
add eax,1
cmp eax,matrix[216]
je verificare36
cmp eax,matrix[220]
je verificare36
cmp eax,matrix[224]
je verificare36
cmp eax,matrix[232]
je verificare36
cmp eax,matrix[236]
je verificare36
cmp eax,matrix[240]
je verificare36
cmp eax,matrix[244]
je verificare36
cmp eax,matrix[248]
je verificare36
cmp eax,matrix[228-9*1*4]
je verificare36
cmp eax,matrix[228-9*2*4]
je verificare36
cmp eax,matrix[228-9*3*4]
je verificare36
cmp eax,matrix[228-9*4*4]
je verificare36
cmp eax,matrix[228-9*5*4]
je verificare36
cmp eax,matrix[228-9*6*4]
je verificare36
cmp eax,matrix[228+9*1*4]
je verificare36
cmp eax,matrix[228+9*2*4]
je verificare36
cmp eax,matrix[268]
je verificare36
cmp eax,matrix[272]
je verificare36
cmp eax,matrix[304]
je verificare36
cmp eax,matrix[308]
je verificare36

mov matrix[228],eax

add eax,'0'
make_text_macro1 eax,area,170,220
nu_este_in_patrat36:



mov eax,[ebp+arg2]
cmp eax,190
jl nu_este_in_patrat37
cmp eax,190+20
jg nu_este_in_patrat37
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat37
cmp eax,220+20
jg nu_este_in_patrat37
mov eax,matrix[232]
verificare37:
add eax,1
cmp eax,matrix[216]
je verificare37
cmp eax,matrix[220]
je verificare37
cmp eax,matrix[224]
je verificare37
cmp eax,matrix[228]
je verificare37
cmp eax,matrix[236]
je verificare37
cmp eax,matrix[240]
je verificare37
cmp eax,matrix[244]
je verificare37
cmp eax,matrix[248]
je verificare37
cmp eax,matrix[232-9*1*4]
je verificare37
cmp eax,matrix[232-9*2*4]
je verificare37
cmp eax,matrix[232-9*3*4]
je verificare37
cmp eax,matrix[232-9*4*4]
je verificare37
cmp eax,matrix[232-9*5*4]
je verificare37
cmp eax,matrix[232-9*6*4]
je verificare37
cmp eax,matrix[232+9*1*4]
je verificare37
cmp eax,matrix[232+9*2*4]
je verificare37
cmp eax,matrix[264]
je verificare37
cmp eax,matrix[272]
je verificare37
cmp eax,matrix[300]
je verificare37
cmp eax,matrix[308]
je verificare37

mov matrix[232],eax

add eax,'0'
make_text_macro1 eax,area,190,220
nu_este_in_patrat37:



mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat38
cmp eax,210+20
jg nu_este_in_patrat38
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat38
cmp eax,220+20
jg nu_este_in_patrat38
mov eax,matrix[236]
verificare38:
add eax,1
cmp eax,matrix[216]
je verificare38
cmp eax,matrix[220]
je verificare38
cmp eax,matrix[224]
je verificare38
cmp eax,matrix[228]
je verificare38
cmp eax,matrix[232]
je verificare38
cmp eax,matrix[240]
je verificare38
cmp eax,matrix[244]
je verificare38
cmp eax,matrix[248]
je verificare38
cmp eax,matrix[236-9*1*4]
je verificare38
cmp eax,matrix[236-9*2*4]
je verificare38
cmp eax,matrix[236-9*3*4]
je verificare38
cmp eax,matrix[236-9*4*4]
je verificare38
cmp eax,matrix[236-9*5*4]
je verificare38
cmp eax,matrix[236-9*6*4]
je verificare38
cmp eax,matrix[236+9*1*4]
je verificare38
cmp eax,matrix[236+9*2*4]
je verificare38
cmp eax,matrix[264]
je verificare38
cmp eax,matrix[268]
je verificare38
cmp eax,matrix[300]
je verificare38
cmp eax,matrix[304]
je verificare38

mov matrix[236],eax

add eax,'0'
make_text_macro1 eax,area,210,220
nu_este_in_patrat38:



mov eax,[ebp+arg2]
cmp eax,270
jl nu_este_in_patrat40
cmp eax,270+20
jg nu_este_in_patrat40
mov eax,[ebp+arg3]
cmp eax,220
jl nu_este_in_patrat40
cmp eax,220+20
jg nu_este_in_patrat40
mov eax,matrix[248]
verificare40:
add eax,1
cmp eax,matrix[216]
je verificare40
cmp eax,matrix[220]
je verificare40
cmp eax,matrix[224]
je verificare40
cmp eax,matrix[228]
je verificare40
cmp eax,matrix[232]
je verificare40
cmp eax,matrix[236]
je verificare40
cmp eax,matrix[240]
je verificare40
cmp eax,matrix[244]
je verificare40
cmp eax,matrix[248-9*1*4]
je verificare40
cmp eax,matrix[248-9*2*4]
je verificare40
cmp eax,matrix[248-9*3*4]
je verificare40
cmp eax,matrix[248-9*4*4]
je verificare40
cmp eax,matrix[248-9*5*4]
je verificare40
cmp eax,matrix[248-9*6*4]
je verificare40
cmp eax,matrix[248+9*1*4]
je verificare40
cmp eax,matrix[248+9*2*4]
je verificare40
cmp eax,matrix[280]
je verificare40
cmp eax,matrix[276]
je verificare40
cmp eax,matrix[312]
je verificare40
cmp eax,matrix[316]
je verificare40

mov matrix[248],eax

add eax,'0'
make_text_macro1 eax,area,270,220
nu_este_in_patrat40:




mov eax,[ebp+arg2]
cmp eax,110
jl nu_este_in_patrat41
cmp eax,110+20
jg nu_este_in_patrat41
mov eax,[ebp+arg3]
cmp eax,240
jl nu_este_in_patrat41
cmp eax,240+20
jg nu_este_in_patrat41
mov eax,matrix[252]
verificare41:
add eax,1
cmp eax,matrix[256]
je verificare41
cmp eax,matrix[260]
je verificare41
cmp eax,matrix[264]
je verificare41
cmp eax,matrix[268]
je verificare41
cmp eax,matrix[272]
je verificare41
cmp eax,matrix[276]
je verificare41
cmp eax,matrix[280]
je verificare41
cmp eax,matrix[284]
je verificare41
cmp eax,matrix[252-9*1*4]
je verificare41
cmp eax,matrix[252-9*2*4]
je verificare41
cmp eax,matrix[252-9*3*4]
je verificare41
cmp eax,matrix[252-9*4*4]
je verificare41
cmp eax,matrix[252-9*5*4]
je verificare41
cmp eax,matrix[252-9*6*4]
je verificare41
cmp eax,matrix[252-9*7*4]
je verificare41
cmp eax,matrix[252+9*1*4]
je verificare41
cmp eax,matrix[292]
je verificare41
cmp eax,matrix[296]
je verificare41
cmp eax,matrix[220]
je verificare41
cmp eax,matrix[224]
je verificare41

mov matrix[252],eax

add eax,'0'
make_text_macro1 eax,area,110,240
nu_este_in_patrat41:


mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat42
cmp eax,130+20
jg nu_este_in_patrat42
mov eax,[ebp+arg3]
cmp eax,240
jl nu_este_in_patrat42
cmp eax,240+20
jg nu_este_in_patrat42
mov eax,matrix[256]
verificare42:
add eax,1
cmp eax,matrix[252]
je verificare42
cmp eax,matrix[260]
je verificare42
cmp eax,matrix[264]
je verificare42
cmp eax,matrix[268]
je verificare42
cmp eax,matrix[272]
je verificare42
cmp eax,matrix[276]
je verificare42
cmp eax,matrix[280]
je verificare42
cmp eax,matrix[284]
je verificare42
cmp eax,matrix[256-9*1*4]
je verificare42
cmp eax,matrix[256-9*2*4]
je verificare42
cmp eax,matrix[256-9*3*4]
je verificare42
cmp eax,matrix[256-9*4*4]
je verificare42
cmp eax,matrix[256-9*5*4]
je verificare42
cmp eax,matrix[256-9*6*4]
je verificare42
cmp eax,matrix[256-9*7*4]
je verificare42
cmp eax,matrix[256+9*1*4]
je verificare42
cmp eax,matrix[216]
je verificare42
cmp eax,matrix[224]
je verificare42
cmp eax,matrix[288]
je verificare42
cmp eax,matrix[296]
je verificare42

mov matrix[256],eax

add eax,'0'
make_text_macro1 eax,area,130,240
nu_este_in_patrat42:




mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat43
cmp eax,150+20
jg nu_este_in_patrat43
mov eax,[ebp+arg3]
cmp eax,240
jl nu_este_in_patrat43
cmp eax,240+20
jg nu_este_in_patrat43
mov eax,matrix[260]
verificare43:
add eax,1
cmp eax,matrix[252]
je verificare43
cmp eax,matrix[256]
je verificare43
cmp eax,matrix[264]
je verificare43
cmp eax,matrix[268]
je verificare43
cmp eax,matrix[272]
je verificare43
cmp eax,matrix[276]
je verificare43
cmp eax,matrix[280]
je verificare43
cmp eax,matrix[284]
je verificare43
cmp eax,matrix[260-9*1*4]
je verificare43
cmp eax,matrix[260-9*2*4]
je verificare43
cmp eax,matrix[260-9*3*4]
je verificare43
cmp eax,matrix[260-9*4*4]
je verificare43
cmp eax,matrix[260-9*5*4]
je verificare43
cmp eax,matrix[260-9*6*4]
je verificare43
cmp eax,matrix[260-9*7*4]
je verificare43
cmp eax,matrix[260+9*1*4]
je verificare43
cmp eax,matrix[216]
je verificare43
cmp eax,matrix[220]
je verificare43
cmp eax,matrix[288]
je verificare43
cmp eax,matrix[292]
je verificare43

mov matrix[260],eax

add eax,'0'
make_text_macro1 eax,area,150,240
nu_este_in_patrat43:




mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat44
cmp eax,230+20
jg nu_este_in_patrat44
mov eax,[ebp+arg3]
cmp eax,240
jl nu_este_in_patrat44
cmp eax,240+20
jg nu_este_in_patrat44
mov eax,matrix[276]
verificare44:
add eax,1
cmp eax,matrix[252]
je verificare44
cmp eax,matrix[256]
je verificare44
cmp eax,matrix[260]
je verificare44
cmp eax,matrix[264]
je verificare44
cmp eax,matrix[268]
je verificare44
cmp eax,matrix[272]
je verificare44
cmp eax,matrix[280]
je verificare44
cmp eax,matrix[284]
je verificare44
cmp eax,matrix[276-9*1*4]
je verificare44
cmp eax,matrix[276-9*2*4]
je verificare44
cmp eax,matrix[276-9*3*4]
je verificare44
cmp eax,matrix[276-9*4*4]
je verificare44
cmp eax,matrix[276-9*5*4]
je verificare44
cmp eax,matrix[276-9*6*4]
je verificare44
cmp eax,matrix[276-9*7*4]
je verificare44
cmp eax,matrix[276+9*1*4]
je verificare44
cmp eax,matrix[244]
je verificare44
cmp eax,matrix[248]
je verificare44
cmp eax,matrix[316]
je verificare44
cmp eax,matrix[320]
je verificare44

mov matrix[276],eax

add eax,'0'
make_text_macro1 eax,area,230,240
nu_este_in_patrat44:




mov eax,[ebp+arg2]
cmp eax,250
jl nu_este_in_patrat45
cmp eax,250+20
jg nu_este_in_patrat45
mov eax,[ebp+arg3]
cmp eax,240
jl nu_este_in_patrat45
cmp eax,240+20
jg nu_este_in_patrat45
mov eax,matrix[280]
verificare45:
add eax,1
cmp eax,matrix[252]
je verificare45
cmp eax,matrix[256]
je verificare45
cmp eax,matrix[260]
je verificare45
cmp eax,matrix[264]
je verificare45
cmp eax,matrix[268]
je verificare45
cmp eax,matrix[272]
je verificare45
cmp eax,matrix[280]
je verificare45
cmp eax,matrix[284]
je verificare45
cmp eax,matrix[280-9*1*4]
je verificare45
cmp eax,matrix[280-9*2*4]
je verificare45
cmp eax,matrix[280-9*3*4]
je verificare45
cmp eax,matrix[280-9*4*4]
je verificare45
cmp eax,matrix[280-9*5*4]
je verificare45
cmp eax,matrix[280-9*6*4]
je verificare45
cmp eax,matrix[280-9*7*4]
je verificare45
cmp eax,matrix[280+9*1*4]
je verificare45
cmp eax,matrix[240]
je verificare45
cmp eax,matrix[248]
je verificare45
cmp eax,matrix[312]
je verificare45
cmp eax,matrix[320]
je verificare45

mov matrix[280],eax

add eax,'0'
make_text_macro1 eax,area,250,240
nu_este_in_patrat45:



mov eax,[ebp+arg2]
cmp eax,110
jl nu_este_in_patrat46
cmp eax,110+20
jg nu_este_in_patrat46
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat46
cmp eax,260+20
jg nu_este_in_patrat46
mov eax,matrix[288]
verificare46:
add eax,1
cmp eax,matrix[292]
je verificare46
cmp eax,matrix[296]
je verificare46
cmp eax,matrix[300]
je verificare46
cmp eax,matrix[304]
je verificare46
cmp eax,matrix[308]
je verificare46
cmp eax,matrix[312]
je verificare46
cmp eax,matrix[316]
je verificare46
cmp eax,matrix[320]
je verificare46
cmp eax,matrix[288-9*1*4]
je verificare46
cmp eax,matrix[288-9*2*4]
je verificare46
cmp eax,matrix[288-9*3*4]
je verificare46
cmp eax,matrix[288-9*4*4]
je verificare46
cmp eax,matrix[288-9*5*4]
je verificare46
cmp eax,matrix[288-9*6*4]
je verificare46
cmp eax,matrix[288-9*7*4]
je verificare46
cmp eax,matrix[288-9*8*4]
je verificare46
cmp eax,matrix[256]
je verificare46
cmp eax,matrix[260]
je verificare46
cmp eax,matrix[220]
je verificare46
cmp eax,matrix[224]
je verificare46

mov matrix[288],eax

add eax,'0'
make_text_macro1 eax,area,110,260
nu_este_in_patrat46:



mov eax,[ebp+arg2]
cmp eax,130
jl nu_este_in_patrat47
cmp eax,130+20
jg nu_este_in_patrat47
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat47
cmp eax,260+20
jg nu_este_in_patrat47
mov eax,matrix[292]
verificare47:
add eax,1
cmp eax,matrix[288]
je verificare47
cmp eax,matrix[296]
je verificare47
cmp eax,matrix[300]
je verificare47
cmp eax,matrix[304]
je verificare47
cmp eax,matrix[308]
je verificare47
cmp eax,matrix[312]
je verificare47
cmp eax,matrix[316]
je verificare47
cmp eax,matrix[320]
je verificare47
cmp eax,matrix[292-9*1*4]
je verificare47
cmp eax,matrix[292-9*2*4]
je verificare47
cmp eax,matrix[292-9*3*4]
je verificare47
cmp eax,matrix[292-9*4*4]
je verificare47
cmp eax,matrix[292-9*5*4]
je verificare47
cmp eax,matrix[292-9*6*4]
je verificare47
cmp eax,matrix[292-9*7*4]
je verificare47
cmp eax,matrix[292-9*8*4]
je verificare47
cmp eax,matrix[252]
je verificare47
cmp eax,matrix[260]
je verificare47
cmp eax,matrix[216]
je verificare47
cmp eax,matrix[224]
je verificare47

mov matrix[292],eax

add eax,'0'
make_text_macro1 eax,area,130,260
nu_este_in_patrat47:


mov eax,[ebp+arg2]
cmp eax,150
jl nu_este_in_patrat48
cmp eax,150+20
jg nu_este_in_patrat48
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat48
cmp eax,260+20
jg nu_este_in_patrat48
mov eax,matrix[296]
verificare48:
add eax,1
cmp eax,matrix[288]
je verificare48
cmp eax,matrix[292]
je verificare48
cmp eax,matrix[300]
je verificare48
cmp eax,matrix[304]
je verificare48
cmp eax,matrix[308]
je verificare48
cmp eax,matrix[312]
je verificare48
cmp eax,matrix[316]
je verificare48
cmp eax,matrix[320]
je verificare48
cmp eax,matrix[296-9*1*4]
je verificare48
cmp eax,matrix[296-9*2*4]
je verificare48
cmp eax,matrix[296-9*3*4]
je verificare48
cmp eax,matrix[296-9*4*4]
je verificare48
cmp eax,matrix[296-9*5*4]
je verificare48
cmp eax,matrix[296-9*6*4]
je verificare48
cmp eax,matrix[296-9*7*4]
je verificare48
cmp eax,matrix[296-9*8*4]
je verificare48
cmp eax,matrix[256]
je verificare48
cmp eax,matrix[260]
je verificare48
cmp eax,matrix[220]
je verificare48
cmp eax,matrix[224]
je verificare48

mov matrix[296],eax

add eax,'0'
make_text_macro1 eax,area,150,260
nu_este_in_patrat48:




mov eax,[ebp+arg2]
cmp eax,170
jl nu_este_in_patrat49
cmp eax,170+20
jg nu_este_in_patrat49
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat49
cmp eax,260+20
jg nu_este_in_patrat49
mov eax,matrix[300]
verificare49:
add eax,1
cmp eax,matrix[288]
je verificare49
cmp eax,matrix[292]
je verificare49
cmp eax,matrix[296]
je verificare49
cmp eax,matrix[304]
je verificare49
cmp eax,matrix[308]
je verificare49
cmp eax,matrix[312]
je verificare49
cmp eax,matrix[316]
je verificare49
cmp eax,matrix[320]
je verificare49
cmp eax,matrix[300-9*1*4]
je verificare49
cmp eax,matrix[300-9*2*4]
je verificare49
cmp eax,matrix[300-9*3*4]
je verificare49
cmp eax,matrix[300-9*4*4]
je verificare49
cmp eax,matrix[300-9*5*4]
je verificare49
cmp eax,matrix[300-9*6*4]
je verificare49
cmp eax,matrix[300-9*7*4]
je verificare49
cmp eax,matrix[300-9*8*4]
je verificare49
cmp eax,matrix[268]
je verificare49
cmp eax,matrix[272]
je verificare49
cmp eax,matrix[232]
je verificare49
cmp eax,matrix[236]
je verificare49

mov matrix[300],eax

add eax,'0'
make_text_macro1 eax,area,170,260
nu_este_in_patrat49:




mov eax,[ebp+arg2]
cmp eax,210
jl nu_este_in_patrat50
cmp eax,210+20
jg nu_este_in_patrat50
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat50
cmp eax,260+20
jg nu_este_in_patrat50
mov eax,matrix[308]
verificare50:
add eax,1
cmp eax,matrix[288]
je verificare50
cmp eax,matrix[292]
je verificare50
cmp eax,matrix[296]
je verificare50
cmp eax,matrix[300]
je verificare50
cmp eax,matrix[304]
je verificare50
cmp eax,matrix[312]
je verificare50
cmp eax,matrix[316]
je verificare50
cmp eax,matrix[320]
je verificare50
cmp eax,matrix[308-9*1*4]
je verificare50
cmp eax,matrix[308-9*2*4]
je verificare50
cmp eax,matrix[308-9*3*4]
je verificare50
cmp eax,matrix[308-9*4*4]
je verificare50
cmp eax,matrix[308-9*5*4]
je verificare50
cmp eax,matrix[308-9*6*4]
je verificare50
cmp eax,matrix[308-9*7*4]
je verificare50
cmp eax,matrix[308-9*8*4]
je verificare50
cmp eax,matrix[268]
je verificare50
cmp eax,matrix[264]
je verificare50
cmp eax,matrix[232]
je verificare50
cmp eax,matrix[228]
je verificare50

mov matrix[308],eax

add eax,'0'
make_text_macro1 eax,area,210,260
nu_este_in_patrat50:


mov eax,[ebp+arg2]
cmp eax,230
jl nu_este_in_patrat51
cmp eax,230+20
jg nu_este_in_patrat51
mov eax,[ebp+arg3]
cmp eax,260
jl nu_este_in_patrat51
cmp eax,260+20
jg nu_este_in_patrat51
mov eax,matrix[312]
verificare51:
add eax,1
cmp eax,matrix[288]
je verificare51
cmp eax,matrix[292]
je verificare51
cmp eax,matrix[296]
je verificare51
cmp eax,matrix[300]
je verificare51
cmp eax,matrix[304]
je verificare51
cmp eax,matrix[308]
je verificare51
cmp eax,matrix[316]
je verificare51
cmp eax,matrix[320]
je verificare51
cmp eax,matrix[312-9*1*4]
je verificare51
cmp eax,matrix[312-9*2*4]
je verificare51
cmp eax,matrix[312-9*3*4]
je verificare51
cmp eax,matrix[312-9*4*4]
je verificare51
cmp eax,matrix[312-9*5*4]
je verificare51
cmp eax,matrix[312-9*6*4]
je verificare51
cmp eax,matrix[312-9*7*4]
je verificare51
cmp eax,matrix[312-9*8*4]
je verificare51
cmp eax,matrix[280]
je verificare51
cmp eax,matrix[284]
je verificare51
cmp eax,matrix[244]
je verificare51
cmp eax,matrix[248]
je verificare51

mov matrix[312],eax

add eax,'0'
make_text_macro1 eax,area,230,260
nu_este_in_patrat51:


line_horizontal  105,100,0FFh
line_horizontal  105,120,0
line_horizontal  105,140,0
line_horizontal  105,160,0FFh
line_horizontal  105,180,0
line_horizontal  105,200,0
line_horizontal  105,220,0FFh
line_horizontal  105,240,0
line_horizontal  105,260,0
line_horizontal  105,280,0FFh
line_vertical    105,100,0FFh
line_vertical    125,100,0
line_vertical    145,100,0
line_vertical    165,100,0FFh
line_vertical    185,100,0
line_vertical    205,100,0
line_vertical    225,100,0FFh
line_vertical    245,100,0
line_vertical    265,100,0
line_vertical    285,100,0FFh
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp


	


start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
