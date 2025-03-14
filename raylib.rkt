#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-raylib (ffi-lib "./raylib-5.5_linux_amd64/lib/libraylib" "5.5.0"))

(define-cstruct _Color ([r: _uint8]
                        [g: _uint8]
                        [b: _uint8]
                        [a: _uint8]))

(define RAYWHITE (make-Color 245 245 245 255))

(define-raylib InitWindow (_fun _int _int _string -> _void))
(define-raylib CloseWindow (_fun -> _void))
(define-raylib WindowShouldClose (_fun -> _stdbool))
(define-raylib BeginDrawing (_fun -> _void))
(define-raylib EndDrawing (_fun -> _void))
(define-raylib ClearBackground (_fun _Color -> _void))
(define-raylib SetTargetFPS (_fun _int -> _void))
(define-raylib GetFPS (_fun -> _int))
(define-raylib DrawFPS (_fun _int _int -> _void))

(InitWindow 640 480 "Window from Racket")
(SetTargetFPS 30)

(let loop ()
  (when (not (WindowShouldClose))
    (BeginDrawing)
    (ClearBackground RAYWHITE)
    (DrawFPS 0 0)
    (EndDrawing)
    (loop)))
(CloseWindow)

