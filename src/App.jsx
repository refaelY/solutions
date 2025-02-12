import React, { useState, useRef, useEffect } from "react";
import { Stage, Layer, Rect, Text, Group } from "react-konva";
import categoriesData from "./קטגוריות/categories.json";
import "./App.css"

export default function RaftechSingleFile() {
  // מצבי קטגוריה / עצים / עריכת אובייקטים / שכבות
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [stageSize, setStageSize] = useState({ width: window.innerWidth, height: window.innerHeight });
  const [categories, setCategories] = useState({});
  const [objects, setObjects] = useState([]);
  const [mode, setMode] = useState("view");  // תצוגה, מהות, עיצוב, פעולה
  const [selectedObject, setSelectedObject] = useState(null);

  // עץ קבצים
  const [fileTree, setFileTree] = useState([]);
  const [fileContent, setFileContent] = useState("");

  const stageRef = useRef(null);

  // -- useEffect ראשוני
  useEffect(() => {
    setCategories(categoriesData.categories);
    loadFileTree(); // טעינת עץ הקבצים
  }, []);

  // -- מאזין גודל חלון
  useEffect(() => {
    const handleResize = () => {
      setStageSize({ width: window.innerWidth, height: window.innerHeight });
    };
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  // -- פונקציה לזום עם גלגל העכבר
  const handleWheel = (e) => {
    e.evt.preventDefault();
    const scaleBy = 1.1;
    const stage = stageRef.current;
    if (!stage) return;

    const oldScale = stage.scaleX();
    const pointer = stage.getPointerPosition();
    const mousePointTo = {
      x: (pointer.x - stage.x()) / oldScale,
      y: (pointer.y - stage.y()) / oldScale,
    };
    const newScale = e.evt.deltaY > 0 ? oldScale / scaleBy : oldScale * scaleBy;

    stage.scale({ x: newScale, y: newScale });
    stage.position({
      x: pointer.x - mousePointTo.x * newScale,
      y: pointer.y - mousePointTo.y * newScale,
    });
    stage.batchDraw();
  };

  // -- טעינת עץ הקבצים מהשרת
  const loadFileTree = async () => {
    try {
      const response = await fetch("/file-tree");
      if (!response.ok) {
        throw new Error("Failed to fetch file tree");
      }
      const tree = await response.json();
      setFileTree(tree);
    } catch (error) {
      console.error("Error loading file tree:", error);
    }
  };

  // -- טעינת תוכן קובץ
  const loadFileContent = async (path) => {
    try {
      const response = await fetch(`/file-content?path=${encodeURIComponent(path)}`);
      if (!response.ok) {
        throw new Error("Failed to fetch file content");
      }
      const content = await response.text();
      setFileContent(content);
    } catch (error) {
      console.error("Error loading file content:", error);
    }
  };

  // -- רינדור רקורסיבי של עץ הקבצים
  const renderFileTree = (tree) => {
    return tree.map((item, index) => (
      <li
        key={index}
        style={{ cursor: "pointer" }}
        onClick={() => {
          if (item.type === "file") {
            loadFileContent(item.path);
          }
        }}
      >
        {item.type === "directory" ? `📁 ${item.name}` : `📄 ${item.name}`}
        {item.children && <ul>{renderFileTree(item.children)}</ul>}
      </li>
    ));
  };

  // -- הוספת אובייקט חדש למרחב העבודה
  const addObjectToWorkspace = (element) => {
    const newObject = {
      id: objects.length + 1,
      name: element.name,
      type: element.type || "default",
      x: 100 + objects.length * 20,
      y: 100 + objects.length * 20,
      width: 50,
      height: 50,
      color: "#3498db",
      action: element.action,
    };
    setObjects([...objects, newObject]);
  };

  // -- עדכון אובייקט
  const updateObject = (key, value) => {
    if (!selectedObject) return;
    setObjects(
      objects.map((obj) =>
        obj.id === selectedObject.id ? { ...obj, [key]: value } : obj
      )
    );
  };

  // -- רינדור
  return (
    <div>

      {/* כאן מתחיל הקוד ה-HTML/JSX שלך */}
      <div className="app-container">
        <header>
          <div className="user-profile">ר</div>
          <div className="header-center">
            <div className="software-name">רפטק - פתרונות עבודה</div>
            <nav className="main-menu">
              <ul>
                <li><a href="#">פרויקטים</a></li>
                <li><a href="#">שרת</a></li>
                <li><a href="#">ייבוא/ייצוא</a></li>
                <li><a href="#">תיעוד ועזרה</a></li>
                <li><a href="#">יציאה</a></li>
              </ul>
            </nav>
          </div>
          <div className="logo">
            <img src="src/images/logo.png" alt="לוגו" />
          </div>
        </header>

        <div id="workspace-container">
          {/* עמודת קטגוריות */}
          <aside id="sidebar" className={selectedCategory ? "expanded" : "collapsed"}>
            <button id="toggle-sidebar">⇔</button>
            <h3>קטגוריות</h3>
            <div className="categories-list">
              {Object.entries(categories).map(([category, items], index) => (
                <div key={index} className="category-container">
                  <img
                    src={`./src/קטגוריות/${category}/${category}.png`}
                    alt={category}
                    className="category-icon"
                    onClick={() => setSelectedCategory(selectedCategory === category ? null : category)}
                  />
                  <h5>{category}</h5>
                  {selectedCategory === category && (
                    <div className="elements-list">
                      {items.map((element, idx) => (
                        <div key={idx} className="element-item" onClick={() => addObjectToWorkspace(element)}>
                          <img src={element.image} alt={element.name} className="element-icon" />
                          <span>{element.name}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </aside>

          {/* עמודת שכבות */}
          <div id="layers-panel">
            <h3>שכבות</h3>
            <div className="layer-buttons">
              <button onClick={() => setMode("view")}>תצוגה</button>
              <button onClick={() => setMode("essence")}>מהות</button>
              <button onClick={() => setMode("design")}>עיצוב</button>
              <button onClick={() => setMode("action")}>פעולה</button>
            </div>
          </div>

          {/* פאנל עריכת האובייקט */}
          <div id="object-editor-panel">
            {selectedObject && (
              <div className="object-editor">
                <h3>עריכת אובייקט</h3>
                <label>
                  שם:
                  <input
                    type="text"
                    value={selectedObject.name}
                    onChange={(e) => updateObject("name", e.target.value)}
                  />
                </label>
                <label>
                  רוחב:
                  <input
                    type="number"
                    value={selectedObject.width}
                    onChange={(e) => updateObject("width", Number(e.target.value))}
                  />
                </label>
                <label>
                  גובה:
                  <input
                    type="number"
                    value={selectedObject.height}
                    onChange={(e) => updateObject("height", Number(e.target.value))}
                  />
                </label>
                <label>
                  צבע:
                  <input
                    type="color"
                    value={selectedObject.color}
                    onChange={(e) => updateObject("color", e.target.value)}
                  />
                </label>
              </div>
            )}
          </div>

          {/* פאנל תחתון לניהול קבצים */}
          <div id="resizable-panel">
            <div id="file-tree-container">
              <div id="file-tree">
                <ul id="file-tree-root">
                  {renderFileTree(fileTree)}
                </ul>
              </div>
              <div id="file-tree-buttons">
                <button id="add-file-button" title="הוספת קובץ">➕</button>
                <button id="delete-file-button" title="מחיקת קובץ">🗑</button>
                <button id="refresh-file-button" title="רענון">🔄</button>
                <button id="text-direction-button" title="שנה כיוון טקסט">⇆</button>
                <button id="save-button" title="שמור קובץ">💾</button>
                <button id="reset-button" title="חזור על הפעולה">↩</button>
              </div>
            </div>
            <div id="file-view">
              <textarea
                id="file-content"
                placeholder="בחר קובץ לעריכה..."
                value={fileContent}
                readOnly
              />
              <img id="file-image" alt="תמונה" />
            </div>
          </div>

          <button id="toggle-button" className="floating-button">▲</button>

          {/* איזור הקנבס - מרחב העבודה */}
          <Stage
            width={stageSize.width}
            height={stageSize.height}
            onWheel={handleWheel}
            ref={stageRef}
            draggable
          >
            <Layer>
              {objects.map((obj) => (
                <Group
                  key={obj.id}
                  draggable
                  onClick={() => setSelectedObject(obj)}
                >
                  <Rect
                    x={obj.x}
                    y={obj.y}
                    width={obj.width}
                    height={obj.height}
                    fill={obj.color}
                    stroke="black"
                    strokeWidth={2}
                  />

                  {/* מצבי תצוגה בהתאם ל-mode */}
                  {mode === "essence" && (
                    <Text
                      text={obj.type}
                      x={obj.x}
                      y={obj.y - 15}
                      fontSize={12}
                      fill="black"
                    />
                  )}

                  {mode === "design" && (
                    <Text
                      text={`W:${obj.width} H:${obj.height}`}
                      x={obj.x}
                      y={obj.y + obj.height + 5}
                      fontSize={12}
                      fill="black"
                    />
                  )}

                  {mode === "action" && (
                    <Text
                      text={`Action: ${obj.action}`}
                      x={obj.x}
                      y={obj.y + obj.height + 5}
                      fontSize={12}
                      fill="red"
                    />
                  )}

                  {/* במצב view רק רואים את האובייקט עצמו, ואין טקסט מיוחד */}
                  {/* נציג בכל המקרים את שם האובייקט מעליו */}
                  {mode === "view" && (
                    <Text
                      text={obj.name}
                      x={obj.x}
                      y={obj.y - 15}
                      fontSize={12}
                      fill="black"
                    />
                  )}
                </Group>
              ))}
            </Layer>
          </Stage>
        </div>
      </div>
    </div>
  );
}
