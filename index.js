const express = require("express");
const cors = require("cors");
const app = express();
const router = express.Router();
const MongoClient = require("mongodb").MongoClient;
const ObjectId = require("mongodb").ObjectId;
const port = 3000;
const mongo_uri =
  "mongodb+srv://saurabh:test1234@cluster0.zgy6d8u.mongodb.net/?retryWrites=true&w=majority";

app.use(cors());

MongoClient.connect(mongo_uri, { useNewUrlParser: true })
  .then((client) => {
    const db = client.db("sample_analytics");
    const collection = db.collection("customers");
    app.locals.collection = collection;
    // app.listen(port, () => console.info(`REST API running on port ${port}`));
  })
  .catch((error) => console.error(error));

app.get("/", (req, res) => {
  const collection = req.app.locals.collection;
  collection
    .find({})
    .toArray()
    .then((response) => res.status(200).json(response))
    .catch((error) => console.error(error));
});

// app.get("/:id", (req, res) => {
//   const collection = req.app.locals.collection;
//   const id = new ObjectId(req.params._id);
//   collection
//     .findOne({ _id: id })
//     .then((response) => res.status(200).json(response))
//     .catch((error) => console.error(error));
// });

app.listen(port, () => {
  console.log(`REST API running on port ${port}`);
});
