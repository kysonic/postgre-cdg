-- TRANSACTIONS ************************************** --
-- Transfer 50$ from one account to another --

UPDATE accounts SET balance = balance - 50 WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 50 WHERE name = 'Gia';

-- What if server is crashed after first operation ? -- 

INSERT INTO accounts (name, balance) VALUES 
('Alice', 100),
('Gia', 100);

BEGIN;
UPDATE accounts SET balance = balance - 50
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 50
    WHERE name = 'GIA';
-- oops ... forget that and use Wally's account
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 50
    WHERE name = 'Wally';
COMMIT;
