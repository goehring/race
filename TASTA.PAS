{$G+}

unit tasta;


interface
uses grap486;

procedure koord_berechnen(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);

procedure kauswertung(var posx,posy,flx,fly,frx,fry,hrx,hry,hlx,hly,
          v:integer; angle:real; takt:shortint;var pic:pointer);




implementation

procedure v1(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
begin
      if takt mod 2 = 0 then
       if takt mod 4=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             dec(posx);
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             inc(posx);
        if (angle=67.5) or (angle=90) or (angle=112.5) then
               dec(posy);
        if (angle=247.5) or (angle=270) or (angle=292.5) then
               inc(posy);
        if angle=45  then begin dec(posx);dec(posy);end;
        if angle=135 then begin inc(posx);dec(posy);end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=315 then begin dec(posx);inc(posy);end;
                end;

       if takt mod 4=2 then begin
        if angle=0 then posx:=posx-2;
        if angle=22.5  then begin posx:=posx-2;dec(posy);end;
        if angle=337.5 then begin posx:=posx-2;inc(posy);end;
        if angle=45  then begin dec(posx);dec(posy) end;
        if angle=315 then begin dec(posx);inc(posy);end;
        if angle=67.5  then begin posy:=posy-2; dec(posx);end;
        if angle=292.5 then begin posy:=posy+2; dec(posx);end;
        if angle=90  then posy:=posy-2;
        if angle=270 then posy:=posy+2;
        if angle=112.5 then begin posy:=posy-2; inc(posx);end;
        if angle=247.5 then begin posy:=posy+2; inc(posx);end;
        if angle=135 then begin inc(posx);dec(posy); end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=157.5 then begin posx:=posx+2; dec(posy);end;
        if angle=202.5 then begin posx:=posx+2; inc(posy);end;
        if angle=180 then posx:=posx+2;
           end;
end;

procedure v2(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
begin
       if takt mod 2=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             dec(posx);
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             inc(posx);
        if (angle=67.5) or (angle=90) or (angle=112.5) then
               dec(posy);
        if (angle=247.5) or (angle=270) or (angle=292.5) then
               inc(posy);
        if angle=45  then begin dec(posx);dec(posy);end;
        if angle=135 then begin inc(posx);dec(posy);end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=315 then begin dec(posx);inc(posy);end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-2;
        if angle=22.5  then begin posx:=posx-2;dec(posy);end;
        if angle=337.5 then begin posx:=posx-2;inc(posy);end;
        if angle=45  then begin dec(posx);dec(posy) end;
        if angle=315 then begin dec(posx);inc(posy);end;
        if angle=67.5  then begin posy:=posy-2; dec(posx);end;
        if angle=292.5 then begin posy:=posy+2; dec(posx);end;
        if angle=90  then posy:=posy-2;
        if angle=270 then posy:=posy+2;
        if angle=112.5 then begin posy:=posy-2; inc(posx);end;
        if angle=247.5 then begin posy:=posy+2; inc(posx);end;
        if angle=135 then begin inc(posx);dec(posy); end;
        if angle=157.5 then begin posx:=posx+2; dec(posy);end;
        if angle=202.5 then begin posx:=posx+2; inc(posy);end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=180 then posx:=posx+2;
           end;
end;

procedure v3(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
begin
       if takt mod 2=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             posx:=posx-2;
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             posx:=posx+2;
        if (angle=67.5) or (angle=90) or (angle=112.5) then
             posy:=posy-2;
        if (angle=247.5) or (angle=270) or (angle=292.5) then
             posy:=posy+2;
        if angle=45  then begin dec(posx);dec(posy);end;
        if angle=135 then begin inc(posx);dec(posy);end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=315 then begin dec(posx);inc(posy);end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-2;
        if angle=22.5  then begin posx:=posx-2;dec(posy);end;
        if angle=337.5 then begin posx:=posx-2;inc(posy);end;
        if angle=45  then begin posx:=posx-2;posy:=posy-2; end;
        if angle=315 then begin posx:=posx-2;posy:=posy+2;end;
        if angle=67.5  then begin posy:=posy-2; dec(posx);end;
        if angle=292.5 then begin posy:=posy+2; dec(posx);end;
        if angle=90  then posy:=posy-2;
        if angle=270 then posy:=posy+2;
        if angle=112.5 then begin posy:=posy-2; inc(posx);end;
        if angle=247.5 then begin posy:=posy+2; inc(posx);end;
        if angle=135 then begin posx:=posx+2;posy:=posy-2; end;
        if angle=157.5 then begin posx:=posx+2; dec(posy);end;
        if angle=202.5 then begin posx:=posx+2; inc(posy);end;
        if angle=225 then begin posx:=posx+2;posy:=posy+2;end;
        if angle=180 then posx:=posx+2;
           end;
end;

procedure v4(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
begin
       if takt mod 2=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             posx:=posx-2;
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             posx:=posx+2;
        if (angle=67.5) or (angle=90) or (angle=112.5) then
             posy:=posy-2;
        if (angle=247.5) or (angle=270) or (angle=292.5) then
             posy:=posy+2;
        if angle=45  then begin dec(posx);dec(posy);end;
        if angle=135 then begin inc(posx);dec(posy);end;
        if angle=225 then begin inc(posx);inc(posy);end;
        if angle=315 then begin dec(posx);inc(posy);end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-3;
        if angle=22.5  then begin posx:=posx-2;dec(posy);end;
        if angle=337.5 then begin posx:=posx-2;inc(posy);end;
        if angle=45  then begin posx:=posx-2;posy:=posy-2; end;
        if angle=315 then begin posx:=posx-2;posy:=posy+2;end;
        if angle=67.5  then begin posy:=posy-2; dec(posx);end;
        if angle=292.5 then begin posy:=posy+2; dec(posx);end;
        if angle=90  then posy:=posy-3;
        if angle=270 then posy:=posy+3;
        if angle=112.5 then begin posy:=posy-2; inc(posx);end;
        if angle=247.5 then begin posy:=posy+2; inc(posx);end;
        if angle=135 then begin posx:=posx+2;posy:=posy-2; end;
        if angle=157.5 then begin posx:=posx+2; dec(posy);end;
        if angle=202.5 then begin posx:=posx+2; inc(posy);end;
        if angle=225 then begin posx:=posx+2;posy:=posy+2;end;
        if angle=180 then posx:=posx+3;
           end;
end;


procedure v5(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
       if takt mod 2=0 then begin

        if (angle=0) then posx:=posx-3;
        if angle=22.5  then begin posx:=posx-3;posy:=posy-1;end;
        if angle=337.5 then begin posx:=posx-3;posy:=posy+1;end;

        if (angle=180) then posx:=posx+3;
        if (angle=157.5) then begin posx:=posx+3; posy:=posy-1;end;
        if (angle=202.5) then begin posx:=posx+3; posy:=posy+1;end;

        if (angle=90) then posy:=posy-3;
        if (angle=112.5) then begin posy:=posy-3; posx:=posx+1;end;
        if (angle=67.5)  then begin posy:=posy-3; posx:=posx-1;end;

        if (angle=270) then posy:=posy+3;
        if (angle=247.5)   then begin posy:=posy+3; posx:=posx+1;end;
        if (angle=292.5)  then begin posy:=posy+3; posx:=posx-1;end;

        if angle=45  then begin posx:=posx-2;posy:=posy-2;end;
        if angle=135 then begin posx:=posx+2;posy:=posy-2;end;
        if angle=225 then begin posx:=posx+2;posy:=posy+2;end;
        if angle=315 then begin posx:=posx-2;posy:=posy+2;end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-4;
        if angle=22.5  then begin posx:=posx-3;dec(posy);end;
        if angle=337.5 then begin posx:=posx-3;inc(posy);end;
        if angle=45  then begin posx:=posx-3;posy:=posy-3; end;
        if angle=315 then begin posx:=posx-3;posy:=posy+3;end;
        if angle=67.5  then begin posy:=posy-3; dec(posx);end;
        if angle=292.5 then begin posy:=posy+3; dec(posx);end;
        if angle=90  then posy:=posy-4;
        if angle=270 then posy:=posy+4;
        if angle=112.5 then begin posy:=posy-3; inc(posx);end;
        if angle=247.5 then begin posy:=posy+3; inc(posx);end;
        if angle=135 then begin posx:=posx+3;posy:=posy-3; end;
        if angle=157.5 then begin posx:=posx+3; dec(posy);end;
        if angle=202.5 then begin posx:=posx+3; inc(posy);end;
        if angle=225 then begin posx:=posx+3;posy:=posy+3;end;
        if angle=180 then posx:=posx+4;
           end;

     end;





procedure v6(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
       if takt mod 2=0 then begin

        if (angle=0) then posx:=posx-5;
        if angle=22.5  then begin posx:=posx-4;posy:=posy-2;end;
        if angle=337.5 then begin posx:=posx-4;posy:=posy+2;end;

        if (angle=180) then posx:=posx+5;
        if (angle=157.5) then begin posx:=posx+4; posy:=posy-2;end;
        if (angle=202.5) then begin posx:=posx+4; posy:=posy+2;end;

        if (angle=90) then posy:=posy-5;
        if (angle=112.5) then begin posy:=posy-4; posx:=posx+2;end;
        if (angle=67.5)  then begin posy:=posy-4; posx:=posx-2;end;

        if (angle=270) then posy:=posy+5;
        if (angle=247.5)  then begin posy:=posy+4; posx:=posx+2;end;
        if (angle=292.5)  then begin posy:=posy+4; posx:=posx-2;end;



        if angle=45  then begin posx:=posx-3;posy:=posy-3;end;
        if angle=135 then begin posx:=posx+3;posy:=posy-3;end;
        if angle=225 then begin posx:=posx+3;posy:=posy+3;end;
        if angle=315 then begin posx:=posx-3;posy:=posy+3;end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-4;
        if angle=22.5  then begin posx:=posx-4;dec(posy);end;
        if angle=337.5 then begin posx:=posx-4;inc(posy);end;
        if angle=45  then begin posx:=posx-3;posy:=posy-3;end;
        if angle=315 then begin posx:=posx-3;posy:=posy+3;end;
        if angle=67.5  then begin posy:=posy-4; dec(posx);end;
        if angle=292.5 then begin posy:=posy+4; dec(posx);end;
        if angle=90  then posy:=posy-4;
        if angle=270 then posy:=posy+4;
        if angle=112.5 then begin posy:=posy-4; inc(posx);end;
        if angle=247.5 then begin posy:=posy+4; inc(posx);end;
        if angle=135 then begin posx:=posx+3;posy:=posy-3; end;
        if angle=157.5 then begin posx:=posx+4; dec(posy);end;
        if angle=202.5 then begin posx:=posx+4; inc(posy);end;
        if angle=225 then begin posx:=posx+3;posy:=posy+3;end;
        if angle=180 then posx:=posx+4;
           end;

     end;

procedure v7(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);

     begin
       if takt mod 2=0 then begin



        if (angle=0) then posx:=posx-5;
        if angle=22.5  then begin posx:=posx-5;posy:=posy-2;end;
        if angle=337.5 then begin posx:=posx-5;posy:=posy+2;end;

        if (angle=180) then posx:=posx+5;
        if (angle=157.5) then begin posx:=posx+5; posy:=posy-2;end;
        if (angle=202.5) then begin posx:=posx+5; posy:=posy+2;end;

        if (angle=90) then posy:=posy-5;
        if (angle=112.5) then begin posy:=posy-5; posx:=posx+2;end;
        if (angle=67.5)  then begin posy:=posy-5; posx:=posx-2;end;

        if (angle=270) then posy:=posy+5;
        if (angle=247.5)  then begin posy:=posy+5; posx:=posx+2;end;
        if (angle=292.5)  then begin posy:=posy+5; posx:=posx-2;end;



        if angle=45  then begin posx:=posx-4;posy:=posy-4;end;
        if angle=135 then begin posx:=posx+4;posy:=posy-4;end;
        if angle=225 then begin posx:=posx+4;posy:=posy+4;end;
        if angle=315 then begin posx:=posx-4;posy:=posy+4;end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-6;
        if angle=22.5  then begin posx:=posx-5;posy:=posy-2;end;
        if angle=337.5 then begin posx:=posx-5;posy:=posy+2;end;
        if angle=45  then begin posx:=posx-4;posy:=posy-4; end;
        if angle=315 then begin posx:=posx-4;posy:=posy+4;end;
        if angle=67.5  then begin posy:=posy-5; posx:=posx-2;end;
        if angle=292.5 then begin posy:=posy+5; posx:=posx-2;end;
        if angle=90  then posy:=posy-6;
        if angle=270 then posy:=posy+6;
        if angle=112.5 then begin posy:=posy-5; posx:=posx+2;end;
        if angle=247.5 then begin posy:=posy+5; posx:=posx+2;end;
        if angle=135 then begin posx:=posx+4;posy:=posy-4; end;
        if angle=157.5 then begin posx:=posx+5; posy:=posy-2;end;
        if angle=202.5 then begin posx:=posx+5; posy:=posy+2;end;
        if angle=225 then begin posx:=posx+4;posy:=posy+4;end;
        if angle=180 then posx:=posx+6;
           end;

     end;





procedure v8(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
       if takt mod 2=0 then begin



        if (angle=0) then posx:=posx-7;
        if angle=22.5  then begin posx:=posx-6;posy:=posy-3;end;
        if angle=337.5 then begin posx:=posx-6;posy:=posy+3;end;

        if (angle=180) then posx:=posx+7;
        if (angle=157.5) then begin posx:=posx+6; posy:=posy-3;end;
        if (angle=202.5) then begin posx:=posx+6; posy:=posy+3;end;

        if (angle=90) then posy:=posy-7;
        if (angle=112.5) then begin posy:=posy-6; posx:=posx+3;end;
        if (angle=67.5)  then begin posy:=posy-6; posx:=posx-3;end;

        if (angle=270) then posy:=posy+7;
        if (angle=247.5)  then begin posy:=posy+6; posx:=posx+3;end;
        if (angle=292.5)  then begin posy:=posy+6; posx:=posx-3;end;



        if angle=45  then begin posx:=posx-5;posy:=posy-5;end;
        if angle=135 then begin posx:=posx+5;posy:=posy-5;end;
        if angle=225 then begin posx:=posx+5;posy:=posy+5;end;
        if angle=315 then begin posx:=posx-5;posy:=posy+5;end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-6;
        if angle=22.5  then begin posx:=posx-6;posy:=posy-2;end;
        if angle=337.5 then begin posx:=posx-6;posy:=posy+2;end;
        if angle=45  then begin posx:=posx-5;posy:=posy-5; end;
        if angle=315 then begin posx:=posx-5;posy:=posy+5;end;
        if angle=67.5  then begin posy:=posy-6; posx:=posx-2;end;
        if angle=292.5 then begin posy:=posy+6; posx:=posx-2;end;
        if angle=90  then posy:=posy-6;
        if angle=270 then posy:=posy+6;
        if angle=112.5 then begin posy:=posy-6; posx:=posx+2;end;
        if angle=247.5 then begin posy:=posy+6; posx:=posx+2;end;
        if angle=135 then begin posx:=posx+5;posy:=posy-5; end;
        if angle=157.5 then begin posx:=posx+6; posy:=posy-2;end;
        if angle=202.5 then begin posx:=posx+6; posy:=posy+2;end;
        if angle=225 then begin posx:=posx+5;posy:=posy+5;end;
        if angle=180 then posx:=posx+6;
           end;

     end;



procedure v9(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
       if takt mod 2=0 then begin



        if (angle=0) then posx:=posx-9;
        if angle=22.5  then begin posx:=posx-8;posy:=posy-3;end;
        if angle=337.5 then begin posx:=posx-8;posy:=posy+3;end;

        if (angle=180) then posx:=posx+9;
        if (angle=157.5) then begin posx:=posx+8; posy:=posy-3;end;
        if (angle=202.5) then begin posx:=posx+8; posy:=posy+3;end;

        if (angle=90) then posy:=posy-9;
        if (angle=112.5) then begin posy:=posy-8; posx:=posx+3;end;
        if (angle=67.5)  then begin posy:=posy-8; posx:=posx-3;end;

        if (angle=270) then posy:=posy+9;
        if (angle=247.5)  then begin posy:=posy+8; posx:=posx+3;end;
        if (angle=292.5)  then begin posy:=posy+8; posx:=posx-3;end;



        if angle=45  then begin posx:=posx-6;posy:=posy-6;end;
        if angle=135 then begin posx:=posx+6;posy:=posy-6;end;
        if angle=225 then begin posx:=posx+6;posy:=posy+6;end;
        if angle=315 then begin posx:=posx-6;posy:=posy+6;end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx-9;
        if angle=22.5  then begin posx:=posx-8;posy:=posy-3;end;
        if angle=337.5 then begin posx:=posx-8;posy:=posy+3;end;
        if angle=45  then begin posx:=posx-7;posy:=posy-7; end;
        if angle=315 then begin posx:=posx-7;posy:=posy+7;end;
        if angle=67.5  then begin posy:=posy-8; posx:=posx-3;end;
        if angle=292.5 then begin posy:=posy+8; posx:=posx-3;end;
        if angle=90  then posy:=posy-9;
        if angle=270 then posy:=posy+9;
        if angle=112.5 then begin posy:=posy-8; posx:=posx+3;end;
        if angle=247.5 then begin posy:=posy+8; posx:=posx+3;end;
        if angle=135 then begin posx:=posx+7;posy:=posy-7; end;
        if angle=157.5 then begin posx:=posx+8; posy:=posy-3;end;
        if angle=202.5 then begin posx:=posx+8; posy:=posy+3;end;
        if angle=225 then begin posx:=posx+7;posy:=posy+7;end;
        if angle=180 then posx:=posx+9;
           end;

     end;


                                      {rueckwaerts}




procedure vneg1(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
      if takt mod 2 = 0 then
       if takt mod 4=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             inc(posx);
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             dec(posx);
        if (angle=67.5) or (angle=90) or (angle=112.5) then
               inc(posy);
        if (angle=247.5) or (angle=270) or (angle=292.5) then
               dec(posy);
        if angle=45  then begin inc(posx);inc(posy);end;
        if angle=135 then begin dec(posx);inc(posy);end;
        if angle=225 then begin dec(posx);dec(posy);end;
        if angle=315 then begin inc(posx);dec(posy);end;
                end;

       if takt mod 4=2 then begin
        if angle=0 then posx:=posx+2;
        if angle=22.5  then begin posx:=posx+2;inc(posy);end;
        if angle=337.5 then begin posx:=posx+2;dec(posy);end;
        if angle=45  then begin inc(posx);inc(posy) end;
        if angle=315 then begin inc(posx);dec(posy);end;
        if angle=67.5  then begin posy:=posy+2; inc(posx);end;
        if angle=292.5 then begin posy:=posy-2; inc(posx);end;
        if angle=90  then posy:=posy+2;
        if angle=270 then posy:=posy-2;
        if angle=112.5 then begin posy:=posy+2; dec(posx);end;
        if angle=247.5 then begin posy:=posy-2; dec(posx);end;
        if angle=135 then begin dec(posx);inc(posy); end;
        if angle=225 then begin dec(posx);dec(posy);end;
        if angle=157.5 then begin posx:=posx-2; inc(posy);end;
        if angle=202.5 then begin posx:=posx-2; dec(posy);end;
        if angle=180 then posx:=posx-2;
           end;

     end;








procedure vneg2(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);

     begin
       if takt mod 2=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             inc(posx);
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             dec(posx);
        if (angle=67.5) or (angle=90) or (angle=112.5) then
               inc(posy);
        if (angle=247.5) or (angle=270) or (angle=292.5) then
               dec(posy);
        if angle=45  then begin inc(posx);inc(posy);end;
        if angle=135 then begin dec(posx);inc(posy);end;
        if angle=225 then begin dec(posx);dec(posy);end;
        if angle=315 then begin inc(posx);dec(posy);end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx+2;
        if angle=22.5  then begin posx:=posx+2;inc(posy);end;
        if angle=337.5 then begin posx:=posx+2;dec(posy);end;
        if angle=45  then begin inc(posx);inc(posy) end;
        if angle=315 then begin inc(posx);dec(posy);end;
        if angle=67.5  then begin posy:=posy+2; inc(posx);end;
        if angle=292.5 then begin posy:=posy-2; inc(posx);end;
        if angle=90  then posy:=posy+2;
        if angle=270 then posy:=posy-2;
        if angle=112.5 then begin posy:=posy+2; dec(posx);end;
        if angle=247.5 then begin posy:=posy-2; dec(posx);end;
        if angle=135 then begin dec(posx);inc(posy); end;
        if angle=157.5 then begin posx:=posx-2; inc(posy);end;
        if angle=202.5 then begin posx:=posx-2; dec(posy);end;
        if angle=225 then begin dec(posx);dec(posy);end;
        if angle=180 then posx:=posx-2;
           end;

     end;





procedure vneg3(var posx,posy,v:integer; var angle:real;
                          var takt:shortint);
     begin
       if takt mod 2=0 then begin

        if (angle=0) or (angle=22.5) or (angle=337.5) then
             posx:=posx+2;
        if (angle=157.5) or (angle=180) or (angle=202.5) then
             posx:=posx-2;
        if (angle=67.5) or (angle=90) or (angle=112.5) then
             posy:=posy+2;
        if (angle=247.5) or (angle=270) or (angle=292.5) then
             posy:=posy-2;
        if angle=45  then begin inc(posx);inc(posy);end;
        if angle=135 then begin dec(posx);inc(posy);end;
        if angle=225 then begin dec(posx);dec(posy);end;
        if angle=315 then begin inc(posx);dec(posy);end;
                end;

       if takt mod 2=1 then begin
        if angle=0 then posx:=posx+2;
        if angle=22.5  then begin posx:=posx+2;inc(posy);end;
        if angle=337.5 then begin posx:=posx+2;dec(posy);end;
        if angle=45  then begin posx:=posx+2;posy:=posy+2; end;
        if angle=315 then begin posx:=posx+2;posy:=posy-2;end;
        if angle=67.5  then begin posy:=posy+2; inc(posx);end;
        if angle=292.5 then begin posy:=posy-2; inc(posx);end;
        if angle=90  then posy:=posy+2;
        if angle=270 then posy:=posy-2;
        if angle=112.5 then begin posy:=posy+2; dec(posx);end;
        if angle=247.5 then begin posy:=posy-2; dec(posx);end;
        if angle=135 then begin posx:=posx-2;posy:=posy+2; end;
        if angle=157.5 then begin posx:=posx-2; inc(posy);end;
        if angle=202.5 then begin posx:=posx-2; dec(posy);end;
        if angle=225 then begin posx:=posx-2;posy:=posy-2;end;
        if angle=180 then posx:=posx-2;
           end;

     end;







procedure koord_berechnen;
begin
if v=1 then  {3}
     begin
       v1(posx,posy,v,angle,takt);
     end;


     if v=2 then  {3}
     begin
       v2(posx,posy,v,angle,takt);
     end;



if v=3 then  {4}
     begin
       v3(posx,posy,v,angle,takt);
     end;

   if v=4 then  {5}
     begin
       v4(posx,posy,v,angle,takt);
     end;
   if v=5 then  {5}
     begin
       v5(posx,posy,v,angle,takt);
     end;
      if v=6 then  {5}
     begin
       v6(posx,posy,v,angle,takt);
     end;
   if v=7 then  {5}
     begin
       v7(posx,posy,v,angle,takt);
     end;
   if v=8 then  {5}
     begin
       v8(posx,posy,v,angle,takt);
     end;
   if v=9 then  {5}
     begin
       v9(posx,posy,v,angle,takt);
     end;
   if v=-1 then  {5}
     begin
       vneg1(posx,posy,v,angle,takt);
     end;
      if v=-2 then  {5}
     begin
       vneg2(posx,posy,v,angle,takt);
     end;
   if v=-3 then  {5}
     begin
       vneg3(posx,posy,v,angle,takt);
     end;
   end;




{nutzung   der kollosionsauswertung}

procedure kauswertung(var posx,posy,flx,fly,frx,fry,hrx,hry,hlx,hly,
          v:integer; angle:real; takt:shortint;var pic:pointer);
begin


if v=20 then
     begin

        if (angle=0)  then
             dec(posx);
        if  (angle=180) then
             inc(posx);
        if  (angle=90) then
               dec(posy);
        if  (angle=270) then
               inc(posy);

        if  ((angle=45) or (angle=22.5) or (angle=67.5))
        and ((Getpixel(Pic,hrx,hry)=0) and
             (GetPixel(Pic,hlx,hly)=0)) then begin
             dec(posx); dec(posy);
            end;

       if ((angle=45) or (angle=22.5) or (angle=67.5)) and
       (not(Getpixel(Pic,hlx,hly)=0) and
       (GetPixel(Pic,hrx,hry)=0)) then
        dec(posx);
       if ((angle=45) or (angle=22.5) or (angle=67.5)) and
       (not(Getpixel(Pic,hrx,hry)=0) and
        (GetPixel(Pic,hlx,hly)=0)) then
        dec(posy);

      if  ((angle=135) or (angle=112.5) or (angle=157.5))
        and ((Getpixel(Pic,hrx,hry)=0) and
             (GetPixel(Pic,hlx,hly)=0)) then begin
             inc(posx); dec(posy); end;
      if ((angle=135) or (angle=112.5) or (angle=157.5))
      and (not(Getpixel(Pic,hlx,hly)=0) and
          (GetPixel(Pic,hrx,hry)=0)) then
           dec(posy);

      if ((angle=135) or (angle=112.5) or (angle=157.5))
      and (not(Getpixel(Pic,hrx,hry)=0) and
        (GetPixel(Pic,hlx,hly)=0)) then
        inc(posx);

      if  ((angle=225) or (angle=202.5) or (angle=247.5))
        and ((Getpixel(Pic,hrx,hry)=0) and
             (GetPixel(Pic,hlx,hly)=0)) then begin
             inc(posx); inc(posy); end;
      if ((angle=225) or (angle=202.5) or (angle=247.5)) and
          (not(Getpixel(Pic,hlx,hly)=0) and
          (GetPixel(Pic,hrx,hry)=0)) then
           inc(posx);
      if ((angle=225) or (angle=202.5) or (angle=247.5)) and
          (not(Getpixel(Pic,hrx,hry)=0) and
        (GetPixel(Pic,hlx,hly)=0)) then
          inc(posy);

       if  ((angle=315) or (angle=292.5) or (angle=337.5))
        and ((Getpixel(Pic,hrx,hry)=0) and
             (GetPixel(Pic,hlx,hly)=0)) then begin
             dec(posx); inc(posy); end;
      if ((angle=315) or (angle=292.5) or (angle=337.5))
          and (not(Getpixel(Pic,hlx,hly)=0) and
          (GetPixel(Pic,hrx,hry)=0)) then
           inc(posy);

      if ((angle=315) or (angle=292.5) or (angle=337.5))
          and (not(Getpixel(Pic,hrx,hry)=0) and
        (GetPixel(Pic,hlx,hly)=0)) then
        dec(posx);
       end;




if v=-20 then
     begin

        if (angle=0)  then
             inc(posx);
        if  (angle=180) then
             dec(posx);
        if  (angle=90) then
               inc(posy);
        if  (angle=270) then
               dec(posy);

        if  ((angle=45) or (angle=22.5) or (angle=67.5))
        and ((Getpixel(Pic,frx,fry)=0) and
             (GetPixel(Pic,flx,fly)=0)) then begin
             inc(posx); inc(posy);
            end;

       if ((angle=45) or (angle=22.5) or (angle=67.5)) and
       (not(Getpixel(Pic,flx,fly)=0) and
       (GetPixel(Pic,frx,fry)=0)) then
        inc(posy);
       if ((angle=45) or (angle=22.5) or (angle=67.5)) and
       (not(Getpixel(Pic,frx,fry)=0) and
        (GetPixel(Pic,flx,fly)=0)) then
        inc(posx);

      if  ((angle=135) or (angle=112.5) or (angle=157.5))
        and ((Getpixel(Pic,frx,fry)=0) and
             (GetPixel(Pic,flx,fly)=0)) then begin
             dec(posx); inc(posy); end;
      if ((angle=135) or (angle=112.5) or (angle=157.5))
      and (not(Getpixel(Pic,flx,fly)=0) and
          (GetPixel(Pic,frx,fry)=0)) then
           dec(posx);

      if ((angle=135) or (angle=112.5) or (angle=157.5))
      and (not(Getpixel(Pic,frx,fry)=0) and
        (GetPixel(Pic,flx,fly)=0)) then
        inc(posy);

      if  ((angle=225) or (angle=202.5) or (angle=247.5))
        and ((Getpixel(Pic,frx,fry)=0) and
             (GetPixel(Pic,flx,fly)=0)) then begin
             dec(posx); dec(posy); end;
      if ((angle=225) or (angle=202.5) or (angle=247.5)) and
          (not(Getpixel(Pic,flx,fly)=0) and
          (GetPixel(Pic,frx,fry)=0)) then
           dec(posy);
      if ((angle=225) or (angle=202.5) or (angle=247.5)) and
          (not(Getpixel(Pic,frx,fry)=0) and
        (GetPixel(Pic,flx,fly)=0)) then
          dec(posx);

       if  ((angle=315) or (angle=292.5) or (angle=337.5))
        and ((Getpixel(Pic,frx,fry)=0) and
             (GetPixel(Pic,flx,fly)=0)) then begin
             inc(posx); dec(posy); end;
      if ((angle=315) or (angle=292.5) or (angle=337.5))
          and (not(Getpixel(Pic,flx,fly)=0) and
          (GetPixel(Pic,frx,fry)=0)) then
           inc(posx);

      if ((angle=315) or (angle=292.5) or (angle=337.5))
          and (not(Getpixel(Pic,frx,fry)=0) and
        (GetPixel(Pic,flx,fly)=0)) then
        dec(posy);

      end;
  end;









begin
end.