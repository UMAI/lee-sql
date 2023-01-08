CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	balance DECIMAL NOT NULL DEFAULT 0.0,
	creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	close_date TIMESTAMP,
	status VARCHAR(1),
    account_owner_id INTEGER NOT NULL
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    birth_date DATE,
    ssn_number INTEGER,
    account_id INTEGER,
    CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts(id)
);

ALTER TABLE accounts ADD CONSTRAINT fk_account_owner_id FOREIGN KEY (account_owner_id) REFERENCES customers(id);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    transaction_type VARCHAR(4) NOT NULL,
    ordering_account_id INTEGER NOT NULL,
    beneficiary_account_id INTEGER NOT NULL,
    time_of_transaction TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL,
    CONSTRAINT fk_ordering_account_id FOREIGN KEY (ordering_account_id) REFERENCES accounts(id),
    CONSTRAINT fk_beneficiary_account_id FOREIGN KEY (beneficiary_account_id) REFERENCES accounts(id)
);

CREATE TABLE cards (
    type TEXT,
    cardholder TEXT,
    serial_number VARCHAR(16) NOT NULL,
    expiry_date DATE NOT NULL,
    cvv VARCHAR(3) NOT NULL,
    account_id INTEGER,
    customer_id INTEGER,
    PRIMARY KEY (serial_number, type),
    CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts (id),
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (id)
);

INSERT INTO accounts
VALUES (1, 123.50, 'Jane', 'Doe', 12345678, CURRENT_TIMESTAMP, NULL, 'A');

INSERT INTO accounts (id, balance, owner_first_name, owner_last_name, creation_date, status)
VALUES (2, 40.69, 'John', 'Doe', CURRENT_TIMESTAMP, 'B');

INSERT INTO accounts
VALUES (3, 123456.50, 'Jeffrey', 'Bezos', 65659898, CURRENT_TIMESTAMP, NULL, 'B');

SELECT * FROM accounts;

SELECT id, owner_first_name, balance FROM accounts;

SELECT * FROM accounts
WHERE balance > 100.0
  AND status IN ('A', 'B');
  
UPDATE accounts
SET balance = 246.12
WHERE id = 3;

DROP TABLE accounts;