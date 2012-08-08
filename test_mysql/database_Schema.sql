USE vleo_test;

DROP TABLE IF exists books_store;

CREATE TABLE books_store (
  id int(10) NOT NULL AUTO_INCREMENT,
  book_id int(10) unsigned NOT NULL, 
  qty int(10) NOT NULL,
  cost decimal (10,2) NOT NULL,
  author_id int(10) unsigned NOT NULL,
  store_id int(10) unsigned NOT NULL,
  KEY (store_id,author_id),
  PRIMARY KEY (id)
);

INSERT INTO books_store (book_id,qty,cost,author_id,store_id) VALUES 
(1,134,10.50,10,100),
(1,345,10.50,10,101),
(2,656,11.50,10,100),
(3,876,11.50,11,100),
(4,432,11.50,11,102);

select sum(qty) from books_store where store_id=100 and author_id=10;
