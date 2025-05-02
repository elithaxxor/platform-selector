const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const cors = require("cors");

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(cors());
app.use(express.json());

let logs = [];
let stockTrend = [];

// Simulate stock trend data
setInterval(() => {
  const price = (Math.random() * 1000 + 100).toFixed(2);
  stockTrend.push({ time: new Date().toLocaleTimeString(), price });
  if (stockTrend.length > 10) stockTrend.shift();
}, 3000);

app.post("/api/command", (req, res) => {
  const { platform, ticker } = req.body;
  const log = `Command sent to ${platform} for ticker: ${ticker}`;
  logs.push({ log, timestamp: new Date().toISOString() });
  io.emit("logs", logs); // Emit logs in real-time
  res.json({ message: log });
});

app.get("/api/data", (req, res) => {
  res.json({ logs });
});

io.on("connection", (socket) => {
  console.log("New client connected");
  socket.emit("logs", logs); // Send initial logs
  socket.emit("stockTrend", stockTrend); // Send stock trend data
  socket.on("disconnect", () => console.log("Client disconnected"));
});

server.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
