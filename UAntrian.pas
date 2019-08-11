program UAntrian;
uses crt;
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
  banyak_data : integer;

//RUANG KERJA ALIF ↓↓
procedure MyProcedure(params;
begin
  
end;

//RUANG KERJA YUSUP ↓↓


//RUANG KERJA AZIS ↓↓

//fungsi ini dipanggil untuk mengecek apakah nomor simpul merupakan daun (leaf) atau bukan
function apakahDaun(nomor_simpul : integer) : boolean;
begin
  if (nomor_simpul >= (banyak_data div 2)) and (nomor_simpul <= banyak_data) then
    apakahDaun := true;
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
  while(nomor_simpul > 1) and ( ambilNilaiDariHeap(orangTua(nomor_simpul))^.info.antrian > ambilNilaiDariHeap(nomor_simpul)^.info.antrian ) do
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
    if (ambilNilaiDariHeap(nomor_simpul)^.info.antrian > ambilNilaiDariHeap(anakKiri(nomor_simpul))^.info.antrian) or (ambilNilaiDariHeap(nomor_simpul)^.info.antrian > ambilNilaiDariHeap(anakKanan(nomor_simpul))^.info.antrian) then
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

//MAIN FUNCTION ↓↓
begin
  banyak_data := 0;
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