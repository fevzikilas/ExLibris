const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
module.exports = router;
const { authMiddleware } = require("../Middleware/security/authMiddlware");

// Get list items
router.get("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  const { rows } = await db.query(
    "SELECT user_id FROM list WHERE list_id = $1",
    [id]
  );

  if (rows.length === 0) {
    res.status(400).json({ message: "The list does not exist." });
  } else if (rows[0].user_id === user_id || req.tokenPayload.admin) {
    const { rows } = await db.query(
      "SELECT list_name, name, rate, publication_date FROM user_to_see_list WHERE list_id = $1",
      [id]
    );
    res.status(200).json(rows);
  } else {
    res.status(400).json({ message: "The list does not belong to this user." });
  }
});

// Delete list
router.delete("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    const { rows } = await db.query(
      "SELECT user_id FROM list WHERE list_id = $1",
      [id]
    );
    if (rows.length === 0) {
      res.status(400).json({ message: "The list does not exist." });
    } else if (rows[0].user_id === user_id || req.tokenPayload.admin) {
      await db.query(
        "DELETE FROM list WHERE list_id = $1",
        [id],
        user_id,
        false
      );
      res.status(200).json("The list was deleted successfully.");
    } else {
      res
        .status(400)
        .json({ message: "The list does not belong to this user." });
    }
  } catch {
    (err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: "An error occurred while deleting the list." });
    };
  }
});

// Update list name
router.patch("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { new_name } = req.body;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    const { rows } = await db.query(
      "SELECT user_id FROM list WHERE list_id = $1",
      [id]
    );
    if (rows.length === 0) {
      res.status(400).json({ message: "The list does not exist." });
    } else if (rows[0].user_id === user_id || req.tokenPayload.admin) {
      await db.query(
        "UPDATE list SET list_name = $1::VARCHAR WHERE list_id = $2::INTEGER",
        [new_name, id],
        user_id,
        false
      );
      res.status(200).json("The list name was updated successfully.");
    } else {
      res
        .status(400)
        .json({ message: "The list does not belong to this user." });
    }
  } catch {
    (err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: "An error occurred while updating the list name." });
    };
  }
});

// Add item to list
router.post("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { item_id } = req.body;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    const { rows } = await db.query(
      "SELECT COUNT(*) FROM item_list WHERE list_id = $1 AND item_id = $2",
      [id, item_id]
    );
    if (rows[0].count > 0) {
      res.status(409).json("The item is already in the list.");
    } else {
      const { rows } = await db.query(
        "SELECT user_id FROM list WHERE list_id = $1",
        [id]
      );
      if (rows.length === 0) {
        res.status(400).json({ message: "The list does not exist." });
      } else if (rows[0].user_id === user_id || req.tokenPayload.admin) {
        await db.query(
          "INSERT INTO item_list (list_id, item_id) VALUES ($1, $2)",
          [id, item_id],
          user_id,
          false
        );
        res.status(200).json("The item was added to the list successfully.");
      } else {
        res
          .status(400)
          .json({ message: "The list does not belong to this user." });
      }
    }
  } catch {
    (err) => {
      console.log(err);
      res.status(500).json({
        error: "An error occurred while adding the item to the list.",
      });
    };
  }
});

// Delete item from list
router.delete("/:id/items", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { item_id } = req.body;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    const { rows } = await db.query(
      "SELECT user_id FROM list WHERE list_id = $1",
      [id]
    );
    if (rows.length === 0) {
      res.status(400).json({ message: "The list does not exist." });
    } else if (rows[0].user_id === user_id || req.tokenPayload.admin) {
      await db.query(
        "DELETE FROM item_list WHERE list_id = $1 AND item_id = $2",
        [id, item_id],
        user_id,
        false
      );
      res.status(200).json("The item was deleted from the list successfully.");
    } else {
      res
        .status(400)
        .json({ message: "The list does not belong to this user." });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: "An error occurred while deleting the item from the list",
    });
  }
});
