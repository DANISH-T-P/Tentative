const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*" }
});

io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  socket.on('user_connected', (username) => {
    socket.username = username;
    socket.broadcast.emit('user_joined', username);
  });

  socket.on("chat", (msg) => {
    socket.broadcast.emit("chat", msg);
  });

  socket.on("scroll", (offset) => {
    socket.broadcast.emit("scroll", offset);
  });

  socket.on('typing', (username) => {
    socket.broadcast.emit('typing', username);
  });

  socket.on('stop_typing', (username) => {
    socket.broadcast.emit('stop_typing', username);
  });

  socket.on('broadcast', (msg) => {
    io.emit('broadcast', msg);
  });


  socket.on("disconnect", () => {
    socket.broadcast.emit("disconnect", socket.id);
    console.log("User disconnected:", socket.id);
  });
});

server.listen(3000, () => {
  console.log("Socket.IO server running on http://localhost:3000");
});
