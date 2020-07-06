
print macro x, y, attrib, sdat
LOCAL s_dcl,skip_dcl,s_dcl_end
pusha
mov dx,cs
mov es,dx
mov ah,13h
mov al,1
mov bh,0
mov bl,attrib
mov cx,offset s_dcl_end - offset s_dcl
mov dl,x
mov dh,y
mov bp,offset s_dcl
int 10h
popa
jmp skip_dcl
s_dcl DB sdat
s_dcl_end DB 0
skip_dcl:
endm  
clear_screen macro
    pusha
    mov ax, 0600h
    mov bh, 0000_1111b
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 10h
    popa
endm

data segment
    a db 3 dup(0)
    b db 3 dup(0)
    c db 3 dup(0)
    ox db 0
    oy db 0  
    turn db 1 
    chck db 1   
    
data ends

place macro v1,v2       
    mov ah,v1
    mov bh,v2
    mov ox,ah
    mov oy,bh   
    endm

select macro 
    mov bh,turn
    cmp bh,0 
    je o
    jne x
    o:
    print ox,oy,0000_1111b,"O"
    jmp et
    x:
    print ox,oy,0000_1111b,"X"
    
    
    et:
endm

code segment    
    assume ds:data,cs:code    
  
    start:     
    mov ax,data
    mov ds,ax
    mov ax,0h
    int 33h
    mov ax,0h
    
    print 5,5,0000_1111b,"Press any key to Play Game"   
    wait_for_key:

; check for keystroke in
; keyboard buffer:
        mov     ah, 1
        int     16h
        jz      wait_for_key

; get keystroke from keyboard:
; (remove from the buffer)
    mov     ah, 0
    int     16h   
    clear_screen
   
    call tictoe 
    mov ax, 1
    int 33h
    mov ax,0h
    int 33h     
    
    mov ax,0h  
    next:
        mov ax,0003h
        int 33h
        cmp bx,01
        je putx
        jne goes  
        putx:  
        call check
        mov al,01h
        mov chck,al 
        call winner
        
        mov al,02h
        mov chck,al 
        call winner
        goes:    
        
    jmp next
    mov ax,4c00h
    int 21h
    
    
    
    
    tictoe proc near:
    print 5,5,0000_1111b,"  |   |  " 
    print 5,7,0000_1111b,"- + - + -"     
    print 5,9,0000_1111b,"  |   |  "
    print 5,11,0000_1111b,"- + - + -"
    print 5,13,0000_1111b,"  |   |  "
    Ret
    
    
    
    check proc near: 
          cmp cx,26h
          jle nme
          cmp dx,38h
          jle  first 
          cmp dx,58h
          jle second
          cmp dx,6Eh
          jle third
          mov bh,turn
          first:
               cmp cx,38h
               jle fc
               cmp cx,55h
               jle sc
               cmp cx,6Fh
               jle tc
               
               fc:  
               mov ah,a
               cmp ah,0
               jne last
               
               place 5,5
           
               mov ah,turn
               cmp ah,0
               je t
               jne t1
           
               t: 
                mov a,1
                jmp tend
               t1:
                mov a,2 
                jmp tend
               tend:
           
               jmp la                   
               
               
               sc:  
               
               mov ah,a+1
               cmp ah,0
               jne last
               
               place 9,5
               
               
               mov ah,turn
               cmp ah,0
               je st
               jne sst1
               st: 
                mov a+1,1
                jmp stend
               sst1:
                mov a+1,2 
                jmp stend
               stend:
               
               jmp la
               
               
               tc:
               
               mov ah,a+2
               cmp ah,0
               jne last
               
               place 13,5
              
              
               mov ah,turn
               cmp ah,0
               je tt
               jne tt1
               tt: 
                mov a+2,1
                jmp ttend
               tt1:
                mov a+2,2 
                jmp ttend
               ttend:
               la:
              
               jmp nm
               
          second:
               cmp cx,38h
               jle sfc
               cmp cx,55h
               jle ssc
               cmp cx,6Fh
               jle sstc
               sfc:
               
               mov ah,b
               cmp ah,0
               jne last
                              
               place 5,9
               mov ah,turn
               cmp ah,0
               je fsst
               jne fsst1
               fsst: 
                mov b,1
                jmp fstend
               fsst1:
                mov b,2 
                jmp fstend
               fstend:
               
               
               jmp sla 
               
               ssc:
               
               mov ah,b+1
               cmp ah,0
               jne last
               place 9,9
                 mov ah,turn
               cmp ah,0
               je sst
               jne ssst1
               sst: 
                mov b+1,1
                jmp sstend
               ssst1:
                mov b+1,2 
                jmp sstend
               sstend:
               
               
               jmp sla
               
               
               sstc:
               
               mov ah,b+2
               cmp ah,0
               jne last
               place 13,9
               mov ah,turn
               cmp ah,0
               je tst
               jne tsst1
               tst: 
                mov b+2,1
                jmp tstend
               tsst1:
                mov b+2,2 
                jmp tstend
               tstend:
               
               sla:
               jmp nm
               
          third:     
               cmp cx,38h
               jle tfc
               cmp cx,55h
               jle tsc
               cmp cx,6Fh
               jle ttc
              
               tfc:
               
               mov ah,c
               cmp ah,0
               jne last
               place 5,13
               mov ah,turn
               cmp ah,0
               je fesst
               jne fssst1
               fesst: 
               mov c,1
               jmp fsstend
               fssst1:
                mov c,2 
                jmp fsstend
               fsstend:
               
               jmp tla 
               
               tsc: 
               
               mov ah,c+1
               cmp ah,0
               jne last
               place 9,13
                 mov ah,turn
               cmp ah,0
               je ssst
               jne sssst1
               ssst: 
                mov c+1,1
                jmp ssstend
               sssst1:
                mov c+1,2 
                jmp ssstend
               ssstend:
               
               jmp tla
               
               
               ttc:      
               
               mov ah,c+2
               cmp ah,0
               jne last
               place 13,13
                 mov ah,turn
               cmp ah,0
               je tsst
               jne tssst1
               tsst: 
                mov c+2,1
                jmp tsstend
               tssst1:
                mov c+2,2 
                jmp tsstend
               tsstend:
               
               tla:
               jmp nm      
          nm: 
          select
          nme:
          cmp bh,0h
          je tj
          jne tnj
          tj:
          mov bh,1h
          jmp cc
          tnj:
          mov bh,0h
          cc:
          mov turn,bh
          last:
    Ret 
    endp 
    
    winner proc near:
        lea si,a
        mov ah,00h
        mov cx,3
        mov bx,0h
        
        fnext:    
            mov ah,[si]
            cmp ah,chck
            je  fkick
            jne fen
            fkick:  
                add bx,1
                jmp fen
            fen:
            inc si
        loop fnext
        cmp bx,3
        je win
        
        lea si,b
        mov ah,00h
        mov cx,3
        mov bx,0h
        mnext:    
            mov ah,[si]
            cmp ah,chck
            je  mkick
            jne men
            mkick:  
                add bx,1
                jmp men
            men:
            inc si
        loop mnext
        cmp bx,3
        je win
        
        lea si,c
        mov ah,00h
        mov cx,3
        mov bx,0h
        lnext:    
            mov ah,[si]
            cmp ah,chck
            je  lkick
            jne len
            lkick:  
                add bx,1
                jmp len
            len:
            inc si
        loop lnext
        cmp bx,3
        je win 
        
        mov bx,0
        mov cx,03h
     
        mov ah,chck
        cool:     
            
            mov dx,cx
            dec dx
            mov bx,0
            lea si,a
            add si,dx
            cmp [si],ah
            je  ad
            jne nad
            ad:
            add bx,1
            
            
            lea si,b
            add si,dx
            cmp [si],ah
            je  sad
            jne nad 
            sad:    
            add bx,1
            
            
            lea si,c
            add si,dx
            cmp [si],ah
            je laud
            jne nad
            laud:
            add bx,1 
            
            
            cmp bx,3
            je win
            nad:
             
        loop cool
        
        
        mov bx,0h
        mov ah,chck
            cmp a,ah
            je as
            jne bad
            as: 
            cmp b+1,ah
            je bs
            jne bad
            bs:
            cmp c+2,ah
            je win
            bad:    
            
            cmp a+2,ah
            je asd
            jne bads
            asd: 
            cmp b+1,ah
            je bsd
            jne bads
            bsd:
            cmp c,ah
            je win
            bads:
        jmp nwin
        win:    
            cmp chck,2
            je xwin
            jne owin
            xwin:
            print 16,2,0000_1111b," X is Winner "
            jmp excs
            owin:
            print 16,2,0000_1111b," O is Winner "
            excs:
            mov ax,4c00h
            int 21h
        nwin:
    Ret
    endp
ends
end start

