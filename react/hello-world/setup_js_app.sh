#!/bin/bash

# To build a React "Hello World" application, you can use the modern,
# standard setup using a toolchain like Vite.
#
# Vite is a modern, ultra-fast build tool and development server that is used
# to set up, run, and bundle modern JavaScript applications, including React.
# It has effectively replaced the older, deprecated create-react-app (CRA) tool
# as the community standard for starting a standalone React project.

# React GitHub: https://github.com/react/react

# Hello World with React and JavaScript
MyAppName="hello-world-js-app"

rm -rf "$MyAppName"

echo "Step 1: Initialize Your Project"

# Create a new React application named "$MyAppName"
npm create vite@latest "$MyAppName" -- --template react

# Move into the correct project directory
cd "$MyAppName"

# Install the necessary dependencies
npm install

echo "Step 2: Write the 'Hello World' Code"

# Automatically write the Hello World component into App.jsx
cat << 'EOF' > src/App.jsx

  import React from 'react';

  function App() {
    return (
      <div>
        <h1>Hello, World!</h1>
      </div>
    );
  }

  export default App;

EOF

echo "Step 3: Run the Application"
echo "Starting the local development server..."

# Start the development server
cd "$MyAppName"
npm run dev
