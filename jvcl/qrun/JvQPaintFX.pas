{******************************************************************************}
{* WARNING:  JEDI VCL To CLX Converter generated unit.                        *}
{*           Manual modifications will be lost on next release.               *}
{******************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPaintFX.PAS, released on 2002-06-15.

The Initial Developer of the Original Code is Jan Verhoeven [jan1 dott verhoeven att wxs dott nl]
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): Robert Love [rlove att slcdug dott org].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit JvQPaintFX;

interface

uses  
  Types, QWindows, QGraphics, QControls, QForms, 
  SysUtils, Classes;

type
  // Type of a filter for use with Stretch()
  TFilterProc = function(Value: Single): Single;
  TLightBrush = (lbBrightness, lbContrast, lbSaturation,
    lbFisheye, lbrotate, lbtwist, lbrimple,
    mbHor, mbTop, mbBottom, mbDiamond, mbWaste, mbRound,
    mbRound2, mbSplitRound, mbSplitWaste);

  TJvPaintFX = class(TComponent)
  public
    class procedure Solarize(const Src: TBitmap; var Dst: TBitmap; Amount: Integer);
    class procedure Posterize(const Src: TBitmap; var Dst: TBitmap; Amount: Integer);
    class procedure Blend(const Src1, Src2: TBitmap; var Dst: TBitmap; Amount: Single);
    class procedure Blend2(const Src1, Src2: TBitmap; var Dst: TBitmap; Amount: Single);
    class procedure ExtractColor(const Dst: TBitmap; AColor: TColor);
    class procedure ExcludeColor(const Dst: TBitmap; AColor: TColor);
    class procedure Turn(Src, Dst: TBitmap);
    class procedure TurnRight(Src, Dst: TBitmap);
    class procedure HeightMap(const Dst: TBitmap; Amount: Integer);
    class procedure TexturizeTile(const Dst: TBitmap; Amount: Integer);
    class procedure TexturizeOverlap(const Dst: TBitmap; Amount: Integer);
    class procedure RippleRandom(const Dst: TBitmap; Amount: Integer);
    class procedure RippleTooth(const Dst: TBitmap; Amount: Integer);
    class procedure RippleTriangle(const Dst: TBitmap; Amount: Integer);
    class procedure Triangles(const Dst: TBitmap; Amount: Integer);
    class procedure DrawMandelJulia(const Dst: TBitmap; x0, y0, x1, y1: Single;
      Niter: Integer; Mandel: Boolean);
    class procedure FilterXBlue(const Dst: TBitmap; Min, Max: Integer);
    class procedure FilterXGreen(const Dst: TBitmap; Min, Max: Integer);
    class procedure FilterXRed(const Dst: TBitmap; Min, Max: Integer);
    class procedure FilterBlue(const Dst: TBitmap; Min, Max: Integer);
    class procedure FilterGreen(const Dst: TBitmap; Min, Max: Integer);
    class procedure FilterRed(const Dst: TBitmap; Min, Max: Integer);
    class procedure Emboss(var Bmp: TBitmap);
    class procedure Plasma(Src1, Src2, Dst: TBitmap; Scale, Turbulence: Single);
    class procedure Shake(Src, Dst: TBitmap; Factor: Single);
    class procedure ShakeDown(Src, Dst: TBitmap; Factor: Single);
    class procedure KeepBlue(const Dst: TBitmap; Factor: Single);
    class procedure KeepGreen(const Dst: TBitmap; Factor: Single);
    class procedure KeepRed(const Dst: TBitmap; Factor: Single);
    class procedure Mandelbrot(const Dst: TBitmap; Factor: Integer);
    class procedure MaskMandelbrot(const Dst: TBitmap; Factor: Integer);
    class procedure FoldRight(Src1, Src2, Dst: TBitmap; Amount: Single);
    class procedure QuartoOpaque(Src, Dst: TBitmap);
    class procedure SemiOpaque(Src, Dst: TBitmap);
    class procedure ShadowDownLeft(const Dst: TBitmap);
    class procedure ShadowDownRight(const Dst: TBitmap);
    class procedure ShadowUpLeft(const Dst: TBitmap);
    class procedure ShadowUpRight(const Dst: TBitmap);
    class procedure Darkness(const Dst: TBitmap; Amount: Integer);
    class procedure Trace(const Dst: TBitmap; Intensity: Integer);
    class procedure FlipRight(const Dst: TBitmap);
    class procedure FlipDown(const Dst: TBitmap);
    class procedure SpotLight(const Dst: TBitmap; Amount: Integer; Spot: TRect);
    class procedure SplitLight(const Dst: TBitmap; Amount: Integer);
    class procedure MakeSeamlessClip(var Dst: TBitmap; Seam: Integer);
    class procedure Wave(const Dst: TBitmap; Amount, Inference, Style: Integer);
    class procedure Mosaic(const Bm: TBitmap; Size: Integer);
    class procedure SmoothRotate(var Src, Dst: TBitmap; CX, CY: Integer;
      Angle: Single);
    class procedure SmoothResize(var Src, Dst: TBitmap);
    class procedure Twist(var Bmp, Dst: TBitmap; Amount: Integer);
    class procedure SplitBlur(const Dst: TBitmap; Amount: Integer);
    class procedure GaussianBlur(const Dst: TBitmap; Amount: Integer);
    class procedure Smooth(const Dst: TBitmap; Weight: Integer);
    class procedure GrayScale(const Dst: TBitmap);
    class procedure AddColorNoise(const Dst: TBitmap; Amount: Integer);
    class procedure AddMonoNoise(const Dst: TBitmap; Amount: Integer);
    class procedure Contrast(const Dst: TBitmap; Amount: Integer);
    class procedure Lightness(const Dst: TBitmap; Amount: Integer);
    class procedure Saturation(const Dst: TBitmap; Amount: Integer);
    class procedure Spray(const Dst: TBitmap; Amount: Integer);
    class procedure AntiAlias(const Dst: TBitmap);
    class procedure AntiAliasRect(const Dst: TBitmap; XOrigin, YOrigin, XFinal, YFinal: Integer);
    class procedure SmoothPoint(const Dst: TBitmap; XK, YK: Integer);
    class procedure FishEye(var Bmp, Dst: TBitmap; Amount: Single);
    class procedure Marble(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble2(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble3(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble4(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble5(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble6(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble7(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure Marble8(const Src: TBitmap; var Dst: TBitmap; Scale: Single; Turbulence: Integer);
    class procedure SqueezeHor(Src, Dst: TBitmap; Amount: Integer; Style: TLightBrush);
    class procedure SplitRound(Src, Dst: TBitmap; Amount: Integer; Style: TLightBrush);
    class procedure Tile(Src, Dst: TBitmap; Amount: Integer);
    // Interpolator
    // Src: Source bitmap
    // Dst: Destination bitmap
    // Filter: Weight calculation filter
    // AWidth: Relative sample radius
    class procedure Stretch(Src, Dst: TBitmap; Filter: TFilterProc; AWidth: Single);
    class procedure Grow(Src1, Src2, Dst: TBitmap; Amount: Single; X, Y: Integer);
    class procedure Invert(Src: TBitmap);
    class procedure MirrorRight(Src: TBitmap);
    class procedure MirrorDown(Src: TBitmap);
  end;

// Sample filters for use with Stretch()
function SplineFilter(Value: Single): Single;
function BellFilter(Value: Single): Single;
function TriangleFilter(Value: Single): Single;
function BoxFilter(Value: Single): Single;
function HermiteFilter(Value: Single): Single;
function Lanczos3Filter(Value: Single): Single;
function MitchellFilter(Value: Single): Single;

const
  ResampleFilters: array [0..6] of record
    Name: string; // Filter name
    Filter: TFilterProc; // Filter implementation
    Width: Single; // Suggested sampling width/radius
  end = (
    (Name: 'Box'; Filter: BoxFilter; Width: 0.5),
    (Name: 'Triangle'; Filter: TriangleFilter; Width: 1.0),
    (Name: 'Hermite'; Filter: HermiteFilter; Width: 1.0),
    (Name: 'Bell'; Filter: BellFilter; Width: 1.5),
    (Name: 'B-Spline'; Filter: SplineFilter; Width: 2.0),
    (Name: 'Lanczos3'; Filter: Lanczos3Filter; Width: 3.0),
    (Name: 'Mitchell'; Filter: MitchellFilter; Width: 2.0)
    );

implementation

uses
  Math,
  JvQJCLUtils, JvQTypes;

resourcestring
  RsESourceBitmapTooSmall = 'Source bitmap too small';

const  
  bpp = 4; 

function TrimInt(N, Min, Max: Integer): Integer;
begin
  if N > Max then
    Result := Max
  else
  if N < Min then
    Result := Min
  else
    Result := N;
end;

function IntToByte(N: Integer): Byte;
begin
  if N > 255 then
    Result := 255
  else
  if N < 0 then
    Result := 0
  else
    Result := N;
end;

// Just a small function to map the numbers to colors

function ConvertColor(Value: Integer): TColor;
const
  Colors: array [0..15] of TColor =
   (
    clBlack, clNavy, clGreen, clAqua, clRed, clPurple, clMaroon, clSilver,
    clGray, clBlue, clLime, clOlive, clFuchsia, clTeal, clYellow, clWhite
   );
begin
  if (Value < 0) or (Value > High(Colors)) then
    Result := clWhite
  else
    Result := Colors[Value];
end;

function BellFilter(Value: Single): Single;
begin
  if Value < 0.0 then
    Value := -Value;
  if Value < 0.5 then
    Result := 0.75 - Sqr(Value)
  else
  if Value < 1.5 then
  begin
    Value := Value - 1.5;
    Result := 0.5 * Sqr(Value);
  end
  else
    Result := 0.0;
end;

// a.k.a. "Nearest Neighbour" filter
// anme: I have not been able to get acceptable
//       results with this filter for subsampling.

function BoxFilter(Value: Single): Single;
begin
  if (Value > -0.5) and (Value <= 0.5) then
    Result := 1.0
  else
    Result := 0.0;
end;

function HermiteFilter(Value: Single): Single;
begin
  // f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1
  if Value < 0.0 then
    Value := -Value;
  if Value < 1.0 then
    Result := (2.0 * Value - 3.0) * Sqr(Value) + 1.0
  else
    Result := 0.0;
end;

function Lanczos3Filter(Value: Single): Single;

  function SinC(Value: Single): Single;
  begin
    if Value <> 0.0 then
    begin
      Value := Value * Pi;
      Result := Sin(Value) / Value;
    end
    else
      Result := 1.0;
  end;

begin
  if Value < 0.0 then
    Value := -Value;
  if Value < 3.0 then
    Result := SinC(Value) * SinC(Value / 3.0)
  else
    Result := 0.0;
end;

function MitchellFilter(Value: Single): Single;
const
  B = 1.0 / 3.0;
  C = 1.0 / 3.0;
var
  tt: Single;
begin
  if Value < 0.0 then
    Value := -Value;
  tt := Sqr(Value);
  if Value < 1.0 then
  begin
    Value := (((12.0 - 9.0 * B - 6.0 * C) * (Value * tt)) +
      ((-18.0 + 12.0 * B + 6.0 * C) * tt) +
      (6.0 - 2 * B));
    Result := Value / 6.0;
  end
  else
  if Value < 2.0 then
  begin
    Value := (((-1.0 * B - 6.0 * C) * (Value * tt)) +
      ((6.0 * B + 30.0 * C) * tt) +
      ((-12.0 * B - 48.0 * C) * Value) +
      (8.0 * B + 24 * C));
    Result := Value / 6.0;
  end
  else
    Result := 0.0;
end;

// B-spline filter

function SplineFilter(Value: Single): Single;
var
  tt: Single;
begin
  if Value < 0.0 then
    Value := -Value;
  if Value < 1.0 then
  begin
    tt := Sqr(Value);
    Result := 0.5 * tt * Value - tt + 2.0 / 3.0;
  end
  else
  if Value < 2.0 then
  begin
    Value := 2.0 - Value;
    Result := 1.0 / 6.0 * Sqr(Value) * Value;
  end
  else
    Result := 0.0;
end;

// Triangle filter
// a.k.a. "Linear" or "Bilinear" filter

function TriangleFilter(Value: Single): Single;
begin
  if Value < 0.0 then
    Value := -Value;
  if Value < 1.0 then
    Result := 1.0 - Value
  else
    Result := 0.0;
end;

class procedure TJvPaintFX.AddColorNoise(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  X, Y: Integer;
  OPF: TPixelFormat;
begin
  Randomize;
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      Line[X].rgbRed   := IntToByte(Line[X].rgbRed + (Random(Amount) - (Amount shr 1)));
      Line[X].rgbGreen := IntToByte(Line[X].rgbGreen + (Random(Amount) - (Amount shr 1)));
      Line[X].rgbBlue  := IntToByte(Line[X].rgbBlue + (Random(Amount) - (Amount shr 1)));
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.AddMonoNoise(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  X, Y, A: Integer;
  OPF: TPixelFormat;
begin
  Randomize;
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      A := Random(Amount) - (Amount shr 1);
      Line[X].rgbRed   := IntToByte(Line[X].rgbRed + A);
      Line[X].rgbGreen := IntToByte(Line[X].rgbGreen + A);
      Line[X].rgbBlue  := IntToByte(Line[X].rgbBlue + A);
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.AntiAlias(const Dst: TBitmap);
begin  
  JvQJCLUtils.AntiAlias(Dst); 
end;

class procedure TJvPaintFX.AntiAliasRect(const Dst: TBitmap; XOrigin, YOrigin,
  XFinal, YFinal: Integer);
begin  
  JvQJCLUtils.AntiAliasRect(Dst, XOrigin, YOrigin, XFinal, YFinal); 
end;

class procedure TJvPaintFX.Contrast(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  rg, gg, bg, R, G, B, X, Y: Integer;
  OPF: TPixelFormat;
begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      R := Line[X].rgbRed;
      G := Line[X].rgbGreen;
      B := Line[X].rgbBlue;
      rg := (Abs(127 - R) * Amount) div 255;
      gg := (Abs(127 - G) * Amount) div 255;
      bg := (Abs(127 - B) * Amount) div 255;
      if R > 127 then
        R := R + rg
      else
        R := R - rg;
      if G > 127 then
        G := G + gg
      else
        G := G - gg;
      if B > 127 then
        B := B + bg
      else
        B := B - bg;
      Line[X].rgbRed   := IntToByte(R);
      Line[X].rgbGreen := IntToByte(G);
      Line[X].rgbBlue  := IntToByte(B);
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.FishEye(var Bmp, Dst: TBitmap; Amount: Single);
var
  xmid, ymid: Single;
  fx, fy: Single;
  r1, r2: Single;
  ifx, ify: Integer;
  dx, dy: Single;
  rmax: Single;
  ty, tx: Integer;
  weight_x, weight_y: array [0..1] of Single;
  weight: Single;
  new_red, new_green: Integer;
  new_blue: Integer;
  total_red, total_green: Single;
  total_blue: Single;
  ix, iy: Integer;
  sli, slo: PJvRGBArray;
begin
  xmid := Bmp.Width / 2;
  ymid := Bmp.Height / 2;
  rmax := Dst.Width * Amount;

  for ty := 0 to Dst.Height - 1 do
  begin
    for tx := 0 to Dst.Width - 1 do
    begin
      dx := tx - xmid;
      dy := ty - ymid;
      r1 := Sqrt(dx * dx + dy * dy);
      if r1 = 0 then
      begin
        fx := xmid;
        fy := ymid;
      end
      else
      begin
        r2 := rmax / 2 * (1 / (1 - r1 / rmax) - 1);
        fx := dx * r2 / r1 + xmid;
        fy := dy * r2 / r1 + ymid;
      end;
      ify := Trunc(fy);
      ifx := Trunc(fx);
      // Calculate the weights.
      if fy >= 0 then
      begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end
      else
      begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then
      begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end
      else
      begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;

      if ifx < 0 then
        ifx := Bmp.Width - 1 - (-ifx mod Bmp.Width)
      else
      if ifx > Bmp.Width - 1 then
        ifx := ifx mod Bmp.Width;
      if ify < 0 then
        ify := Bmp.Height - 1 - (-ify mod Bmp.Height)
      else
      if ify > Bmp.Height - 1 then
        ify := ify mod Bmp.Height;

      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          if ify + iy < Bmp.Height then
            sli := Bmp.ScanLine[ify + iy]
          else
            sli := Bmp.ScanLine[Bmp.Height - ify - iy];
          if ifx + ix < Bmp.Width then
          begin
            new_red   := sli[ifx + ix].rgbRed;
            new_green := sli[ifx + ix].rgbGreen;
            new_blue  := sli[ifx + ix].rgbBlue;
          end
          else
          begin
            new_red   := sli[Bmp.Width - ifx - ix].rgbRed;
            new_green := sli[Bmp.Width - ifx - ix].rgbGreen;
            new_blue  := sli[Bmp.Width - ifx - ix].rgbBlue;
          end;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      slo := Dst.ScanLine[ty];
      slo[tx].rgbRed   := Round(total_red);
      slo[tx].rgbGreen := Round(total_green);
      slo[tx].rgbBlue  := Round(total_blue);
    end;
  end;
end;

class procedure TJvPaintFX.GaussianBlur(const Dst: TBitmap; Amount: Integer);
var
  I: Integer;
  OPF: TPixelFormat;
begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for I := Amount downto 0 do
    SplitBlur(Dst, 3);
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.GrayScale(const Dst: TBitmap);
var
  Line: PJvRGBArray;
  Gray, X, Y: Integer;
  OPF: TPixelFormat;
begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      Gray := Round(Line[X].rgbRed * 0.3 + Line[X].rgbGreen * 0.59 + Line[X].rgbBlue * 0.11);
      Line[X].rgbRed   := Gray;
      Line[X].rgbGreen := Gray;
      Line[X].rgbBlue  := Gray;
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.Lightness(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  R, G, B, X, Y: Integer;
  OPF: TPixelFormat;
begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      R := Line[X].rgbRed;
      G := Line[X].rgbGreen;
      B := Line[X].rgbBlue;
      Line[X].rgbRed   := IntToByte(R + ((255 - R) * Amount) div 255);
      Line[X].rgbGreen := IntToByte(G + ((255 - G) * Amount) div 255);
      Line[X].rgbBlue  := IntToByte(B + ((255 - B) * Amount) div 255);
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.Darkness(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  R, G, B, X, Y: Integer;
  OPF: TPixelFormat;
begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      R := Line[X].rgbRed;
      G := Line[X].rgbGreen;
      B := Line[X].rgbBlue;
      Line[X].rgbRed   := IntToByte(R - (R * Amount) div 255);
      Line[X].rgbGreen := IntToByte(G - (G * Amount) div 255);
      Line[X].rgbBlue  := IntToByte(B - (B * Amount) div 255);
    end;
  end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.Marble(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Cos((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -Scale * Sin((X mod Turbulence) / Scale);
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble2(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Cos((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -Scale * Sin((X mod Turbulence) / Scale);
      XM := Round(Abs(X + XX - YY));
      YM := Round(Abs(Y + YY - XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble3(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Cos((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -Scale * Sin((X mod Turbulence) / Scale);
      XM := Round(Abs(X - XX + YY));
      YM := Round(Abs(Y - YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble4(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Sin((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -Scale * Cos((X mod Turbulence) / Scale);
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble5(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := H - 1 downto 0 do
  begin
    YY := Scale * Cos((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := W - 1 downto 0 do
    begin
      XX := -Scale * Sin((X mod Turbulence) / Scale);
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble6(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Cos((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -tan((X mod Turbulence) / Scale) / Scale;
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble7(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    YY := Scale * Sin((Y mod Turbulence) / Scale);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := -tan((X mod Turbulence) / Scale) / (Scale * Scale);
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Marble8(const Src: TBitmap; var Dst: TBitmap; Scale: Single;
  Turbulence: Integer);
var
  X, XM, Y, YM: Integer;
  XX, YY: Single;
  Line1, Line2: PJvRGBArray;
  W, H: Integer;
  ax: Single;
  Source: TBitmap;
begin
  if Src = nil then
    Exit;
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Source := TBitmap.Create;
  Source.Assign(Src);
  Dst.PixelFormat := pf24bit;
  Source.PixelFormat := pf24bit;
  H := Src.Height;
  W := Src.Width;
  for Y := 0 to H - 1 do
  begin
    ax := (Y mod Turbulence) / Scale;
    YY := Scale * Sin(ax) * Cos(1.5 * ax);
    Line1 := Source.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      ax := (X mod Turbulence) / Scale;
      XX := -Scale * Sin(2 * ax) * Cos(ax);
      XM := Round(Abs(X + XX + YY));
      YM := Round(Abs(Y + YY + XX));
      if (YM < H) and (XM < W) then
      begin
        Line2 := Dst.ScanLine[YM];
        Line2[XM] := Line1[X];
      end;
    end;
  end;
  Source.Free;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Saturation(const Dst: TBitmap; Amount: Integer);
var
  Line: PJvRGBArray;
  Gray, R, G, B, X, Y: Integer;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      R := Line[X].rgbRed;
      G := Line[X].rgbGreen;
      B := Line[X].rgbBlue;
      Gray := (R + G + B) div 3;
      Line[X].rgbRed   := IntToByte(Gray + (((R - Gray) * Amount) div 255));
      Line[X].rgbGreen := IntToByte(Gray + (((G - Gray) * Amount) div 255));
      Line[X].rgbBlue  := IntToByte(Gray + (((B - Gray) * Amount) div 255));
    end;
  end;
end;

class procedure TJvPaintFX.Smooth(const Dst: TBitmap; Weight: Integer);
var
  Line, Line1, Line2, Line3: PJvRGBArray;
  W, H, X, Y: Integer;
  Src: TBitmap;
  OPF: TPixelFormat;
begin
  if (Dst.Height < 2) or (Dst.Width < 2) then
    Exit;
  W := Dst.Width;
  H := Dst.Height;
  Src := TBitmap.Create;
  Src.Assign(Dst);
  OPF := Dst.PixelFormat;
  Src.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  for Y := 1 to H - 2 do
  begin
    Line := Dst.ScanLine[Y];
    Line1 := Src.ScanLine[Y-1];
    Line2 := Src.ScanLine[Y];
    Line3 := Src.ScanLine[Y+1];
    Line[0].rgbRed   := (Line2[0].rgbRed   + Line2[1].rgbRed   + Line1[0].rgbRed   + Line3[0].rgbRed) div 4;
    Line[0].rgbGreen := (Line2[0].rgbGreen + Line2[1].rgbGreen + Line1[0].rgbGreen + Line3[0].rgbGreen) div 4;
    Line[0].rgbBlue  := (Line2[0].rgbBlue  + Line2[1].rgbBlue  + Line1[0].rgbBlue  + Line3[0].rgbBlue) div 4;
    Line[W-1].rgbRed   := (Line2[W-2].rgbRed   + Line2[W-1].rgbRed   + Line1[W-1].rgbRed   + Line3[W-1].rgbRed) div 4;
    Line[W-1].rgbGreen := (Line2[W-2].rgbGreen + Line2[W-1].rgbGreen + Line1[W-1].rgbGreen + Line3[W-1].rgbGreen) div 4;
    Line[W-1].rgbBlue  := (Line2[W-2].rgbBlue  + Line2[W-1].rgbBlue  + Line1[W-1].rgbBlue  + Line3[W-1].rgbBlue) div 4;
    for X := 1 to W - 2 do
    begin
      Line[X].rgbRed   := (Line2[X-1].rgbRed   + Line2[X+1].rgbRed   + Line1[X].rgbRed   + Line3[X].rgbRed) div 4;
      Line[X].rgbGreen := (Line2[X-1].rgbGreen + Line2[X+1].rgbGreen + Line1[X].rgbGreen + Line3[X].rgbGreen) div 4;
      Line[X].rgbBlue  := (Line2[X-1].rgbBlue  + Line2[X+1].rgbBlue  + Line1[X].rgbBlue  + Line3[X].rgbBlue) div 4;
    end;
  end;
  Line := Dst.ScanLine[0];
  Line1 := Src.ScanLine[0];
  Line2 := Src.ScanLine[0];
  Line3 := Src.ScanLine[1];
  for X := 1 to Dst.Width - 2 do
  begin
    Line[X].rgbRed   := (Line2[X-1].rgbRed   + Line2[X+1].rgbRed   + Line1[X].rgbRed   + Line3[X].rgbRed) div 4;
    Line[X].rgbGreen := (Line2[X-1].rgbGreen + Line2[X+1].rgbGreen + Line1[X].rgbGreen + Line3[X].rgbGreen) div 4;
    Line[X].rgbBlue  := (Line2[X-1].rgbBlue  + Line2[X+1].rgbBlue  + Line1[X].rgbBlue  + Line3[X].rgbBlue) div 4;
  end;
  Line := Dst.ScanLine[H-1];
  Line1 := Src.ScanLine[H-2];
  Line2 := Src.ScanLine[H-1];
  Line3 := Src.ScanLine[H-1];
  for X := 1 to Dst.Width - 2 do
  begin
    Line[X].rgbRed   := (Line2[X-1].rgbRed   + Line2[X+1].rgbRed   + Line1[X].rgbRed   + Line3[X].rgbRed) div 4;
    Line[X].rgbGreen := (Line2[X-1].rgbGreen + Line2[X+1].rgbGreen + Line1[X].rgbGreen + Line3[X].rgbGreen) div 4;
    Line[X].rgbBlue  := (Line2[X-1].rgbBlue  + Line2[X+1].rgbBlue  + Line1[X].rgbBlue  + Line3[X].rgbBlue) div 4;
  end;
  Src.Free;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.SmoothPoint(const Dst: TBitmap; XK, YK: Integer);
var
  Pixel: TColor;
  B, G, R: Cardinal;
begin
  if (XK > 0) and (YK > 0) and (XK < Dst.Width - 1) and (YK < Dst.Height - 1) then
    with Dst.Canvas do
    begin
      Pixel := ColorToRGB(Pixels[XK, YK - 1]);
      R := GetRValue(Pixel);
      B := GetGValue(Pixel);
      G := GetBValue(Pixel);
      Pixel := ColorToRGB(Pixels[XK + 1, YK]);
      R := R + GetRValue(Pixel);
      G := G + GetGValue(Pixel);
      B := B + GetBValue(Pixel);
      Pixel := ColorToRGB(Pixels[XK, YK + 1]);
      R := R + GetRValue(Pixel);
      G := G + GetGValue(Pixel);
      B := B + GetBValue(Pixel);
      Pixel := ColorToRGB(Pixels[XK - 1, YK]);
      R := R + GetRValue(Pixel);
      G := G + GetGValue(Pixel);
      B := B + GetBValue(Pixel);
      Pixels[XK, YK] := RGB(R div 4, G div 4, B div 4);
    end;
end;

class procedure TJvPaintFX.SmoothResize(var Src, Dst: TBitmap);
var
  X, Y, xP, yP, yP2, xP2: Integer;
  Read, Read2: PByteArray;
  t, z, z2, iz2: Integer;
  pc: PByteArray;
  w1, w2, w3, w4: Integer;
  Col1r, col1g, col1b, Col2r, col2g, col2b: Byte;
begin
  xP2 := ((Src.Width - 1) shl 15) div Dst.Width;
  yP2 := ((Src.Height - 1) shl 15) div Dst.Height;
  yP := 0;
  for Y := 0 to Dst.Height - 1 do
  begin
    xP := 0;
    Read := Src.ScanLine[yP shr 15];
    if yP shr 16 < Src.Height - 1 then
      Read2 := Src.ScanLine[yP shr 15 + 1]
    else
      Read2 := Src.ScanLine[yP shr 15];
    pc := Dst.ScanLine[Y];
    z2 := yP and $7FFF;
    iz2 := $8000 - z2;
    for X := 0 to Dst.Width - 1 do
    begin
      t := xP shr 15;
      Col1r := Read[t * bpp];
      Col1g := Read[t * bpp + 1];
      Col1b := Read[t * bpp + 2];
      Col2r := Read2[t * bpp];
      Col2g := Read2[t * bpp + 1];
      Col2b := Read2[t * bpp + 2];
      z := xP and $7FFF;
      w2 := (z * iz2) shr 15;
      w1 := iz2 - w2;
      w4 := (z * z2) shr 15;
      w3 := z2 - w4;
      pc[X * bpp + 2] :=
        (Col1b * w1 + Read[(t + 1) * bpp + 2] * w2 +
        Col2b * w3 + Read2[(t + 1) * bpp + 2] * w4) shr 15;
      pc[X * bpp + 1] :=
        (Col1g * w1 + Read[(t + 1) * bpp + 1] * w2 +
        Col2g * w3 + Read2[(t + 1) * bpp + 1] * w4) shr 15;
      pc[X * bpp] :=
        (Col1r * w1 + Read2[(t + 1) * bpp] * w2 +
        Col2r * w3 + Read2[(t + 1) * bpp] * w4) shr 15;
      Inc(xP, xP2);
    end;
    Inc(yP, yP2);
  end;
end;

class procedure TJvPaintFX.SmoothRotate(var Src, Dst: TBitmap; CX, CY: Integer;
  Angle: Single);
type
  TFColor = record
    B, G, R: Byte
  end;
var
  Top,
    Bottom,
    Left,
    Right,
    eww, nsw,
    fx, fy,
    wx, wy: Single;
  cAngle,
    sAngle: Double;
  xDiff,
    yDiff,
    ifx, ify,
    px, py,
    ix, iy,
    X, Y: Integer;
  nw, ne,
    sw, se: TFColor;
  P1, P2, P3: PByteArray;
begin
  Angle := angle;
  Angle := -Angle * Pi / 180;
  sAngle := Sin(Angle);
  cAngle := Cos(Angle);
  xDiff := (Dst.Width - Src.Width) div 2;
  yDiff := (Dst.Height - Src.Height) div 2;
  for Y := 0 to Dst.Height - 1 do
  begin
    P3 := Dst.ScanLine[Y];
    py := 2 * (Y - CY) + 1;
    for X := 0 to Dst.Width - 1 do
    begin
      px := 2 * (X - CX) + 1;
      fx := (((px * cAngle - py * sAngle) - 1) / 2 + CX) - xDiff;
      fy := (((px * sAngle + py * cAngle) - 1) / 2 + CY) - yDiff;
      ifx := Round(fx);
      ify := Round(fy);

      if (ifx > -1) and (ifx < Src.Width) and (ify > -1) and (ify < Src.Height) then
      begin
        eww := fx - ifx;
        nsw := fy - ify;
        iy := TrimInt(ify + 1, 0, Src.Height - 1);
        ix := TrimInt(ifx + 1, 0, Src.Width - 1);
        P1 := Src.ScanLine[ify];
        P2 := Src.ScanLine[iy];
        nw.R := P1[ifx * bpp];
        nw.G := P1[ifx * bpp + 1];
        nw.B := P1[ifx * bpp + 2];
        ne.R := P1[ix * bpp];
        ne.G := P1[ix * bpp + 1];
        ne.B := P1[ix * bpp + 2];
        sw.R := P2[ifx * bpp];
        sw.G := P2[ifx * bpp + 1];
        sw.B := P2[ifx * bpp + 2];
        se.R := P2[ix * bpp];
        se.G := P2[ix * bpp + 1];
        se.B := P2[ix * bpp + 2];

        Top := nw.B + eww * (ne.B - nw.B);
        Bottom := sw.B + eww * (se.B - sw.B);
        P3[X * bpp + 2] := IntToByte(Round(Top + nsw * (Bottom - Top)));

        Top := nw.G + eww * (ne.G - nw.G);
        Bottom := sw.G + eww * (se.G - sw.G);
        P3[X * bpp + 1] := IntToByte(Round(Top + nsw * (Bottom - Top)));

        Top := nw.R + eww * (ne.R - nw.R);
        Bottom := sw.R + eww * (se.R - sw.R);
        P3[X * bpp] := IntToByte(Round(Top + nsw * (Bottom - Top)));
      end;
    end;
  end;
end;

class procedure TJvPaintFX.SplitBlur(const Dst: TBitmap; Amount: Integer);
var
  p0, p1, p2: PByteArray;
  CX, X, Y: Integer;
  Buf: array[0..3, 0..2] of Byte;
begin
  if Amount = 0 then
    Exit;
  for Y := 0 to Dst.Height - 1 do
  begin
    p0 := Dst.ScanLine[Y];
    if Y - Amount < 0 then
      p1 := Dst.ScanLine[Y]
    else {Y-Amount>0}
      p1 := Dst.ScanLine[Y - Amount];
    if Y + Amount < Dst.Height then
      p2 := Dst.ScanLine[Y + Amount]
    else {Y+Amount>=Height}
      p2 := Dst.ScanLine[Dst.Height - Y];

    for X := 0 to Dst.Width - 1 do
    begin
      if X - Amount < 0 then
        CX := X
      else {X-Amount>0}
        CX := X - Amount;
      Buf[0, 0] := p1[CX * bpp];
      Buf[0, 1] := p1[CX * bpp + 1];
      Buf[0, 2] := p1[CX * bpp + 2];
      Buf[1, 0] := p2[CX * bpp];
      Buf[1, 1] := p2[CX * bpp + 1];
      Buf[1, 2] := p2[CX * bpp + 2];
      if X + Amount < Dst.Width then
        CX := X + Amount
      else {X+Amount>=Width}
        CX := Dst.Width - X;
      Buf[2, 0] := p1[CX * bpp];
      Buf[2, 1] := p1[CX * bpp + 1];
      Buf[2, 2] := p1[CX * bpp + 2];
      Buf[3, 0] := p2[CX * bpp];
      Buf[3, 1] := p2[CX * bpp + 1];
      Buf[3, 2] := p2[CX * bpp + 2];
      p0[X * bpp] := (Buf[0, 0] + Buf[1, 0] + Buf[2, 0] + Buf[3, 0]) shr 2;
      p0[X * bpp + 1] := (Buf[0, 1] + Buf[1, 1] + Buf[2, 1] + Buf[3, 1]) shr 2;
      p0[X * bpp + 2] := (Buf[0, 2] + Buf[1, 2] + Buf[2, 2] + Buf[3, 2]) shr 2;
    end;
  end;
end;

class procedure TJvPaintFX.Spray(const Dst: TBitmap; Amount: Integer);
var
  I, J, X, Y, W, H, Val: Integer;
begin
  H := Dst.Height;
  W := Dst.Width;
  for I := 0 to W - 1 do
    for J := 0 to H - 1 do
    begin
      Val := Random(Amount);
      X := I + Val - Random(Val * 2);
      Y := J + Val - Random(Val * 2);
      if (X > -1) and (X < W) and (Y > -1) and (Y < H) then
        Dst.Canvas.Pixels[I, J] := Dst.Canvas.Pixels[X, Y];
    end;
end;

class procedure TJvPaintFX.Mosaic(const Bm: TBitmap; Size: Integer);
var
  X, Y, i, j: Integer;
  p1, p2: PJvRGBArray;
  P1Val: TJvRGBTriple;
begin
  Y := 0;
  repeat
    p1 := bm.ScanLine[Y];
    repeat
      j := 1;
      repeat
        p2 := bm.ScanLine[Y];
        X := 0;
        repeat
          P1Val := p1[X];
          i := 1;
          repeat
            p2[X] := P1Val;
            Inc(X);
            Inc(i);
          until (i > Size) or (X >= bm.Width);
        until X >= bm.Width;
        Inc(j);
        Inc(Y);
      until (j > Size) or (Y >= bm.Height);
    until (Y >= bm.Height) or (X >= bm.Width);
  until Y >= bm.Height;
end;

class procedure TJvPaintFX.Twist(var Bmp, Dst: TBitmap; Amount: Integer);
var
  fxmid, fymid: Single;
  txmid, tymid: Single;
  fx, fy: Single;
  tx2, ty2: Single;
  R: Single;
  theta: Single;
  ifx, ify: Integer;
  dx, dy: Single;
  OFFSET: Single;
  ty, tx: Integer;
  weight_x, weight_y: array [0..1] of Single;
  weight: Single;
  new_red, new_green: Integer;
  new_blue: Integer;
  total_red, total_green: Single;
  total_blue: Single;
  ix, iy: Integer;
  sli, slo: PByteArray;

  function ArcTan2(xt, yt: Single): Single;
  begin
    if xt = 0 then
      if yt > 0 then
        Result := Pi / 2
      else
        Result := -(Pi / 2)
    else
    begin
      Result := ArcTan(yt / xt);
      if xt < 0 then
        Result := Pi + ArcTan(yt / xt);
    end;
  end;

begin
  OFFSET := -(Pi / 2);
  dx := Bmp.Width - 1;
  dy := Bmp.Height - 1;
  R := Sqrt(dx * dx + dy * dy);
  tx2 := R;
  ty2 := R;
  txmid := (Bmp.Width - 1) / 2; //Adjust these to move center of rotation
  tymid := (Bmp.Height - 1) / 2; //Adjust these to move ......
  fxmid := (Bmp.Width - 1) / 2;
  fymid := (Bmp.Height - 1) / 2;
  if tx2 >= Bmp.Width then
    tx2 := Bmp.Width - 1;
  if ty2 >= Bmp.Height then
    ty2 := Bmp.Height - 1;

  for ty := 0 to Round(ty2) do
  begin
    for tx := 0 to Round(tx2) do
    begin
      dx := tx - txmid;
      dy := ty - tymid;
      R := Sqrt(dx * dx + dy * dy);
      if R = 0 then
      begin
        fx := 0;
        fy := 0;
      end
      else
      begin
        theta := ArcTan2(dx, dy) - R / Amount - OFFSET;
        fx := R * Cos(theta);
        fy := R * Sin(theta);
      end;
      fx := fx + fxmid;
      fy := fy + fymid;

      ify := Trunc(fy);
      ifx := Trunc(fx);
      // Calculate the weights.
      if fy >= 0 then
      begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end
      else
      begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then
      begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end
      else
      begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;

      if ifx < 0 then
        ifx := Bmp.Width - 1 - (-ifx mod Bmp.Width)
      else
      if ifx > Bmp.Width - 1 then
        ifx := ifx mod Bmp.Width;
      if ify < 0 then
        ify := Bmp.Height - 1 - (-ify mod Bmp.Height)
      else
      if ify > Bmp.Height - 1 then
        ify := ify mod Bmp.Height;

      total_red := 0.0;
      total_green := 0.0;
      total_blue := 0.0;
      for ix := 0 to 1 do
      begin
        for iy := 0 to 1 do
        begin
          if ify + iy < Bmp.Height then
            sli := Bmp.ScanLine[ify + iy]
          else
            sli := Bmp.ScanLine[Bmp.Height - ify - iy];
          if ifx + ix < Bmp.Width then
          begin
            new_red := sli[(ifx + ix) * bpp];
            new_green := sli[(ifx + ix) * bpp + 1];
            new_blue := sli[(ifx + ix) * bpp + 2];
          end
          else
          begin
            new_red := sli[(Bmp.Width - ifx - ix) * bpp];
            new_green := sli[(Bmp.Width - ifx - ix) * bpp + 1];
            new_blue := sli[(Bmp.Width - ifx - ix) * bpp + 2];
          end;
          weight := weight_x[ix] * weight_y[iy];
          total_red := total_red + new_red * weight;
          total_green := total_green + new_green * weight;
          total_blue := total_blue + new_blue * weight;
        end;
      end;
      slo := Dst.ScanLine[ty];
      slo[tx * bpp] := Round(total_red);
      slo[tx * bpp + 1] := Round(total_green);
      slo[tx * bpp + 2] := Round(total_blue);
    end;
  end;
end;

class procedure TJvPaintFX.Wave(const Dst: TBitmap; Amount, Inference, Style: Integer);
var
  X, Y: Integer;
  Bitmap: TBitmap;
  P1, P2: PByteArray;
  B: Integer;
  Angle: Extended;
  wavex: Integer;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Assign(Dst);
  wavex := Style;
  Angle := Pi / 2 / Amount;
  for Y := Bitmap.Height - 1 - (2 * Amount) downto Amount do
  begin
    P1 := Bitmap.ScanLine[Y];
    B := 0;
    for X := 0 to Bitmap.Width - 1 do
    begin
      P2 := Dst.ScanLine[Y + Amount + B];
      P2[X * bpp] := P1[X * bpp];
      P2[X * bpp + 1] := P1[X * bpp + 1];
      P2[X * bpp + 2] := P1[X * bpp + 2];
      case wavex of
        0:
          B := Amount * Variant(Sin(Angle * X));
        1:
          B := Amount * Variant(Sin(Angle * X) * Cos(Angle * X));
        2:
          B := Amount * Variant(Sin(Angle * X) * Sin(Inference * Angle * X));
      end;
    end;
  end;
  Bitmap.Free;
end;

class procedure TJvPaintFX.MakeSeamlessClip(var Dst: TBitmap; Seam: Integer);
var
  p0, p1, p2: PByteArray;
  H, W, i, j, sv, sh: Integer;
  f0, f1, f2: real;
begin
  H := Dst.Height;
  W := Dst.Width;
  sv := H div Seam;
  sh := W div Seam;
  p1 := Dst.ScanLine[0];
  p2 := Dst.ScanLine[H - 1];
  for i := 0 to W - 1 do
  begin
    p1[i * bpp] := p2[i * bpp];
    p1[i * bpp + 1] := p2[i * bpp + 1];
    p1[i * bpp + 2] := p2[i * bpp + 2];
  end;
  p0 := Dst.ScanLine[0];
  p2 := Dst.ScanLine[sv];
  for j := 1 to sv - 1 do
  begin
    p1 := Dst.ScanLine[j];
    for i := 0 to W - 1 do
    begin
      f0 := (p2[i * bpp] - p0[i * bpp]) / sv * j + p0[i * bpp];
      p1[i * bpp] := Round(f0);
      f1 := (p2[i * bpp + 1] - p0[i * bpp + 1]) / sv * j + p0[i * bpp + 1];
      p1[i * bpp + 1] := Round(f1);
      f2 := (p2[i * bpp + 2] - p0[i * bpp + 2]) / sv * j + p0[i * bpp + 2];
      p1[i * bpp + 2] := Round(f2);
    end;
  end;
  for j := 0 to H - 1 do
  begin
    p1 := Dst.ScanLine[j];
    p1[(W - 1) * bpp] := p1[0];
    p1[(W - 1) * bpp + 1] := p1[1];
    p1[(W - 1) * bpp + 2] := p1[2];
    for i := 1 to sh - 1 do
    begin
      f0 := (p1[(W - sh) * bpp] - p1[(W - 1) * bpp]) / sh * i + p1[(W - 1) * bpp];
      p1[(W - 1 - i) * bpp] := Round(f0);
      f1 := (p1[(W - sh) * bpp + 1] - p1[(W - 1) * bpp + 1]) / sh * i + p1[(W - 1) * bpp + 1];
      p1[(W - 1 - i) * bpp + 1] := Round(f1);
      f2 := (p1[(W - sh) * bpp + 2] - p1[(W - 1) * bpp + 2]) / sh * i + p1[(W - 1) * bpp + 2];
      p1[(W - 1 - i) * bpp + 2] := Round(f2);
    end;
  end;
end;

class procedure TJvPaintFX.SplitLight(const Dst: TBitmap; Amount: Integer);
var
  X, Y, I: Integer;
  P: PJvRGBArray;
  OPF: TPixelFormat;

  function Sinus(A: Integer): Integer;
  begin
    Result := Round(Sin(A / 255 * Pi / 2) * 255);
  end;

begin
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  for I := 1 to Amount do
    for Y := 0 to Dst.Height - 1 do
    begin
      P := Dst.ScanLine[Y];
      for X := 0 to Dst.Width - 1 do
      begin
        P[X].rgbBlue  := Sinus(P[X].rgbBlue);
        P[X].rgbGreen := Sinus(P[X].rgbGreen);
        P[X].rgbRed   := Sinus(P[X].rgbRed);
      end;
    end;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.SqueezeHor(Src, Dst: TBitmap; Amount: Integer; Style: TLightBrush);
var
  dx, X, Y, c, CX: Integer;
  R: TRect;
  bm: TBitmap;
  p0, p1: PByteArray;
begin
  if Amount > (Src.Width div 2) then
    Amount := Src.Width div 2;
  bm := TBitmap.Create;
  bm.PixelFormat := pf24bit;
  bm.Height := 1;
  bm.Width := Src.Width;
  CX := Src.Width div 2;
  p0 := bm.ScanLine[0];
  for Y := 0 to Src.Height - 1 do
  begin
    p1 := Src.ScanLine[Y];
    for X := 0 to Src.Width - 1 do
    begin
      c := X * bpp;
      p0[c] := p1[c];
      p0[c + 1] := p1[c + 1];
      p0[c + 2] := p1[c + 2];
    end;
    case Style of
      mbhor:
        begin
          dx := Amount;
          R := Rect(dx, Y, Src.Width - dx, Y + 1);
        end;
      mbtop:
        begin
          dx := Round((Src.Height - 1 - Y) / Src.Height * Amount);
          R := Rect(dx, Y, Src.Width - dx, Y + 1);
        end;
      mbBottom:
        begin
          dx := Round(Y / Src.Height * Amount);
          R := Rect(dx, Y, Src.Width - dx, Y + 1);
        end;
      mbDiamond:
        begin
          dx := Round(Amount * Abs(Cos(Y / (Src.Height - 1) * Pi)));
          R := Rect(dx, Y, Src.Width - dx, Y + 1);
        end;
      mbWaste:
        begin
          dx := Round(Amount * Abs(Sin(Y / (Src.Height - 1) * Pi)));
          R := Rect(dx, Y, Src.Width - dx, Y + 1);
        end;
      mbRound:
        begin
          dx := Round(Amount * Abs(Sin(Y / (Src.Height - 1) * Pi)));
          R := Rect(CX - dx, Y, CX + dx, Y + 1);
        end;
      mbRound2:
        begin
          dx := Round(Amount * Abs(Sin(Y / (Src.Height - 1) * Pi * 2)));
          R := Rect(CX - dx, Y, CX + dx, Y + 1);
        end;
    end;
    Dst.Canvas.StretchDraw(R, bm);
  end;
  bm.Free;
end;

class procedure TJvPaintFX.Tile(Src, Dst: TBitmap; Amount: Integer);
var
  w2, h2, i, j: Integer;
  Bmp: TBitmap;
begin
  Dst.Assign(Src);
  if (Amount <= 0) or ((Src.Width div Amount) < 5) or ((Src.Height div Amount) < 5) then
    Exit;
  h2 := Src.Width div Amount;
  w2 := Src.Height div Amount;
  Bmp := TBitmap.Create;
  Bmp.Width := w2;
  Bmp.Height := h2;
  Bmp.PixelFormat := pf24bit;
  SmoothResize(Src, Bmp);
  for j := 0 to Amount - 1 do
    for i := 0 to Amount - 1 do
      Dst.Canvas.Draw(i * w2, j * h2, Bmp);
  Bmp.Free;
end;

// ---------------------------------------------------------------------------
// Interpolator
// ---------------------------------------------------------------------------
type
  // Contributor for a pixel
  TContributor = record
    pixel: Integer; // Source pixel
    weight: Single; // Pixel weight
  end;

  TContributorList = array [0..0] of TContributor;
  PContributorList = ^TContributorList;

  // List of source pixels contributing to a destination pixel
  TCList = record
    n: Integer;
    p: PContributorList;
  end;

  TCListList = array[0..0] of TCList;
  PCListList = ^TCListList;

  TRGB = packed record
    R, G, B: Single;
  end;

  // Physical bitmap pixel
  TColorRGB = packed record
    R, G, B: BYTE;
  end;
  PColorRGB = ^TColorRGB;

  // Physical bitmap ScanLine (row)
  TRGBList = packed array[0..0] of TColorRGB;
  PRGBList = ^TRGBList;

class procedure TJvPaintFX.Stretch(Src, Dst: TBitmap; Filter: TFilterProc;
  AWidth: Single);
var
  xscale, yscale: Single; // Zoom Scale factors
  i, j, k: Integer; // Loop variables
  center: Single; // Filter calculation variables
  Width, fscale, weight: Single; // Filter calculation variables
  left, right: Integer; // Filter calculation variables
  n: Integer; // Pixel number
  Work: TBitmap;
  contrib: PCListList;
  rgb: TRGB;
  color: TColorRGB;
  SourceLine, DestLine: PRGBList;
  SourcePixel, DestPixel: PColorRGB;
  Delta, DestDelta: Integer;
  SrcWidth, SrcHeight, DstWidth, DstHeight: Integer;

  function Color2RGB(Color: TColor): TColorRGB;
  begin
    Result.R := Color and $000000FF;
    Result.G := (Color and $0000FF00) shr 8;
    Result.B := (Color and $00FF0000) shr 16;
  end;

  function RGB2Color(Color: TColorRGB): TColor;
  begin
    Result := Color.R or (Color.G shl 8) or (Color.B shl 16);
  end;

begin
  DstWidth := Dst.Width;
  DstHeight := Dst.Height;
  SrcWidth := Src.Width;
  SrcHeight := Src.Height;
  if (SrcWidth < 1) or (SrcHeight < 1) then
    raise Exception.CreateRes(@RsESourceBitmapTooSmall);

  // Create intermediate image to hold horizontal zoom
  Work := TBitmap.Create;
  try
    Work.Height := SrcHeight;
    Work.Width := DstWidth;
    // xscale := DstWidth / SrcWidth;
    // yscale := DstHeight / SrcHeight;
    // Improvement suggested by David Ullrich:
    if (SrcWidth = 1) then
      xscale := DstWidth / SrcWidth
    else
      xscale := (DstWidth - 1) / (SrcWidth - 1);
    if (SrcHeight = 1) then
      yscale := DstHeight / SrcHeight
    else
      yscale := (DstHeight - 1) / (SrcHeight - 1);
    // This implementation only works on 24-bit images because it uses
    // TBitmap.ScanLine
    Src.PixelFormat := pf24bit;
    Dst.PixelFormat := Src.PixelFormat;
    Work.PixelFormat := Src.PixelFormat;

    // --------------------------------------------
    // Pre-calculate filter contributions for a row
    // -----------------------------------------------
    GetMem(contrib, DstWidth * SizeOf(TCList));
    // Horizontal sub-sampling
    // Scales from bigger to smaller Width
    if (xscale < 1.0) then
    begin
      Width := AWidth / xscale;
      fscale := 1.0 / xscale;
      for i := 0 to DstWidth - 1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(Width * 2.0 + 1) * SizeOf(TContributor));
        center := i / xscale;
        // Original code:
        // left := ceil(center - Width);
        // right := floor(center + Width);
        left := floor(center - Width);
        right := ceil(center + Width);
        for j := left to right do
        begin
          weight := Filter((center - j) / fscale) / fscale;
          if (weight = 0.0) then
            Continue;
          if (j < 0) then
            n := -j
          else
          if (j >= SrcWidth) then
            n := SrcWidth - j + SrcWidth - 1
          else
            n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end;
    end
    else
      // Horizontal super-sampling
      // Scales from smaller to bigger Width
    begin
      for i := 0 to DstWidth - 1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(AWidth * 2.0 + 1) * SizeOf(TContributor));
        center := i / xscale;
        // Original code:
        // left := ceil(center - AWidth);
        // right := floor(center + AWidth);
        left := floor(center - AWidth);
        right := ceil(center + AWidth);
        for j := left to right do
        begin
          weight := Filter(center - j);
          if (weight = 0.0) then
            Continue;
          if j < 0 then
            n := -j
          else
          if j >= SrcWidth then
            n := SrcWidth - j + SrcWidth - 1
          else
            n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end;
    end;

    // ----------------------------------------------------
    // Apply filter to sample horizontally from Src to Work
    // ----------------------------------------------------
    for k := 0 to SrcHeight - 1 do
    begin
      SourceLine := Src.ScanLine[k];
      DestPixel := Work.ScanLine[k];
      for i := 0 to DstWidth - 1 do
      begin
        rgb.R := 0.0;
        rgb.G := 0.0;
        rgb.B := 0.0;
        for j := 0 to contrib^[i].n - 1 do
        begin
          color := SourceLine^[contrib^[i].p^[j].pixel];
          weight := contrib^[i].p^[j].weight;
          if (weight = 0.0) then
            Continue;
          rgb.R := rgb.R + color.R * weight;
          rgb.G := rgb.G + color.G * weight;
          rgb.B := rgb.B + color.B * weight;
        end;
        if rgb.R > 255.0 then
          color.R := 255
        else
        if rgb.R < 0.0 then
          color.R := 0
        else
          color.R := Round(rgb.R);
        if rgb.G > 255.0 then
          color.G := 255
        else
        if rgb.G < 0.0 then
          color.G := 0
        else
          color.G := Round(rgb.G);
        if rgb.B > 255.0 then
          color.B := 255
        else
        if rgb.B < 0.0 then
          color.B := 0
        else
          color.B := Round(rgb.B);
        // Set new pixel value
        DestPixel^ := color;
        // Move on to next column
        Inc(DestPixel);
      end;
    end;

    // Free the memory allocated for horizontal filter weights
    for i := 0 to DstWidth - 1 do
      FreeMem(contrib^[i].p);

    FreeMem(contrib);

    // -----------------------------------------------
    // Pre-calculate filter contributions for a column
    // -----------------------------------------------
    GetMem(contrib, DstHeight * SizeOf(TCList));
    // Vertical sub-sampling
    // Scales from bigger to smaller Height
    if (yscale < 1.0) then
    begin
      Width := AWidth / yscale;
      fscale := 1.0 / yscale;
      for i := 0 to DstHeight - 1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(Width * 2.0 + 1) * SizeOf(TContributor));
        center := i / yscale;
        // Original code:
        // left := ceil(center - Width);
        // right := floor(center + Width);
        left := floor(center - Width);
        right := ceil(center + Width);
        for j := left to right do
        begin
          weight := Filter((center - j) / fscale) / fscale;
          if weight = 0.0 then
            Continue;
          if j < 0 then
            n := -j
          else
          if j >= SrcHeight then
            n := SrcHeight - j + SrcHeight - 1
          else
            n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end
    end
    else
      // Vertical super-sampling
      // Scales from smaller to bigger Height
    begin
      for i := 0 to DstHeight - 1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(AWidth * 2.0 + 1) * SizeOf(TContributor));
        center := i / yscale;
        // Original code:
        // left := ceil(center - AWidth);
        // right := floor(center + AWidth);
        left := floor(center - AWidth);
        right := ceil(center + AWidth);
        for j := left to right do
        begin
          weight := Filter(center - j);
          if weight = 0.0 then
            Continue;
          if j < 0 then
            n := -j
          else
          if j >= SrcHeight then
            n := SrcHeight - j + SrcHeight - 1
          else
            n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end;
    end;

    // --------------------------------------------------
    // Apply filter to sample vertically from Work to Dst
    // --------------------------------------------------
    SourceLine := Work.ScanLine[0];
    Delta := Integer(Work.ScanLine[1]) - Integer(SourceLine);
    DestLine := Dst.ScanLine[0];
    DestDelta := Integer(Dst.ScanLine[1]) - Integer(DestLine);
    for k := 0 to DstWidth - 1 do
    begin
      DestPixel := pointer(DestLine);
      for i := 0 to DstHeight - 1 do
      begin
        rgb.R := 0;
        rgb.G := 0;
        rgb.B := 0;
        // weight := 0.0;
        for j := 0 to contrib^[i].n - 1 do
        begin
          color := PColorRGB(Integer(SourceLine) + contrib^[i].p^[j].pixel * Delta)^;
          weight := contrib^[i].p^[j].weight;
          if (weight = 0.0) then
            Continue;
          rgb.R := rgb.R + color.R * weight;
          rgb.G := rgb.G + color.G * weight;
          rgb.B := rgb.B + color.B * weight;
        end;
        if rgb.R > 255.0 then
          color.R := 255
        else
        if rgb.R < 0.0 then
          color.R := 0
        else
          color.R := Round(rgb.R);
        if rgb.G > 255.0 then
          color.G := 255
        else
        if rgb.G < 0.0 then
          color.G := 0
        else
          color.G := Round(rgb.G);
        if rgb.B > 255.0 then
          color.B := 255
        else
        if rgb.B < 0.0 then
          color.B := 0
        else
          color.B := Round(rgb.B);
        DestPixel^ := color;
        Inc(Integer(DestPixel), DestDelta);
      end;
      Inc(SourceLine, 1);
      Inc(DestLine, 1);
    end;

    // Free the memory allocated for vertical filter weights
    for i := 0 to DstHeight - 1 do
      FreeMem(contrib^[i].p);

    FreeMem(contrib);
  finally
    Work.Free;
  end;
end;

class procedure TJvPaintFX.Grow(Src1, Src2, Dst: TBitmap; Amount: Single; X, Y: Integer);
var
  Bmp: TBitmap;
begin
  Dst.Assign(Src1);
  Bmp := TBitmap.Create;
  Bmp.Width := Round(Amount * Src1.Width);
  Bmp.Height := Round(Amount * Src1.Height);
  Stretch(Src2, Bmp, ResampleFilters[4].Filter, ResampleFilters[4].Width);
  Dst.Canvas.Draw(X, Y, Bmp);
  Bmp.Free;
end;

class procedure TJvPaintFX.SpotLight(const Dst: TBitmap; Amount: Integer; Spot: TRect);
var
  Bmp: TBitmap;
begin
  Darkness(Dst, Amount);
  Bmp := TBitmap.Create;
  Bmp.Width := Dst.Width;
  Bmp.Height := Dst.Height;
  Bmp.Canvas.Brush.Color := clBlack;
  Bmp.Canvas.FillRect(Rect(0, 0, Dst.Width, Dst.Height));
  Bmp.Canvas.Brush.Color := clWhite;
  Bmp.Canvas.Ellipse(Spot.Left, Spot.Top, Spot.Right, Spot.Bottom);
  Bmp.Transparent := True;
  Bmp.TransparentColor := clWhite;
  Dst.Canvas.Draw(0, 0, Bmp);
  Bmp.Free;
end;

class procedure TJvPaintFX.FlipDown(const Dst: TBitmap);
var
  Bmp: TBitmap;
  W, H, X, Y: Integer;
  pd, ps: PByteArray;
begin
  W := Dst.Width;
  H := Dst.Height;
  Bmp := TBitmap.Create;
  Bmp.Width := W;
  Bmp.Height := H;
  Bmp.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    pd := Bmp.ScanLine[Y];
    ps := Dst.ScanLine[H - 1 - Y];
    for X := 0 to W - 1 do
    begin
      pd[X * bpp] := ps[X * bpp];
      pd[X * bpp + 1] := ps[X * bpp + 1];
      pd[X * bpp + 2] := ps[X * bpp + 2];
    end;
  end;
  Dst.Assign(Bmp);
  Bmp.Free;
end;

class procedure TJvPaintFX.FlipRight(const Dst: TBitmap);
var
  dest: TBitmap;
  W, H, X, Y: Integer;
  pd, ps: PByteArray;
begin
  W := Dst.Width;
  H := Dst.Height;
  dest := TBitmap.Create;
  dest.Width := W;
  dest.Height := H;
  dest.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    pd := dest.ScanLine[Y];
    ps := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      pd[X * bpp] := ps[(W - 1 - X) * bpp];
      pd[X * bpp + 1] := ps[(W - 1 - X) * bpp + 1];
      pd[X * bpp + 2] := ps[(W - 1 - X) * bpp + 2];
    end;
  end;
  Dst.Assign(dest);
  dest.Free;
end;

class procedure TJvPaintFX.Trace(const Dst: TBitmap; Intensity: Integer);
var
  X, Y, i: Integer;
  P1, P2, P3, P4: PByteArray;
  tb, TraceB: Byte;
  hasb: Boolean;
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := Dst.Width;
  Bitmap.Height := Dst.Height;
  Bitmap.Canvas.draw(0, 0, Dst);
  Bitmap.PixelFormat := pf8bit;
  Dst.PixelFormat := pf24bit;
  hasb := False;
  TraceB := $00;
  tb := 0;
  for i := 1 to Intensity do
  begin
    for Y := 0 to Bitmap.Height - 2 do
    begin
      P1 := Bitmap.ScanLine[Y];
      P2 := Bitmap.ScanLine[Y + 1];
      P3 := Dst.ScanLine[Y];
      P4 := Dst.ScanLine[Y + 1];
      X := 0;
      repeat
        if p1[X] <> p1[X + 1] then
        begin
          if not hasb then
          begin
            tb := p1[X + 1];
            hasb := True;
            p3[X * bpp] := TraceB;
            p3[X * bpp + 1] := TraceB;
            p3[X * bpp + 2] := TraceB;
          end
          else
          begin
            if p1[X] <> tb then
            begin
              p3[X * bpp] := TraceB;
              p3[X * bpp + 1] := TraceB;
              p3[X * bpp + 2] := TraceB;
            end
            else
            begin
              p3[(X + 1) * bpp] := TraceB;
              p3[(X + 1) * bpp + 1] := TraceB;
              p3[(X + 1) * bpp + 1] := TraceB;
            end;
          end;
        end;
        if p1[X] <> p2[X] then
        begin
          if not hasb then
          begin
            tb := p2[X];
            hasb := True;
            p3[X * bpp] := TraceB;
            p3[X * bpp + 1] := TraceB;
            p3[X * bpp + 2] := TraceB;
          end
          else
          begin
            if p1[X] <> tb then
            begin
              p3[X * bpp] := TraceB;
              p3[X * bpp + 1] := TraceB;
              p3[X * bpp + 2] := TraceB;
            end
            else
            begin
              p4[X * bpp] := TraceB;
              p4[X * bpp + 1] := TraceB;
              p4[X * bpp + 2] := TraceB;
            end;
          end;
        end;
        Inc(X);
      until X >= (Bitmap.Width - 2);
    end;
    // do the same in the opposite direction
    // only when Intensity > 1
    if i > 1 then
      for Y := Bitmap.Height - 1 downto 1 do
      begin
        P1 := Bitmap.ScanLine[Y];
        P2 := Bitmap.ScanLine[Y - 1];
        P3 := Dst.ScanLine[Y];
        P4 := Dst.ScanLine[Y - 1];
        X := Bitmap.Width - 1;
        repeat
          if p1[X] <> p1[X - 1] then
          begin
            if not hasb then
            begin
              tb := p1[X - 1];
              hasb := True;
              p3[X * bpp] := TraceB;
              p3[X * bpp + 1] := TraceB;
              p3[X * bpp + 2] := TraceB;
            end
            else
            begin
              if p1[X] <> tb then
              begin
                p3[X * bpp] := TraceB;
                p3[X * bpp + 1] := TraceB;
                p3[X * bpp + 2] := TraceB;
              end
              else
              begin
                p3[(X - 1) * bpp] := TraceB;
                p3[(X - 1) * bpp + 1] := TraceB;
                p3[(X - 1) * bpp + 2] := TraceB;
              end;
            end;
          end;
          if p1[X] <> p2[X] then
          begin
            if not hasb then
            begin
              tb := p2[X];
              hasb := True;
              p3[X * bpp] := TraceB;
              p3[X * bpp + 1] := TraceB;
              p3[X * bpp + 2] := TraceB;
            end
            else
            begin
              if p1[X] <> tb then
              begin
                p3[X * bpp] := TraceB;
                p3[X * bpp + 1] := TraceB;
                p3[X * bpp + 2] := TraceB;
              end
              else
              begin
                p4[X * bpp] := TraceB;
                p4[X * bpp + 1] := TraceB;
                p4[X * bpp + 2] := TraceB;
              end;
            end;
          end;
          Dec(X);
        until X <= 1;
      end;
  end;
  Bitmap.Free;
end;

class procedure TJvPaintFX.ShadowUpLeft(const Dst: TBitmap);
var
  X, Y: Integer;
  Bitmap: TBitmap;
  P1, P2: PByteArray;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := Dst.Width;
  Bitmap.Height := Dst.Height;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.draw(0, 0, Dst);
  for Y := 0 to Bitmap.Height - 5 do
  begin
    P1 := Bitmap.ScanLine[Y];
    P2 := Bitmap.ScanLine[Y + 4];
    for X := 0 to Bitmap.Width - 5 do
      if P1[X * bpp] > P2[(X + 4) * bpp] then
      begin
        P1[X * bpp] := P2[(X + 4) * bpp] + 1;
        P1[X * bpp + 1] := P2[(X + 4) * bpp + 1] + 1;
        P1[X * bpp + 2] := P2[(X + 4) * bpp + 2] + 1;
      end;
  end;
  Dst.Assign(Bitmap);
  Bitmap.Free;
end;

class procedure TJvPaintFX.ShadowUpRight(const Dst: TBitmap);
var
  X, Y: Integer;
  Bitmap: TBitmap;
  P1, P2: PByteArray;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := Dst.Width;
  Bitmap.Height := Dst.Height;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.draw(0, 0, Dst);
  for Y := 0 to Bitmap.Height - 5 do
  begin
    P1 := Bitmap.ScanLine[Y];
    P2 := Bitmap.ScanLine[Y + 4];
    for X := Bitmap.Width - 1 downto 4 do
      if P1[X * bpp] > P2[(X - 4) * bpp] then
      begin
        P1[X * bpp] := P2[(X - 4) * bpp] + 1;
        P1[X * bpp + 1] := P2[(X - 4) * bpp + 1] + 1;
        P1[X * bpp + 2] := P2[(X - 4) * bpp + 2] + 1;
      end;
  end;
  Dst.Assign(Bitmap);
  Bitmap.Free;
end;

class procedure TJvPaintFX.ShadowDownLeft(const Dst: TBitmap);
var
  X, Y: Integer;
  Bitmap: TBitmap;
  P1, P2: PByteArray;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := Dst.Width;
  Bitmap.Height := Dst.Height;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.draw(0, 0, Dst);
  for Y := Bitmap.Height - 1 downto 4 do
  begin
    P1 := Bitmap.ScanLine[Y];
    P2 := Bitmap.ScanLine[Y - 4];
    for X := 0 to Bitmap.Width - 5 do
      if P1[X * bpp] > P2[(X + 4) * bpp] then
      begin
        P1[X * bpp] := P2[(X + 4) * bpp] + 1;
        P1[X * bpp + 1] := P2[(X + 4) * bpp + 1] + 1;
        P1[X * bpp + 2] := P2[(X + 4) * bpp + 2] + 1;
      end;
  end;
  Dst.Assign(Bitmap);
  Bitmap.Free;
end;

class procedure TJvPaintFX.ShadowDownRight(const Dst: TBitmap);
var
  X, Y: Integer;
  Bitmap: TBitmap;
  P1, P2: PByteArray;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := Dst.Width;
  Bitmap.Height := Dst.Height;
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Canvas.draw(0, 0, Dst);
  for Y := Bitmap.Height - 1 downto 4 do
  begin
    P1 := Bitmap.ScanLine[Y];
    P2 := Bitmap.ScanLine[Y - 4];
    for X := Bitmap.Width - 1 downto 4 do
      if P1[X * bpp] > P2[(X - 4) * bpp] then
      begin
        P1[X * bpp] := P2[(X - 4) * bpp] + 1;
        P1[X * bpp + 1] := P2[(X - 4) * bpp + 1] + 1;
        P1[X * bpp + 2] := P2[(X - 4) * bpp + 2] + 1;
      end;
  end;
  Dst.Assign(Bitmap);
  Bitmap.Free;
end;

class procedure TJvPaintFX.SemiOpaque(Src, Dst: TBitmap);
var
  B: TBitmap;
  P: PByteArray;
  X, Y: Integer;
begin
  B := TBitmap.Create;
  B.Width := Src.Width;
  B.Height := Src.Height;
  B.PixelFormat := pf24bit;
  B.Canvas.draw(0, 0, Src);
  for Y := 0 to B.Height - 1 do
  begin
    p := B.ScanLine[Y];
    if (Y mod 2) = 0 then
    begin
      for X := 0 to B.Width - 1 do
        if (X mod 2) = 0 then
        begin
          p[X * bpp] := $FF;
          p[X * bpp + 1] := $FF;
          p[X * bpp + 2] := $FF;
        end;
    end
    else
    begin
      for X := 0 to B.Width - 1 do
        if ((X + 1) mod 2) = 0 then
        begin
          p[X * bpp] := $FF;
          p[X * bpp + 1] := $FF;
          p[X * bpp + 2] := $FF;
        end;
    end;
  end;
  B.Transparent := True;
  B.TransparentColor := clWhite;
  Dst.Canvas.draw(0, 0, B);
  B.Free;

end;

class procedure TJvPaintFX.QuartoOpaque(Src, Dst: TBitmap);
var
  B: TBitmap;
  P: PByteArray;
  X, Y: Integer;
begin
  B := TBitmap.Create;
  B.Width := Src.Width;
  B.Height := Src.Height;
  B.PixelFormat := pf24bit;
  B.Canvas.draw(0, 0, Src);
  for Y := 0 to B.Height - 1 do
  begin
    p := B.ScanLine[Y];
    if (Y mod 2) = 0 then
    begin
      for X := 0 to B.Width - 1 do
        if (X mod 2) = 0 then
        begin
          p[X * bpp] := $FF;
          p[X * bpp + 1] := $FF;
          p[X * bpp + 2] := $FF;
        end;
    end
    else
    begin
      for X := 0 to B.Width - 1 do
      begin
        p[X * bpp] := $FF;
        p[X * bpp + 1] := $FF;
        p[X * bpp + 2] := $FF;
      end;

    end;
  end;
  B.Transparent := True;
  B.TransparentColor := clWhite;
  Dst.Canvas.draw(0, 0, B);
  B.Free;
end;

class procedure TJvPaintFX.FoldRight(Src1, Src2, Dst: TBitmap; Amount: Single);
var
  W, H, X, Y, xf, xf0: Integer;
  ps1, ps2, pd: PByteArray;
begin
  Src1.PixelFormat := pf24bit;
  Src2.PixelFormat := pf24bit;
  W := Src1.Width;
  H := Src2.Height;
  Dst.Width := W;
  Dst.Height := H;
  Dst.PixelFormat := pf24bit;
  xf := Round(Amount * W);
  for Y := 0 to H - 1 do
  begin
    ps1 := Src1.ScanLine[Y];
    ps2 := Src2.ScanLine[Y];
    pd := Dst.ScanLine[Y];
    for X := 0 to xf do
    begin
      xf0 := xf + (xf - X);
      if xf0 < W then
      begin
        pd[xf0 * bpp] := ps1[X * bpp];
        pd[xf0 * bpp + 1] := ps1[X * bpp + 1];
        pd[xf0 * bpp + 2] := ps1[X * bpp + 2];
        pd[X * bpp] := ps2[X * bpp];
        pd[X * bpp + 1] := ps2[X * bpp + 1];
        pd[X * bpp + 2] := ps2[X * bpp + 2];
      end;
    end;
    if (2 * xf) < W - 1 then
      for X := 2 * xf + 1 to W - 1 do
      begin
        pd[X * bpp] := ps1[X * bpp];
        pd[X * bpp + 1] := ps1[X * bpp + 1];
        pd[X * bpp + 2] := ps1[X * bpp + 2];
      end;
  end;
end;

class procedure TJvPaintFX.Mandelbrot(const Dst: TBitmap; Factor: Integer);
const
  maxX = 1.25;
  minX = -2;
  maxY = 1.25;
  minY = -1.25;
var
  W, H, X, Y : Integer;
  dx, dy: Extended;
  Line: PByteArray;
  color: Integer;

  function IsMandel(CA, CBi: Extended): Integer;
  const
    MAX_ITERATION = 64;
  var
    OLD_A: Extended; {just a variable to keep 'a' from being destroyed}
    A, B: Extended; {function Z divided in real and imaginary parts}
    LENGTH_Z: Extended; {length of Z, sqrt(length_z)>2 => Z->infinity}
    iteration: Integer;
  begin
    A := 0; {initialize Z(0) = 0}
    B := 0;
    ITERATION := 0; {initialize iteration}
    repeat
      OLD_A := A; {saves the 'a'  (Will be destroyed in next line}
      A := A * A - B * B + CA;
      B := 2 * OLD_A * B + CBi;
      ITERATION := ITERATION + 1;
      LENGTH_Z := A * A + B * B;
    until (LENGTH_Z >= 4) or (ITERATION > MAX_ITERATION);
    Result := iteration;
  end;

begin
  W := Dst.Width;
  H := Dst.Height;
  Dst.PixelFormat := pf24bit;
  dx := (MaxX - MinX) / W;
  dy := (Maxy - MinY) / H;
  for Y := 0 to H - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      color := IsMandel(MinX + X * dx, MinY + Y * dy);
      if color > Factor then
        color := $FF
      else
        color := $00;
      Line[X * bpp] := color;
      Line[X * bpp + 1] := color;
      Line[X * bpp + 2] := color;
    end;
  end;
end;

class procedure TJvPaintFX.MaskMandelbrot(const Dst: TBitmap; Factor: Integer);
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  bm.Width := Dst.Width;
  bm.Height := Dst.Height;
  Mandelbrot(bm, Factor);
  bm.Transparent := True;
  bm.TransparentColor := clWhite;
  Dst.Canvas.draw(0, 0, bm);
  bm.Free;
end;

class procedure TJvPaintFX.KeepBlue(const Dst: TBitmap; Factor: Single);
var
  X, Y, W, H: Integer;
  Line: PByteArray;
begin
  Dst.PixelFormat := pf24bit;
  W := Dst.Width;
  H := Dst.Height;
  for Y := 0 to H - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      Line[X * bpp] := Round(Factor * Line[X * bpp]);
      Line[X * bpp + 1] := 0;
      Line[X * bpp + 2] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.KeepGreen(const Dst: TBitmap; Factor: Single);
var
  X, Y, W, H: Integer;
  Line: PByteArray;
begin
  Dst.PixelFormat := pf24bit;
  W := Dst.Width;
  H := Dst.Height;
  for Y := 0 to H - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      Line[X * bpp + 1] := Round(Factor * Line[X * bpp + 1]);
      Line[X * bpp] := 0;
      Line[X * bpp + 2] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.KeepRed(const Dst: TBitmap; Factor: Single);
var
  X, Y, W, H: Integer;
  Line: PByteArray;
begin
  Dst.PixelFormat := pf24bit;
  W := Dst.Width;
  H := Dst.Height;
  for Y := 0 to H - 1 do
  begin
    Line := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      Line[X * bpp + 2] := Round(Factor * Line[X * bpp + 2]);
      Line[X * bpp + 1] := 0;
      Line[X * bpp] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.Shake(Src, Dst: TBitmap; Factor: Single);
var
  X, Y, H, W, dx: Integer;
  p: PByteArray;
begin
  Dst.Canvas.draw(0, 0, Src);
  Dst.PixelFormat := pf24bit;
  W := Dst.Width;
  H := Dst.Height;
  dx := Round(Factor * W);
  if dx = 0 then
    Exit;
  if dx > (W div 2) then
    Exit;

  for Y := 0 to H - 1 do
  begin
    p := Dst.ScanLine[Y];
    if (Y mod 2) = 0 then
      for X := dx to W - 1 do
      begin
        p[(X - dx) * bpp] := p[X * bpp];
        p[(X - dx) * bpp + 1] := p[X * bpp + 1];
        p[(X - dx) * bpp + 2] := p[X * bpp + 2];
      end
    else
      for X := W - 1 downto dx do
      begin
        p[X * bpp] := p[(X - dx) * bpp];
        p[X * bpp + 1] := p[(X - dx) * bpp + 1];
        p[X * bpp + 2] := p[(X - dx) * bpp + 2];
      end;
  end;

end;

class procedure TJvPaintFX.ShakeDown(Src, Dst: TBitmap; Factor: Single);
var
  X, Y, H, W, dy: Integer;
  p, p2, p3: PByteArray;
begin
  Dst.Canvas.draw(0, 0, Src);
  Dst.PixelFormat := pf24bit;
  W := Dst.Width;
  H := Dst.Height;
  dy := Round(Factor * H);
  if dy = 0 then
    Exit;
  if dy > (H div 2) then
    Exit;

  for Y := dy to H - 1 do
  begin
    p := Dst.ScanLine[Y];
    p2 := Dst.ScanLine[Y - dy];
    for X := 0 to W - 1 do
      if (X mod 2) = 0 then
      begin
        p2[X * bpp] := p[X * bpp];
        p2[X * bpp + 1] := p[X * bpp + 1];
        p2[X * bpp + 2] := p[X * bpp + 2];
      end;
  end;
  for Y := H - 1 - dy downto 0 do
  begin
    p := Dst.ScanLine[Y];
    p3 := Dst.ScanLine[Y + dy];
    for X := 0 to W - 1 do
      if (X mod 2) <> 0 then
      begin
        p3[X * bpp] := p[X * bpp];
        p3[X * bpp + 1] := p[X * bpp + 1];
        p3[X * bpp + 2] := p[X * bpp + 2];
      end;
  end;
end;

class procedure TJvPaintFX.Plasma(Src1, Src2, Dst: TBitmap; Scale, Turbulence: Single);
var
  cval, sval: array[0..255] of Integer;
  i, X, Y, W, H, XX, YY: Integer;
  Asin, Acos: Extended;
  ps1, ps2, pd: PByteArray;
begin
  W := Src1.Width;
  H := Src1.Height;
  if Turbulence < 10 then
    Turbulence := 10;
  if Scale < 5 then
    Scale := 5;
  for i := 0 to 255 do
  begin
    sincos(i / Turbulence, Asin, Acos);
    sval[i] := Round(-Scale * Asin);
    cval[i] := Round(Scale * Acos);
  end;
  for Y := 0 to H - 1 do
  begin
    pd := Dst.ScanLine[Y];
    ps2 := Src2.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      XX := X + sval[ps2[X * bpp]];
      YY := Y + cval[ps2[X * bpp]];
      if (XX >= 0) and (XX < W) and (YY >= 0) and (YY < H) then
      begin
        ps1 := Src1.ScanLine[YY];
        pd[X * bpp] := ps1[XX * bpp];
        pd[X * bpp + 1] := ps1[XX * bpp + 1];
        pd[X * bpp + 2] := ps1[XX * bpp + 2];
      end;
    end;
  end;
  ;
end;

class procedure TJvPaintFX.SplitRound(Src, Dst: TBitmap; Amount: Integer; Style: TLightBrush);
var
  X, Y, W, c, c00, dx, CX: Integer;
  R, R00: TRect;
  bm, bm2: TBitmap;
  p0, p00, p1: PByteArray;
begin
  if Amount = 0 then
  begin
    Dst.Canvas.Draw(0, 0, Src);
    Exit;
  end;
  CX := Src.Width div 2;
  if Amount > CX then
    Amount := CX;
  W := Src.Width;
  bm := TBitmap.Create;
  bm.PixelFormat := pf24bit;
  bm.Height := 1;
  bm.Width := CX;
  bm2 := TBitmap.Create;
  bm2.PixelFormat := pf24bit;
  bm2.Height := 1;
  bm2.Width := CX;
  p0 := bm.ScanLine[0];
  p00 := bm2.ScanLine[0];
  dx := 0;
  for Y := 0 to Src.Height - 1 do
  begin
    p1 := Src.ScanLine[Y];
    for X := 0 to CX - 1 do
    begin
      c := X * bpp;
      c00 := (CX + X) * bpp;
      p0[c] := p1[c];
      p0[c + 1] := p1[c + 1];
      p0[c + 2] := p1[c + 2];
      p00[c] := p1[c00];
      p00[c + 1] := p1[c00 + 1];
      p00[c + 2] := p1[c00 + 2];
    end;
    case Style of
      mbSplitRound:
        dx := Round(Amount * Abs(Sin(Y / (Src.Height - 1) * Pi)));
      mbSplitWaste:
        dx := Round(Amount * Abs(Cos(Y / (Src.Height - 1) * Pi)));
    end;
    R := Rect(0, Y, dx, Y + 1);
    Dst.Canvas.StretchDraw(R, bm);
    R00 := Rect(W - 1 - dx, Y, W - 1, Y + 1);
    Dst.Canvas.StretchDraw(R00, bm2);
  end;
  bm.Free;
  bm2.Free;
end;

class procedure TJvPaintFX.Emboss(var Bmp: TBitmap);
var
  X, Y: Integer;
  p1, p2: PByteArray;
begin
  for Y := 0 to Bmp.Height - 2 do
  begin
    p1 := bmp.ScanLine[Y];
    p2 := bmp.ScanLine[Y + 1];
    for X := 0 to Bmp.Width - 4 do
    begin
      p1[X * bpp] := (p1[X * bpp] + (p2[(X + bpp) * bpp] xor $FF)) shr 1;
      p1[X * bpp + 1] := (p1[X * bpp + 1] + (p2[(X + bpp) * bpp + 1] xor $FF)) shr 1;
      p1[X * bpp + 2] := (p1[X * bpp + 2] + (p2[(X + bpp) * bpp + 2] xor $FF)) shr 1;
    end;
  end;

end;

class procedure TJvPaintFX.FilterRed(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c + 2] > Min) and (p1[c + 2] < Max) then
        p1[c + 2] := $FF
      else
        p1[c + 2] := 0;
      p1[c] := 0;
      p1[c + 1] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.FilterGreen(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c + 1] > Min) and (p1[c + 1] < Max) then
        p1[c + 1] := $FF
      else
        p1[c + 1] := 0;
      p1[c] := 0;
      p1[c + 2] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.FilterBlue(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c] > Min) and (p1[c] < Max) then
        p1[c] := $FF
      else
        p1[c] := 0;
      p1[c + 1] := 0;
      p1[c + 2] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.FilterXRed(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c + 2] > Min) and (p1[c + 2] < Max) then
        p1[c + 2] := $FF
      else
        p1[c + 2] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.FilterXGreen(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c + 1] > Min) and (p1[c + 1] < Max) then
        p1[c + 1] := $FF
      else
        p1[c + 1] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.FilterXBlue(const Dst: TBitmap; Min, Max: Integer);
var
  c, X, Y: Integer;
  p1: PByteArray;
begin
  for Y := 0 to Dst.Height - 1 do
  begin
    p1 := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      c := X * bpp;
      if (p1[c] > Min) and (p1[c] < Max) then
        p1[c] := $FF
      else
        p1[c] := 0;
    end;
  end;
end;

class procedure TJvPaintFX.DrawMandelJulia(const Dst: TBitmap; x0, y0, x1, y1: Single; Niter: Integer; Mandel: Boolean);
const
  //Number if colors. If this is changed, the number of mapped colors must also be changed
  nc = 16;
type
  TJvRGBTriplet = record
    R, G, B: Byte;
  end;
var
  X, XX, Y, YY, Cx, Cy, Dx, Dy, XSquared, YSquared: Double;
  Nx, Ny, Py, Px, I: Integer;
  Line: PByteArray;
  cc: array[0..15] of TJvRGBTriplet;
  AColor: TColor;
begin
  Dst.PixelFormat := pf24bit;
  for i := 0 to 15 do
  begin
    AColor := ConvertColor(i);
    cc[i].B := GetBValue(ColorToRGB(AColor));
    cc[i].G := GetGValue(ColorToRGB(AColor));
    cc[i].R := GetRValue(ColorToRGB(AColor));
  end;
  if Niter < nc then
    Niter := nc;
  try
    Nx := Dst.Width;
    Ny := Dst.Height;
    Cx := 0;
    Cy := 1;
    Dx := (x1 - x0) / nx;
    Dy := (y1 - y0) / ny;
    Py := 0;
    while (PY < Ny) do
    begin
      Line := Dst.ScanLine[py];
      PX := 0;
      while (Px < Nx) do
      begin
        X := x0 + px * dx;
        Y := y0 + py * dy;
        if mandel then
        begin
          CX := X;
          CY := Y;
          X := 0;
          Y := 0;
        end;
        xsquared := 0;
        ysquared := 0;
        I := 0;
        while (I <= niter) and (xsquared + ysquared < (4)) do
        begin
          xsquared := X * X;
          ysquared := Y * Y;
          XX := xsquared - ysquared + CX;
          YY := (2 * X * Y) + CY;
          X := XX;
          Y := YY;
          I := I + 1;
        end;
        I := I - 1;
        if (i = niter) then
          i := 0
        else
          i := Round(i / (niter / nc));
        //        Canvas.Pixels[PX,PY] := ConvertColor(I);
        Line[px * 3] := cc[i].B;
        Line[px * 3 + 1] := cc[i].G;
        Line[px * 3 + 2] := cc[i].R;
        Px := Px + 1;
      end;
      Py := Py + 1;
    end;
  finally
  end;
end;

class procedure TJvPaintFX.Invert(Src: TBitmap);
var
  W, H, X, Y: Integer;
  p: PByteArray;
begin
  W := Src.Width;
  H := Src.Height;
  Src.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    p := Src.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      p[X * bpp] := not p[X * bpp];
      p[X * bpp + 1] := not p[X * bpp + 1];
      p[X * bpp + 2] := not p[X * bpp + 2];
    end;
  end;
end;

class procedure TJvPaintFX.MirrorRight(Src: TBitmap);
var
  W, H, X, Y: Integer;
  p: PByteArray;
begin
  W := Src.Width;
  H := Src.Height;
  Src.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    p := Src.ScanLine[Y];
    for X := 0 to W div 2 do
    begin
      p[(W - 1 - X) * bpp] := p[X * bpp];
      p[(W - 1 - X) * bpp + 1] := p[X * bpp + 1];
      p[(W - 1 - X) * bpp + 2] := p[X * bpp + 2];
    end;
  end;
end;

class procedure TJvPaintFX.MirrorDown(Src: TBitmap);
var
  W, H, X, Y: Integer;
  p1, p2: PByteArray;
begin
  W := Src.Width;
  H := Src.Height;
  Src.PixelFormat := pf24bit;
  for Y := 0 to H div 2 do
  begin
    p1 := Src.ScanLine[Y];
    p2 := Src.ScanLine[H - 1 - Y];
    for X := 0 to W - 1 do
    begin
      p2[X * bpp] := p1[X * bpp];
      p2[X * bpp + 1] := p1[X * bpp + 1];
      p2[X * bpp + 2] := p1[X * bpp + 2];
    end;
  end;
end;

// resample image as triangles

class procedure TJvPaintFX.Triangles(const Dst: TBitmap; Amount: Integer);
type
  Ttriplet = record
    R, G, B: Byte;
  end;
var
  W, H, X, Y, tb, tm, te: Integer;
  ps: PByteArray;
  T: ttriplet;
begin
  W := Dst.Width;
  H := Dst.Height;
  Dst.PixelFormat := pf24bit;
  if Amount < 5 then
    Amount := 5;
  Amount := (Amount div 2) * 2 + 1;
  tm := Amount div 2;
  for Y := 0 to H - 1 do
  begin
    ps := Dst.ScanLine[Y];
    t.R := ps[0];
    t.G := ps[1];
    t.B := ps[2];
    tb := Y mod (Amount - 1);
    if tb > tm then
      tb := 2 * tm - tb;
    if tb = 0 then
      tb := Amount;
    te := tm + Abs(tm - (Y mod Amount));
    for X := 0 to W - 1 do
    begin
      if (X mod tb) = 0 then
      begin
        t.R := ps[X * bpp];
        t.G := ps[X * bpp + 1];
        t.B := ps[X * bpp + 2];
      end;
      if ((X mod te) = 1) and (tb <> 0) then
      begin
        t.R := ps[X * bpp];
        t.G := ps[X * bpp + 1];
        t.B := ps[X * bpp + 2];
      end;
      ps[X * bpp] := t.R;
      ps[X * bpp + 1] := t.G;
      ps[X * bpp + 2] := t.B;
    end;
  end;
end;

class procedure TJvPaintFX.RippleTooth(const Dst: TBitmap; Amount: Integer);
var
  X, Y: Integer;
  P1, P2: PByteArray;
  B: Byte;
begin
  Dst.PixelFormat := pf24bit;
  Amount := Min(Dst.Height div 2, Amount);
  for Y := Dst.Height - 1 - Amount downto 0 do
  begin
    P1 := Dst.ScanLine[Y];
    B := 0;
    for X := 0 to Dst.Width - 1 do
    begin
      P2 := Dst.ScanLine[Y + B];
      P2[X * bpp] := P1[X * bpp];
      P2[X * bpp + 1] := P1[X * bpp + 1];
      P2[X * bpp + 2] := P1[X * bpp + 2];
      Inc(B);
      if B > Amount then
        B := 0;
    end;
  end;
end;

class procedure TJvPaintFX.RippleTriangle(const Dst: TBitmap; Amount: Integer);
var
  X, Y: Integer;
  P1, P2: PByteArray;
  B: Byte;
  doinc: Boolean;
begin
  Amount := Min(Dst.Height div 2, Amount);
  for Y := Dst.Height - 1 - Amount downto 0 do
  begin
    P1 := Dst.ScanLine[Y];
    B := 0;
    doinc := True;
    for X := 0 to Dst.Width - 1 do
    begin
      P2 := Dst.ScanLine[Y + B];
      P2[X * bpp] := P1[X * bpp];
      P2[X * bpp + 1] := P1[X * bpp + 1];
      P2[X * bpp + 2] := P1[X * bpp + 2];
      if doinc then
      begin
        Inc(B);
        if B > Amount then
        begin
          doinc := False;
          B := Amount - 1;
        end;
      end
      else
      begin
        if B = 0 then
        begin
          doinc := True;
          B := 2;
        end;
        Dec(B);
      end;
    end;
  end;
end;

class procedure TJvPaintFX.RippleRandom(const Dst: TBitmap; Amount: Integer);
var
  X, Y: Integer;
  P1, P2: PByteArray;
  B: Byte;
begin
  Amount := Min(Dst.Height div 2, Amount);
  Dst.PixelFormat := pf24bit;
  Randomize;
  for Y := Dst.Height - 1 - Amount downto 0 do
  begin
    P1 := Dst.ScanLine[Y];
    B := 0;
    for X := 0 to Dst.Width - 1 do
    begin
      P2 := Dst.ScanLine[Y + B];
      P2[X * bpp] := P1[X * bpp];
      P2[X * bpp + 1] := P1[X * bpp + 1];
      P2[X * bpp + 2] := P1[X * bpp + 2];
      B := Random(Amount);
    end;
  end;
end;

class procedure TJvPaintFX.TexturizeOverlap(const Dst: TBitmap; Amount: Integer);
var
  W, H, X, Y, xo: Integer;
  bm: TBitmap;
  ARect: TRect;
begin
  bm := TBitmap.Create;
  Amount := Min(Dst.Width div 2, Amount);
  Amount := Min(Dst.Height div 2, Amount);
  xo := Round(Amount * 2 / 3);
  bm.Width := Amount;
  bm.Height := Amount;
  W := Dst.Width;
  H := Dst.Height;
  ARect := Rect(0, 0, Amount, Amount);
  bm.Canvas.StretchDraw(ARect, Dst);
  Y := 0;
  repeat
    X := 0;
    repeat
      Dst.Canvas.Draw(X, Y, bm);
      X := X + xo;
    until X >= W;
    Y := Y + xo;
  until Y >= H;
  bm.Free;
end;

class procedure TJvPaintFX.TexturizeTile(const Dst: TBitmap; Amount: Integer);
var
  W, H, X, Y: Integer;
  bm: TBitmap;
  ARect: TRect;
begin
  bm := TBitmap.Create;
  Amount := Min(Dst.Width div 2, Amount);
  Amount := Min(Dst.Height div 2, Amount);
  bm.Width := Amount;
  bm.Height := Amount;
  W := Dst.Width;
  H := Dst.Height;
  ARect := Rect(0, 0, Amount, Amount);
  bm.Canvas.StretchDraw(ARect, Dst);
  Y := 0;
  repeat
    X := 0;
    repeat
      Dst.Canvas.Draw(X, Y, bm);
      X := X + bm.Width;
    until X >= W;
    Y := Y + bm.Height;
  until Y >= H;
  bm.Free;
end;

class procedure TJvPaintFX.HeightMap(const Dst: TBitmap; Amount: Integer);
var
  bm: TBitmap;
  W, H, X, Y: Integer;
  pb, ps: PByteArray;
  c: Integer;
begin
  H := Dst.Height;
  W := Dst.Width;
  bm := TBitmap.Create;
  bm.Width := W;
  bm.Height := H;
  bm.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  bm.Canvas.Draw(0, 0, Dst);
  for Y := 0 to H - 1 do
  begin
    pb := bm.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      c := Round((pb[X * bpp] + pb[X * bpp + 1] + pb[X * bpp + 2]) / 3 / 255 * Amount);
      if (Y - c) >= 0 then
      begin
        ps := Dst.ScanLine[Y - c];
        ps[X * bpp] := pb[X * bpp];
        ps[X * bpp + 1] := pb[X * bpp + 1];
        ps[X * bpp + 2] := pb[X * bpp + 2];
      end;
    end;
  end;
  bm.Free;
end;

class procedure TJvPaintFX.Turn(Src, Dst: TBitmap);
var
  W, H, X, Y: Integer;
  ps, pd: PByteArray;
begin
  H := Src.Height;
  W := Src.Width;
  Src.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  Dst.Height := W;
  Dst.Width := H;
  for Y := 0 to H - 1 do
  begin
    ps := Src.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      pd := Dst.ScanLine[W - 1 - X];
      pd[Y * bpp] := ps[X * bpp];
      pd[Y * bpp + 1] := ps[X * bpp + 1];
      pd[Y * bpp + 2] := ps[X * bpp + 2];
    end;
  end;
end;

class procedure TJvPaintFX.TurnRight(Src, Dst: TBitmap);
var
  W, H, X, Y: Integer;
  ps, pd: PByteArray;
begin
  H := Src.Height;
  W := Src.Width;
  Src.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  Dst.Height := W;
  Dst.Width := H;
  for Y := 0 to H - 1 do
  begin
    ps := Src.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      pd := Dst.ScanLine[X];
      pd[(H - 1 - Y) * bpp] := ps[X * bpp];
      pd[(H - 1 - Y) * bpp + 1] := ps[X * bpp + 1];
      pd[(H - 1 - Y) * bpp + 2] := ps[X * bpp + 2];
    end;
  end;
end;

class procedure TJvPaintFX.ExtractColor(const Dst: TBitmap; AColor: TColor);
var
  X, Y: Integer;
  P: PJvRGBArray;
  EColor: TColor;
  R, G, B: Byte;
  OPF: TPixelFormat;
  Val: Byte;
begin
  EColor := ColorToRGB(AColor);
  R := GetRValue(EColor);
  G := GetGValue(EColor);
  B := GetBValue(EColor);
  OPF := Dst.PixelFormat;
  Dst.PixelFormat := pf24bit;
  if EColor = 0 then
    Val := $FF
  else
    Val := 0;
  for Y := 0 to Dst.Height - 1 do
  begin
    p := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      if ((P[X].rgbBlue <> B) or (P[X].rgbGreen <> G) or (P[X].rgbRed <> R)) then
      begin
        P[X].rgbBlue  := Val;
        P[X].rgbGreen := Val;
        P[X].rgbRed   := Val;
      end;
    end
  end;
  if AColor = clBlack then
    Dst.TransparentColor := clWhite
  else
    Dst.TransparentColor := clBlack;
  Dst.Transparent := True;
  Dst.PixelFormat := OPF;
end;

class procedure TJvPaintFX.ExcludeColor(const Dst: TBitmap; AColor: TColor);
begin
  Dst.TransparentColor := AColor;
  Dst.Transparent := True;
end;

class procedure TJvPaintFX.Blend(const Src1, Src2: TBitmap; var Dst: TBitmap; Amount: Single);
var
  W, H, X, Y: Integer;
  ps1, ps2, pd: PByteArray;
begin
  W := Src1.Width;
  H := Src1.Height;
  Dst.Width := W;
  Dst.Height := H;
  Src1.PixelFormat := pf24bit;
  Src2.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    ps1 := Src1.ScanLine[Y];
    ps2 := Src2.ScanLine[Y];
    pd := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
    begin
      pd[X * bpp] := Round((1 - Amount) * ps1[X * bpp] + Amount * ps2[X * bpp]);
      pd[X * bpp + 1] := Round((1 - Amount) * ps1[X * bpp + 1] + Amount * ps2[X * bpp + 1]);
      pd[X * bpp + 2] := Round((1 - Amount) * ps1[X * bpp + 2] + Amount * ps2[X * bpp + 2]);
    end;
  end;
end;

class procedure TJvPaintFX.Blend2(const Src1, Src2: TBitmap; var Dst: TBitmap; Amount: Single);
var
  W, H, X, Y: Integer;
  Ps1, Ps2, Pd: PByteArray;
begin
  W := Src1.Width;
  H := Src1.Height;
  Dst.Width := W;
  Dst.Height := H;
  Src1.PixelFormat := pf24bit;
  Src2.PixelFormat := pf24bit;
  Dst.PixelFormat := pf24bit;
  for Y := 0 to H - 1 do
  begin
    Ps1 := Src1.ScanLine[Y];
    Ps2 := Src2.ScanLine[Y];
    Pd := Dst.ScanLine[Y];
    for X := 0 to W - 1 do
      if ((Ps2[X * bpp] = $FF) and (Ps2[X * bpp + 1] = $FF) and (Ps2[X * bpp + 2] = $FF)) then
      begin
        Pd[X * bpp] := $FF;
        Pd[X * bpp + 2] := $FF;
        Pd[X * bpp + 2] := $FF;
      end
      else
      begin
        Pd[X * bpp] := Round((1 - Amount) * Ps1[X * bpp] + Amount * Ps2[X * bpp]);
        Pd[X * bpp + 1] := Round((1 - Amount) * Ps1[X * bpp + 1] + Amount * Ps2[X * bpp + 1]);
        Pd[X * bpp + 2] := Round((1 - Amount) * Ps1[X * bpp + 2] + Amount * Ps2[X * bpp + 2]);
      end;
  end;
end;

class procedure TJvPaintFX.Solarize(const Src: TBitmap; var Dst: TBitmap; Amount: Integer);
var
  X, Y: Integer;
  P: PJvRGBArray;
  C: Integer;
begin
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    P := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      C := (P[X].rgbBlue + P[X].rgbGreen + P[X].rgbRed) div 3;
      if C > Amount then
      begin
        P[X].rgbBlue  := 255 - P[X].rgbBlue;
        P[X].rgbGreen := 255 - P[X].rgbGreen;
        P[X].rgbRed   := 255 - P[X].rgbRed;
      end;
    end;
  end;
  Dst.PixelFormat := Src.PixelFormat;
end;

class procedure TJvPaintFX.Posterize(const Src: TBitmap; var Dst: TBitmap; Amount: Integer);
var
  X, Y: Integer;
  PD: PJvRGBArray;
begin
  if Dst = nil then
    Dst := TBitmap.Create;
  Dst.Assign(Src);
  Dst.PixelFormat := pf24bit;
  for Y := 0 to Dst.Height - 1 do
  begin
    PD := Dst.ScanLine[Y];
    for X := 0 to Dst.Width - 1 do
    begin
      PD[X].rgbBlue  := Round(PD[X].rgbBlue  / Amount) * Amount;
      PD[X].rgbGreen := Round(PD[X].rgbGreen / Amount) * Amount;
      PD[X].rgbRed   := Round(PD[X].rgbRed   / Amount) * Amount;
    end;
  end;
  Dst.PixelFormat := Src.PixelFormat;
end;

end.
