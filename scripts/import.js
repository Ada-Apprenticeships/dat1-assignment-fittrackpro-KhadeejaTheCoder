const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

const dbFile = path.join(__dirname, '../src/fittrackpro.sqlite');
const sqlFile = path.join(__dirname, 'sample_data.sql');

// Check if the database file exists
if (!fs.existsSync(dbFile)) {
    console.error('Database file does not exist:', dbFile);
    process.exit(1);
}

const db = new sqlite3.Database(dbFile, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
        return;
    }
    console.log('Connected to the fittrackpro database.');
});

fs.readFile(sqlFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading SQL file:', err.message);
        return;
    }

    db.exec(data, (err) => {
        if (err) {
            console.error('Error executing SQL script:', err.message);
        } else {
            console.log('Sample data imported successfully.');
        }
        db.close((err) => {
            if (err) {
                console.error('Error closing the database:', err.message);
            } else {
                console.log('Database connection closed.');
            }
        });
    });
});