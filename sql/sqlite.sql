CREATE TABLE IF NOT EXISTS member (
    id           INTEGER NOT NULL PRIMARY KEY,
    name         VARCHAR(255),
    access_token VARCHAR(255),
    access_token_secret VARCHAR(255)
);
