-- Customers account table
CREATE TABLE customers (
	id serial PRIMARY KEY,
	"name" varchar NOT NULL
);


-- Bank account table
CREATE TABLE accounts (
	account_number VARCHAR PRIMARY KEY,
	agency VARCHAR NOT NULL,
	balance INT,
	customer_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES customers(id)
);

CREATE INDEX idx_customer_id ON accounts using btree (customer_id);


-- Transactions table
CREATE TYPE transaction_types AS ENUM('deposit',
	'withdraw',
	'bank_transfer',
	'received_bank_transfer',
	'bank_slip_payment'
);

CREATE TABLE transactions (
	id serial PRIMARY KEY,
	transaction_at TIMESTAMP NOT NULL,
	transaction_type transaction_types NOT NULL,
	transaction_amount INT NOT NULL,
	account_number VARCHAR NOT NULL,
	CONSTRAINT fk_account FOREIGN KEY(account_number) REFERENCES accounts("account_number")
);

CREATE INDEX idx_account_number ON transactions using btree (account_number);
CREATE INDEX idx_transaction_type ON transactions using btree (transaction_type);


-- Selecting bank slip payments
SELECT 
	TO_CHAR(DATE_TRUNC('month', t.transaction_at), 'Month') AS transactions_month,
	SUM(t.transaction_amount) AS total_payments
FROM transactions t
WHERE t.transaction_type = 'bank_slip_payment'
GROUP BY DATE_TRUNC('month', t.transaction_at)
ORDER BY DATE_TRUNC('month', t.transaction_at);
