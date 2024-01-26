Unit strecke;
INTERFACE

procedure strPkt(var streckenpunkt,zielx,ziely,zielv,modus:integer;
min,max,posx,posy:integer);

IMPLEMENTATION

procedure strPkt(var streckenpunkt,zielx,ziely,zielv,modus:integer;
min,max,posx,posy:integer);

begin

if modus=4 then begin
       if streckenpunkt=0 then begin
       zielx:=130; ziely:=130; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=1; end;

       if streckenpunkt=1 then begin
       zielx:=100; ziely:=185; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=2; end;
       if streckenpunkt=2 then begin
       zielx:=40; ziely:=160; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=3; end;

       if streckenpunkt=3 then begin
       zielx:=47; ziely:=30; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=4; end;
       if streckenpunkt=4 then begin
       zielx:=110; ziely:=35; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=5; end;
       if streckenpunkt=5 then begin
       zielx:=120; ziely:=60; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=6; end;

       if streckenpunkt=6 then begin
       zielx:=190; ziely:=70; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=7; end;
{220 25}
       if streckenpunkt=7 then begin
       zielx:=220; ziely:=30; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=8; end;

       if streckenpunkt=8 then begin
       zielx:=270; ziely:=25; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=9; end;
       if streckenpunkt=9 then begin
       zielx:=280; ziely:=170; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=10; end;
       if streckenpunkt=10 then begin
       zielx:=225; ziely:=175; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=11; end;
       if streckenpunkt=11 then begin
       zielx:=190; ziely:=130; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=0; end;

 end;


if modus=3 then begin
       if streckenpunkt=0 then begin
       zielx:=140; ziely:=175; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=1; end;

       if streckenpunkt=1 then begin
       zielx:=115; ziely:=145; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=2; end;

       if streckenpunkt=2 then begin
       zielx:=55{60}; ziely:=125; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=3; end;
       if streckenpunkt=3 then begin
       zielx:=65; ziely:=75; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=4; end;
       if streckenpunkt=4 then begin
       zielx:=110; ziely:=59; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=5; end;
       if streckenpunkt=5 then begin
       zielx:=130; ziely:=29; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=6; end;
       if streckenpunkt=6 then begin
       zielx:=180; ziely:=25; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=7; end;
       if streckenpunkt=7 then begin
       zielx:=195; ziely:=55; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=8; end;
       if streckenpunkt=8 then begin
       zielx:=260; ziely:=80; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=9; end;
       if streckenpunkt=9 then begin
       zielx:=260; ziely:=115; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=10; end;
       if streckenpunkt=10 then begin
       zielx:=205; ziely:=140; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=11; end;
       if streckenpunkt=11 then begin
       zielx:=185; ziely:=170; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=0; end;

 end;

if modus=2 then begin

       if streckenpunkt=0 then begin
       {putpixel(dst,70,175,200);}
       zielx:=70; ziely:=175; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=1; end;
       if streckenpunkt=1 then begin
{       putpixel(dst,120,145,200);}
       zielx:=120; ziely:=145; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=2; end;
       if streckenpunkt=2 then begin
{       putpixel(dst,140,70,200);}
       zielx:=140; ziely:=70; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=3; end;

      if streckenpunkt=3 then begin
{        putpixel(dst,159,40,200);}
       zielx:=159; ziely:=40; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=4; end;
       if streckenpunkt=4 then begin
{          putpixel(dst,220,20,200);}
       zielx:=230; ziely:=20; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=5; end;
       if streckenpunkt=5 then begin
{            putpixel(dst,295,50,200);}
       zielx:=295; ziely:=50; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=6; end;

        if streckenpunkt=6 then begin
{            putpixel(dst,305,100,200);}
       zielx:=305; ziely:=100; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=7; end;
       if streckenpunkt=7 then begin
{            putpixel(dst,295,150,200);}
       zielx:=295; ziely:=150; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=8; end;
       if streckenpunkt=8 then begin
{         putpixel(dst,260,175,200);}
       zielx:=260; ziely:=175; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=9; end;
       if streckenpunkt=9 then begin
{         putpixel(dst,190,140,200);}
       zielx:=190; ziely:=140; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=10; end;
       if streckenpunkt=10 then begin
{         putpixel(dst,180,70,200);}
       zielx:=180; ziely:=70; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=11; end;
       if streckenpunkt=11 then begin
{           putpixel(dst,159,40,200);}
       zielx:=159; ziely:=40; zielv:=max;
       if (abs(zielx-posx)<16) and (abs(ziely-posy)<16)
       then Streckenpunkt:=12; end;
       if streckenpunkt=12 then begin
{        putpixel(dst,90,20,200);}
       zielx:=100; ziely:=20; zielv:=max;
       if (abs(zielx-posx)<16) and (abs(ziely-posy)<16)
       then Streckenpunkt:=13; end;
       if streckenpunkt=13 then begin
{       putpixel(dst,20,50,200);}
       zielx:=20; ziely:=50; zielv:=max;
       if (abs(zielx-posx)<16) and (abs(ziely-posy)<16)
       then Streckenpunkt:=14; end;
       if streckenpunkt=14 then begin
{       putpixel(dst,10,100,200);}
       zielx:=10; ziely:=100; zielv:=max;
       if (abs(zielx-posx)<16) and (abs(ziely-posy)<16)
       then Streckenpunkt:=15; end;
       if streckenpunkt=15 then begin
{       putpixel(dst,25,150,200);}
       zielx:=25; ziely:=150; zielv:=max;
       if (abs(zielx-posx)<16) and (abs(ziely-posy)<16)
       then Streckenpunkt:=0; end;
 end;


if modus=1 then begin
       if streckenpunkt=0 then begin zielx:=70; ziely:=155; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=1; end;
       if streckenpunkt=1 then begin zielx:=40; ziely:=135; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=2; end;
       if streckenpunkt=2 then begin zielx:=55; ziely:=65; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=3; end;
       if streckenpunkt=3 then begin zielx:=75; ziely:=30; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=4; end;
       if streckenpunkt=4 then begin zielx:=255; ziely:=35; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=5; end;
       if streckenpunkt=5 then begin zielx:=275; ziely:=55; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=6; end;
       if streckenpunkt=6 then begin zielx:=265; ziely:=135; zielv:=max;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=7; end;
       if streckenpunkt=7 then begin zielx:=245; ziely:=160; zielv:=min;
       if (abs(zielx-posx)<12) and (abs(ziely-posy)<12)
       then Streckenpunkt:=0; end;

   end;

end;

begin
end.