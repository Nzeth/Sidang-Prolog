?-
%pendeklarasian objeck game
G_Background is bitmap_image("cosplay.bmp",_),
  G_Comp_First=0,
  G_Take_Last=0,
  G_K := 0,
  G_Ikon is bitmap_image("moe.bmp","moeb.bmp"),
  G_Latar is bitmap_image("gambar 7.bmp",_),
  G_kalah is bitmap_image("gambar 12.bmp",_),
  G_boom is bitmap_image("gambar 3.bmp",_),
  G_menu is bitmap_image("cafe.bmp",_),	

pen(0,0),       
  set(pos([1,2,3,4,5,4,3,2,1])),
 

window(G_pertama,_,win_pertama(_),"window splash screen",400,200,300,400).
win_pertama(init):-
button(_,_,tombol_play(_),"Play",90,100,100,40),
button(_,_,tombol_exit(_),"Exit",90,200,100,40),
button(_,_,tombol_about(_),"About",90,300,100,40).

%memanggil gambar background di menu awal
win_pertama(paint):-
draw_bitmap(0,0,G_menu,_,_).

%deklarasi tombol exit di menu utama
tombol_exit(press):-
beep("ho.wav"),
message("Exit","Senpai kok gak jadi main T_T",i),
close_window(G_pertama).

%deklarasi tombol about di menu utama
tombol_about(press):-
shell_execute("html\\index.html").


tombol_play(press):-
close_window(G_pertama),
window(G_kedua,_,win_kedua(_),"Splash Screen",400,200,400,400).
update_window(_).



win_kedua(paint):-
draw_bitmap(0,0,G_Background,_,_).

win_kedua(init):-
execute("ganteng.exe ah"),
G_batas:=0,
G_waktu is set_timer(_,0.1,fungsi_timer).



fungsi_timer(end):-
pen(1,rgb(228,207,204)), % warna loading bar
brush(rgb(250,0,0)), %warna merah loading bar
rect(30,300,30+G_K,320),
text_out(150,280,print("Loading : "+G_batas)),
G_batas := G_batas+1,
G_K := G_K+3,
(G_batas = 100 -> kill_timer(_, G_waktu),
close_window(G_kedua),
window(G_Main, _, win_func(_), "Kyun Kyun", 80,80,680,590),
update_window(_)).


win_func(close):-
execute("ganteng.exe stop"),
close_window(G_main).


win_func(init) :- % menambah opsi game
  menu( normal, _, _, menu_new(_), "&Ulang"),
  menu( normal, _, _, menu_Help(_), "&Help"),
  menu( normal, _, _, menu_exit(_), "&Keluar"),
  menu( normal, _, _, menu_stop(_), "&Stop").

win_func(paint):- %memanggil latar dan icon
draw_bitmap(0,0,G_Latar,_,300),
    pos(Pos),
  el(Pos,El,N),
  for(I,1,El),
  draw_bitmap(10+75*N,5+70*(I-1),G_Ikon,_,_),
    fail.

 
win_func(mouse_click(X,Y)):- %letak icon yang di klik
  X1 is (X-10)//75,
  Y1 is (Y-5)//70,
  X1=<9,X>=10,
  pos(Pos),
  el(Pos,El,X1),
  El>Y1,
  beep("oh.wav"),
  replace(Pos2, Pos, Y1, X1),
  (Pos2=[0,0,0,0,0,0,0,0,0]->
    set(pos(Pos2)),
    end(0)

  else

    wait(0.1),
    play(Pos3, Pos2),
    (Pos3=[0,0,0,0,0,0,0,0,0]->
      end(1)),
    set(pos(Pos3))),
  update_window(_).

win_func(mouse_click(X,Y)):-
 beep.

play(Pos3, Pos2):- %Inti dari AI
  G_Take_Last=0,
  count_successes(not_trivial(Pos2))<2,
  find_max(Pos2,Max,N),
  New is (Max>1,count_successes(not_empty(Pos2)) mod 2=:=1 -> 1 else 0),
  replace(Pos3, Pos2, New, N).
play(Pos3, Pos2):-
  el(Pos2,A, N),
  R:=0,
  add_xor(R,Pos2,N),
  R<A,
  replace(Pos3, Pos2, R, N).
play(Pos3, Pos2):-
  find_max(Pos2,Max,N),
  Max2 is (Max>1, random(2)=:=0 ->
    Max - 2
  else
    Max - 1),
  replace(Pos3, Pos2, Max2, N).


not_empty(Pos):-
  el(Pos,A, _),
  A>0.
not_trivial(Pos):-
  el(Pos,A, _),
  A>1.

el([H|T],H,0).
el([H|T],El,N):-
  el(T,El,N1),
  N is N1+1.

replace([H|T],[_|T],H,0).
replace([H|T2],[H|T],El,N):-
  replace(T2,T,El,N1),
  N is N1+1.

find_max([H],H,0).
find_max([H|T],A, N) :-
  find_max(T,A1,N1),
  (A1<H->
    A is H,
    N is 0
  else
    A is A1,
    N is N1+1).


add_xor(_,[],_):-!.
add_xor(R,[H|T],0):- !,
  add_xor(R, T, -1).
add_xor(R,[H|T],N):-
  N1 is N- 1
,
  R:=R xor H,
  add_xor(R, T, N1).


end(Flag):- %akhir permainan
  Flag=G_Take_Last->
draw_bitmap(0,0,G_boom,_,_),

 wait(0.1),
draw_bitmap(0,0,G_kalah,_,_),
    message("LOLICON","GOMENN SENPAI I WILL KILL YOU!!!",!)

  else
draw_bitmap(0,0,G_boom,_,_),

 wait(0.1),
draw_bitmap(0,0,G_boom,_,_),
beep,
    message("YATTA","Selamat Kamu Senpai Kamu Menang DAISUKI Muach :*",i),
update_window(_).

menu_new(press) :- %permainan baru
  (G_Comp_First=0->
    set(pos([1,2,3,4,5,4,3,1,2]))
  else
    Pos=[1,2,3,4,5,4,3,1,2],
    N is 2*random(3),
    el(Pos,A, N),
    A2 is A - 1,
    replace(Pos2, Pos, A2, N),
    set(pos(Pos2))),
  update_window(_).

%deklarasi menu help
menu_Help(press) :-
  message("Help","Permainan ini jangan sampai mengambil kyun kyun yang terakhir", i),
update_window(_).
 
ok_func(press) :-
  G_Comp_First:=get_check_box_value(G_A),
  G_Take_Last:=get_check_box_value(G_B),
  (G_Take_Last=1->
    set_text("Matches (Take the last)",G_Main)
  else
    set_text("Matches (Don't take the last)",G_Main)),
  close_window(parent(_)).

cancel_func(press) :-
  close_window(parent(_)).

check_func(press) :-
  set_check_box_value(_,1-get_check_box_value(_)).

%deklarasi menu exit
menu_exit(press) :-
beep("onichan.wav"),
message("Exit","Sayonara Oniichan muach :*", i),
close_window(G_main).

%deklarasi menu  stop musik
menu_stop(press):-
beep("itai.wav"),
message("Stop","Musik berhenti yaa", i),
execute("ganteng.exe stop").

button(_,_,tombol_3(_),"kembali",400,600,200,40).
tombol_3(press):-
close_window(G_ketiga),
window(G_pertama,_,win_pertama(),"window splash screen",400,200,400,400),
update_window(_).

win_func(close):-
execute("ganteng.exe stop"),
close_window(G_kedua).
