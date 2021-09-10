CREATE TABLE "customers"(customer_id serial PRIMARY KEY, 
						 first_name VARCHAR(50), 
						 last_name VARCHAR(50), 
						 username VARCHAR(50)
						 );

INSERT INTO "customers"(customer_id, first_name, last_name, username)
VALUES 
(1, 'Kevin', 'Nguyen', 'Kevin nguyen'),
(2, 'Derek', 'Hawkins', 'Derek Hawkins'),
(3, 'Lucas', 'Lang', 'Lucas Lang'),
(4, 'Bren', 'Joy', 'Bren Joy')
RETURNING *;

-- made a mistake in row customer_id 4 so I updated it
update customers
set last_name = 'Joy'
where customer_id = 4
returning *;

CREATE TABLE "concessions"(concession_id serial PRIMARY KEY, 
						   customer_id integer, 
						   item_name VARCHAR(50), 
						   item_price FLOAT, 
						   CONSTRAINT concessions_customers FOREIGN KEY(customer_id) REFERENCES "customers"(customer_id) 
						   );

INSERT INTO "concessions"(concession_id, customer_id, item_name, item_price)
VALUES
(1, 1, 'Popcorn', 10.00),
(2, 2, 'Icee', 10.00),
(3, 3, 'Raisinets', 10.00),
(4, 4, 'Nachos', 10.00)
RETURNING *;
-- noticed a problem if adding multiple items to one customer because of concession_id being unique 
-- -- because of the serial constraint
-- I'm thinking concession_id can be considered specific to the item_name which can be unique
-- I could solve the problem by maybe adding a item_id col or making a separate table for payments
-- So I would have to make an id that is unique to an item_name, which would only make sense in another table
-- The fix would be to remove the foreign key 'customer_id' 
-- -- and replace it with payment_id in a payment table with item prices and then add the customer_id here as well
-- -- so that there I can relay everything



CREATE TABLE "tickets"(ticket_id serial PRIMARY KEY, 
					   customer_id integer, 
					   ticket_price FLOAT, 
					   CONSTRAINT tickets_customers FOREIGN KEY(customer_id) REFERENCES "customers"(customer_id) 
					   );

INSERT INTO "tickets"(ticket_id, customer_id, ticket_price)
VALUES
(123, 1, 16.00),
(234, 2, 16.00),
(345, 3, 16.00),
(456, 4, 16.00)
RETURNING *;
-- Same problem as in concessions. Same solve

CREATE TABLE "movies"(movie_id serial PRIMARY KEY, 
					  ticket_id integer, 
					  title VARCHAR(50), 
					  rating VARCHAR(50), 
					  description VARCHAR(250),
					  CONSTRAINT movies_tickets FOREIGN KEY(ticket_id) REFERENCES "tickets"(ticket_id)
					  );

INSERT INTO "movies"(movie_id, ticket_id, title, rating, description)
VALUES
(1, 123, 'Jurassic Park', 'PG-13', 'Dinosuars are alive, it gets wild.'),
(2, 234, 'Eternal Sunshine of a Spotless Mind', 'R', 'The original Inception.'),
(3, 345, 'Shutter Island', 'R', 'The only thing thatll be shuttering is your mind.'),
(4, 456, 'The Talented Mr. Ripley', 'R', 'This guy gets lost in the sauce. And when I say sauce I mean his identity.')
RETURNING *; 

select *
from customers
join concessions on customers.customer_id = concessions.customer_id
join tickets on customers.customer_id = tickets.customer_id
join movies on tickets.ticket_id = movies.ticket_id

select *
from concessions;

select *
from tickets;

select *
from movies;
