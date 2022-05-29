async function main() {
  const mysql    = require('mysql2/promise');
  const express  = require('express');
  const app      = express();
  const port     = 3000;
  
  // Conntect to mysql database
  const database = await mysql.createConnection({
    host     : process.env.DB_HOST,
    user     : process.env.DB_USER,
    password : process.env.DB_PASSWORD,
    database : process.env.DB_DATABASE
  });
  
  // Close the connection on ctrl+c.
  process.on('SIGINT', close);

  app.set('json spaces', 4)
  
  // Get user route
  app.get('/', getData);

  app.listen(port);
  console.log(`Listening on port ${port}.`);
  
  async function close() {
    await conn.end();
    process.exit(0);
  }

  // Fetch data from database
  async function getData(req, res) {
    const [users] = await database.query(`
      SELECT  u.userID, u.firstName, u.lastName
      FROM    data u`);
    
      res.json(users);
  }
}

main();