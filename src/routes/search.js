const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();

module.exports = router;

router.get("/", async (req, res) => {
  const searchTerm = req.query.q;

  const itemResult = await db.query(
    "SELECT * FROM item_search WHERE name ILIKE '%' || $1 || '%'",
    [searchTerm]
  );
  const itemResultHeading = await db.query(
    "SELECT * FROM item_search WHERE heading ILIKE '%' || $1 || '%'",
    [searchTerm]
  );
  const authorResult = await db.query(
    "SELECT * FROM nonperiodical_item_author WHERE last_name ILIKE '%' || $1 || '%' OR first_name ILIKE '%' || $1 || '%'",
    [searchTerm]
  );

  const results = {
    items: itemResult.rows,
    itemsHeading: itemResultHeading.rows,
    authors: authorResult.rows,
  };
  res.status(200).json(results);
});
