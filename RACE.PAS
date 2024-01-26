program RACE;  {ver(gleichbar mit CBR1100XX ) V 1.000a

Fertig sind: CK: Tastaturabfrage;
              DG: Steering incl. Coordinatecalculating;
                  Pathfinding by CPU
                  Lapcounting, Menustructure, Intropicture, Menu-
                  Graphics, Collisionrecognizing and Recalculating
                  Mobil Collisionsrecoc.,
              MK: Ruckeling Graphic with only one Screen and solala
                  memoryneeding,  Outtrotextwriting, writtextprocedure
       all procedures which could cause damage on your PC }
{evtl pathfinder pocedural
benoetigte raw/pal files:
bmw1,bmw2,ampel,ziffer,chars,
menuex,race2,menu,menu1,menu111,menu112,menu113,...
bahn2, bahn2sw!!!(raw version wurde veraendert 15->255)

zu machen    zeittraining zeitfahren   einzelrennen  wettkampf
hiscore nur bei siegen faktor 1,2,4, hilfe mit balken und ferrari
}

USES CRT, DOS, TASTA,STRECKE,grap486;

TYPE    AUTO=RECORD
           v:integer;
           angle:real;
           posx,posy:integer;
           flx,fly,frx,fry,hlx,hly,hrx,hry:integer;

           end;



        nhi=array[1..6] of string;
        shi=array[1..6] of longint;

        zHi=RECORD
          namz,namc:nhi;
          scrz,scrc:shi;
          end;






        SPRITE=ARRAY[0..23,0..23,0..15] of boolean;

        CONFIG=RECORD
              laps,diff,keyuh,keydh,keylh,keyrh,
              keyuc,keydc,keylc,keyrc:byte;
              end;


VAR             hi:zhi;

                cfg:config;
           k,speed,count,x,y,cx,cy,cx1,cy1,cx111,cy111,modus :integer;
              keyuh,keydh,keylh,keyrh,
              keyuc,keydc,keylc,keyrc,j:byte;

           car,car1,car2,carc:auto;
           taste:char;
           Key_Tab:array [0..255] of byte;
           Key_LED:byte;
           r:registers;
           old_int09_seg,
           old_int09_ofs:word;
           Pos       : Word;
           IncPos    : ShortInt;
           key_down, key_up, key_left, key_right : boolean;  {for player 1}
           kdc,kuc,klc,krc:boolean;
           anstieg,zielangle:real; {for ki}
           hilfint,zaehl,streckenpunkt,a:integer;
           h1,h,hg,m1,m,mg,s1,s,sg,c1,c,cg:word;
           alls,alls2,allsb1,allsb2:longint; {hundertstel sekunden}
           takt,taktbak,vrasen  : shortint;
                               strlapset:string[2];
                               lapset,lapsetbak,diffbak:byte;
             allstr,scoreb,scorea,strcounthwon,strcountcwon:string[8];

           zielx,ziely,zielv:integer;  {ki}
           col,factor,counthwon,countcwon:byte;
           wfk:integer;
           n,n2:Word;
    Buffer            : array[0..320*25-1] of Byte;

    Src,Dst,Pic : Pointer;
    p,p2,p3,psw:Palette;
    wahl,wahl1,wahl111,wahle    :shortint;
    hauptmenu,timein,hwon,cwon,time2anz,timeafter,backsich:boolean;
    check1,check2,check3,checkc1,checkc2,checkc3,check4,checkc4:boolean;
    runde,rundec,art:integer;
    Sprx,Spry:integer;
    Spr1,Spr2:Sprite;
    min,max:integer;
    cfr,cfl,chr,chl,ccc:boolean;
    e,f:integer;

    dateint:longint;

    MomText, MomZeile : Byte;
    Text              : string[17];


const i=1;
const MaxText = 147;
{***********************************Program-Part**************}
{***********************************Program-Part**************}
{***********************************Program-Part**************}

procedure New_int09; interrupt;
var Key_nr,Key_val:byte;
begin
 asm
  in al,60h
  mov ah,al
  and al,7fh
  not ah
  and ah,80h
  mov Key_nr,al
  mov Key_val,ah
  in al,61h
  mov ah,al
  or al,80h
  out 61h,al
  xchg al,ah
  out 61h,al
  mov al,20h
  out 20h,al
 end;
key_tab[Key_nr]:=key_val;
end;

procedure Install_new_keyboard_driver;
var I:byte;
begin

 Key_Led:=mem[$40:$17];
 mem[$40:$17]:= Key_LED and (1+2+4+8+128);
 r.ah:=01;
 intr ($16,r);

 r.ah:=$35;
 r.al:=$09;
 intr ($21,r);
 old_int09_seg:=r.es;
 old_int09_ofs:=r.bx;

 r.ah:=$25;
 r.al:=$09;
 r.ds:=seg(New_int09);
 r.dx:=ofs(New_int09);
 intr ($21,r);
 for i:= 0 to 255 do key_tab[i]:=0;
end;

procedure DeInstall_new_keyboard_driver;
begin
 r.dx:=old_int09_ofs;
 r.ds:=old_int09_seg;
 r.ah:=$25;
 r.al:=$09;
 intr ($21,r);
 mem[$40:$17]:=Key_LED;
 r.ah:=01;
 intr ($16,r);
end;

function key_pressed (key_nr:byte):boolean;
begin
 if key_tab[key_nr]=$80 then key_pressed:=true
                        else key_pressed:=false;
end;

{********************************TASTATUR*Proceduren*********************}






procedure taste_erkennen;


  Begin
     if (key_pressed(cfg.keydh)=true) and (key_pressed(cfg.keyuh)=false) then      {down}
         key_down:=true
         else
           if takt mod 2=1 then key_down:=false;
       if (key_pressed(cfg.keyuh)=true) and (key_pressed(cfg.keydh)=false) then    {up}
         key_up:=true
         else
           if takt mod 2=1 then key_up:=false;

       if (key_pressed(cfg.keylh)=true) and (key_pressed(cfg.keyrh)=false) then    {left}
         key_left:=true
         else
           if takt mod 2=1 then key_left:=false;

       if (key_pressed(cfg.keyrh)=true) and (key_pressed(cfg.keylh)=false)then    {right}
         key_right:=true
         else
          if takt mod 2=1 then key_right:=false;

   end;


procedure taste2_erkennen;

  Begin
     if (key_pressed(cfg.keydc)=true) and (key_pressed(cfg.keyuc)=false) then      {down}
         kdc:=true
         else
           if takt mod 2=1 then kdc:=false;
       if (key_pressed(cfg.keyuc)=true) and (key_pressed(cfg.keydc)=false) then    {up}
         kuc:=true
         else
           if takt mod 2=1 then kuc:=false;

       if (key_pressed(cfg.keylc)=true) and (key_pressed(cfg.keyrc)=false) then    {left}
         klc:=true
         else
           if takt mod 2=1 then klc:=false;

       if (key_pressed(cfg.keyrc)=true) and (key_pressed(cfg.keylc)=false)then    {right}
         krc:=true
         else
          if takt mod 2=1 then krc:=false;

   end;


procedure WriteText(s,d:Pointer;x,y:Word;str:string);
var i, Ascii, SprNr : Byte;
    Text            : Boolean;
begin
  for i:=1 to Length(str) do
    begin
      Ascii := Ord(str[i]);
      case Ascii of
        48..57  : begin
                    SprNr := 64 + Ascii-48;
                    Text  := True;
                  end;
        65..90  : begin
                    SprNr := 78 + Ascii-65;
                    Text  := True;
                  end;
        97..122 : begin
                    SprNr := 78 + Ascii-32-65;
                    Text  := True;
                  end;
        43      : begin
                    SprNr := 77;
                    Text  := True;
                  end;
        46      : begin
                    SprNr := 74;
                    Text  := True;
                  end;
        47      : begin
                    SprNr := 76;
                    Text  := True;
                  end;
        58      : begin
                    SprNr := 75;
                    Text  := True;
                  end;
        else Text := False;
      end;
      if Text then PutSprite(s,d,x,y,SprNr);
      Inc(x,18);
    end;
end;





{tastatur ends}


PROCEDURE KOLLISION;

begin

  with car do
  begin

  {berechnet die zu kollidierenden koordinaten}
  flx:=posx-round(10.9*cos((-16.7+angle)/180*Pi));
  fly:=posy-round(10.9*sin((-16.7+angle)/180*Pi));

  frx:=posx-round(10.9*cos((16.7+angle)/180*Pi));
  fry:=posy-round(10.9*sin((16.7+angle)/180*Pi));

  hrx:=posx-round(10.9*cos((+163.3+angle)/180*Pi));
  hry:=posy-round(10.9*sin((+163.3+angle)/180*Pi));

  hlx:=posx-round(10.9*cos((+196.7+angle)/180*Pi));
  hly:=posy-round(10.9*sin((+196.7+angle)/180*Pi));

 end;

end;


procedure Startrace;
begin
 for e:= 0 to 4 do GetSprite(dst,src,99+e*24,20,42+e);
 for e:= 0 to 4 do begin PutSprite2(Src,dst,99+e*24,20,36);
                         PutSprite2(Src,vidptr,99+e*24,20,36);  end;
 for e:=0 to 4 do begin for zaehl:=1 to speed*12 do waitretrace;
 PutSprite2(Src,dst,99+e*24,20,39); PutSprite2(Src,vidptr,99+e*24,20,39);end;
 for zaehl:=1 to speed*12 do waitretrace;
 for e:=0 to 4 do begin PutSprite2(Src,dst,99+e*24,20,41);
                        PutSprite2(Src,vidptr,99+e*24,20,41); end;
end;


procedure lap(x:byte);
begin

                                    putsprite2(src,dst,18,174,53);
     if runde<lapset then           putsprite(src,dst,18,174,64+runde+1)
      else                          putsprite(src,dst,18,174,64+lapset);





      if x>1 then begin

                               putsprite2(src,dst,240,174,54);
      if rundec<lapset then    putsprite(src,dst,240,174,64+rundec+1)
      else                     putsprite(src,dst,240,174,64+lapset);



      end;

end;




Procedure clock;

begin

       gettime(h,m,s,c);

       if h<h1 then h:=h+24;
       if m<m1 then begin m:=m+60;  dec(h); end;
       if s<s1 then begin s:=s+60;  dec(m); end;
       if c<c1 then begin c:=c+100; dec(s); end;
       hg:=h-h1; mg:=m-m1; sg:=s-s1; cg:=c-c1;



if (sg<0) or (sg>59) then begin sg:=59; dec(mg); end;
if (mg<0) or (mg>59) then begin mg:=59; dec(hg); end;
alls:=hg*60*60*100+mg*60*100+sg*100+cg;



if alls>=0 then  begin
putsprite2(src,dst,52+9*24,0,42+9); putsprite2(src,dst,52+8*24,0,42+8);
              putsprite(src,dst,52+24*8,0,64+(cg div 10));
              putsprite(src,dst,52+24*9,0,64+(cg mod 10));end;
       if alls>=100 then  begin putsprite2(src,dst,52+6*24,0,42+6);
       putsprite(src,dst,52+24*6,0,64+(sg mod 10));
  end;
       if alls>=1000 then begin  putsprite2(src,dst,52+5*24,0,42+5);
       putsprite(src,dst,52+24*5,0,64+(sg div 10)); end;
       if alls>=6000 then  begin putsprite2(src,dst,52+3*24,0,42+3);
       putsprite(src,dst,52+24*3,0,64+(mg mod 10));
       putsprite(src,dst,52+24*4,0,64+11); end;
       if alls>=60000 then begin putsprite2(src,dst,52+2*24,0,42+2);
       putsprite(src,dst,52+24*2,0,64+(mg div 10)); end;
       if alls>360000 then begin putsprite2(src,dst,52*24,0,42);
       putsprite(src,dst,52+24*0,0,64+(hg mod 10));
       putsprite(src,dst,52+24*1,0,64+11); end;







end;






procedure dars1(x,y:Word;a:Real);
var s,s2:Word;
begin
  GradToSprnr(a,s);
  GetSprite(dst,src,x,y,32);
  PutSprite(Src,dst,x,y,s);   {eventuell a mit 16 mehr uebergeben bei dars}
  CopyMem(dst,vidptr,16000);

  for zaehl:= 1 to speed do
  waitretrace;
  PutSprite(Src,dst,x,y,32);
end;

procedure dars(x,y,x2,y2:Word;a,a2:Real);
var s,s2:Word;
begin

  GradToSprnr(a,s);
  GradToSprnr(a2,s2);
  GetSprite(dst,Src,x,y,32);
  GetSprite(dst,Src,x2,y2,33);
  PutSprite(Src,dst,x,y,s);
  PutSprite(Src,dst,x2,y2,s2+16);
  copymem(dst,vidptr,16000);

  for zaehl:= 1 to speed do
  WaitRetrace;
  PutSprite2(Src,dst,x,y,32);
  PutSprite2(Src,dst,x2,y2,33);


end;

PROCEDURE KOLLISIONSABFRAGE320200;

BEGIN

WITH CAR DO

BEGIN
   while (posx<0+i) or (frx<0+i) or (flx<0+i) or (hrx<0+i) or (hlx<0+i) do

      begin
       inc (posx);inc(frx);inc(flx);inc(hrx);inc(hlx);
       v:=0;
      end;
   while (posy<0+i) or (fry<0+i) or (fly<0+i) or (hry<0+i) or (hly<0+i) do
      begin
        inc (posy);inc(fry);inc(fly);inc(hry);inc(hly);
        v:=0;
      end;

  while (posx>319-i) or (frx>319-i) or (flx>319-i) or (hrx>319-i) or (hlx>319-i)
    do begin
        dec (posx);dec(frx);dec(flx);dec(hrx);dec(hlx);
        v:=0;
       end;

  while (posy>199-i) or (fry>199-i) or (fly>199-i) or (hry>199-i) or (hly>199-i)
     do
      begin
       dec (posy);dec(fry);dec(fly);dec(hry);dec(hly);
       v:=0;
      end;


   if (getpixel(pic,posx,posy)=0) or
      (getpixel(pic,frx,fry)=0) or
      (getpixel(pic,flx,fly)=0) or
      (getpixel(pic,hrx,hry)=0) or
      (getpixel(pic,hlx,hly)=0)
          then


      begin
       if v>0 then hilfint:=-20;
       if V<0 then hilfint:=20;

        if v<>0 then begin
        taktbak:=takt;
        e:=0;
        repeat
         takt:=0;
         inc(e);

         if ((getpixel(pic,hrx,hry)=0) or
             (getpixel(pic,hlx,hly)=0)) and (hilfint=-20) then
              hilfint:=20;

         if ((getpixel(pic,frx,fry)=0) or
             (getpixel(pic,flx,fly)=0)) and (hilfint=20) then

             hilfint:=-20;

{linke seite}
         if ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx  ,hly  )=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx  ,hly-1)=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx  ,hly+1)=0)) or

            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx-1,hly  )=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx-1,hly-1)=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx-1,hly+1)=0)) or

            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx+1,hly  )=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx+1,hly-1)=0)) or
            ((getpixel(pic,flx,fly)=0) and (getpixel(pic,hlx+1,hly+1)=0)) or


            ((getpixel(pic,flx,  fly+1)=0) and (getpixel(pic,hlx,hly)=0)) or
            ((getpixel(pic,flx,  fly-1)=0) and (getpixel(pic,hlx,hly)=0)) or

            ((getpixel(pic,flx-1,fly  )=0) and (getpixel(pic,hlx,hly)=0)) or
            ((getpixel(pic,flx-1,fly-1)=0) and (getpixel(pic,hlx,hly)=0)) or
            ((getpixel(pic,flx-1,fly+1)=0) and (getpixel(pic,hlx,hly)=0)) or

            ((getpixel(pic,flx+1,fly  )=0) and (getpixel(pic,hlx,hly)=0)) or
            ((getpixel(pic,flx+1,fly-1)=0) and (getpixel(pic,hlx,hly)=0)) or
            ((getpixel(pic,flx+1,fly+1)=0) and (getpixel(pic,hlx,hly)=0)) then
               begin
               if (angle>= 22.5) and (angle<=67.5) then
                  begin inc(posx); dec(posy); end;
               if (angle>=112.5) and (angle<=157.5) then
                  begin inc(posx); inc(posy); end;
               if (angle>=202.5) and (angle<=247.5) then
                  begin dec(posx); inc(posy); end;
               if (angle>=292.5) and (angle<=337.5) then
                  begin dec(posx); dec(posy); end;
               if angle=0 then dec(posy);
               if angle=90 then inc(posx);
               if angle=180 then inc(posy);
               if angle=270 then dec(posx);

               hilfint:=0;

               v:=0;

             end;


{rechte Seite}
if ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx  ,hry  )=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx  ,hry-1)=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx  ,hry+1)=0)) or

            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx-1,hry  )=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx-1,hry-1)=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx-1,hry+1)=0)) or

            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx+1,hry  )=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx+1,hry-1)=0)) or
            ((getpixel(pic,frx,fry)=0) and (getpixel(pic,hrx+1,hry+1)=0)) or


            ((getpixel(pic,frx,  fry+1)=0) and (getpixel(pic,hrx,hry)=0)) or
            ((getpixel(pic,frx,  fry-1)=0) and (getpixel(pic,hrx,hry)=0)) or

            ((getpixel(pic,frx-1,fry  )=0) and (getpixel(pic,hrx,hry)=0)) or
            ((getpixel(pic,frx-1,fry-1)=0) and (getpixel(pic,hrx,hry)=0)) or
            ((getpixel(pic,frx-1,fry+1)=0) and (getpixel(pic,hrx,hry)=0)) or

            ((getpixel(pic,frx+1,fry  )=0) and (getpixel(pic,hrx,hry)=0)) or
            ((getpixel(pic,frx+1,fry-1)=0) and (getpixel(pic,hrx,hry)=0)) or
            ((getpixel(pic,frx+1,fry+1)=0) and (getpixel(pic,hrx,hry)=0)) then
               begin
               if (angle>= 22.5) and (angle<=67.5) then
                  begin dec(posx); inc(posy); end;
               if (angle>=112.5) and (angle<=157.5) then
                  begin dec(posx); dec(posy); end;
               if (angle>=202.5) and (angle<=247.5) then
                  begin inc(posx); dec(posy); end;
               if (angle>=292.5) and (angle<=337.5) then
                  begin inc(posx); inc(posy); end;
               if angle=0 then inc(posy);
               if angle=90 then dec(posx);
               if angle=180 then dec(posy);
               if angle=270 then inc(posx);

               hilfint:=0;
               v:=0;
             end;

          kauswertung(posx,posy,flx,fly,frx,fry,hrx,hry,hlx,hly,
          hilfint,angle,takt,pic);
          kollision;

        until  not
        ((getpixel(pic,posx,posy)=0) or
         (getpixel(pic,frx,fry)=0) or
         (getpixel(pic,flx,fly)=0) or
         (getpixel(pic,hrx,hry)=0) or
         (getpixel(pic,hlx,hly)=0))

           or (key_pressed(1)) or (e>=20);


      if v>1 then v:=v-2 else if v<-1 then v:=v+2 else
      v:=0;

     takt:=taktbak;

     end


       else
       begin
        taktbak:=0;

        if key_left=true then angle:=angle+22.5;
        if key_right=true then angle:=angle-22.5;


        if angle<0 then angle:=angle+360;
        if angle>=360 then angle:=angle-360;

        kollision;

     end;
   key_left:=false;
   key_right:=false;

  end;

END;
END;


PROCEDURE Halbkollision;

Begin;
 with car do begin

  if (getpixel(pic,posx,posy)=128) or
    (getpixel(pic,frx ,fry )=128) or
    (getpixel(pic,flx ,fly )=128) or
    (getpixel(pic,hrx ,hry )=128) or
    (getpixel(pic,hlx ,hly )=128) then

 begin


  vrasen:=7;

 if (getpixel(pic,posx,posy)=128) then dec(vrasen);
 if (getpixel(pic,frx ,fry )=128) then dec(vrasen);
 if (getpixel(pic,flx ,fly )=128) then dec(vrasen);
 if (getpixel(pic,hrx ,hry )=128) then dec(vrasen);
 if (getpixel(pic,hlx ,hly )=128) then dec(vrasen);

     if (takt mod 3=0) and (v>vrasen) then begin dec(v);dec(v);end;
     if (takt mod 3=0) and (v=-3) then begin inc(v);inc(v);end;
     end;

   end;
  End;

Procedure SprScan;
begin

  for a:=0 to 15 do
  for spry:=0 to 23 do
  for sprx:=0 to 23 do
  begin
  if GetSprPixel(Src,sprx,spry,round(car1.angle/22.5)) =255 then
      spr1[sprx,spry,a]:=false else
      spr1[sprx,spry,a]:=true;

  if GetSprPixel(Src,sprx,spry,round(car2.angle/22.5)+16)=255 then
      spr2[sprx,spry,a]:=false else
      spr2[sprx,spry,a]:=true;
  end;

{   asm
    mov ax,3h
    int 10h
   end;

   for sprx:=0 to 23 do
    for spry:=0 to 23 do
     begin
      gotoxy((sprx+1)*2,spry+1); if spr1[sprx,spry]=false then
      begin textcolor(white);write('0'); end
             else begin textcolor(red);write('1'); end;
      end;

   for cx:=1 to 10 do
   waitretrace;


  asm
   mov ax,13h
   int 10h
  end;
 }
end;



{********************************TASTATUR*Proceduren*********************}


procedure humanparameter;    {wertet key player 1 aus}

begin
 with car do
 begin
  if takt mod 2=0 then begin if (key_down = true)  then
     begin if v > -3 then v:=v-1;  end
      else if (key_up=false) and (takt mod 8 = 6) and (v<0) then inc(v);
    if (key_up=true)  then  begin if v < 9  then v:=v+1;   {7} end
      else if (key_down=false) and (takt mod 8 = 6) and (v>0) then  dec(v);
    if key_left = true then angle:=angle-22.5;
    if key_right = true then angle:=angle+22.5;
    if angle < 0 then angle:=angle + 360;
    if angle >= 360 then angle:=angle - 360;
   end;
  end;
end;

procedure cpuparameter;

begin                         {wertet die imaginaer gedrueckten CPU-Keys aus}
 with car do
 begin
  if takt mod 2=0 then begin if kdc = true then
     begin if v > -3 then v:=v-1; end
      else if (kuc=false) and (takt mod 8 = 6) and (v<0) then inc(v);
   if kuc = true then begin if v < 9  then v:=v+1 end
      else if (kdc=false) and (takt mod 8 = 6) and (v>0) then dec(v);
  if klc = true then angle:=angle-22.5;
  if krc = true then angle:=angle+22.5;
  if angle < 0 then angle:=angle + 360;
  if angle >= 360 then angle:=angle - 360;
     end;
  end;
end;




PROCEDURE pathfinder (zielx,ziely,zielv:integer);
begin
       if zielx-car2.posx<>0 then
        begin
         anstieg:=((ziely-car2.posy)/(zielx-car2.posx));

  for wfk:= -3 to 3 do
   begin
   if (anstieg>=(sin((wfk*22.5-11.25)/180*Pi)/cos((wfk*22.5-11.25)/180*Pi))) and
      (anstieg<(sin((wfk*22.5+11.25) /180*Pi)/cos((wfk*22.5+11.25)/180*Pi))) and
      ((zielx-car2.posx)>0) then zielangle:=wfk*22.5+180;
     end;

       if ((anstieg>= (sin(78.75/180*Pi)/cos(78.75/180*Pi))) xor
          (anstieg<(sin(101.25/180*Pi)/cos(101.25/180*Pi)))) and
          ((ziely-car2.posy)>0) then zielangle:=90+180;

  for wfk:=5 to 11 do
   begin
   if (anstieg>=(sin((wfk*22.5-11.25)/180*Pi)/cos((wfk*22.5-11.25)/180*Pi))) and
       (anstieg<(sin((wfk*22.5+11.25) /180*Pi)/cos((wfk*22.5+11.25)/180*Pi))) and
       ((zielx-car2.posx)<0) then zielangle:=wfk*22.5+180;
      end;

     if ((anstieg>= (sin(258.75/180*Pi)/cos(258.75/180*Pi))) xor
        (anstieg<(sin(281.25/180*Pi)/cos(281.25/180*Pi)))) and
        ((ziely-car2.posy)<0) then zielangle:=90;
       end;

       if (zielx-car2.posx=0) and (ziely-car2.posy>0) then
       zielangle:=270;
       if (zielx-car2.posx=0) and (ziely-car2.posy<0) then
       zielangle:=90;

      if zielangle<0 then zielangle:=zielangle+360;
      if zielangle>=360 then zielangle:=zielangle-360;

      if (zielangle>car2.angle) and (360-zielangle+car2.angle>180) then
         begin krc:=true; klc:=false; end;
      if (zielangle>=car2.angle) and (360-zielangle+car2.angle<=180) then
         begin klc:=true; krc:=false; end;
      if (zielangle<=car2.angle) and (360+zielangle-car2.angle>=180) then
         begin klc:=true; krc:=false; end;
      if (zielangle<car2.angle) and (360+zielangle-car2.angle<180) then
         begin krc:=true; klc:=false; end;
      if zielangle=car2.angle then
       begin krc:=false; klc:=false; end;
      if zielv>=car2.v then kuc:=true else kuc:=false;
      if zielv<=car2.v then kdc:=true else kdc:=false;
end;

PROCEDURE INITIALISING;
var f:file of config;

begin



     getmem(src,64000);
     write('loading intro ... ');


   Assign (f,'YAMAHA.AF1');
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then
     begin
      write('Configurationfile not found');
     end
    else
        begin
         read(f,cfg);
        end;
       close(f);
       lapset:=cfg.laps;
        if cfg.diff=0 then begin min:=4; max:=6; end;
        if cfg.diff=1 then begin min:=6; max:=8; end;
        if cfg.diff=2 then begin min:=8; max:=9; end;



     install_new_keyboard_driver;


     setmode($13);

     SPEED:=4;


     getmem(dst,64000);
     getmem(pic,64000);
end;




Procedure zeitstrecke;
Begin
key_up    :=false; key_down  :=false; key_left  :=false; key_right :=false;
clearpal;

if modus=4 then begin
  loadraw('ssw', src,p,       0,16*24*24);loadraw('ampelp',src,p,36*24*24, 6*24*24);
  loadraw('zifferp',src,p,64*24*24,14*24*24);loadraw('charsp',src,p,78*24*24,26*24*24);
  loadraw('bahn4',vidptr,p2,0,64000);   loadraw('bahn4sw',pic,psw,0,64000);
  with car1 do  begin v:=0; posx:=192; posy:=126; angle:=0; end;
  end;

if modus=3 then begin
  loadraw('shipw', src,p,       0,16*24*24);loadraw('ampelo',src,p,36*24*24, 6*24*24);
  loadraw('ziffero',src,p,64*24*24,14*24*24);loadraw('charso',src,p,78*24*24,26*24*24);
  loadraw('odyssey',vidptr,p2,0,64000);   loadraw('odysssw',pic,psw,0,64000);
  with car1 do  begin v:=0; posx:=185; posy:=180; angle:=0; end;
    end;
if modus=2 then begin
loadraw('bmwt1', src,p,       0,16*24*24);loadraw('ampelt',src,p,36*24*24, 6*24*24);
loadraw('ziffert',src,p,64*24*24,14*24*24);loadraw('charst',src,p,78*24*24,26*24*24);
loadraw('beach2',vidptr,p2,0,64000); loadraw('beach2sw',pic,psw,0,64000);
with car1 do begin v:=0; posx:=300; posy:=175;  angle:=0;  end;
end;
if modus=1 then begin
 loadraw('rennw', src,p,       0,16*24*24); loadraw('ampel',src,p,36*24*24, 6*24*24);
 loadraw('ziffer',src,p,64*24*24,14*24*24); loadraw('chars',src,p,78*24*24,26*24*24);
 loadraw('bahn2',vidptr,p2,0,64000); loadraw('bahn2sw',pic,psw,0,64000);
 with car1 do begin v:=0;posx:=148; posy:=165; angle:=0;   end;
 end;
  copymem(vidptr,dst,16000);fadein(p2);
     timein:=false;backsich:=true; takt:=0;
     check1:=false;check2:=false;check3:=false; check4:=false; runde:=0;
     dars1(car1.posx-12,car1.posy-12,car1.angle);
     startrace; gettime(h1,m1,s1,c1);
   repeat
    if (takt mod 36=16) and (timein=false) then begin timein:=true;
     for e:=0 to 4 do PutSprite2(Src,dst,99+e*24,20,42+e);
     {new}
     for e:=0 to 10 do GetSprite(dst,Src,52+e*24,0,42+e);
     {ends}       putsprite(src,dst,52+24*7,0,64+10);
     putsprite(src,dst,52+24*10,0,4);
     end;
     if backsich=true then
     begin GetSprite(dst,src, 18,174 ,53);
     backsich:=false;  putsprite(src,dst,18+16,174,64+12);
     putsprite(src,dst,18+32,174,64+lapset); putsprite(src,dst,0,174,4);
     end;


      if (modus=1) or (modus=3) or (modus=4) then begin
       if runde<lapset then             {ausrollen}
       taste_erkennen
        else begin key_up:=false;key_down:=false;key_left:=false;
        key_right:=false;
        if car1.v>0 then dec(car1.v)
              else if car1.v<0 then inc(car1.v);end; end;
        if (modus=2) then begin
         if not((runde=lapset) and (check3=true))  then
         taste_erkennen
          else begin key_up:=false;key_down:=false;key_left:=false;
          key_right:=false; if car1.v>0 then dec(car1.v)
           else if car1.v<0 then inc(car1.v);end;
           if runde=lapset then writetext(src,dst,5,150,'FINALE');end;
       car:=car1;
       humanparameter;
       koord_berechnen(car.posx,car.posy,car.v,car.angle,takt);
       kollision;
       kollisionsabfrage320200; {spezifische}
       halbkollision;  {kartenunabhaengig}
    if ((((modus=1) or (modus=3) or (modus=4)) and (runde<lapset)) or
       ((modus=2) and not((runde=lapset) and (check3=true))))
        and (timein=true)
        then clock;

       lap(1);
       dars1(car.posx-12,car.posy-12,car.angle);
       car1:=car;

     if modus=4 then begin
       if (car1.posx<=177) and (car1.posx>=152) and
          (car1.posy>=105) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
               check2:=false; check3:=false; end;
       if (car1.posx<=70) and (car1.posx>=0) and
          (car1.posy>=50) and (car1.posy<=70) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; end;
       if (car1.posx<=319) and (car1.posx>=249) and
          (car1.posy>=50) and (car1.posy<=70)
          then
           if check2=false then begin check3:=false; check1:=false; end
            else check3:=true; end;
      if modus=3 then begin
       if (car1.posx<=174) and (car1.posx>=154) and
          (car1.posy>=150) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
               check2:=false; check3:=false; end;
       if (car1.posx<=80) and (car1.posx>=0) and
          (car1.posy>=0) and (car1.posy<=90) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; end;
       if (car1.posx<=319) and (car1.posx>=234) and
          (car1.posy>=90) and (car1.posy<=110)
          then
           if check2=false then begin check3:=false; check1:=false; end
            else check3:=true; end;
if modus=2 then begin
       if (car1.posx<=255) and (car1.posx>=240) and
          (car1.posy>=120) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) and (check4=true)
          then inc(runde);
               check2:=false; check3:=false;check4:=false;
          end;
       if (car1.posx<=80) and (car1.posx>=65) and
          (car1.posy>=0) and (car1.posy<=80) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; check4:=false;
             end;
       if (car1.posx<=60) and (car1.posx>=45) and
          (car1.posy>=120) and (car1.posy<=199)
          then
           if check2=false then begin check3:=false;
              check4:=false; end
          else check3:=true;
       if (car1.posx<=265) and (car1.posx>=240) and
          (car1.posy>=0) and (car1.posy<=60)
          then
           if check3=false then begin check4:=false;  end
            else check4:=true;end;
    if modus=1 then begin
       if (car1.posx<=133) and (car1.posx>=100) and
          (car1.posy>=120) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
             check2:=false; check3:=false;
          end;
       if (car1.posx<=183) and (car1.posx>=150) and
          (car1.posy>=0) and (car1.posy<=80) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; end;
       if (car1.posx<=233) and (car1.posx>=200) and
          (car1.posy>=120) and (car1.posy<=199)
          then
           if check2=false then begin check3:=false; check1:=false; end
            else check3:=true; end;
      inc(takt); takt:=takt mod 36;
 until (key_pressed(1)) or (((modus=1) or (modus=3) or (modus=4))and
       ((runde=lapset) and (car1.v=0))) or
       ((modus=2) and (runde=lapset) and (check3=true) and
       (car1.v=0));

      fadeout(p2);
      hauptmenu:=true;

end;


Procedure CPUstrecke;
Begin
clearpal;


if modus=4 then begin
  loadraw('ssw', src,p,       0,16*24*24);loadraw('ssr', src,p,16*24*24,16*24*24);
  loadraw('ampelp',src,p,36*24*24, 6*24*24);loadraw('zifferp',src,p,64*24*24,14*24*24);
  loadraw('charsp',src,p,78*24*24,26*24*24);loadraw('bahn4',vidptr,p2,0,64000);
  loadraw('bahn4sw',pic,psw,0,64000);
  with car1 do  begin v:=0; posx:=192; posy:=121; angle:=0; end;
  with car2 do  begin v:=0; posx:=192; posy:=131; angle:=0; end; end;

if modus = 3 then begin
loadraw('odyssey',vidptr,p2,0,64000);loadraw('odysssw',pic,psw,0,64000);
loadraw('shipw', src,p,       0,16*24*24); loadraw('shipr', src,p,16*24*24,16*24*24);
loadraw('ampelo',src,p,36*24*24, 6*24*24); loadraw('ziffero',src,p,64*24*24,14*24*24);
loadraw('charso',src,p,78*24*24,26*24*24);
with car2 do begin v:=0; posx:=185; posy:=175; angle:=0; end;
with car1 do begin v:=0; posx:=185; posy:=185; angle:=0; end;
end;
if modus = 2 then begin
loadraw('beach2',vidptr,p2,0,64000);loadraw('beach2sw',pic,psw,0,64000);
loadraw('bmwt1', src,p,       0,16*24*24); loadraw('bmwt2', src,p,16*24*24,16*24*24);
loadraw('ampelt',src,p,36*24*24, 6*24*24); loadraw('ziffert',src,p,64*24*24,14*24*24);
loadraw('charst',src,p,78*24*24,26*24*24);
with car2 do begin v:=0; posx:=20; posy:=172; angle:=180; end;
with car1 do begin v:=0; posx:=300; posy:=175; angle:=0; end;
end;
if modus = 1 then begin
loadraw('bahn2',vidptr,p2,0,64000); loadraw('bahn2sw',pic,psw,0,64000);
loadraw('rennw', src,p,       0,16*24*24); loadraw('rennr', src,p,16*24*24,16*24*24);
loadraw('ampel',src,p,36*24*24, 6*24*24);  loadraw('ziffer',src,p,64*24*24,14*24*24);
loadraw('chars',src,p,78*24*24,26*24*24);
with car1 do begin v:=0; posx:=148; posy:=175; angle:=0; end;
with car2 do begin v:=0; posx:=148; posy:=155; angle:=0; end;
end;
kuc:=false;key_up:=false;  kdc:=false;key_down:=false;
klc:=false;key_left:=false;  krc:=false;key_right:=false;
timein:=false;hwon:=false;cwon:=false; time2anz:=true;timeafter:=true;
backsich:=true;copymem(vidptr,dst,16000);fadein(p2);sprscan;



takt:=0; streckenpunkt:=0;
check1:=false;check2:=false;check3:=false;check4:=false;runde:=0;
checkc1:=false;checkc2:=false;checkc3:=false;checkc4:=false;rundec:=0;
dars(car1.posx-12,car1.posy-12,car2.posx-12,car2.posy-12,car1.angle,car2.angle);
startrace;gettime(h1,m1,s1,c1);
  repeat
    if (takt mod 36=16) and (timein=false) then begin
     for e:=0 to 4 do PutSprite2(Src,dst,99+e*24,20,42+e);
     for e:=0 to 10 do GetSprite(dst,Src,52+e*24,0,42+e); timein:=true;
                       GetSprite(dst,src,52+10*24+3,0,42+13);
                       putsprite(src,dst,52+24*7,0,64+10);
     putsprite(src,dst,52+24*10+8,0,16+4);
     if (modus=1) or (modus=3) or (modus=4) then
      putsprite(src,dst,52+24*10-5,0,4);
     if modus=2 then putsprite(src,dst,52+24*10-5,1,4);
     end;

     if backsich=true then begin backsich:=false;
     GetSprite(dst,src, 18,174 ,53); GetSprite(dst,src, 240,174,54);
     putsprite(src,dst,18+16,174,64+12);putsprite(src,dst,18+32,174,64+lapset);
     putsprite(src,dst,0,174,4); putsprite(src,dst,240+16,174,64+12);
     putsprite(src,dst,240+32,174,64+lapset);putsprite(src,dst,295,174,4+16);
        end;
 if modus=2 then begin if runde=lapset then writetext(src,dst,5,150,'FINALE');
      if rundec=lapset then writetext(src,dst,206,150,'FINALE'); end;

     if (modus=1) or (modus=3) or (modus=4) then begin
     if (runde=lapset) and (cwon=false) then hwon:=true;
       if runde<lapset then taste_erkennen
        else begin key_up:=false;key_down:=false;key_left:=false;
        key_right:=false; if car1.v>0 then dec(car1.v)
              else if car1.v<0 then inc(car1.v); end; end;

     if (modus=2) then begin
      if (runde=lapset) and (check3=true) and (cwon=false) then hwon:=true;
      if not((runde=lapset) and (check3=true)) then taste_erkennen
        else begin key_up:=false;key_down:=false;key_left:=false;
        key_right:=false; if car1.v>0 then dec(car1.v)
          else if car1.v<0 then inc(car1.v); end; end;
     if (modus=1) or (modus=3) or (modus=4) then
      if (rundec=lapset) and (hwon=false) then cwon:=true;
     if modus=2 then
     if (rundec=lapset) and (checkc3=true) and (hwon=false) then cwon:=true;

       car:=car1;
       humanparameter;
       koord_berechnen(car.posx,car.posy,car.v,car.angle,takt);
       kollision;
       GetSprite(Pic,Src,-12+car2.posx,-12+car2.posy,34);

     for sprx:=0 to 23 do for spry:= 0 to 23 do
     if spr2[sprx,spry,round(car2.angle/22.5)]=true then
      putpixel(PIC,car2.posx+sprx-12,car2.posy+spry-12,0);
       kollisionsabfrage320200;
      PutSprite2(Src,Pic,-12+car2.posx,-12+car2.posy,34);

       halbkollision;
       car1:=car;

  if modus=4 then begin
       if (car1.posx<=177) and (car1.posx>=152) and
          (car1.posy>=105) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
               check2:=false; check3:=false; end;
       if (car1.posx<=70) and (car1.posx>=0) and
          (car1.posy>=50) and (car1.posy<=70) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; end;
       if (car1.posx<=319) and (car1.posx>=249) and
          (car1.posy>=50) and (car1.posy<=70)
          then
           if check2=false then begin check3:=false; check1:=false; end
            else check3:=true;

       if (car2.posx<=177) and (car2.posx>=152) and
          (car2.posy>=105) and (car2.posy<=199)
          then begin checkc1:=true;
          if (checkc2=true) and (checkc3=true) then inc(rundec);
               checkc2:=false; checkc3:=false; end;
       if (car2.posx<=70) and (car2.posx>=0) and
          (car2.posy>=50) and (car2.posy<=70) then
            if (checkc1=false) then checkc2:=false
             else begin checkc2:=true; checkc3:=false; end;
       if (car2.posx<=319) and (car2.posx>=249) and
          (car2.posy>=50) and (car2.posy<=70)
          then
           if checkc2=false then begin checkc3:=false; checkc1:=false; end
            else checkc3:=true; end;

if modus=3 then begin
  {cp1} if (car1.posx<=174) and (car1.posx>=154) and
          (car1.posy>=150) and (car1.posy<=199) then begin check1:=true;
    if (check2=true) and (check3=true) then inc(runde);
    check2:=false; check3:=false;  end;
   {cp2}
       if (car1.posx<=80) and (car1.posx>=0) and
          (car1.posy>=0) and (car1.posy<=90) then
 if (check1=false) then check2:=false else begin check2:=true; check3:=false; end;
   {cp3} if (car1.posx<=319) and (car1.posx>=234) and
          (car1.posy>=90) and (car1.posy<=110) then
      if check2=false then begin check3:=false; check1:=false; end
           else check3:=true;
  {cp1} if (car2.posx<=174) and (car2.posx>=154) and
          (car2.posy>=150) and (car2.posy<=199)  then begin checkc1:=true;
          if (checkc2=true) and (checkc3=true) then inc(rundec);
          checkc2:=false; checkc3:=false; end;
   {cp2} if (car2.posx<=80) and (car2.posx>=0) and
    (car2.posy>=0) and (car2.posy<=90) then if (checkc1=false) then checkc2:=false
     else begin checkc2:=true; checkc3:=false; end;
   {cp3} if (car2.posx<=319) and (car2.posx>=234) and
      (car2.posy>=90) and (car2.posy<=110) then
      if checkc2=false then begin checkc3:=false; checkc1:=false; end
        else checkc3:=true; end;
if modus=2 then begin
      {cp1} if (car1.posx<=255) and (car1.posx>=240) and
          (car1.posy>=120) and (car1.posy<=199) then begin check1:=true;
          if (check2=true) and (check3=true) and (check4=true)
          then inc(runde); check2:=false; check3:=false;check4:=false; end;
       {cp2} if (car1.posx<=80) and (car1.posx>=65) and
    (car1.posy>=0) and (car1.posy<=80) then if (check1=false) then check2:=false
    else begin check2:=true; check3:=false; check4:=false; end;
       {cp3}
    if (car1.posx<=60) and (car1.posx>=45) and (car1.posy>=120) and (car1.posy<=199)
    then if check2=false then begin check3:=false; check4:=false; end
      else check3:=true;
       {cp4} if (car1.posx<=265) and (car1.posx>=240) and
          (car1.posy>=0) and (car1.posy<=60) then
       if check3=false then begin check4:=false;  end else check4:=true;
  {cp1}   if (car2.posx<=60) and (car2.posx>=45) and
          (car2.posy>=120) and (car2.posy<=199)  then begin checkc1:=true;
     if (checkc2=true) and (checkc3=true) and (checkc4=true) then inc(rundec);
     checkc2:=false; checkc3:=false;checkc4:=false; end;
   {cp2} if (car2.posx<=265) and (car2.posx>=240) and
         (car2.posy>=0) and (car2.posy<=60) then
         if (checkc1=false) then checkc2:=false
        else begin checkc2:=true; checkc3:=false; checkc4:=false; end;
   {cp3} if (car2.posx<=255) and (car2.posx>=240) and
          (car2.posy>=120) and (car2.posy<=199) then
       if checkc2=false then begin checkc3:=false;  checkc4:=false; end
         else checkc3:=true;
    {cp4} if (car2.posx<=80) and (car2.posx>=65) and
          (car2.posy>=0) and (car2.posy<=80) then
          if checkc3=false then begin checkc4:=false;  end
            else checkc4:=true;
end;

if modus=1 then begin
{cp1}
    if (car1.posx<=133) and (car1.posx>=100) and
       (car1.posy>=120) and (car1.posy<=199) then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
               check2:=false; check3:=false; end;

       if (car1.posx<=183) and (car1.posx>=150) and (car1.posy>=0) and (car1.posy<=80) then
       if (check1=false) then check2:=false else begin check2:=true; check3:=false; end;

       if (car1.posx<=233) and (car1.posx>=200) and
          (car1.posy>=120) and (car1.posy<=199)
          then if check2=false then begin check3:=false; check1:=false; end
         else check3:=true;

    if (car2.posx<=133) and (car2.posx>=100) and (car2.posy>=120) and (car2.posy<=199)
       then begin checkc1:=true; if (checkc2=true) and (checkc3=true) then inc(rundec);
       checkc2:=false; checkc3:=false; end;

    if (car2.posx<=183) and (car2.posx>=150) and (car2.posy>=0) and (car2.posy<=80) then
      if (checkc1=false) then checkc2:=false else begin checkc2:=true; checkc3:=false; end;

    if (car2.posx<=233) and (car2.posx>=200) and (car2.posy>=120) and (car2.posy<=199)
       then if checkc2=false then begin checkc3:=false; checkc1:=false; end
       else checkc3:=true;
   end;

 strpkt(streckenpunkt,zielx,ziely,zielv,modus,min,max,car2.posx,car2.posy);
  if (((modus=1) or (modus=3) or (modus=4)) and (rundec=lapset)) or
     ((modus=2) and (rundec=lapset) and (checkc3=true)) then zielv:=0;


 pathfinder(zielx,ziely,zielv);

       car:=car2;
       cpuparameter;
       koord_berechnen(car.posx,car.posy,car.v,car.angle,takt);
       kollision;
       GetSprite(Pic,Src,-12+car1.posx,-12+car1.posy,35);


      for sprx:=0 to 23 do for spry:= 0 to 23 do
      if spr1[sprx,spry,round(car1.angle/22.5)]=true then
       putpixel(PIC,car1.posx+sprx-12,car1.posy+spry-12,0);

       kollisionsabfrage320200;

      PutSprite2(Src,Pic,-12+car1.posx,-12+car1.posy,35);
            halbkollision;
       car2:=car;

       if (modus=1) or (modus=3) or (modus=4) then
       if (timein=true)  and (runde<lapset) and (rundec<lapset) then clock;

       if modus=2 then
       if (timein=true)  and not((runde=lapset) and (check3=true))
       and not((rundec=lapset) and (checkc3=true)) then clock;

      if cwon=true then begin putsprite2(src,dst,52+24*10,0,52);
                              putsprite2(src,dst,52+24*10+3,0,55);
                              putsprite(src,dst,52+24*10,0,16+4);
                              WriteText(Src,dst,130,70,'CPU');
                              WriteText(Src,dst,120,100,'SIEGT');
                 if (runde=lapset) and ((modus=1) or (modus=3) or (modus=4))
                 then putsprite(src,dst,52+24*10,0+24,4);
                 if (runde=lapset) and (check3=true) and (modus=2)
                 then putsprite(src,dst,52+24*10,1+24,4); end;

      if hwon=true then begin putsprite2(src,dst,52+24*10,0,52);
                              putsprite2(src,dst,52+24*10+3,0,55);
                              if (modus=1) or (modus=3) or (modus=4) then
                               putsprite(src,dst,52+24*10,0,4);
                               if (modus=2) then
                               putsprite(src,dst,52+24*10,1,4);
                              WriteText(Src,dst,140,70,'DU');
                              WriteText(Src,dst,110,100,'SIEGST');
               if (rundec=lapset) and ((modus=1) or (modus=3) or (modus=4))  then
                      putsprite(src,dst,52+24*10,0+24,16+4);
                      if (rundec=lapset) and (checkc3=true) and (modus=2) then
                      putsprite(src,dst,52+24*10,0+24,16+4);

                      end;

       lap(2);
    dars(car1.posx-12,car1.posy-12,car2.posx-12,car2.posy-12,car1.angle,car2.angle);
      inc(takt); takt:=takt mod 36;


if ((((cwon=true) and (runde=lapset)) or ((hwon=true) and (rundec=lapset)))
   and ((modus=1) or (modus=3) or (modus=4)) and (timeafter=true)) or
   ((((cwon=true) and (runde=lapset) and (check3=true))
    or ((hwon=true) and (rundec=lapset) and (checkc3=true))) and (modus=2)
      and (timeafter=true)) then

      begin gettime(h,m,s,c);
       if h<h1 then h:=h+24;
       timeafter:=false;
       if m<m1 then begin m:=m+60;  dec(h); end;
       if s<s1 then begin s:=s+60;  dec(m); end;
       if c<c1 then begin c:=c+100; dec(s); end;
       h:=h-h1; m:=m-m1; s:=s-s1; c:=c-c1;



if (s<0) or (s>59) then begin s:=59; dec(m); end;
if (m<0) or (m>59) then begin m:=59; dec(h); end;

      if time2anz=true then begin
       if h<hg then h:=h+24;
       if m<mg then begin m:=m+60;  dec(h); end;
       if s<sg then begin s:=s+60;  dec(m); end;
       if c<cg then begin c:=c+100; dec(s); end;
       h:=h-hg; m:=m-mg; s:=s-sg; c:=c-cg;

    alls2:=h*60*60*100+m*60*100+s*100+c; time2anz:=false end;

       if alls2>=0 then  begin putsprite(src,dst,52+24*8,24,64+(c div 10));
                              putsprite(src,dst,52+24*9,24,64+(c mod 10));end;
       if alls2>=100 then  begin putsprite(src,dst,52+24*6,24,64+(s mod 10));
       putsprite(src,dst,52+24*7,24,64+10); end;
       if alls2>=1000 then  putsprite(src,dst,52+24*5,24,64+(s div 10));
       if alls2>=6000 then  begin putsprite(src,dst,52+24*3,24,64+(m mod 10));
       putsprite(src,dst,52+24*4,24,64+11); end;
       if alls2>=60000 then putsprite(src,dst,52+24*2,24,64+(m div 10));
       if alls2>360000 then begin putsprite(src,dst,52+24*0,24,64+(h mod 10));
        putsprite(src,vidptr,52+24*1,24,64+11); end;
       if alls2<100 then putsprite(src,dst,52+24*7,24,77) else
       if alls2<1000 then putsprite(src,dst,52+24*5,24,77) else
       if alls2<6000 then putsprite(src,dst,52+24*4,24,77) else
       if alls2<60000 then putsprite(src,dst,52+24*2,24,77) else
       if alls2<360000 then putsprite(src,dst,52+24*1,24,77) else
       putsprite(src,dst,52-24,24,77);

     dars(car1.posx-12,car1.posy-12,
            car2.posx-12,car2.posy-12,car1.angle,car2.angle);
   end;

 until (key_pressed(1)) or ((car1.v=0) and
        ((((modus=1) or (modus=3) or (modus=4)) and (runde=lapset))
        or ((modus=2) and (runde=lapset) and (check3=true))));



      fadeout(p2);
      hauptmenu:=true;

end;



Procedure Multistrecke;
Begin
timein:=false;hwon:=false;cwon:=false; time2anz:=true;timeafter:=true;
backsich:=true; clearpal;streckenpunkt:=0;
randomize; art:=random(2);

if modus=4 then begin
  loadraw('ssw', src,p,       0,16*24*24);loadraw('ssr', src,p,16*24*24,16*24*24);
  loadraw('ampelp',src,p,36*24*24, 6*24*24);loadraw('zifferp',src,p,64*24*24,14*24*24);
  loadraw('charsp',src,p,78*24*24,26*24*24);loadraw('bahn4',vidptr,p2,0,64000);
  loadraw('bahn4sw',pic,psw,0,64000);
  if art=0 then begin
  with car1 do  begin v:=0; posx:=192; posy:=121; angle:=0; end;
  with car2 do  begin v:=0; posx:=192; posy:=131; angle:=0; end; end
  else begin
  with car2 do  begin v:=0; posx:=192; posy:=121; angle:=0; end;
  with car1 do  begin v:=0; posx:=192; posy:=131; angle:=0; end; end; end;


if  modus=3 then begin
 loadraw('shipw', src,p,       0,16*24*24);loadraw('shipr', src,p,16*24*24,16*24*24);
 loadraw('ampelo',src,p,36*24*24, 6*24*24);loadraw('ziffero',src,p,64*24*24,14*24*24);
 loadraw('charso',src,p,78*24*24,26*24*24);loadraw('odyssey',vidptr,p2,0,64000);
 loadraw('odysssw',pic,psw,0,64000);
 if art=0 then begin
   with car1 do begin v:=0; posx:=185; posy:=175; angle:=0; end;
   with car2 do begin v:=0; posx:=185; posy:=185; angle:=0; end; end
 else begin
       with car2 do begin v:=0; posx:=185; posy:=175; angle:=0; end;
       with car1 do begin v:=0; posx:=185; posy:=185; angle:=0; end; end; end;
if modus=2 then begin
  loadraw('bmwt1', src,p,       0,16*24*24); loadraw('bmwt2', src,p,16*24*24,16*24*24);
  loadraw('ampelt',src,p,36*24*24, 6*24*24); loadraw('ziffert',src,p,64*24*24,14*24*24);
  loadraw('charst',src,p,78*24*24,26*24*24); loadraw('beach2',vidptr,p2,0,64000);
  loadraw('beach2sw',pic,psw,0,64000);
 if art=0 then begin
    with car1 do begin v:=0; posx:=20; posy:=172; angle:=180; end;{w li}
    with car2 do begin v:=0; posx:=300; posy:=175; angle:=0; end; end
       else begin
       with car2 do begin v:=0; posx:=20; posy:=172; angle:=180; end;{w re}
       with car1 do begin v:=0; posx:=300; posy:=175; angle:=0; end; end;end;
if modus=1 then begin
  loadraw('rennw', src,p,       0,16*24*24); loadraw('rennr', src,p,16*24*24,16*24*24);
  loadraw('ampel',src,p,36*24*24, 6*24*24);  loadraw('ziffer',src,p,64*24*24,14*24*24);
  loadraw('chars',src,p,78*24*24,26*24*24);  loadraw('bahn2',vidptr,p2,0,64000);
  loadraw('bahn2sw',pic,psw,0,64000);
if art=0 then begin
  with car1 do begin v:=0; posx:=148; posy:=175; angle:=0; end;
  with car2 do begin v:=0; posx:=148; posy:=155; angle:=0; end; end
 else begin
  with car2 do begin v:=0; posx:=148; posy:=175; angle:=0; end;
  with car1 do begin v:=0; posx:=148; posy:=155; angle:=0; end; end;end;
   copymem(vidptr,dst,16000); fadein(p2);
    kuc:=false;key_up:=false;kdc:=false;key_down :=false;
    klc:=false;key_left:=false;krc:=false;key_right:=false;
  sprscan; takt:=0;
      check1:=false;check2:=false;check3:=false; check4:=false;runde:=0;
      checkc1:=false;checkc2:=false;checkc3:=false; checkc4:=false;rundec:=0;
 dars(car1.posx-12,car1.posy-12,car2.posx-12,car2.posy-12,car1.angle,car2.angle);
     startrace;
     gettime(h1,m1,s1,c1);
  repeat
    if (takt mod 36=16) and (timein=false) then begin
     for e:=0 to 4 do PutSprite2(Src,dst,99+e*24,20,42+e);
     for e:=0 to 10 do GetSprite(dst,Src,52+e*24,0,42+e); timein:=true;
                       GetSprite(dst,src,52+10*24+3,0,42+13);
    putsprite(src,dst,52+24*7,0,64+10);
    putsprite(src,dst,52+24*10+8,0,16+4);
    if (modus=1) or (modus=3) or (modus=4) then
    putsprite(src,dst,52+24*10-5,0,4);
    if modus=2 then putsprite(src,dst,52+24*10-5,1,4);
    end;

   if backsich=true then begin backsich:=false;
   GetSprite(dst,src, 18,174 ,53); GetSprite(dst,src, 240,174,54);
   putsprite(src,dst,18+16,174,64+12); putsprite(src,dst,18+32,174,64+lapset);
   putsprite(src,dst,0,174,4); putsprite(src,dst,240+16,174,64+12);
   putsprite(src,dst,240+32,174,64+lapset); putsprite(src,dst,295,174,4+16);
    end;

if (modus=1) or (modus=3) or (modus=4)
  then begin if (runde=lapset) and (cwon=false) then hwon:=true;
     if runde<lapset then
       taste_erkennen
      else begin key_up:=false;key_down:=false;key_left:=false;
       key_right:=false; if car1.v>0 then dec(car1.v)
              else if car1.v<0 then inc(car1.v); end; end;

    if (modus=2) then begin
     if runde=lapset then writetext(src,dst,5,150,'FINALE');
     if rundec=lapset then writetext(src,dst,206,150,'FINALE');
      if (runde=lapset) and (check3=true) and (cwon=false) then hwon:=true;
     if not((runde=lapset) and (check3=true)) then taste_erkennen
        else begin key_up:=false;key_down:=false;key_left:=false;
        key_right:=false;
        if car1.v>0 then dec(car1.v) else if car1.v<0 then inc(car1.v); end; end;

      if (modus=1) or (modus=3) or (modus=4) then begin
      if (rundec=lapset) and (hwon=false) then cwon:=true;
       if rundec<lapset then taste2_erkennen
        else begin kuc:=false;kdc:=false;klc:=false; krc:=false;
        if car2.v>0 then dec(car2.v)
         else if car2.v<0 then inc(car2.v); end; end;
     if modus=2 then  if (rundec=lapset) and (checkc3=true) and (hwon=false) then cwon:=true;
       if not((rundec=lapset) and (checkc3=true)) then
        taste2_erkennen else begin kuc:=false;kdc:=false;klc:=false;
        krc:=false;
        if car2.v>0 then dec(car2.v)
         else if car2.v<0 then inc(car2.v); end;
    car:=car1;  humanparameter; koord_berechnen(car.posx,car.posy,car.v,car.angle,takt);
    kollision;
    GetSprite(Pic,Src,-12+car2.posx,-12+car2.posy,34);
      for sprx:=0 to 23 do for spry:= 0 to 23 do
     if spr2[sprx,spry,round(car2.angle/22.5)]=true then
      putpixel(PIC,car2.posx+sprx-12,car2.posy+spry-12,0);
      kollisionsabfrage320200; PutSprite2(Src,Pic,-12+car2.posx,-12+car2.posy,34);
      halbkollision; car1:=car;



{cp}     if modus=4 then begin
       if (car1.posx<=177) and (car1.posx>=152) and
          (car1.posy>=105) and (car1.posy<=199)
          then begin check1:=true;
          if (check2=true) and (check3=true) then inc(runde);
               check2:=false; check3:=false; end;
       if (car1.posx<=70) and (car1.posx>=0) and
          (car1.posy>=50) and (car1.posy<=70) then
            if (check1=false) then check2:=false
             else begin check2:=true; check3:=false; end;
       if (car1.posx<=319) and (car1.posx>=249) and
          (car1.posy>=50) and (car1.posy<=70)
          then
           if check2=false then begin check3:=false; check1:=false; end
            else check3:=true;

       if (car2.posx<=177) and (car2.posx>=152) and
          (car2.posy>=105) and (car2.posy<=199)
          then begin checkc1:=true;
          if (checkc2=true) and (checkc3=true) then inc(rundec);
               checkc2:=false; checkc3:=false; end;
       if (car2.posx<=70) and (car2.posx>=0) and
          (car2.posy>=50) and (car2.posy<=70) then
            if (checkc1=false) then checkc2:=false
             else begin checkc2:=true; checkc3:=false; end;
       if (car2.posx<=319) and (car2.posx>=249) and
          (car2.posy>=50) and (car2.posy<=70)
          then
           if checkc2=false then begin checkc3:=false; checkc1:=false; end
            else checkc3:=true; end;

     if modus=3 then begin
      {cp1}
    if (car1.posx<=174) and (car1.posx>=154) and (car1.posy>=150) and (car1.posy<=199)
    then begin check1:=true; if (check2=true) and (check3=true) then inc(runde);
      check2:=false; check3:=false; end;
      {cp2}
       if (car1.posx<=80) and (car1.posx>=0) and (car1.posy>=0) and (car1.posy<=90) then
       if (check1=false) then check2:=false else begin check2:=true; check3:=false; end;
      {cp3}
       if (car1.posx<=319) and (car1.posx>=234) and (car1.posy>=90) and (car1.posy<=110)
  then if check2=false then begin check3:=false; check1:=false; end
       else check3:=true;
      {cp1}
     if (car2.posx<=174) and (car2.posx>=154) and (car2.posy>=150) and (car2.posy<=199)
  then begin checkc1:=true; if (checkc2=true) and (checkc3=true) then inc(rundec);
            checkc2:=false; checkc3:=false; end;
       {cp2}
       if (car2.posx<=80) and (car2.posx>=0) and (car2.posy>=0) and (car2.posy<=90) then
       if (checkc1=false) then checkc2:=false else begin checkc2:=true; checkc3:=false; end;
       {cp3}
     if (car2.posx<=319) and (car2.posx>=234) and (car2.posy>=90) and (car2.posy<=110)
 then if checkc2=false then begin checkc3:=false; checkc1:=false; end
      else checkc3:=true; end;
if modus=2 then begin
{cp1}
  if art=1 then begin if (car1.posx<=255) and (car1.posx>=240) and
       (car1.posy>=120) and (car1.posy<=199) then begin check1:=true;
       if (check2=true) and (check3=true) and (check4=true) then inc(runde);
       check2:=false; check3:=false;check4:=false; end;
 {cp2}
  if (car1.posx<=80) and (car1.posx>=65) and (car1.posy>=0) and (car1.posy<=80) then
  if (check1=false) then check2:=false else begin check2:=true; check3:=false; check4:=false; end;
 {cp3}
  if (car1.posx<=60) and (car1.posx>=45) and (car1.posy>=120) and (car1.posy<=199)
  then if check2=false then begin check3:=false; check4:=false; end
  else check3:=true;
 {cp4}
  if (car1.posx<=265) and (car1.posx>=240) and (car1.posy>=0) and (car1.posy<=60)
  then if check3=false then begin check4:=false;  end else check4:=true; end;
 if art=0 then begin
  if (car1.posx<=60) and (car1.posx>=45) and (car1.posy>=120) and (car1.posy<=199) then
   begin check1:=true; if (check2=true) and (check3=true) and (check4=true)
   then inc(runde); check2:=false; check3:=false;check4:=false; end;
 {cp2}
 if (car1.posx<=265) and (car1.posx>=240) and (car1.posy>=0) and (car1.posy<=60) then
 if (check1=false) then check2:=false else begin check2:=true; check3:=false; check4:=false; end;
 {cp3}
 if (car1.posx<=255) and (car1.posx>=240) and (car1.posy>=120) and (car1.posy<=199) then
   if check2=false then begin check3:=false; check4:=false; end
   else check3:=true;
  {cp4}
 if (car1.posx<=80) and (car1.posx>=65) and (car1.posy>=0) and (car1.posy<=80) then
   if check3=false then begin check4:=false;  end else check4:=true; end;
  {cp1}
  if art=0 then begin if (car2.posx<=255) and (car2.posx>=240) and
   (car2.posy>=120) and (car2.posy<=199) then begin checkc1:=true;
   if (checkc2=true) and (checkc3=true) and (checkc4=true)
   then inc(rundec); checkc2:=false; checkc3:=false;checkc4:=false; end;
  {cp2}
  if (car2.posx<=80) and (car2.posx>=65) and (car2.posy>=0) and (car2.posy<=80) then
   if (checkc1=false) then checkc2:=false else begin
   checkc2:=true; checkc3:=false; checkc4:=false; end;
   {cp3}
   if (car2.posx<=60) and (car2.posx>=45) and (car2.posy>=120) and (car2.posy<=199)
   then if checkc2=false then begin checkc3:=false; checkc4:=false; end
   else checkc3:=true;
   {cp4}
   if (car2.posx<=265) and (car2.posx>=240) and (car2.posy>=0) and (car2.posy<=60)
   then if checkc3=false then begin checkc4:=false;  end else checkc4:=true; end;
  if art=1 then begin
   {cp1}
    if (car2.posx<=60) and (car2.posx>=45) and (car2.posy>=120) and (car2.posy<=199)
    then begin checkc1:=true; if (checkc2=true) and (checkc3=true) and (checkc4=true)
    then inc(rundec); checkc2:=false; checkc3:=false;checkc4:=false; end;
   {cp2}
   if (car2.posx<=265) and (car2.posx>=240) and (car2.posy>=0) and (car2.posy<=60)
   then if (checkc1=false) then checkc2:=false
   else begin checkc2:=true; checkc3:=false; checkc4:=false; end;
   {cp3}
   if (car2.posx<=255) and (car2.posx>=240) and (car2.posy>=120) and (car2.posy<=199)
   then if checkc2=false then begin checkc3:=false; checkc4:=false; end
   else checkc3:=true;
   {cp4}
   if (car2.posx<=80) and (car2.posx>=65) and (car2.posy>=0) and (car2.posy<=80) then
   if checkc3=false then begin checkc4:=false;  end else checkc4:=true;
    end;end;

if modus=1 then begin
 if (car1.posx<=133) and (car1.posx>=100) and (car1.posy>=120) and (car1.posy<=199)
 then begin check1:=true; if (check2=true) and (check3=true) then inc(runde);
 check2:=false; check3:=false; end;
 if (car1.posx<=183) and (car1.posx>=150) and (car1.posy>=0) and (car1.posy<=80) then
  if (check1=false) then check2:=false else begin check2:=true; check3:=false; end;
  if (car1.posx<=233) and (car1.posx>=200) and (car1.posy>=120) and (car1.posy<=199)
   then
  if check2=false then begin check3:=false; check1:=false; end
   else check3:=true;
   if (car2.posx<=133) and (car2.posx>=100) and
   (car2.posy>=120) and (car2.posy<=199) then begin checkc1:=true;
    if (checkc2=true) and (checkc3=true) then inc(rundec);
    checkc2:=false; checkc3:=false;
    end;
  if (car2.posx<=183) and (car2.posx>=150) and (car2.posy>=0) and (car2.posy<=80) then
   if (checkc1=false) then checkc2:=false else begin checkc2:=true; checkc3:=false; end;
  if (car2.posx<=233) and (car2.posx>=200) and (car2.posy>=120) and (car2.posy<=199)
    then if checkc2=false then begin checkc3:=false; checkc1:=false; end
     else checkc3:=true;
    end;
       car:=car2; cpuparameter;
       koord_berechnen(car.posx,car.posy,car.v,car.angle,takt);
       kollision; GetSprite(Pic,Src,-12+car1.posx,-12+car1.posy,35);
      for sprx:=0 to 23 do for spry:= 0 to 23 do
      if spr1[sprx,spry,round(car1.angle/22.5)]=true then
       putpixel(PIC,car1.posx+sprx-12,car1.posy+spry-12,0);
       kollisionsabfrage320200;
      PutSprite2(Src,Pic,-12+car1.posx,-12+car1.posy,35);
            halbkollision; car2:=car;

       if (((modus=1) or (modus=3) or (modus=4)) and
          (timein=true)  and (runde<lapset) and (rundec<lapset)) or
      ((modus=2) and (timein=true)  and not((runde=lapset) and (check3=true))
       and not((rundec=lapset) and (checkc3=true))) then
            clock;

    if cwon=true then begin putsprite2(src,dst,52+24*10,0,52);
      putsprite2(src,dst,52+24*10+3,0,55); putsprite(src,dst,52+24*10,0,16+4);
      WriteText(Src,dst,90,70,'SPIELER2'); WriteText(Src,dst,120,100,'SIEGT');
     if ((runde=lapset) and ((modus=1) or (modus=3) or (modus=4))) or
        ((runde=lapset) and (check3=true) and (modus=2)) then begin
       if (modus=1) or (modus=3) or (modus=4) then
        putsprite(src,dst,52+24*10,0+24,4);
       if (modus=2) then
        putsprite(src,dst,52+24*10,1+24,4);
            end;end;

    if hwon=true then begin putsprite2(src,dst,52+24*10,0,52);
      putsprite2(src,dst,52+24*10+3,0,55);
      if (modus=1) or (modus=3) or (modus=4) then
       putsprite(src,dst,52+24*10,0,4);
      if modus=2 then
      putsprite(src,dst,52+24*10,1,4);
      WriteText(Src,dst,90,70,'SPIELER1'); WriteText(Src,dst,120,100,'SIEGT');
     if ((rundec=lapset) and ((modus=1) or (modus=3) or (modus=4))) or
        ((rundec=lapset) and (checkc3=true) and (modus=2)) then
        putsprite(src,dst,52+24*10,0+24,16+4); end;

  lap(2); dars(car1.posx-12,car1.posy-12,car2.posx-12,car2.posy-12,car1.angle,car2.angle);
      inc(takt);takt:=takt mod 36;

   if ((((cwon=true) and (runde=lapset)) or ((hwon=true) and (rundec=lapset)))
   and ((modus=1) or (modus=3) or (modus=4)) and (timeafter=true)) or
   ((((cwon=true) and (runde=lapset) and (check3=true))
    or ((hwon=true) and (rundec=lapset) and (checkc3=true))) and (modus=2)
      and (timeafter=true)) then
       begin gettime(h,m,s,c);
       if h<h1 then h:=h+24;
       timeafter:=false;
       if m<m1 then begin m:=m+60;  dec(h); end;
       if s<s1 then begin s:=s+60;  dec(m); end;
       if c<c1 then begin c:=c+100; dec(s); end;
       h:=h-h1; m:=m-m1; s:=s-s1; c:=c-c1;
if (s<0) or (s>59) then begin s:=59; dec(m); end;
if (m<0) or (m>59) then begin m:=59; dec(h); end;
      if time2anz=true then begin
       if h<hg then h:=h+24;
       if m<mg then begin m:=m+60;  dec(h); end;
       if s<sg then begin s:=s+60;  dec(m); end;
       if c<cg then begin c:=c+100; dec(s); end;
       h:=h-hg; m:=m-mg; s:=s-sg; c:=c-cg;
    alls2:=h*60*60*100+m*60*100+s*100+c; time2anz:=false end;
       if alls2>=0 then  begin putsprite(src,dst,52+24*8,24,64+(c div 10));
                              putsprite(src,dst,52+24*9,24,64+(c mod 10));end;
       if alls2>=100 then  begin putsprite(src,dst,52+24*6,24,64+(s mod 10));
       putsprite(src,dst,52+24*7,24,64+10); end;
       if alls2>=1000 then  putsprite(src,dst,52+24*5,24,64+(s div 10));
       if alls2>=6000 then  begin putsprite(src,dst,52+24*3,24,64+(m mod 10));
       putsprite(src,dst,52+24*4,24,64+11); end;
       if alls2>=60000 then putsprite(src,dst,52+24*2,24,64+(m div 10));
       if alls2>360000 then begin putsprite(src,dst,52+24*0,24,64+(h mod 10));
        putsprite(src,vidptr,52+24*1,24,64+11); end;
       if alls2<100 then putsprite(src,dst,52+24*7,24,77) else
       if alls2<1000 then putsprite(src,dst,52+24*5,24,77) else
       if alls2<6000 then putsprite(src,dst,52+24*4,24,77) else
       if alls2<60000 then putsprite(src,dst,52+24*2,24,77) else
       if alls2<360000 then putsprite(src,dst,52+24*1,24,77) else
       putsprite(src,dst,52-24,24,77);
   dars(car1.posx-12,car1.posy-12,car2.posx-12,car2.posy-12,car1.angle,car2.angle);
   end;
 until (key_pressed(1)) or (((modus=1) or (modus=3) or (modus=4)) and (runde=lapset) and (car1.v=0) and (rundec=lapset)
   and (car2.v=0)) or ((modus=2) and (runde=lapset) and (check3=true) and
       (car1.v=0) and (rundec=lapset) and (checkc3=true));



    fadeout(p2); hauptmenu:=true;
end;

{*****************************Program-Part ends**************}
{*****************************Program-Part ends**************}
{*****************************Program-Part ends**************}



{***************************Menu-Part/Intro-Part*************}

procedure keycfg;
begin
      clearpal;
       loadraw('oph',vidptr,p3,0,64000);
      fadein(p3);
{       cx111:=1;}

      writetext(src,vidptr,10,03,'TASTATURBELEGUNG');
      writetext(src,vidptr,0,33,'SPIELER1 SPIELER2');
      writetext(src,vidptr,130,63, 'GAS');
      writetext(src,vidptr,100,93, 'BREMSE');
      writetext(src,vidptr,110,123, 'LINKS');
      writetext(src,vidptr,100,153, 'RECHTS');
      frame(2,30,150,58,25);      frame(160,30,310,58,25);
      frame(100,63 ,220 ,87,25);  frame(100,93 ,220 ,117,25);
      frame(100,123,220 ,147,25); frame(100,153,220 ,177,25);
      keyuh:=1; keydh:=1;keylh:=1;keyrh:=1;keyuc:=1;keydc:=1;keylc:=1;
      keyrc:=1;

      frame(2,30,150,58,0); frame(100,63 ,220 ,87,0);
      if not key_pressed(1) then
      repeat
         for j:=1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keyuh:=j;
      until (keyuh<>1) or (key_pressed(1));
      if not key_pressed(1) then begin
      writetext(src,vidptr,30,63,'OK');
      frame(100,63 ,220 ,87,25); frame(100,93 ,220 ,117,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keydh:=j;
      until ((keydh<>1) and (keydh<>keyuh)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,30,93,'OK');
      frame(100,93 ,220 ,117,25); frame(100,123 ,220 ,147,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keylh:=j;
      until ((keylh<>1) and (keylh<>keyuh) and (keylh<>keydh)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,30,123,'OK');
      frame(100,123 ,220 ,147,25); frame(100,153 ,220 ,177,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keyrh:=j;
      until ((keyrh<>1) and (keyrh<>keyuh) and (keyrh<>keydh)
              and (keyrh<>keylh)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,30,153,'OK');
      frame(100,153 ,220 ,177,25); frame(100,63 ,220 ,87,0);
      frame(2,30,150,58,25);      frame(160,30,310,58,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keyuc:=j;
      until ((keyuc<>1) and (keyuc<>keyuh) and (keyuc<>keydh)
              and (keyuc<>keylh) and (keyuc<>keyrh)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,250,63,'OK');
      frame(100,63 ,220 ,87,25); frame(100,93 ,220 ,117,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keydc:=j;
      until ((keydc<>1) and (keydc<>keyuh) and (keydc<>keydh)
              and (keydc<>keylh) and (keydc<>keyrh) and (keydc<>keyuc))
              or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,250,93,'OK');
      frame(100,93 ,220 ,117,25); frame(100,123 ,220 ,147,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keylc:=j;
      until ((keylc<>1) and (keylc<>keyuh) and (keylc<>keydh)
              and (keylc<>keylh) and (keylc<>keyrh) and (keylc<>keyuc)
              and (keylc<>keydc)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,250,123,'OK');
      frame(100,123 ,220 ,147,25); frame(100,153 ,220 ,177,0);
      repeat
        for j:= 1 to 128 do if (key_pressed(j)) and (j<>28)
              and (j<>1) then keyrc:=j;
      until ((keyrc<>1) and (keyrc<>keyuh) and (keyrc<>keydh)
              and (keyrc<>keylh) and (keyrc<>keyrh) and (keyrc<>keyuc)
              and (keyrc<>keydc) and (keyrc<>keylc)) or key_pressed(1);
      end;
      if not key_pressed(1) then begin
      writetext(src,vidptr,250,153,'OK');
      cfg.keyuh:=keyuh;cfg.keydh:=keydh;cfg.keylh:=keylh;cfg.keyrh:=keyrh;
      cfg.keyuc:=keyuc;cfg.keydc:=keydc;cfg.keylc:=keylc;cfg.keyrc:=keyrc;
      end;



   cx111:=0; cx1:=0; fadeout(p3);

end;

procedure skill;
begin
      clearpal;
       loadraw('opn',vidptr,p3,0,64000);
      fadein(p3);
       cx111:=cfg.diff;

      writetext(src,vidptr,30,03,'COMPUTERGEGNER');
      writetext(src,vidptr,105,33, 'LEICHT');
      writetext(src,vidptr,105,63, 'MITTEL');
      writetext(src,vidptr,105,93, 'SCHWER');
      writetext(src,vidptr,95,163, 'ABBRUCH');


   repeat

     if key_pressed(72) then dec(cx111);
     if key_pressed(80) then inc(cx111);


        if cx111< 0 then cx111:=cx111+4;
        if cx111>=4 then cx111:=cx111-4;

        if cx111=0 then begin frame(90,32,230,57,0);
           frame(90,62,230,87,25); frame(90,92,230,117,25);
           frame(90,162,230,187,25);
           end;

        if cx111=1 then begin frame(90,32,230,57,25);
           frame(90,62,230,87,0); frame(90,92,230,117,25);
           frame(90,162,230,187,25);
           end;

        if cx111=2 then begin frame(90,32,230,57,25);
           frame(90,62,230,87,25); frame(90,92,230,117,0);
           frame(90,162,230,187,25);
           end;

        if cx111=3 then begin frame(90,32,230,57,25);
           frame(90,62,230,87,25); frame(90,92,230,117,25);
           frame(90,162,230,187,0);
           end;



        for cy111:=1 to speed*2 do waitretrace;
        wahl111:=cx111;

       until key_pressed(28) or (key_pressed(1));;

         if not(key_pressed(1)) and (wahl111<>3) then
            cfg.diff:=wahl111;

           cx111:=0; cx1:=0; fadeout(p3);



end;


procedure setlap;

BEGIN
lapsetbak:=lapset;
      clearpal;
       loadraw('option1',vidptr,p3,0,64000);
      fadein(p3);

       cx111:=1;
      GetSprite(vidptr,src,230,20,60);
      writetext(src,vidptr,45,20,'RUNDENZAHL:');
      writetext(src,vidptr,35,95,'DEC');
      writetext(src,vidptr,140,95,'OK');
      writetext(src,vidptr,225,95,'INC');
      writetext(src,vidptr,95,165,'ABBRUCH');


  repeat
   repeat
     if lapsetbak=1 then strlapset:='1';if lapsetbak=2 then strlapset:='2';
     if lapsetbak=3 then strlapset:='3';if lapsetbak=4 then strlapset:='4';
     if lapsetbak=5 then strlapset:='5';if lapsetbak=6 then strlapset:='6';
     if lapsetbak=7 then strlapset:='7';if lapsetbak=8 then strlapset:='8';



     PutSprite2(src,vidptr,240,20,60);
     writetext(src,vidptr,240,20,strlapset);


  if (key_pressed(77)=true) then if  (cx111<2) then inc(cx111) else
        if (cx111=2) then cx111:=0;

   if (key_pressed(75)=true) then if(cx111<3) and (cx111>0) then dec(cx111)
   else if  (cx111=0) then cx111:=2;
   if (key_pressed(72)=true) or (key_pressed(80)=true)
   then if (cx111=3) then cx111:=1 else cx111:=3;


        if cx111< 0 then cx111:=cx111+4;
        if cx111>=4 then cx111:=cx111-4;

        if cx111=0 then begin frame(30,90,100,120,0);
           frame(130,90,190,120,25); frame(220,90,290,120,25);
           frame(90,160,230,190,25);
           end;
        if cx111=1 then begin frame(30,90,100,120,25);
           frame(130,90,190,120,0); frame(220,90,290,120,25);
           frame(90,160,230,190,25);
           end;
        if cx111=2 then begin frame(30,90,100,120,25);
           frame(130,90,190,120,25); frame(220,90,290,120,0);
           frame(90,160,230,190,25);
           end;
        if cx111=3 then begin frame(30,90,100,120,25);
           frame(130,90,190,120,25); frame(220,90,290,120,25);
           frame(90,160,230,190,0);
           end;




        for cy111:=1 to speed*2 do waitretrace;
        wahl111:=cx111;

       until key_pressed(28) or (key_pressed(1));;

         if not key_pressed(1) then begin
          if wahl111=0 then if lapsetbak>1 then dec(lapsetbak);
          if wahl111=2 then if lapsetbak<8 then inc(lapsetbak);

           if wahl111=1 then
              begin lapset:=lapsetbak;
              wahl111:=3; end;  end;

        if (key_pressed(1)) or (wahl111=3) then
          begin wahl111:=3; cx111:=0; cx1:=0; fadeout(p3);
          end;


    until (wahl111=3);
    wahl111:=0;

END;


Procedure Menuoptions;
var  f : file of config;


BEGIN
      {palette black}
  repeat

      clearpal;
                                {fade in menu}
    loadraw('option2',vidptr,p3,0,64000);
    fadein(p3);

     loadraw('ziffert',src,p,64*24*24,14*24*24);
     loadraw('charst',src,p,78*24*24,26*24*24);


    writetext(src,vidptr,70,25,'RUNDENZAHL');
    writetext(src,vidptr,40,65,'SCHWIERIGKEIT');
    writetext(src,vidptr,75,105,'STEUERUNG');
    writetext(src,vidptr,43,145,'RESET');
    writetext(src,vidptr,165,145,'  OK   ');


       cx1:=0;
       repeat

        if (key_pressed(80)=true) then if (cx1<>3) then inc(cx1) else
         if cx1=3 then cx1:=0;
        if (key_pressed(72)=true) then if (cx1<>4) then dec(cx1) else
         if cx1=4 then cx1:=2;
        if (key_pressed(75)=true) then if
         (cx1=4) then dec(cx1) else if (cx1=3) then inc(cx1);
        if (key_pressed(77)=true) then if
         (cx1=3) then inc(cx1) else if (cx1=4) then dec(cx1);


        if cx1< 0 then cx1:=cx1+5;
        if cx1>=5 then cx1:=cx1-5;

        if cx1=0 then begin frame(29,20,289,50,0); frame(29,60,289,90,20);
           frame(29,100,289,130,20); frame(29,140,150,170,20);
           frame(160,140,289,170,20);end;
        if cx1=1 then begin frame(29,20,289,50,20); frame(29,60,289,90,0);
           frame(29,100,289,130,20); frame(29,140,150,170,20);
           frame(160,140,289,170,20);end;
        if cx1=2 then begin frame(29,20,289,50,20); frame(29,60,289,90,20);
           frame(29,100,289,130,0); frame(29,140,150,170,20);
           frame(160,140,289,170,20);end;
        if cx1=3 then begin frame(29,20,289,50,20); frame(29,60,289,90,20);
           frame(29,100,289,130,20); frame(29,140,150,170,0);
           frame(160,140,289,170,20);end;
        if cx1=4 then begin frame(29,20,289,50,20); frame(29,60,289,90,20);
           frame(29,100,289,130,20); frame(29,140,150,170,20);
           frame(160,140,289,170,0);end;

        for cy1:=1 to speed*2 do waitretrace;
        wahl1:=cx1;

       until key_pressed(28) or (key_pressed(1));;

       if not (key_pressed(1)) and not(wahl1=4) then
        begin

      if (wahl1=0) then begin fadeout(p3); setlap; end;
       if (wahl1=1) then begin fadeout(p3);skill; end;
       if  (wahl1=2) then begin fadeout(p3);keycfg;end;


       if (wahl1=3) then begin
       cfg.diff:=1;
       lapset:=3;
       cfg.keyuh:=72;cfg.keydh:=80;cfg.keylh:=75;cfg.keyrh:=77;
       cfg.keyuc:=17;cfg.keydc:=31;cfg.keylc:=30;cfg.keyrc:=32;
       fadeout(p3);end;
             end
       else begin wahl1:=4; fadeout(p3); end;
        if (key_pressed(1)) or (wahl1=4) then
           begin
           wahl1:=4;
           cx1:=0;
           cx:=0;
           end;

    until (wahl1=4);
    wahl1:=0;

   cfg.laps:=lapset;
   if cfg.diff=0 then begin min:=4; max:=6; end;
   if cfg.diff=1 then begin min:=6; max:=8; end;
   if cfg.diff=2 then begin min:=8; max:=9; end;


   Assign (f,'YAMAHA.AF1');
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then rewrite(f);
    write(f,cfg);
    close(f);
    end;





procedure readtext (p:pointer;pal:palette;x,y:word;var name:string);
var l,i:integer;
c:string;
ch:char;

begin
  deinstall_new_keyboard_driver;
  i:=0;
  repeat
    ch:=readkey;
     {ch darf nur die Werte der Zeichen haben}

    if (((ord(ch)>=46) and (ord(ch)<=58))
       or ((ord(ch)>=65) and (ord(ch)<=90))
       or ((ord(ch)>=97) and (ord(ch)<=122))
       or (ord(ch)=43)) and (ord(ch)<>0) and (i<=5) then
        begin
          c[i]:=ch;
          getsprite(p,src,x+i*18,y,42-1+i);
          writetext(src,p,x+i*18,y,ch);

          inc(i);
        end
        else
        if (ch=^H) then
         begin
          if i>0 then
             begin
               dec(i);
               putsprite2(src,p,x+i*18,y,42-1+i);

              end;
          end

         else
          if ord(ch)=0 then ch:=readkey;

       until ch=#13;


      name:='';
      for l:=0 to i-1 do name:=name+c[l];
      if name='' then name:='ANONYM';


install_new_keyboard_driver;

end;

procedure highscore;

   var pfad : string[30];
     f    : file of zhi;

begin

   pfad:='DoppelXX.CBR';
   Assign (f,pfad);
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then
     begin
       for e:=1 to 5 do
      begin  hi.namz[e]:='leer';hi.namc[e]:='leer';hi.scrz[e]:=50000000;
             hi.scrc[e]:=50000000; end;
      hi.namz[6]:='lllll';hi.namc[6]:='lllll';hi.scrz[6]:=1100+50000000*5;
      hi.scrc[6]:=1100+50000000*5;
     end
    else
        begin
         read(f,hi);
        end;

         if (hi.namz[6]<>hi.namz[1][1]+hi.namz[2][1]+hi.namz[3][1]+
         hi.namz[4][1]+hi.namz[5][1]) or
         (hi.namc[6]<>hi.namc[1][1]+hi.namc[2][1]+hi.namc[3][1]+
         hi.namc[4][1]+hi.namc[5][1]) or
         (hi.scrz[6]<>hi.scrz[1]+hi.scrz[2]+hi.scrz[3]+hi.scrz[4]+hi.scrz[5]+
         1100) or (hi.scrc[6]<>hi.scrc[1]+hi.scrc[2]+hi.scrc[3]+hi.scrc[4]+hi.scrc[5]+
         1100)

         then
          begin
       for e:=1 to 5 do
      begin  hi.namz[e]:='leer';hi.namc[e]:='leer';hi.scrz[e]:=50000000;
             hi.scrc[e]:=50000000; end;
      hi.namz[6]:='lllll';hi.namc[6]:='lllll';hi.scrz[6]:=1100+50000000*5;
      hi.scrc[6]:=1100+50000000*5;


         end;



          for e:=1 to 5 do
     { begin  hi.namz[e]:='leer';hi.namc[e]:='leer';hi.scrz[e]:=50000000;
             hi.scrc[e]:=50000000; end;

     allsb1:=50000000-1;}

       str(round(20000000/allsb1),scoreb);
if cx1=0 then begin
    if allsb1<hi.scrz[5] then begin
       hi.scrz[5]:=allsb1; e:=5;
          if allsb1<hi.scrz[4] then begin
           hi.scrz[5]:=hi.scrz[4]; e:=4;
           hi.namz[5]:=hi.namz[4];
           hi.scrz[4]:=allsb1;
           if allsb1<hi.scrz[3] then begin
            hi.scrz[4]:=hi.scrz[3]; e:=3;
            hi.namz[4]:=hi.namz[3];
            hi.scrz[3]:=allsb1;
            if allsb1<hi.scrz[2] then begin
             hi.scrz[3]:=hi.scrz[2]; e:=2;
             hi.namz[3]:=hi.namz[2];
             hi.scrz[2]:=allsb1;
             if allsb1<hi.scrz[1] then begin
              hi.scrz[2]:=hi.scrz[1]; e:=1;
              hi.namz[2]:=hi.namz[1];
              hi.scrz[1]:=allsb1;
             end;
            end;
           end;
          end;

   clearpal;
     loadraw('inpzeit',vidptr,p,0,64000);
     LoadRAW('ziffer',src,p,64*24*24,14*24*24);
     LoadRAW('chars',src,p,78*24*24,26*24*24);

   fadein(p);


    for a:=1 to 5 do
   if a<>e then begin str(round(20000000/hi.scrz[a]),scorea);
    writetext(src,vidptr,16+30,0+a*31+13,hi.namz[a]);
    writetext(src,vidptr,173,0+a*31+13,scorea);
    end;
    writetext(src,vidptr,16+0,0+1*31+13,'1.');
    writetext(src,vidptr,16+0,0+2*31+13,'2.');
    writetext(src,vidptr,16+0,0+3*31+13,'3.');
    writetext(src,vidptr,16+0,0+4*31+13,'4.');
    writetext(src,vidptr,16+0,0+5*31+13,'5.');

    str(round(20000000/allsb1),scoreb);
    writetext(src,vidptr,173,0 +e*31+13,scoreb);
    readtext(vidptr,p,16+30,0+e*31+13,hi.namz[e]);

   fadeout(p);

    end;
   end;


if cx1=1 then begin
    if allsb1<hi.scrc[5] then begin
       hi.scrc[5]:=allsb1; e:=5;
          if allsb1<hi.scrc[4] then begin
           hi.scrc[5]:=hi.scrc[4]; e:=4;
           hi.namc[5]:=hi.namc[4];
           hi.scrc[4]:=allsb1;
           if allsb1<hi.scrc[3] then begin
            hi.scrc[4]:=hi.scrc[3]; e:=3;
            hi.namc[4]:=hi.namc[3];
            hi.scrc[3]:=allsb1;
            if allsb1<hi.scrc[2] then begin
             hi.scrc[3]:=hi.scrc[2]; e:=2;
             hi.namc[3]:=hi.namc[2];
             hi.scrc[2]:=allsb1;
             if allsb1<hi.scrc[1] then begin
              hi.scrc[2]:=hi.scrc[1]; e:=1;
              hi.namc[2]:=hi.namc[1];
              hi.scrc[1]:=allsb1;
             end;
            end;
           end;
          end;

   clearpal;
     loadraw('inpcpu',vidptr,p,0,64000);
     LoadRAW('ziffer',src,p,64*24*24,14*24*24);
     LoadRAW('chars',src,p,78*24*24,26*24*24);

   fadein(p);

    for a:=1 to 5 do
   if a<>e then begin str(round(20000000/hi.scrc[a]),scorea);
    writetext(src,vidptr,16+30,0+a*31+13,hi.namc[a]);
    writetext(src,vidptr,173,0+a*31+13,scorea);
    end;
    writetext(src,vidptr,16+0,0+1*31+13,'1.');
    writetext(src,vidptr,16+0,0+2*31+13,'2.');
    writetext(src,vidptr,16+0,0+3*31+13,'3.');
    writetext(src,vidptr,16+0,0+4*31+13,'4.');
    writetext(src,vidptr,16+0,0+5*31+13,'5.');

    str(round(20000000/allsb1),scoreb);
    writetext(src,vidptr,173,0 +e*31+13,scoreb);
         readtext(vidptr,p,16+30,0+e*31+13,hi.namc[e]);

   fadeout(p);

    end;
   end;

   hi.namz[6]:=hi.namz[1][1]+hi.namz[2][1]+hi.namz[3][1]+
    hi.namz[4][1]+hi.namz[5][1];
   hi.namc[6]:=hi.namc[1][1]+hi.namc[2][1]+hi.namc[3][1]+
    hi.namc[4][1]+hi.namc[5][1];
   hi.scrz[6]:=hi.scrz[1]+hi.scrz[2]+hi.scrz[3]+hi.scrz[4]+hi.scrz[5]+
    1100;
   hi.scrc[6]:=hi.scrc[1]+hi.scrc[2]+hi.scrc[3]+hi.scrc[4]+hi.scrc[5]+
    1100;

   Assign (f,pfad);
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then rewrite(f);
    write(f,hi);
    close(f);


end;


procedure showhighscore;

   var pfad : string[30];
     f    : file of zhi;

begin

   pfad:='DoppelXX.CBR';
   Assign (f,pfad);
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then
     begin
       for e:=1 to 5 do
      begin  hi.namz[e]:='leer';hi.namc[e]:='leer';hi.scrz[e]:=50000000;
             hi.scrc[e]:=50000000; end;
      hi.namz[6]:='lllll';hi.namc[6]:='lllll';hi.scrz[6]:=1100+50000000*5;
      hi.scrc[6]:=1100+50000000*5;



      end


    else
        begin
         read(f,hi);
        end;

      if (hi.namz[6]<>hi.namz[1][1]+hi.namz[2][1]+hi.namz[3][1]+
       hi.namz[4][1]+hi.namz[5][1]) or
       (hi.namc[6]<>hi.namc[1][1]+hi.namc[2][1]+hi.namc[3][1]+
       hi.namc[4][1]+hi.namc[5][1]) or
       (hi.scrz[6]<>hi.scrz[1]+hi.scrz[2]+hi.scrz[3]+hi.scrz[4]+hi.scrz[5]+
       1100) or (hi.scrc[6]<>hi.scrc[1]+hi.scrc[2]+hi.scrc[3]+hi.scrc[4]+hi.scrc[5]+
       1100)

         then
          begin
       for e:=1 to 5 do
      begin  hi.namz[e]:='leer';hi.namc[e]:='leer';hi.scrz[e]:=50000000;
             hi.scrc[e]:=50000000; end;
      hi.namz[6]:='lllll';hi.namc[6]:='lllll';hi.scrz[6]:=1100+50000000*5;
      hi.scrc[6]:=1100+50000000*5;


         end;







  if cx1=0 then begin
   clearpal;
     loadraw('bestzeit',vidptr,p,0,64000);
     LoadRAW('ziffer',src,p,64*24*24,14*24*24);
     LoadRAW('chars',src,p,78*24*24,26*24*24);

   fadein(p);

    for a:=1 to 5 do
    begin str(round(20000000/hi.scrz[a]),scorea);
    writetext(src,vidptr,16+30,0+a*31+13,hi.namz[a]);
    writetext(src,vidptr,173,0+a*31+13,scorea);
    end;
    writetext(src,vidptr,16+0,0+1*31+13,'1.');
    writetext(src,vidptr,16+0,0+2*31+13,'2.');
    writetext(src,vidptr,16+0,0+3*31+13,'3.');
    writetext(src,vidptr,16+0,0+4*31+13,'4.');
    writetext(src,vidptr,16+0,0+5*31+13,'5.');




       repeat until (key_pressed(28)) or (key_pressed(1));
      fadeout(p);

   end;


if cx1=1 then begin

   clearpal;
     loadraw('bestcpu',vidptr,p,0,64000);
     LoadRAW('ziffer',src,p,64*24*24,14*24*24);
     LoadRAW('chars',src,p,78*24*24,26*24*24);

   fadein(p);

    for a:=1 to 5 do
   begin str(round(20000000/hi.scrc[a]),scorea);
    writetext(src,vidptr,16+30,0+a*31+13,hi.namc[a]);
    writetext(src,vidptr,173,0+a*31+13,scorea);
    end;

    writetext(src,vidptr,16+0,0+1*31+13,'1.');
    writetext(src,vidptr,16+0,0+2*31+13,'2.');
    writetext(src,vidptr,16+0,0+3*31+13,'3.');
    writetext(src,vidptr,16+0,0+4*31+13,'4.');
    writetext(src,vidptr,16+0,0+5*31+13,'5.');
  repeat until (key_pressed(28)) or (key_pressed(1));
   fadeout(p);

    end;

   Assign (f,pfad);
   {$I-} Reset(f);
   {$I+}
   if IOresult <> 0 then rewrite(f);
    write(f,hi);
    close(f);


end;











procedure wettkampf;
begin
lapsetbak:=lapset;
if cx1=0 then begin
lapset:= 3; modus:=1; zeitstrecke; allsb1:=alls;
if  runde=lapset then
 begin lapset:=3{5}; modus:=2; zeitstrecke;allsb1:=allsb1+alls;
  if  runde=lapset then
   begin lapset:=3; modus:=3; zeitstrecke;allsb1:=allsb1+alls;
      if  runde=lapset then begin
        lapset:=4{7}; modus:=4; zeitstrecke;allsb1:=allsb1+alls;
     clearpal;
    loadraw('hiscore1',vidptr,p3,0,64000);
    fadein(p3);
    {hiscore}
     {abcde}                {punktezahl:=10000hund*2000pkt=20*10^6}
   str(allsb1,allstr);str(round(20000000/allsb1),scoreb);
    loadraw('ziffer',src,p,64*24*24,14*24*24); loadraw('chars',src,p,78*24*24,26*24*24);
     writetext(src,vidptr,60,15,'AUSWERTUNG');
     writetext(src,vidptr,60,45,'GESAMTZEIT:');
     writetext(src,vidptr,60,75,allstr);
     writetext(src,vidptr,60,105, 'HUNDERTSTEL');
     writetext(src,vidptr,60,135,'ENTSPRICHT:');
     writetext(src,vidptr,60,165,scoreb+' PUNKTEN');

     repeat until (key_pressed(1)) or (key_pressed(28));

    fadeout(p3);
    {highscorelisteneintrag}
    highscore;
    end;
   end;
  end;

showhighscore
end;

if cx1=1 then begin
lapset:= 3; modus:=1; cpustrecke;allsb1:=alls;
if (runde=lapset) and (hwon=true) then
 begin lapset:=3{5}; modus:=2; cpustrecke;allsb1:=allsb1+alls;
  if  (runde=lapset) and (hwon=true) then
   begin lapset:=3; modus:=3; cpustrecke;allsb1:=allsb1+alls;
      if  (runde=lapset) and (hwon=true) then begin
        lapset:=4{7}; modus:=4; cpustrecke;allsb1:=allsb1+alls;

    clearpal;
    loadraw('hiscore2',vidptr,p3,0,64000);
    fadein(p3);
      {punktezahlberechn=10000hund*2000pkt*skill=20*10^6*skill}

   if cfg.diff=0 then factor:=1;
   if cfg.diff=1 then factor:=2;
   if cfg.diff=2 then factor:=4;
 str(allsb1,allstr);
 loadraw('ziffer',src,p,64*24*24,14*24*24); loadraw('chars',src,p,78*24*24,26*24*24);
  writetext(src,vidptr,60,15,'AUSWERTUNG');
  writetext(src,vidptr,60,45,'GESAMTZEIT:');
  writetext(src,vidptr,60,75,allstr);
  allsb1:=allsb1 div factor;
  str(round(20000000/allsb1),scoreb);
  writetext(src,vidptr,60,105, 'HUNDERTSTEL');
  writetext(src,vidptr,60,135,'ENTSPRICHT:');
  writetext(src,vidptr,60,165,scoreb+' PUNKTEN');

     repeat until (key_pressed(1)) or (key_pressed(28));


    fadeout(p3);
    {highscorelisteneintrag}
    highscore;
    end;
   end;
  end;
showhighscore;
end;

if cx1=2 then begin
countcwon:=0;counthwon:=0;
lapset:= 3; modus:=1; multistrecke;if cwon=true then inc(countcwon);
if hwon=true then inc(counthwon);
if  (hwon=true) or (cwon=true) then
 begin lapset:=3; modus:=2; multistrecke;if cwon=true then inc(countcwon);
if hwon=true then inc(counthwon);
  if  (hwon=true) or (cwon=true) then
   begin lapset:=3; modus:=3; multistrecke;if cwon=true then inc(countcwon);
if hwon=true then inc(counthwon);
      if  (hwon=true) or (cwon=true) then begin
        lapset:=4{7}; modus:=4; multistrecke;if cwon=true then inc(countcwon);
if hwon=true then inc(counthwon);
  str(counthwon,strcounthwon);str(countcwon,strcountcwon);

   clearpal;
    loadraw('hiscore3',vidptr,p3,0,64000);
    fadein(p3);
      {punktezahlberechn=10000hund*2000pkt*skill=20*10^6*skill}

 loadraw('ziffer',src,p,64*24*24,14*24*24); loadraw('chars',src,p,78*24*24,26*24*24);
  writetext(src,vidptr,60,15,'AUSWERTUNG');
  writetext(src,vidptr,20,45,'SIEGE SPIELER1:');
  writetext(src,vidptr,150,75,strcounthwon);
  writetext(src,vidptr,20,105, 'SIEGE SPIELER2:');
  writetext(src,vidptr,150,135,strcountcwon);

     repeat until (key_pressed(1)) or (key_pressed(28));


    fadeout(p3);




    end;
   end;
  end;

end;

lapset:=lapsetbak;


end;





Procedure Menu111;


BEGIN

  repeat
    hauptmenu:=false;

      clearpal;
    if cx1=0 then
     loadraw('menu111',vidptr,p3,0,64000);
    if cx1=1 then
     loadraw('menu112',vidptr,p3,0,64000);
    if cx1=2 then
     loadraw('menu113',vidptr,p3,0,64000);
    fadein(p3);

       cx111:=0;
       repeat
        if (key_pressed(77)=true) or (key_pressed(80)=true) then inc(cx111);
        if (key_pressed(75)=true) or (key_pressed(72)=true) then dec(cx111);

        if cx111< 0 then cx111:=cx111+5;
        if cx111>=5 then cx111:=cx111-5;

        if cx111=0 then begin frame(40,52,123,103,157);
         frame(144,52,227,103,227); frame(40,125,123,177,227);
         frame(144,125,227,177,227); frame(233,156,290,180,227);
           end;
        if cx111=1 then begin frame(40,52,123,103,227);
         frame(144,52,227,103,157); frame(40,125,123,177,227);
         frame(144,125,227,177,227); frame(233,156,290,180,227);
           end;

        if cx111=2 then begin frame(40,52,123,103,227);
         frame(144,52,227,103,227); frame(40,125,123,177,157);
         frame(144,125,227,177,227); frame(233,156,290,180,227);
           end;
       if cx111=3 then begin frame(40,52,123,103,227);
         frame(144,52,227,103,227); frame(40,125,123,177,227);
         frame(144,125,227,177,157); frame(233,156,290,180,227);
           end;
      if cx111=4 then begin frame(40,52,123,103,227);
         frame(144,52,227,103,227); frame(40,125,123,177,227);
         frame(144,125,227,177,227); frame(233,156,290,180,157);
           end;



        for cy111:=1 to speed*2 do waitretrace;
        wahl111:=cx111;

       until key_pressed(28) or (key_pressed(1));;

         if not (key_pressed(1)) and not(wahl111=4) then begin
          modus:=wahl111+1;
          fadeout(p3);
          if cx1=0 then zeitstrecke;
          if cx1=1 then CPUStrecke;
          if cx1=2 then MultiStrecke;
          end
         else  begin wahl111:=4; fadeout(p3); end;
        if (key_pressed(1)) or (wahl111=4) then begin wahl111:=4;
        cx111:=0; cx1:=0; end;


    until (wahl111=4) or (hauptmenu=true);
    wahl111:=0;



END;


Procedure Menu11;

BEGIN
  repeat
    hauptmenu:=false;

      clearpal;
    loadraw('menu1',vidptr,p3,0,64000);
    fadein(p3);

       cx1:=0;
       repeat

        if (key_pressed(77)=true) or (key_pressed(80)=true) then inc(cx1);
        if (key_pressed(75)=true) or (key_pressed(72)=true) then dec(cx1);

        if cx1< 0 then cx1:=cx1+4;
        if cx1>=4 then cx1:=cx1-4;

        if cx1=0 then begin frame(28,13,126,77,89); frame(191,13,289,77,214);
           frame(108,120,206,184,214); frame(31,107,104,133,89);
           frame(213,107,286,133,214); frame(123,87,196,113,214);
           frame(213,157,286,183,214); end;
        if cx1=1 then begin frame(28,13,126,77,214); frame(191,13,289,77,214);
           frame(108,120,206,184,89); frame(31,107,104,133,214);
           frame(213,107,286,133,214); frame(123,87,196,113,89);
           frame(213,157,286,183,214); end;
        if cx1=2 then begin frame(28,13,126,77,214); frame(191,13,289,77,89);
           frame(108,120,206,184,214); frame(31,107,104,133,214);
           frame(213,107,286,133,89); frame(123,87,196,113,214);
           frame(213,157,286,183,214); end;
        if cx1=3 then begin frame(28,13,126,77,214); frame(191,13,289,77,214);
           frame(108,120,206,184,214); frame(31,107,104,133,214);
           frame(213,107,286,133,214); frame(123,87,196,113,214);
           frame(213,157,286,183,89); end;

        for cy1:=1 to speed*2 do waitretrace;
        wahl1:=cx1;

       until key_pressed(28) or (key_pressed(1));;

       if not (key_pressed(1)) and not(wahl1=3) then
        begin

      if (wahl1=0) or (wahl1=1) or (wahl1=2) then begin fadeout(p3);
         art:=0;
         clearpal;
         if cx1=0 then
         loadraw('wettz',vidptr,p2,0,64000);
         if cx1=1 then
         loadraw('wettc',vidptr,p2,0,64000);
         if cx1=2 then
         loadraw('wettm',vidptr,p2,0,64000);




         fadein(p2);
    frame(66,36,247,66,72); frame(66,103,247,133,144);
          repeat
           if key_pressed(80) then inc(art);
           if key_pressed(72) then inc(art);
           art:=art mod 2;

    if (key_pressed(80)) or (key_pressed(72)) then begin
    if art=0 then begin frame(66,36,247,66,72); frame(66,103,247,133,144);end;
    if art=1 then begin frame(66,36,247,66,144); frame(66,103,247,133,72);end;
    end; for cy1:=1 to speed*2 do waitretrace;
   until key_pressed(28);
          fadeout(p2);
          if art=1 then wettkampf else
            menu111;
              end;
             end
       else begin wahl1:=3; fadeout(p3); end;
        if (key_pressed(1)) or (wahl1=3) then
           begin
           wahl1:=3;
           cx1:=0;
           cx:=0;
           end;


    until (wahl1=3) or (hauptmenu=true);
    wahl1:=0;
END;




Procedure Menu1;


BEGIN
      {palette black}
  repeat


      clearpal;
                                {fade in menu}
    loadraw('menu',vidptr,p3,0,64000);
    fadein(p3);

       cx:=0;
       repeat

        if key_pressed(80)=true then inc(cx);
        if key_pressed(72)=true then dec(cx);

        if cx< 0 then cx:=cx+4;
        if cx>=4 then cx:=cx-4;

        if cx=0 then begin frame(91,38 ,231,38+22 ,131);
         frame(91,74 ,231,74+22 ,164); frame(91,110,231,110+22,164);
         frame(91,146,231,146+22,164); end;
        if cx=1 then begin frame(91,38 ,231,38+22 ,164);
         frame(91,74 ,231,74+22 ,131); frame(91,110,231,110+22,164);
         frame(91,146,231,146+22,164); end;
        if cx=2 then begin frame(91,38 ,231,38+22 ,164);
         frame(91,74 ,231,74+22 ,164); frame(91,110,231,110+22,131);
         frame(91,146,231,146+22,164); end;
        if cx=3 then begin frame(91,38 ,231,38+22 ,164);
         frame(91,74 ,231,74+22 ,164); frame(91,110,231,110+22,164);
         frame(91,146,231,146+22,131); end;

       for cy:=1 to speed*2 do waitretrace;
       wahl1:=cx1;

       until key_pressed(28) or (key_pressed(1));;
        wahl:=cx;
         if not (key_pressed(1)) and not(wahl=3) then begin
          if wahl=0 then begin fadeout(p3);  menu11;end
           else if wahl=1 then begin fadeout(p3);
           menuoptions;end
            else if wahl=2 then begin fadeout(p3);
             clearpal;
             if cfg.diff<>2 then
             loadraw('help',vidptr,p3,0,64000) else
             loadraw('helpb',vidptr,p3,0,64000);
             fadein(p3);
              repeat until ((key_pressed(1)) or (key_pressed(28)));
             fadeout(p3);
            end;
         end
             else begin wahl:=3; fadeout(p3); end;

    until (wahl=3) or (key_pressed(1));

END;

{********************************************************}

Procedure Intro;

Begin
     ClearPal;

     loadraw('race2',vidptr,p2,0,64000);

     FadeIN(p2);

     count:=0;
     repeat
     inc(count);
     waitretrace;
     until (key_pressed(28)) or
           (key_pressed( 1)) or (count=round(300)*(speed/4));
     FadeOut(p2);
End;


{MenuPart ends*********************************}


BEGIN
 initialising;
 intro;
   repeat
    wahle:=0;
    menu1;
    clearpal;
    loadraw('menuex',vidptr,p,0,64000);
    fadein(p);
     repeat
      if key_pressed(77) then inc(wahle); if key_pressed(75) then dec (wahle);
      if wahle<0 then wahle:=wahle+2;
      if wahle>=2 then wahle:=wahle-2;
      if wahle= 1 then begin frame(62,111,140,135,232);
      frame(181,111,259,135,144); end;
      if wahle=0 then begin   frame(62,111,140,135,144);
      frame(181,111,259,135,232); end;
      for cy:=1 to speed*2 do waitretrace;
   until (key_pressed(28)) or key_pressed(1);;
      if key_pressed(1) then wahle:=1;
    fadeout(p);
   until (wahle=0);
{ cx1:=0;
 showhighscore;}

 freemem(pic,64000);


 clearbuf(vidptr,64000);

  LoadRAW('ziffer',src,p,64*24*24,14*24*24);
  LoadRAW('chars',src,p,78*24*24,26*24*24);
  SetPal(p);

  PIC      := Ptr(Seg(Buffer),Ofs(Buffer));
  MomText  := 0;
  MomZeile := 0;
  ClearBuf(PIC ,320*24);

  repeat
    case MomText of
       1 : Text := '     R.a.C.e     ';
       2 : Text := '                 ';
       3 : Text := '                 ';
       4 : Text := ' PROGRAMMIERER:  ';
       5 : Text := '                 ';
       6 : Text := ' CBR1100XX DANI  ';
       7 : Text := ' AIRFORCE1 MICHI ';
       8 : Text := '  HTML  GRISCHI  ';
       9 : Text := ' SURROUND  GUIDO ';
      10 : Text := '                 ';
      11 : Text := '                 ';
      12 : Text := '    BENUTZTE     ';
      13 : Text := '   WERKZEUGE:    ';
      14 : Text := '                 ';
      15 : Text := ' AMD 486 DX 2/80 ';
      16 : Text := '    8 MB RAM     ';
      17 : Text := 'TIERISCH SCHNELL ';
      18 : Text := '        +        ';
      19 : Text := '    zu  HAUSE    ';
      20 : Text := 'INTEL PENTIUM TM ';
      21 : Text := ' 120 32 MB RAM + ';
      22 : Text := '  getunter 386   ';
      23 : Text := '                 ';
      24 : Text := '                 ';
      25 : Text := '   FOLGENDE IN   ';
      26 : Text := '   BEHANDLUNG    ';
      27 : Text := 'STEHENDE PERSONEN';
      28 : Text := ' SIND FUER BUGS  ';
      29 : Text := '   IN UND NACH   ';
      30 : Text := '   AUSFUEHRUNG   ';
      31 : Text := '  NACHFOLGENDER  ';
      32 : Text := '     ROUTINEN    ';
      33 : Text := ' VERANTWORTLICH: ';
      34 : Text := '                 ';
      35 : Text := '   FEUER MICHI:  ';
      36 : Text := '                 ';
      37 : Text := 'SPRITE + SCROLLER';
      38 : Text := ' PCX+RAW  LOADER ';
      39 : Text := 'MODE13H FUNCTIONS';
      40 : Text := 'ALL GRAPHIC USING';
      41 : Text := '  ALL BASTLEREI  ';
      42 : Text := '                 ';
      43 : Text := '  SCHUMMEL DANI: ';
      44 : Text := '                 ';
      45 : Text := '    SPIELIDEE    ';
      46 : Text := '   ALLE BILDER   ';
      47 : Text := '    Kollision    ';
      48 : Text := '   KI OPTIONS    ';
      49 : Text := 'GESAMTES  DESIGN';
      50 : Text := '   OPTIMIERUNG   ';
      51 : Text := '    STEUERUNG    ';
      52 : Text := ' HIGHSCORELISTE  ';
      53 : Text := '      HILFE      ';
      54 : Text := '                 ';
      55 : Text := '     GRISCHI:    ';
      56 : Text := '                 ';
      57 : Text := '    HTML  UND    ';
      58 : Text := '   VERSTAENDNIS  ';
      59 : Text := '    FUER  DEN    ';
      60 : Text := ' TASTATURHANDLER ';
      61 : Text := '                 ';
      62 : Text := '   NOISE GUIDO:  ';
      63 : Text := '                 ';
      64 : Text := '      SOUND      ';
      65 : Text := 'ERSTE  HTML SEITE';
      66 : Text := '                 ';
      67 : Text := '                 ';
      68 : Text := '     SPECIAL     ';
      69 : Text := '    THANKS TO:   ';
      70 : Text := '                 ';
      71 : Text := '      CYDO:      ';
      72 : Text := ' KEYBOARDHANDLER ';
      73 : Text := '                 ';
      74 : Text := '     TOLJA:      ';
      75 : Text := '  2.RENNSTRECKE  ';
      76 : Text := '                 ';
      77 : Text := ' FRAU ENGELMANN: ';
      78 : Text := '  HTML FRAMESET  ';
      79 : Text := '                 ';
      80 : Text := '   HERR BLACH:   ';
      81 : Text := '  LOESCHEN DER   ';
      82 : Text := ' BETA VERSIONEN  ';
      83 : Text := '                 ';
      84 : Text := '  FRAU MACHMER:  ';
      85 : Text := 'TP6/7 GRUNDWISSEN';
      86 : Text := '                 ';
      87 : Text := '    MIRKO S.:    ';
      88 : Text := '    FUER DIE     ';
      89 : Text := '  UEBERNOMMENEN  ';
      90 : Text := '  HOMEPAGEIDEEN  ';
      91 : Text := '                 ';
      92 : Text := ' JENS N. AUS B.: ';
      93 : Text := '  SABOTAGE  DES  ';
      94 : Text := '    PROJEKTES    ';
      95 : Text := '                 ';
      96 : Text := '   DANKE  JENS   ';
      97 : Text := '   DANKE  JENS   ';
      98 : Text := '   DANKE  JENS   ';
      99 : Text := '                 ';
     100 : Text := ' TO BE CONTINUED ';
     101 : Text := '                 ';
     102 : Text := '                 ';
     103 : Text := '   3D-Effects:   ';
     104 : Text := '    Kawadenko    ';
     105 : Text := '    Hondaniel    ';
     106 : Text := '  Tuning  TOLJA  ';
     107 : Text := '   SIND  ALLES   ';
     108 : Text := '   notorische    ';
     109 : Text := '      Heizer     ';
     110 : Text := 'von 0 auf 100: 5s';
     111 : Text := '                 ';
     112 : Text := '   Realismus:    ';
     113 : Text := '                 ';
     114 : Text := ' Um das Spiel so ';
     115 : Text := 'echt wie moeglich';
     116 : Text := '  zu  gestalten  ';
     117 : Text := '  wurden  alle   ';
     118 : Text := '  Fahrmanoever   ';
     119 : Text := ' vorher auf der  ';
     120 : Text := '    hiesigen     ';
     121 : Text := ' Rennstrecke  B1 ';
     122 : Text := '  getestet von   ';
     123 : Text := '  Tuning Tolja+  ';
     124 : Text := ' CBR1100XX Dani+ ';
     125 : Text := ' AIRFORCE1 MICHI ';
     126 : Text := '                 ';
     127 : Text := '                 ';
     128 : Text := '                 ';
     129 : Text := '                 ';
     130 : Text := ' Sie koennen den ';
     131 : Text := ' Computer  jetzt ';
     132 : Text := '   ausschalten   ';
     133 : Text := '                 ';
     134 : Text := 'C Copyright  1997';
     135 : Text := '   all rights    ';
     136 : Text := '    reserved     ';
     137 : Text := '                 ';
     138 : Text := '                 ';




    end;

 if (MomZeile = 0)  then  WriteText(Src,pic,0,0,text);

    WaitRetrace;
    WaitRetrace;
    WaitRetrace;


    CopyLine(pic,vidptr,MomZeile,199);
    ScrollUp;

    Inc(MomZeile);
    if MomZeile = 24 then
      begin
        MomZeile := 0;
        ClearBuf(PIC ,320*24);
        Inc(MomText);
      end;
  until (Port[$60] = 1) or (port[$60] = 28) or (Momtext=maxtext);

  clearpal;
  loadraw('racepr',vidptr,p3,0,64000);
  setpal(p3);
  repeat until not(key_pressed(28));
  repeat until (key_pressed(1)) or (key_pressed(28));

freemem(dst,64000);
freemem(src,64000);

deinstall_new_keyboard_driver;
setmode($3);

END.
