async function main() {
  const mysql    = require('mysql2/promise');
  const express  = require('express');
  const app      = express();
  const port     = 3000;
  
  const database = await mysql.createConnection({
    host     : process.env.DB_HOST,
    user     : process.env.DB_USER,
    password : process.env.DB_PASSWORD,
    database : process.env.DB_DATABASE
  });
  
  process.on('SIGINT', close);                                                        // Close the connection on ctrl+c.
  

  app.use('/', (req, res) => {
    const sqlQuery = 'SELECT u.userID, u.firstName, u.lastName FROM data u';

    database.query(sqlQuery, (err, result) => {
      if (err) throw err;
    
      res.json({ 'users': result});
    });
  });
  
  app.listen(port);
  console.log(`Listening on port ${port}.`);
  
  async function close() {
    await conn.end();
    process.exit(0);
  }
}

main();