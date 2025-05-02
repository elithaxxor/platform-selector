#!/bin/bash

# Exit on any error
set -e

# Project names
BACKEND_DIR="platform-selector-backend"
FRONTEND_DIR="platform-selector-frontend"
ZIP_NAME="platform-selector-codebase.zip"

echo "Setting up the Platform Selector project..."

# Create backend directory
echo "Creating backend..."
mkdir $BACKEND_DIR
cd $BACKEND_DIR

# Initialize Node.js project
npm init -y

# Install required packages
npm install express cors socket.io

# Create server.js file
cat > server.js <<EOL
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
  const log = \`Command sent to \${platform} for ticker: \${ticker}\`;
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
EOL

# Go back to the root directory
cd ..

# Create frontend directory
echo "Creating frontend..."
npx create-react-app $FRONTEND_DIR

# Navigate to frontend directory
cd $FRONTEND_DIR

# Install required libraries
npm install socket.io-client recharts
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# Update Tailwind configuration
cat > tailwind.config.js <<EOL
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  darkMode: "class",
  theme: {
    extend: {},
  },
  plugins: [],
};
EOL

# Add Tailwind imports to index.css
cat > src/index.css <<EOL
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

# Create React components
mkdir src/components
cat > src/components/Header.js <<EOL
import React from "react";

function Header() {
  return (
    <h1 className="text-3xl font-bold text-center text-gray-900 mb-8 dark:text-gray-100">
      Platform Selector Dashboard
    </h1>
  );
}

export default Header;
EOL

cat > src/components/DarkModeToggle.js <<EOL
import React from "react";

function DarkModeToggle({ darkMode, setDarkMode }) {
  return (
    <div className="flex justify-end mb-6">
      <button
        onClick={() => setDarkMode(!darkMode)}
        className="px-4 py-2 bg-gray-300 dark:bg-gray-700 text-gray-800 dark:text-gray-100 rounded-lg"
      >
        {darkMode ? "Light Mode" : "Dark Mode"}
      </button>
    </div>
  );
}

export default DarkModeToggle;
EOL

cat > src/components/PlatformSelector.js <<EOL
import React from "react";

function PlatformSelector({ platform, setPlatform }) {
  return (
    <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md mb-6">
      <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
        Select a Platform
      </h2>
      <select
        value={platform}
        onChange={(e) => setPlatform(e.target.value)}
        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring focus:ring-blue-300"
      >
        <option value="telegram">Telegram</option>
        <option value="whatsapp">WhatsApp</option>
        <option value="discord">Discord</option>
      </select>
    </div>
  );
}

export default PlatformSelector;
EOL

cat > src/components/StockInput.js <<EOL
import React from "react";

function StockInput({ ticker, setTicker }) {
  return (
    <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md mb-6">
      <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
        Enter a Stock Ticker
      </h2>
      <input
        type="text"
        value={ticker}
        onChange={(e) => setTicker(e.target.value)}
        placeholder="Enter stock ticker (e.g., AAPL)"
        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring focus:ring-blue-300"
      />
    </div>
  );
}

export default StockInput;
EOL

cat > src/components/LogsDisplay.js <<EOL
import React from "react";

function LogsDisplay({ logs }) {
  return (
    <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
      <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
        Logs
      </h2>
      {logs.length === 0 && (
        <p className="text-gray-500 dark:text-gray-400">No logs available.</p>
      )}
      <ul className="space-y-4">
        {logs.map((log, index) => (
          <li
            key={index}
            className="bg-gray-100 dark:bg-gray-700 p-4 rounded-lg shadow-sm border border-gray-200 dark:border-gray-600"
          >
            <p>{log.log}</p>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">
              {new Date(log.timestamp).toLocaleString()}
            </p>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default LogsDisplay;
EOL

cat > src/components/StockChart.js <<EOL
import React from "react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from "recharts";

function StockChart({ data }) {
  return (
    <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md mb-6">
      <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
        Stock Trends
      </h2>
      <LineChart
        width={500}
        height={300}
        data={data}
        margin={{ top: 5, right: 20, left: 10, bottom: 5 }}
      >
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="time" />
        <YAxis />
        <Tooltip />
        <Line type="monotone" dataKey="price" stroke="#8884d8" />
      </LineChart>
    </div>
  );
}

export default StockChart;
EOL

# Go back to the root directory
cd ..

# Zip the project
echo "Zipping the project..."
zip -r $ZIP_NAME $BACKEND_DIR $FRONTEND_DIR

echo "Project setup is complete. ZIP file created: $ZIP_NAME"