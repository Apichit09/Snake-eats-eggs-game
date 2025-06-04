# Snake Game (Processing)

นี่คือเกม Snake พัฒนาด้วย Processing (Java mode) – control the snake to eat eggs, avoid obstacles และเก็บคะแนน

## Features
- Grid ขนาด 30×30 cells (600×600 px)
- Obstacles สุ่ม spawn 15 จุด
- 4 Egg types:
  - Normal (สีส้ม) – snake grows +1
  - Bonus (สีน้ำเงิน) – snake grows +2
  - Speed (สีม่วง) – frameRate ×2 for 100 frames
  - Immortal (สีฟ้า) – no self-collision death
- Particle effects เมื่อ eat egg
- Dynamic speed based on score
- Restart game with ENTER

## How to Run
1. ติดตั้ง [Processing 3+](https://processing.org/download/)  
2. เปิดไฟล์ [sketch_250509b.pde](sketch_250509b.pde) ใน Processing IDE  
3. กด **Run** (Ctrl+R) เพื่อเริ่มเกม

## Controls
- Arrow keys `↑ ↓ ← →` – change direction  
- `ENTER` – restart เมื่อ Game Over  

## File Structure
- [sketch_250509b.pde](sketch_250509b.pde) — main sketch code  
- [README.md](README.md) — this documentation