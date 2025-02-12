// server.js
import express from "express";
import fs from "fs";
import path from "path";

const app = express();
const PORT = 3001; // אפשר לשנות לאיזה פורט שתרצה

// מגדירים נתיב בסיסי שבו נמצא כל הקבצים
const BASE_DIR = path.join(process.cwd(), "myFiles"); 
// לדוגמה, myFiles הוא שם תיקייה שבה נמצאים הקבצים שלך

app.use(express.json());

// פונקציה לבניית עץ קבצים באופן רקורסיבי
function buildFileTree(dirPath) {
  let entries = fs.readdirSync(dirPath, { withFileTypes: true });
  let result = [];

  for (let entry of entries) {
    const fullPath = path.join(dirPath, entry.name);

    if (entry.isDirectory()) {
      result.push({
        type: "directory",
        name: entry.name,
        // מפעילים את אותה פונקציה רקורסיבית על התיקייה
        children: buildFileTree(fullPath),
      });
    } else {
      result.push({
        type: "file",
        name: entry.name,
        // לצורך ה-client, נרצה לשמור את המסלול המלא
        // כדי שקריאה ל-/file-content תוכל להחזיר את תוכן הקובץ
        path: fullPath,
      });
    }
  }
  return result;
}

// ראוט שמחזיר את עץ הקבצים
app.get("/file-tree", (req, res) => {
  try {
    const tree = buildFileTree(BASE_DIR);
    res.json(tree);
  } catch (error) {
    console.error("Error reading file tree:", error);
    res.status(500).json({ error: "Failed to build file tree" });
  }
});

// ראוט שמחזיר את תוכן הקובץ הספציפי
app.get("/file-content", (req, res) => {
  const filePath = req.query.path;
  if (!filePath) {
    return res.status(400).json({ error: "Missing 'path' query parameter" });
  }
  try {
    // קוראים את תוכן הקובץ
    const content = fs.readFileSync(filePath, "utf8");
    res.send(content);
  } catch (error) {
    console.error("Error reading file content:", error);
    res.status(500).json({ error: "Failed to read file content" });
  }
});

// מפעילים את השרת
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
