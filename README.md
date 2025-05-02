# platform-selector

## Overview

Platform Selector is a versatile JavaScript-based project designed to integrate your current program with APIs for logging and monitoring. It supports multiple platforms such as Telegram, WhatsApp, and Discord. The project provides both a frontend user interface and a backend server to facilitate real-time command execution and data visualization.

### Running the Setup Script (Optional) - My setup is for streaming US equities live data. The .sh will give you an empty space, with a working API and frontend to integrate into your own project. 


## Features

- **Multi-Platform API Integration**: Supports Telegram, WhatsApp, and Discord.
- **Real-time Logging**: Displays logs and stock trend data in real-time using WebSockets.
- **Frontend Interface**: A React-based frontend for user interaction.
- **Backend Server**: An Express.js server handling API requests and WebSocket communication.

## Project Structure

```plaintext
platform-selector/
├── platform-selector-frontend/   # React-based frontend application
│   ├── public/                   # Static files and public assets
│   ├── src/                      # Source code for React app
│   └── README.md                 # Frontend-specific instructions
├── platform-selector-backend/    # Node.js backend application
│   └── server.js                 # Main backend server code
├── setup_project.sh              # Script to set up and configure the project
└── README.md                     # Main project documentation
```

## Setup Instructions

### Prerequisites

Ensure you have the following installed on your system:

- **Node.js** (v14 or newer)
- **npm** (v6 or newer)

### Backend Setup

1. Navigate to the `platform-selector-backend` directory:
   ```bash
   cd platform-selector-backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the backend server:
   ```bash
   node server.js
   ```
   The backend will be available at `http://localhost:3000`.

### Frontend Setup

1. Navigate to the `platform-selector-frontend` directory:
   ```bash
   cd platform-selector-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the frontend application:
   ```bash
   npm start
   ```
   The frontend will be accessible at `http://localhost:3000`.

### Running the Setup Script (Optional) - My setup is for streaming US equities live data. The .sh will give you an empty space, with a working API and frontend to integrate into your own project. 

You can use the provided `setup_project.sh` script to automate the setup process. Run the script in the root directory:
```bash
bash setup_project.sh
```

## Usage Instructions

### Sending Commands

The backend server exposes an API endpoint to send commands to the supported platforms:

- **Endpoint**: `/api/command`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "platform": "telegram",
    "ticker": "AAPL"
  }
  ```
- **Response**:
  ```json
  {
    "message": "Command sent to telegram for ticker: AAPL"
  }
  ```

### Viewing Logs and Stock Trends

The frontend provides a dashboard to view real-time logs and stock trend data. You can open the frontend in a browser and interact with the interface to monitor activities.

## Contributing

1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes and push them to your fork:
   ```bash
   git commit -m "Description of changes"
   git push origin feature-name
   ```
4. Create a pull request.

## License

This project is licensed under the MIT License. See `LICENSE` for more details.

---

If you need additional sections or modifications, let me know!
