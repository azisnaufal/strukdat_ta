program UAntrian;
uses crt, mmsystem, sysutils;
type
  TInfo = record
    antrian : String[8];
  end;
  PData = ^TData;

  TData = record
    info: TInfo;
    Next: PData;
  end;

var
  awal, akhir: PData;
  pilihan: integer;
  penghitung : integer;
  nomor_antrian_meja_1 : TInfo;
  nomor_antrian_meja_2 : TInfo;
  banyak_data : integer;

//RUANG KERJA AZIS ↓↓

//fungsi ini dipanggil untuk mengecek apakah nomor simpul merupakan daun (leaf) atau bukan (dibuat oleh azis)
function apakahDaun(nomor_simpul : integer) : boolean;
begin
  if (nomor_simpul >= (banyak_data div 2)) and (nomor_simpul <= banyak_data) then
    apakahDaun := true
  else 
    apakahDaun := false;
end;

//fungsi ini dipanggil untuk mendapatkan posisi anak kiri dari nomor_simpul (dibuat oleh azis)
function anakKiri(nomor_simpul : integer): integer;
begin
  anakKiri := nomor_simpul * 2;
end;

//fungsi ini dipanggil untuk mendapatkan posisi anak kanan dari nomor_simpul (dibuat oleh azis)
function anakKanan(nomor_simpul : integer): integer;
begin
  anakKanan := nomor_simpul * 2 + 1;
end;

//fungsi ini dipanggil untuk mendapatkan posisi orangtua (parent) dari nomor_simpul (dibuat oleh azis)
function orangTua(nomor_simpul : integer): integer;
begin
  orangTua := nomor_simpul div 2;
end;

//fungsi ini untuk mencari data pada posisi ke n (dibuat oleh azis)
function ambilNilaiDariHeap(n : integer) : PData;
var 
  bantu : PData;
  posisi : integer;
begin
  bantu := awal;
  posisi := 1;
  while (bantu <> akhir) and (posisi <> n) do
  begin
    bantu := bantu^.next;
    posisi := posisi + 1;
  end;  
  ambilNilaiDariHeap := bantu;
end;

//prosedur ini dipanggil untuk menukar data dalam heap (dibuat oleh azis)
procedure tukar(nomor_simpul1:integer;nomor_simpul2:integer);
var
  temp:TInfo;
begin
   temp := ambilNilaiDariHeap(nomor_simpul1)^.info;
   ambilNilaiDariHeap(nomor_simpul1)^.info := ambilNilaiDariHeap(nomor_simpul2)^.info;
   ambilNilaiDariHeap(nomor_simpul2)^.info := temp;
end;

//prosedur ini dipanggil ketika ada penambahan data geser_ke_atas = shift_up (dibuat oleh azis)
procedure geser_ke_atas() ;
var
  nomor_simpul : integer;
begin
  nomor_simpul := banyak_data;
  while(nomor_simpul > 1) and ( ambilNilaiDariHeap(orangTua(nomor_simpul))^.info.antrian < ambilNilaiDariHeap(nomor_simpul)^.info.antrian ) do
  begin
    tukar(nomor_simpul, orangTua(nomor_simpul));
    nomor_simpul := orangTua(nomor_simpul);
  end;
end;

//prosedur ini dipanggil oleh prosedur reorganisasi untuk membuat ulang heap (dibuat oleh azis)
procedure buatHeap(nomor_simpul : integer);
begin
  if not apakahDaun(nomor_simpul) then
  begin
    if (ambilNilaiDariHeap(nomor_simpul)^.info.antrian < ambilNilaiDariHeap(anakKiri(nomor_simpul))^.info.antrian) or (ambilNilaiDariHeap(nomor_simpul)^.info.antrian < ambilNilaiDariHeap(anakKanan(nomor_simpul))^.info.antrian) then
    begin
      if (ambilNilaiDariHeap(anakKiri(nomor_simpul))^.info.antrian < ambilNilaiDariHeap(anakKanan(nomor_simpul))^.info.antrian ) then
      begin
        tukar(nomor_simpul, anakKiri(nomor_simpul));
        buatHeap(anakKiri(nomor_simpul));
      end
      else
      begin
        tukar(nomor_simpul, anakKanan(nomor_simpul));
        buatHeap(anakKanan(nomor_simpul));        
      end;
    end;
  end; 
end;

//prosedur ini dipanggil ketika heap rusak (dibuat oleh azis)
procedure reorganisasi;
var
  nomor_simpul : integer;
begin
  nomor_simpul := orangTua(banyak_data);
  while (nomor_simpul >= 1) do 
  begin
    buatHeap(nomor_simpul);
    nomor_simpul := nomor_simpul - 1;
  end;
end;

//hapus antrian
function hapus_antrian() : TInfo;
var
  pHapus : PData;
  info : TInfo;
begin
  info := awal^.info;
  if (awal = akhir) then
  begin
    Dispose(awal);
    awal := nil;
    akhir := nil;
  end
  else
  begin
    pHapus := awal;
    awal := awal^.Next;
    Dispose(pHapus);
  end;
  banyak_data := banyak_data - 1;
  hapus_antrian := info;
end;

//RUANG KERJA ALIF ↓↓
procedure sisip_belakang( i:String; var awal, akhir:PData );
var
  baru:PData;
  begin
      new(baru);
      baru^.info.antrian :=i;
      baru^.next:=nil;
      if (awal=nil) then
          awal:=baru
      else  
        akhir^.next:=baru;
        akhir:=baru;
end;

procedure ambilAntrianBisnis();
var
  info : TInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'B'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;

procedure ambilAntrianPersonal();
var
  info : TInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'P'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;

//RUANG KERJA YUSUP ↓↓
//function ini untuk mengecek apakah antrian kosong apa tidak, oleeh Yusuf
function apakahkosong():boolean;
begin
  if awal = nil then
    apakahkosong := true
    else
    apakahkosong := false;
end;

//prosedur ini digunakan untuk memamnggil antrian di meja 1, oleeh Yusuf
procedure panggilKeMeja1();
var 
  i : integer;
  namafile : String;
begin
  ClrScr;
  if apakahkosong = true then
  begin
    WriteLn('Antrian Kosong ');
  end
  else
  begin
    nomor_antrian_meja_1 := hapus_antrian;
    reorganisasi;
    WriteLn('Nomor antrian ',nomor_antrian_meja_1.antrian,' ke meja satu' );
    playsound('./voiceaudionumber/Nomorantrian.wav',0,0);
    if nomor_antrian_meja_1.antrian[1]='B' then
      playsound('./voiceaudionumber/B.wav',0,0)
    else
      playsound('./voiceaudionumber/p.wav',0,0);
    
    for i:= 2 to length(nomor_antrian_meja_1.antrian)do 
    begin 
      namafile:='./voiceaudionumber/'+nomor_antrian_meja_1.antrian[i]+'.wav';
      playsound(pchar(namafile),0,0);
    end;
    playsound('./voiceaudionumber/dimeja1.wav',0,0);
    end;
    WriteLn('tekan enter untuk melanjutkan ');
    ReadLn();
end;

//prosedur ini digunakan untuk memamnggil antrian di meja 2, oleeh Yusuf
procedure panggilKeMeja2();
var 
  i : integer;
  namafie : String;
begin
  ClrScr;
  if apakahkosong = true then
  begin
    WriteLn('Antrian Kosong ');
  end
  else
  begin
    nomor_antrian_meja_2 := hapus_antrian;
    reorganisasi;
    WriteLn('Nomor antrian ',nomor_antrian_meja_2.antrian,' ke meja Dua' );
    playsound('./voiceaudionumber/Nomorantrian.wav',0,0);
    if nomor_antrian_meja_2.antrian[1]='B' then
      playsound('./voiceaudionumber/B.wav',0,0)
    else
      playsound('./voiceaudionumber/p.wav',0,0);
    
    for i:= 2 to length(nomor_antrian_meja_2.antrian)do 
    begin 
      namafie:='./voiceaudionumber/'+nomor_antrian_meja_2.antrian[i]+'.wav';
      playsound(pchar(namafie),0,0);
    end;
    playsound('./voiceaudionumber/dimeja2.wav',0,0);
    end;
    WriteLn('tekan enter untuk melanjutkan ');
    ReadLn();
end;

function tampilMenu() : integer;
var
  pilihan : integer;
begin
    ClrScr;
    WriteLn('======= Aplikasi Antrian Bank Masyarakat UNIKOM =======');
    WriteLn('Meja 1 sedang melayani nomor antrian : ', nomor_antrian_meja_1.antrian);
    WriteLn('Meja 2 sedang melayani nomor antrian : ', nomor_antrian_meja_2.antrian);
    if (awal <> nil) then WriteLn('Nomor antrian selanjutnya : ', awal^.info.antrian);
    WriteLn('1. Ambil nomor antrian bisnis');
    WriteLn('2. Ambil nomor antrian personal');
    WriteLn('3. Panggil nomor antrian ke meja 1');
    WriteLn('4. Panggil nomor antrian ke meja 2');
    WriteLn('5. Keluar aplikasi');
    Write('Pilihan anda : ');
    ReadLn(pilihan);
    tampilMenu := pilihan;
end;

//MAIN FUNCTION ↓↓
begin
  banyak_data := 0;
  // inisialisasi linked list
  awal := nil;
  akhir := nil;
  // memberikan tanda '-' pada antrian kosong
  nomor_antrian_meja_1.antrian := '-';
  nomor_antrian_meja_2.antrian := '-';
  repeat
    pilihan := tampilMenu();
    case(pilihan) of 
      1 : ambilAntrianBisnis;
      2 : ambilAntrianPersonal;
      3 : panggilKeMeja1;
      4 : panggilKeMeja2;
    end;
  until pilihan = 5
end.
