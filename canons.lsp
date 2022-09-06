;******************************************************************************
; Joan Martorell Ferriol
;******************************************************************************

;FUNCIONES PARA PINTAR

; Función para pintar el escenario
(defun pintaesc () (color 0 0 0 72 209 204)
(cls) ; pinta el fondo
(color 127 255 0 0 0 0)
(move 0 0)
(rectangulo (get 'escenari 'x2) (get 'escenari 'y2)) ; pinta la montaña del primer cañón
(color 128 64 0 0 0 0)
(move (get 'escenari 'x2) 0)
(rectangulo (-(get 'escenari 'x3)(get 'escenari 'x2)) (get 'escenari 'y1)) ; pinta la montaña central
(color 127 255 0 0 0 0)
(move (get 'escenari 'x3) 0)
(rectangulo (- (get 'escenari 'x4) (get 'escenari 'x3))(get 'escenari 'y3)) ; pinta la montaña del segundo cañón
(color 87 35 100 0 0 0)
(move (get 'cano 'posicio) (get 'escenari 'y2))
(rectangulo 20 10) ; pinta el cañón 1
(move (+(get 'cano 'posicio) 10) (+ (get 'escenari 'y2) 10))
(drawrel (realpart (round (* 15 (cos (get 'cano 'angle))))) (realpart (round (* 15 (sin (get 'cano 'angle))))))

(move (get 'cano2 'posicio) (get 'escenari 'y3))
(rectangulo 20 10) ; pinta el cañón 2
(move (+(get 'cano2 'posicio) 10) (+ (get 'escenari 'y3) 10))
(drawrel (realpart (- 0 (round (* 15 (cos (get 'cano2 'angle)))))) (realpart (- 0 (round (* 15 (sin (get 'cano2 'angle)))))))
(color 0 0 0 72 209 204)
(viento)
)

; Función que pinta un rectángulo lleno según el color de escritura, de X pixeles de ancho e Y pixeles de alto.
; El rectángulo empieza a dibujarse desde la posición actual del lápiz
(defun rectangulo (x y) 
(cond ((= y 0) nil)
(t (drawrel x 0)
(moverel (- 0 x) 1) 
(rectangulo x (- y 1)))))

; Función para pintar el proyectil del cañón 1
(defun proyectilc1 (velocidad tiempo) (cond 
;si choca contra la montaña central = nil
((and (= (posx 'cano velocidad tiempo) (get 'escenari 'x2))(<= (posy 'cano velocidad tiempo) (get 'escenari 'y1))) nil)
;si choca contra el suelo dela primera montaña = nil
((and (< (posx 'cano velocidad tiempo) (get 'escenari 'x2)) (< (posy 'cano velocidad tiempo) (get 'escenari 'y2))) nil)
;si choca contra el suelo de la montaña central = nil
((and (and (<= (posx 'cano velocidad tiempo) (get 'escenari 'x3)) (> (posx 'cano velocidad tiempo) (get 'escenari 'x2))) 
(<= (posy 'cano velocidad tiempo) (get 'escenari 'y1))) nil)
;si choca contra el suelo de la tercera montaña = nil
((and (> (posx 'cano velocidad tiempo) (get 'escenari 'x3)) (<= (posy 'cano velocidad tiempo) (get 'escenari 'y3))) nil)
((> (posx 'cano velocidad tiempo) 640))
;si alcanza al cañón enemigo pinta una explosión
((and (and (> (+ (get 'escenari 'y3) 10)(posy 'cano velocidad tiempo)) (> (posy 'cano velocidad tiempo) (get 'escenari 'y3)))
(and (< (get 'cano2 'posicio) (posx 'cano velocidad tiempo))(< (posx 'cano velocidad tiempo) (+ 20 (get 'cano2 'posicio)))))
(color 255 0 0 0 0 0) (print "GAME OVER")(explosion 0 (+ (get 'cano2 'posicio) 10) (+ (get 'escenari 'y3) 10)))
;continua dibujando el recorrido del proyetil
(t (draw (realpart (round (posx 'cano velocidad tiempo))) (realpart (round (posy 'cano velocidad tiempo))))
(proyectilc1 velocidad (+ 0.01 tiempo)))))

; Función para pintar el proyectil del cañón 2
(defun proyectilc2 (velocidad tiempo) (cond 
;si choca contra el suelo de la tercera montaña = nil
((and (> (posx 'cano2 velocidad tiempo) (get 'escenari 'x3))(< (posy 'cano2 velocidad tiempo) (get 'escenari 'y3))) nil)
;si choca contra la pared de la montaña central = nil
((and (= (posx 'cano2 velocidad tiempo) (get 'escenari 'x3)) (<= (posy 'cano2 velocidad tiempo) (get 'escenari 'y1))) nil)
;si choca contra el suelo de la montaña central = nil
((and (and (> (posx 'cano2 velocidad tiempo) (get 'escenari 'x2)) (< (posx 'cano2 velocidad tiempo) (get 'escenari 'x3)))
(< (posy 'cano2 velocidad tiempo) (get 'escenari 'y1))) nil)
;si coca contra el suelo de la primera montaña = nil
((and (< (posx 'cano2 velocidad tiempo) (get 'escenari 'x2)) (< (posy 'cano2 velocidad tiempo) (get 'escenari 'y2))) nil)
;si alcanza al cañón enemigo dibuja una explosión
((and (and (< (get 'cano 'posicio)(posx 'cano2 velocidad tiempo)) (< (posx 'cano2 velocidad tiempo) (+ (get 'cano 'posicio) 20)))
(and (< (get 'escenari 'y2) (posy 'cano2 velocidad tiempo)) (< (posy 'cano2 velocidad tiempo) (+ (get 'escenari 'y2) 10))))
(color 255 0 0 0 0 0) (print "GAME OVER")(explosion 0 (+ (get 'cano 'posicio) 10) (+ (get 'escenari 'y2) 10)))
;continua dibujando la trayectoria del proyectil
(t (draw (realpart (round (posx 'cano2 velocidad tiempo))) (realpart (round (posy 'cano2 velocidad tiempo))))
(proyectilc2 velocidad  (+  0.01 tiempo)))))

; Funcion para pintar una explosión. Dibuja una linea cada 6 grados hasta completar el circulo
(defun explosion (angle x y)(cond ((= angle 360) nil)
((< angle 360)(move x y)(drawrel (realpart (round (* 20 (cos (toradiant angle)))))(realpart (round (* 20 (sin (toradiant angle))))))
(explosion (+ angle 6) x y))
(t nil)))

; Función para pintar el indicador de viento
(defun viento () 
(cond ((= 0 (get 'escenari 'vent))nil) ; No pintamos nada porque no hay viento
(t (move 25 350)(drawrel 15 0)
(cond ((> (get 'escenari 'vent) 0)(drawrel -5 5)(move 40 350)(drawrel -5 -5) (move 25 350)(fuerzaviento (get 'escenari 'vent))) ;pinta una flecha hacia la derecha
((< (get 'escenari 'vent) 0) (move 25 350) (drawrel 5 5) (move 25 350) (drawrel 5 -5)(move 40 350) (fuerzaviento(get 'escenari 'vent))) ;pita una flecha hacia la izquierda
))))

; Función para pintar la fuerza del viento. Dibuja lineas según la fuerza.
(defun fuerzaviento (fuerza)
(cond ((> fuerza 0) (drawrel 0 5) (moverel 2 -5) (fuerzaviento(- 1 fuerza)))
((< fuerza 0) (drawrel 0 5) (moverel -2 -5)(fuerzaviento (+ 1 fuerza)))
(t nil)))

; FUNCIONES PARA GESTIONAR LA FÍSICA DEL JUEGO

; Funcion para pasar de grados a radianes
(defun toradiant (x) (/ (* x 3.141592) 180))

; Funciones de velocidad y posición para una velocidad y un tiempo dados
(defun vox (cano velocidad) (* velocidad (cos (get cano 'angle)))) ; vox = vo * cos (angle)
(defun voy (cano velocidad) (* velocidad (sin (get cano 'angle)))) ; voy = vo * sin (angle)
(defun velx (cano velocidad tiempo) (+ (vox cano velocidad) (* (get 'escenari 'vent) tiempo))) ; velocidadx = vox + (vent * t)
(defun vely (cano velocidad tiempo) (+ (voy cano velocidad) (* -9.8 tiempo))) ; velocidady = voy + a*t
(defun posx (cano velocidad tiempo) (+ (* (velx cano velocidad tiempo) tiempo) (+ (get cano 'posicio) 10))) ; posicionx = velocidadx * t + posiciónInicial
(defun posy (cano velocidad tiempo) (+(+ (*(vely cano velocidad tiempo) tiempo)(* (/ -9.8 2)(* tiempo tiempo))) (get cano 'altura))); posiciony = velocidady * t + (a*t^2)/2 + alturaInicial

; FUNCIONES INICIALIZACIÓN

;Función para inicializar un escenario aleatorio
(defun initesc () (putprop 'escenari (- 5 (random 10)) 'vent)
(putprop 'escenari (random 300) 'y2) 
(putprop 'escenari (+(random (- 300 (get 'escenari 'y2)))(get 'escenari 'y2)) 'y1) ; Normalización de la coordenada y2 para poder usar el random
(putprop 'escenari (random(get 'escenari 'y1)) 'y3)
(putprop 'escenari 0 'x1)
(putprop 'escenari (+ 100 (random 300)) 'x2)
(putprop 'escenari 640 'x4)
(putprop 'escenari (+ (get 'escenari 'x2)(+ 20 (random 130))) 'x3))

;Funciones para inicializar los cañones
(defun initcano () (putprop 'cano (random (- (get 'escenari 'x2) 20)) 'posicio)
(putprop 'cano (toradiant 45) 'angle)
(putprop 'cano (+ 10 (get 'escenari 'y2)) 'altura))

(defun initcano2 () (putprop 'cano2 (+ (random (-(- (get 'escenari 'x4)(get 'escenari 'x3)) 20)) (get 'escenari 'x3)) 'posicio) ; Normalización de la coordenada x3 para poder usar el random
(putprop 'cano2 (toradiant -45) 'angle)
(putprop 'cano2 (+ 10 (get 'escenari 'y3)) 'altura))

; Función repetir para asegurarnos que los comandos se entran siempre por la primera fila
(defun repetir (x) (goto-xy 0 0) (repetir (eval (read))))

; FUNCIONES DEL JUEGO
(defun simula (cano velocidad) (cond ((eq cano 'cano) (move (+(get 'cano 'posicio) 10) (+ (get 'escenari 'y2) 10))(proyectilc1 velocidad 0))
((eq cano 'cano2) (move (+(get 'cano2 'posicio) 10)(+ (get 'escenari 'y3) 10)) (proyectilc2  (- 0 velocidad) 0))
(t nil))
(goto-xy 0 0)
(color 0 0 0 72 209 204)
(cleol))

(defun puja (cano graus) (cond ((eq cano 'cano)(putprop cano (+ (get cano 'angle) (toradiant graus)) 'angle))
((eq cano 'cano2)(putprop cano (- (get cano 'angle) (toradiant graus)) 'angle))
(t nil))
(pintaesc))

(defun baixa (cano graus) (cond ((eq cano 'cano2)(putprop cano (+ (get cano 'angle) (toradiant graus)) 'angle))
((eq cano 'cano)(putprop cano (- (get cano 'angle) (toradiant graus)) 'angle))
(t nil))
(pintaesc))

(defun pinta () (initesc)
(initcano)
(initcano2)
(pintaesc)
(repetir (eval (read))))