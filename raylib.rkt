#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-raylib (ffi-lib "./raylib-5.5_linux_amd64/lib/libraylib" "5.5.0"))

(define-syntax-rule (_pointer-to type) _pointer)
(define-cstruct _Color ([r _uint8] [g _uint8] [b _uint8] [a _uint8]))
(define-cstruct _Rectangle ([x _float] [y _float] [width _float] [height _float]))
(define-cstruct _Texture ([id _uint] [width _int] [height _int] [mipmaps _int] [format _int]))
(define-cstruct _Vector2 ([x _float] [y _float]))
(define-cstruct _Image ([data (_pointer-to _void)]
                        [width   _int]
                        [height  _int]
                        [mipmaps _int]
                        [format _int]))

(define-raylib InitWindow (_fun [width : _int] [height : _int] [title : _string] -> _void))
(define-raylib CloseWindow (_fun -> _void))
(define-raylib WindowShouldClose (_fun -> _stdbool))
(define-raylib BeginDrawing (_fun -> _void))
(define-raylib EndDrawing (_fun -> _void))
(define-raylib ClearBackground (_fun [color : _Color] -> _void))
(define-raylib SetTargetFPS (_fun [fps : _int] -> _void))
(define-raylib GetFPS (_fun -> _int))
(define-raylib DrawFPS (_fun [posX : _int] [posY : _int] -> _void))
(define-raylib GetColor (_fun [hexValue : _int] -> _Color))
(define-raylib DrawRectangleGradientEx
  (_fun [rec : _Rectangle] [topLeft : _Color] [bottomLeft : _Color] [topRight : _Color] [bottomRight : _Color] -> _void))
(define-raylib DrawRectangle
  (_fun [posX : _int] [posY : _int] [width : _int] [height : _int] [color : _Color] -> _void))
(define-raylib DrawRectangleLines
  (_fun [posX : _int] [posY : _int] [width : _int] [height : _int] [color : _Color] -> _void))
(define-raylib DrawRectangleLinesEx
  (_fun [rec : _Rectangle] [lineThick : _float] [color : _Color] -> _void))
(define-raylib DrawRectangleRoundedLinesEx (_fun [rec : _Rectangle] [roundness : _float] [segments : _int] [lineThick : _float] [color : _Color] -> _void))
(define-raylib GetScreenWidth (_fun -> _int))
(define-raylib GetScreenHeight (_fun -> _int))
(define-raylib LoadTexture (_fun _string -> _Texture))
(define-raylib LoadTextureFromImage (_fun _Image -> _Texture))
(define-raylib UnloadTexture (_fun _Texture -> _void))
(define-raylib DrawTexture (_fun [texture : _Texture] [posX : _int] [posY : _int] [tint : _Color] -> _void))
(define-raylib DrawTextureRec (_fun [texture : _Texture] [source : _Rectangle] [position : _Vector2] [tint : _Color] -> _void))
(define-raylib LoadImage (_fun _string -> _Image))
(define-raylib UnloadImage (_fun _Image -> _void))
(define-raylib ImageResize (_fun (_pointer-to _Image) _int _int -> _void))

(define WINDOW 120)
(define SIDEBAR_WIDTH 300)
(define BORDER 10.0)
(define RAYWHITE (make-Color 245 245 245 255))

(InitWindow (* 16 WINDOW) (* 9 WINDOW) "Window from Racket")
(SetTargetFPS 30)

(define SettingImage (LoadImage "./assets/icons/button_settings.png"))
(ImageResize SettingImage 200 117)
(define SettingTexture (LoadTextureFromImage SettingImage))
(UnloadImage SettingImage)

(define HomeImage (LoadImage "./assets/icons/button_home.png"))
(ImageResize HomeImage 180 180)
(define HomeTexture (LoadTextureFromImage HomeImage))
(UnloadImage HomeImage)

(let loop ()
  (when (not (WindowShouldClose))
    (BeginDrawing)
    (ClearBackground (GetColor #x181818FF))
    (DrawRectangle 0 0 SIDEBAR_WIDTH (GetScreenHeight) (GetColor #x393939FF))
    (DrawRectangleLinesEx
     (make-Rectangle
      (real->double-flonum SIDEBAR_WIDTH)
      0.0
      (- (GetScreenWidth) (real->double-flonum SIDEBAR_WIDTH))
      (- (GetScreenHeight) 0.1))
     BORDER
     (GetColor #x00FF00FF))
    (DrawRectangleGradientEx
     (make-Rectangle
      (+ (real->double-flonum SIDEBAR_WIDTH) BORDER)
      BORDER
      (- (GetScreenWidth) (real->double-flonum SIDEBAR_WIDTH) (* BORDER 2))
      (- (GetScreenHeight) (* BORDER 2)))
     (make-Color 255 0 0 255)
     (make-Color 0 0 0 255)
     (make-Color 255 0 0 255)
     (make-Color 0 0 0 255))

    (DrawTextureRec SettingTexture (make-Rectangle 0.0 0.0 200.0 117.0) (make-Vector2 50.0 35.0) RAYWHITE)
    (DrawTextureRec HomeTexture (make-Rectangle 0.0 0.0 180.0 180.0) (make-Vector2 60.0 860.0) RAYWHITE)

    (DrawRectangleRoundedLinesEx (make-Rectangle (+ 30.0 4) (+ 338.0 4) 100.0 118.0) 0.18 0 2.0 RAYWHITE)
    (DrawRectangleRoundedLinesEx (make-Rectangle 30.0 338.0 240.0 126.0) 0.20 0 2.0 (GetColor #x00FFFF55))

    (DrawRectangleLinesEx (make-Rectangle 30.0 496.0 240.0 126.0) 10.0 (GetColor #x000000FF))

    (DrawRectangleLinesEx (make-Rectangle 30.0 654.0 240.0 126.0) 10.0 (GetColor #x000000FF))
    
    (DrawFPS 0 0)
    (EndDrawing)
    (loop)))

(UnloadTexture SettingTexture)
(UnloadTexture HomeTexture)

(CloseWindow)
