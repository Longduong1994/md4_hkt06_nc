create database quanlytruonghoc;
use quanlytruonghoc;

create table dmkhoa(
makhoa varchar(20) primary key,
tenkhoa varchar(255) 
);

create table dmnganh(
manganh int primary key,
tennganh varchar(255),
makhoa varchar(20),
foreign key (makhoa) references dmkhoa(makhoa)
);

create table dmlop(
malop  varchar(20) primary key,
tenlop varchar(255),
manganh int,
khoahoc int,
hedt varchar(255),
namnhaphoc int,
foreign key(manganh) references dmnganh(manganh)
);

create table dmhocphan(
mahp int primary key,
tenhp varchar(255),
sodvht int ,
manganh int, 
hocky int,
foreign key(manganh) references dmnganh(manganh)
);
create table sinhvien(
masv int primary key,
hoten varchar(255),
malop varchar(20),
gioitinh tinyint(1),
ngaysinh date,
diachi varchar(255),
foreign key (malop) references dmlop(malop)
);

create table diemhp(
masv int,
mahp int,
diemhp float,
foreign key (masv) references sinhvien(masv),
foreign key (mahp) references dmhocphan(mahp)
);

insert into dmkhoa(makhoa,tenkhoa) values
("CNTT","Công Nghệ Thông Tin"),
("KT","Kế Toán"),
("SP","Sư Phạm");

insert into dmnganh(manganh,tennganh,makhoa) values
(140902,"Sư Phạm Toán Tin","SP"),
(480202,"Tin Học Ứng Dụng","CNTT");

insert into dmlop() values
("CT11","Cao Đẳng Tin Học",480202,11,"TC",2013),
("CT12","Cao Đẳng Tin Học",480202,12,"CĐ",2013),
("CT13","Cao Đẳng Tin Học",480202,13,"TC",2014);

insert into dmhocphan() values
(1,"Toán Cao cấp A1",4,480202,1),
(2,"Tiếng Anh 1",3,480202,1),
(3,"Vật Lý Đại Cương",4,480202,1),
(4,"Tiếng Anh 2",7,480202,1),
(5,"Tiếng Anh 1",3,480202,1),
(6,"Xác Suất Thống Kê",3,480202,1);

insert into sinhvien() values
(1,"Phan Thanh","CT12",0,"1990-09-12","Tuy Phước"),
(2,"Nguyến Thị Cẩm","CT12",1,"1994-01-12","Quy Nhơn"),
(3,"Võ Thị Hà","CT12",1,"1995-07-02","An Nhơn"),
(4,"Trần Hoài Nam","CT12",0,"1994-04-05","Tây Sơn"),
(5,"Trần Văn Hoàng","CT13",0,"1995-08-04","Vĩnh Thạnh"),
(6,"Đặng Thị Thảo","CT13",1,"1995-06-12","Quy Nhơn"),
(7,"Lê Thị Sen","CT13",1,"1994-08-12","Phủ Mỹ"),
(8,"Nguyễn Văn Huy","CT11",0,"1995-06-04","Tuy Phước"),
(9,"Trần Thị Hoa","CT11",1,"1994-08-09","Hoài Nhơn");
insert into diemhp() values 
(2,2,5.9),(2,3,4.5),(3,1,4.3),(3,2,6.7),(3,3,7.3),
(4,1,4),(4,2,5.2),(4,3,3.5),(5,1,9.8),(5,2,7.9),
(5,3,7.5),(6,1,6.1),(6,2,5.6),(6,3,4),(7,1,6.2);

-- 1
select sv.masv "Mã SV" ,sv.hoten "Họ Tên" from sinhvien sv left join diemhp d on sv.masv = d.masv
where d.diemhp is null;
 
 -- 2
 select sv.masv "Mã SV" ,sv.hoten "Họ Tên" from sinhvien sv left join diemhp d on sv.masv = d.masv and d.mahp = 1
 where d.masv is null ;
 
 -- 3
 
select hp.mahp "Mã HP", hp.tenhp "Tên HP" from dmhocphan hp left join diemhp d on hp.mahp = d.mahp and d.diemhp<5
where d.masv is null;
-- 4

select sv.masv "Họ Tên", sv.hoten "Họ Tên" from sinhvien sv left join diemhp d on sv.masv = d.masv and d.diemhp <5
where d.masv is null;

-- 5
select l.tenlop "Tên Lớp" from dmlop l join sinhvien sv on  sv.malop = l.malop and sv.hoten like "%Hoa";

-- 6
select sv.hoten "Họ Tên" from sinhvien sv join diemhp d on sv.masv = d.masv and d.mahp = 1
where d.diemhp <5;
-- 7

select hp.mahp "Mã HP", hp.tenhp "Tên HP", hp.sodvht "Số DVHT", hp.manganh "Mã Ngành", hp.hocky "Học Kỳ"
from dmhocphan hp 
where sodvht >= (select sodvht from dmhocphan where mahp = 1);  

-- 8
select sv.masv "Mã SV", sv.hoten "Họ Tên", d.mahp "Mã HP", d.diemhp "Điểm HP"
from sinhvien sv
join diemhp d on sv.masv = d.masv
where d.diemhp = (
    select MAX(diemhp) from diemhp
);
-- 9
select sv.masv "Mã SV", sv.hoten "Họ Tên"
from sinhvien sv
join diemhp d on sv.masv = d.masv where d.mahp = 1
and d.diemhp >= all (
    select diemhp from diemhp where mahp = 1
);
-- 10
select d.masv "Mã SV", d.mahp "Mã HP" from diemhp d
where d.diemhp > any (
    select diemhp from diemhp  where masv = 3
);

-- 11
select sv.masv "Mã SV", sv.hoten "Tên SV"
from sinhvien sv
where exists ( select 1 from diemhp d where sv.masv = d.masv);

-- 12
select sv.masv as "Mã SV", sv.hoten as "Tên SV"
from sinhvien sv
where not exists (select 1 from diemhp d where sv.masv = d.masv);

-- 13
select masv as "Mã SV" from diemhp where mahp = 1
UNION
select masv from diemhp where mahp = 2;

-- 14
delimiter //
create procedure KIEM_TRA_LOP (Malop_input varchar(20))
begin
 declare lop_count int;
    select count(*) into lop_count from dmlop
    where MaLop = Malop_input;
    if lop_count = 0 then
        select 'Lớp này không có trong danh mục' as Message;
    else
        select sv.HoTen from sinhvien sv
        join diemhp hp on sv.MaSV = hp.MaSV
        where sv.MaLop = Malop_input and hp.DiemHP < 5;
    end if;
end;
// delimiter ;
call KIEM_TRA_LOP('CT12');

-- 15
delimiter //
create trigger check_masv_not_empty
before insert on sinhvien
for each row 
begin
    if new.masv is null or new.masv = '' then
        signal sqlstate '45000'
        set message_text = 'Mã sinh viên phải được nhập';
    end if ;
end;
// delimiter ;

-- 16

alter table dmlop add column SiSo int not null default 0;

delimiter //
create trigger check_add 
after insert on sinhvien for each row
begin 
declare count int;
 select count(*) into count from dmlop 
 where malop = new.malop;
if count = 1 then update dmlop set SiSo = SiSo + 1 where malop = new.malop ;
    end if;
end;
// delimiter ;

-- 17
    
delimiter //

create function doc_diem(diemhp float) returns varchar(255) deterministic
begin
    declare docdiem varchar(255);
    declare integer_part int;
    declare decimal_part int;

    set integer_part = floor(diemhp);
    set decimal_part = round((diemhp - integer_part) * 10);

    set docdiem =
        case
            when integer_part = 10 then 'mười'
            else case integer_part
                when 9 then 'chín'
                when 8 then 'tám'
                when 7 then 'bảy'
                when 6 then 'sáu'
                when 5 then 'năm'
                when 4 then 'bốn'
                when 3 then 'ba'
                when 2 then 'hai'
                when 1 then 'một'
                else ''
            end
        end;

    if integer_part >= 0 and integer_part <= 10 then
        set docdiem = concat(docdiem, ' phẩy ');                
        if decimal_part = 0 then
            set docdiem = concat(docdiem, 'không');
        else
            set docdiem =
                case decimal_part
                    when 9 then concat(docdiem, 'chín')
                    when 8 then concat(docdiem, 'tám')
                    when 7 then concat(docdiem, 'bảy')
                    when 6 then concat(docdiem, 'sáu')
                    when 5 then concat(docdiem, 'lăm')
                    when 4 then concat(docdiem, 'bốn')
                    when 3 then concat(docdiem, 'ba')
                    when 2 then concat(docdiem, 'hai')
                    when 1 then concat(docdiem, 'một')
                    else ''
                end;
        end if;
    end if;

    return docdiem;
end;
//

delimiter ;

select
    sv.masv as "Mã SV",sv.hoten as "Tên SV",d.mahp as "Mã HP",d.diemhp as "Điểm HP",doc_diem(d.diemhp) as "Điểm Chữ"
from sinhvien sv join diemhp d on sv.masv = d.masv;
-- 18

delimiter //
create procedure HIEN_THI_DIEM(input float)
begin
 declare count int;
 select count(*) into count from sinhvien sv 
 join diemhp dhp on dhp.masv = sv.masv 
 where dhp.DiemHp < input ;
    if count > 0 then
        select sv.MaSV, sv.HoTen, sv.MaLop, dhp.DiemHP, dhp.MaHP
        from sinhvien sv
        join diemhp dhp on dhp.MaSV = sv.MaSV
        where dhp.DiemHP < input;
    else
        select 'Không có sinh viên nào có điểm HP nhỏ hơn ', input as DiemHP;
   end if;
end;
// delimiter  ;
call HIEN_THI_DIEM(5);

-- 19
delimiter //

create procedure HIEN_THI_MAHP(in mahp int)
begin
    if not exists (select 1 from dmhocphan where dmhocphan.mahp = mahp) then
        select 'Không có học phần này' as message;
    else select 
            sinhvien.hoten
        from 
            sinhvien
        where 
            sinhvien.masv not in 
                (select diemhp.masv from diemhp where diemhp.mahp = mahp);
    end if;
end //

delimiter ;

call HIEN_THI_MAHP(1);

-- 20
delimiter //

create procedure hien_thi_tuoi(in min_tuoi int, in max_tuoi int)
begin
    declare tuoi_min date;
    declare tuoi_max date;
    
    set tuoi_min = curdate() - interval max_tuoi year;
    set tuoi_max = curdate() - interval min_tuoi year;

    -- Hiển thị danh sách sinh viên trong khoảng tuổi chỉ định
    select 
        sv.masv,
        sv.hoten,
        sv.malop,
        sv.ngaysinh,
        sv.gioitinh,
        year(curdate()) - year(sv.ngaysinh) as tuoi
    from 
        sinhvien sv
    where 
        sv.ngaysinh between tuoi_min and tuoi_max;
    if not exists (select 1 from sinhvien where ngaysinh between tuoi_min and tuoi_max) then
        select 'Không có sinh viên nào trong khoảng tuổi chỉ định' as message;
    end if;
end;
//

delimiter ;
call hien_thi_tuoi(25, 35);






