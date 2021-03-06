create table author
(au_id number(5) primary key,
au_f_name varchar2(20),
au_l_name varchar2(20),
au_dob date,
au_address varchar2(20)
);

insert all
into author values(1,'raj','deshpande','22-jan-15','jpnagar,bang')
into author values(2,'arun','patil','03-mar-15','rrnagar,bang')
into author values(3,'ritesh','deshmukh','28-sep-15','kalyannagar,bang')
into author values(4,'arjun','janya','19-oct-15','jaynagar,bang')
into author values(5,'kiran','sharma','17-nov-15','tnagar,bang');
select * from dual;

create table publisher
(pub_id number(5) primary key,
pub_nm varchar2(20), 
pub_address varchar2(20),
pub_city varchar2(20),
pub_state varchar2(20)
);



insert all
into publisher values(1101,'abc publications','ring road','bangalore','karnataka')
into publisher values(1102,'pqr publications','south end','bangalore','karnataka')
into publisher values(1103,'xyz publications','kr circle','bangalore','karnataka')
into publisher values(1104,'rrr publications','rr road','bangalore','karnataka')
into publisher values(1105,'lmn publications','dk circle','bangalore','karnataka')
into publisher values(1106,'zzz publications','kr puram','bangalore','karnataka');
select * from dual;

create table book
(book_id number(5) primary key,
book_nm varchar2(20),
pub_id number(5) references publisher(pub_id));
);

insert all
into book values(11,'cartoon books',1101)
into book values(12,'story books',1101)
into book values(13,'adventures books',1102)
into book values(14,'novel books',1101)
into book values(15,'thriller books',1103)
into book values(16,'horror books',1102)
select * from dual;


create table book_author
(bk_au_id number(5) primary key,
book_id number(5) references book(book_id),
au_id number(5) references author(au_id)
);

insert all
into book_author values(111,14,1)
into book_author values(222,12,1)
into book_author values(333,11,2)
into book_author values(444,11,3)
into book_author values(555,11,2)
into book_author values(666,14,2);
select * from dual;

--2.	Query to get the number of books by each publisher.
select count(book_id),pub_nm
from book b, publisher p
where b.pub_id=p.pub_id
group by pub_nm;

--3.Write a query which gives book_name, author_name for publisher ?XYZ?
select book_nm,au_f_name || au_l_name
from author a,publisher p,book b,book_author ba
where a.au_id (+)= ba.au_id  and
    b.booK_id =ba.book_id (+)  and
    b.pub_id =p.pub_id  and
    pub_nm LIKE 'xyz%';
    
--4.Which book was written by more than 3 authors?
select book_nm
from  book b, book_author ba
where b.book_id=ba.book_id
group by book_nm
having count(au_id)>=3;

--5. Want to include city and state information of author as well in the model.
--So, modifiy the model and show us the new model what you come up with.


--6.	Display publisher name, pub_city and metro flag of the city.
--If city is CHN or MUM or DEL or CAL then display the flag as ?Y? otherwise ?N?

select pub_nm,pub_city ,case when pub_city in('chn','bangalore','del','cal') then 'Y'
                else 'N'
                END metro_flag
                from publisher;
--7.Display the authors whose age is greater than the author ?RAM KUMAR?
select au_f_name || ' ' ||au_l_name, trunc(months_between(sysdate,au_dob)/12) as age
from author
where trunc(months_between(sysdate,au_dob)/12) >(select trunc(months_between(sysdate,au_dob)/12)
                                            from author
                                            where au_f_name || ' ' ||au_l_name like 'arjun janya');
                                            
--8.display the publisher name, author_name and no of books they wrote.

select p.pub_nm,au_f_name || ' ' ||au_l_name
from(select au_f_name || ' ' ||au_l_name,count(book_id)
            from author a,book_author ba
            where a.au_id=ba.au_id
            group by au_f_name || ' ' ||au_l_name) s ,publisher p,book b
where b.book_id=s.book_id and 
b.pub_id=p.pub_id;

--9.Which author wrote the maximum number of books?
select au_f_name || ' ' ||au_l_name
from author a, book_author ba
where a.au_id=ba.au_id
group by au_f_name || ' ' ||au_l_name
having count(book_id)=(select max(count(book_id))
                        from book_author
                        group by au_id);

--10.	Create a stored procedure which returns book_name, 
--author_full_name by taking publisher name as the input.

create or replace procedure sp_pub (p_pubname varchar)as
v_book_nm  book.book_nm%type;
v_au_nm  author.au_f_name%type;
begin
select book_nm,au_f_name ||' ' ||au_l_name into v_book_nm,v_au_nm
from author a,publisher p,book b,book_author ba
where a.au_id (+)= ba.au_id  and
    b.booK_id =ba.book_id (+)  and
    b.pub_id =p.pub_id and pub_nm like p_pubname;
dbms_output.put_line(v_book_nm || ' ' || v_au_nm);
exception
when no_data_found then
dbms_output.put_line('invalid');
when others then 
dbms_output.put_line(sqlcode||','||sqlerrm);
end;
exec sp_pub('xyz%');

set serveroutput on



