program CafeOrder;
uses crt;

type
  ItemMenu = record // record untuk setiap item
    nama: string;
    harga: real;
  end;
  
  ItemDibeli = record // record untuk item yang dipilih, a.k.a. keranjang
    index: integer;
    jumlah: integer;
  end;

var
  itemDalamMenu: array[1..16] of ItemMenu;
  keranjangOrder: array[1..128] of ItemDibeli;
  jumlahBelanja: integer;
  
procedure InisialisasiMenu;
begin
  // offsetituapa.
  // coffee
  with itemDalamMenu[1] do begin nama := 'Americano'; harga := 18000; end;
  with itemDalamMenu[2] do begin nama := 'Kopi Susu Aren'; harga := 18000; end;
  with itemDalamMenu[3] do begin nama := 'Coconut Latte'; harga := 23000; end;
  with itemDalamMenu[4] do begin nama := 'Cappuccino'; harga := 24000; end;
  with itemDalamMenu[5] do begin nama := 'Caramel Macchiato'; harga := 26000; end;
  // non-coffee
  with itemDalamMenu[6] do begin nama := 'Lemonade'; harga := 14000; end;
  with itemDalamMenu[7] do begin nama := 'Choco Frappe'; harga := 24000; end;
  // food
  with itemDalamMenu[8] do begin nama := 'Butter Croissant'; harga := 16000; end;
  with itemDalamMenu[9] do begin nama := 'Choco Danish'; harga := 18000; end;
  with itemDalamMenu[10] do begin nama := 'Chicken Black Pepper Puff'; harga := 23000; end;
end;

procedure TampilkanMenu(kategori: integer);
var
  i, awal, akhir: integer;
begin
  case (kategori) of
    1: begin
        writeln('=== Coffee ===');
        awal := 1;
        akhir := 5;
      end;
    2: begin // jika kategori non-kopi
        writeln('=== Non-coffee ===');
        awal := 6;
        akhir := 7;
      end;
    3: begin // jika kategori snack
        writeln('=== Food ===');
        awal := 8;
        akhir := 10;
      end;
  end;
  
  for i := awal to akhir do
    writeln(i - awal + 1, '. ', itemDalamMenu[i].nama, ' - Rp', itemDalamMenu[i].harga:0:0);
  writeln('0. Kembali ke menu utama');
  writeln;
end;

procedure TambahBelanja(indexMenu, jumlah: integer);
var
  i: integer;
  ketemu: boolean; // cek apakah item sudah ada di keranjang
begin
  ketemu := false;
  for i := 1 to jumlahBelanja do
  begin
    if (keranjangOrder[i].index = indexMenu) then // jika item sudah ada di keranjang
    begin
      keranjangOrder[i].jumlah := keranjangOrder[i].jumlah + jumlah; // tambahkan jumlahnya
      ketemu := true; // set flag menjadi true
      break; // keluar dari loop
    end;
  end;
  
  if (not ketemu) then // jika item belum ada di keranjang
  begin
    inc(jumlahBelanja); // tambah counter jumlah jenis item
    keranjangOrder[jumlahBelanja].index := indexMenu; // simpan index itemDalamMenu
    keranjangOrder[jumlahBelanja].jumlah := jumlah; // simpan jumlah pembelian
  end;
end;

procedure ProsesKategori(kategori: integer);
var
  pilihan, jumlah, offset, maxPilihan: integer;
  lanjut: char;
begin
  case (kategori) of
    // offsetituapa?
    1: begin offset := 0; maxPilihan := 5; end;
    2: begin offset := 5; maxPilihan := 2; end;
    3: begin offset := 7; maxPilihan := 3; end;
  end;
  
  repeat
    clrscr;
    TampilkanMenu(kategori);
    write('Pilih item: ');
    readln(pilihan);
    
    if (pilihan = 0) then
      exit;
    
    if (pilihan < 1) or (pilihan > maxPilihan) then // validasi pilihan
    begin
      writeln('Pilihan tidak valid!');
      readln;
      continue; // kembali ke awal loop
    end;
    
    write('Jumlah pembelian: '); // prompt input jumlah
    readln(jumlah);
    
    if (jumlah > 0) then
    begin
      TambahBelanja(offset + pilihan, jumlah); // tambahkan ke keranjang
      writeln('Item berhasil ditambahkan!');
    end;
    
    write('Ingin membeli yang lain? (y/n): ');
    readln(lanjut);
    lanjut := UpCase(lanjut);
  until (lanjut <> 'Y');
end;

procedure TampilkanStruk;
var
  i: integer;
  total: real;
begin
  clrscr;
  writeln('========================================');
  writeln('           STRUK PEMBELIAN');
  writeln('========================================');
  writeln; // baris kosong
  
  total := 0;
  for i := 1 to jumlahBelanja do
  begin
    writeln(itemDalamMenu[keranjangOrder[i].index].nama); 
    writeln('  ', keranjangOrder[i].jumlah, ' x Rp ', itemDalamMenu[keranjangOrder[i].index].harga:0:0,
            ' = Rp ', (keranjangOrder[i].jumlah * itemDalamMenu[keranjangOrder[i].index].harga):0:0);
    total := total + (keranjangOrder[i].jumlah * itemDalamMenu[keranjangOrder[i].index].harga);
  end;
  
  writeln;
  writeln('----------------------------------------');
  writeln('TOTAL: Rp ', total:0:0);
  writeln('========================================');
  writeln;
  writeln('Terima kasih atas kunjungan Anda!');
  readln;
end;

var
  katalog: integer; // variabel untuk menyimpan pilihan katalog
  selesai: boolean; // boolen untuk menghentikan repeat until

begin
  InisialisasiMenu;
  jumlahBelanja := 0;
  selesai := false;
  
  repeat
    clrscr;
    writeln('========================================');
    writeln('  What would you like to have today?');
    writeln('========================================');
    writeln;
    writeln('1. Kopi');
    writeln('2. Non-Kopi');
    writeln('3. Snack');
    writeln('4. Selesai dan bayar');
    writeln('0. Batalkan pesanan');
    writeln;
    write('Silahkan pilih katalog: ');
    readln(katalog);
    
    case (katalog) of
      1..3: ProsesKategori(katalog);
      4: begin
          if (jumlahBelanja > 0) then // cek apakah ada item di keranjang
          begin
            TampilkanStruk;
            selesai := true;
          end
        else
          begin
            writeln('Keranjang kamu kosong!');
            readln;
          end;
        end;
      0: begin
          writeln('Pesanan dibatalkan.');
          selesai := true;
        end;
    else
      writeln('Katalog tidak tersedia!');
      readln;
    end;
  until (selesai);
end.
