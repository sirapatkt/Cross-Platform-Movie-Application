# Cinema Hub (Flutter Project)

## Overview
Cinema Hub เป็นแอปพลิเคชันสำหรับค้นหาและดูข้อมูลภาพยนตร์ พัฒนาด้วย Flutter (Cross-platform) 

โปรเจกต์นี้เป็น Final Project ของวิชาเรียนในมหาวิทยาลัย โดยมีโจทย์คือการนำโปรเจกต์ต้นแบบ (Existing Project/Open-source) มาศึกษาโครงสร้าง ทำความเข้าใจโค้ด แก้ไขข้อผิดพลาด และดัดแปลงพัฒนาต่อยอด (Modify & Enhance) เพื่อนำเสนอทักษะการเชื่อมต่อ REST API, การจัดการ State และการทำงานกับ Local Storage

ตัวแอปสามารถค้นหาหนัง ดูรายละเอียด สตรีมตัวอย่างผ่าน YouTube ได้โดยตรง และมีฟังก์ชัน Watchlist สำหรับบันทึกหนังเก็บไว้ดูภายหลัง โดยเน้นการออกแบบ UI เป็น Dark Theme เพื่อให้เรียบง่ายและใช้งานสะดวก

## Tech Stack
- **Framework:** Flutter (Dart)
- **API:** TMDB (The Movie Database)
- **Local Storage:** shared_preferences 
- **Key Packages:** youtube_player_iframe (สำหรับฝังวิดีโอ), cached_network_image (สำหรับโหลดและแคชรูปภาพ), http (สำหรับจัดการ API)

## Features
- **Trending & Search:** หน้าแรกแสดงรายชื่อหนังฮิต และมีระบบค้นหาหนังจากชื่อ
- **Watch Trailer:** สามารถกดดูตัวอย่างหนังจาก YouTube ได้จากภายในแอป
- **Watchlist:** กดเซฟหนังที่สนใจเก็บไว้ในเครื่องได้ (ข้อมูลยังอยู่แม้ปิดแอป)
- **UI Design:** รองรับการแสดงผลโหมดมืด (Dark Theme)

## Screenshots
<img width="1918" height="906" alt="image" src="https://github.com/user-attachments/assets/f234fd4a-6850-419b-835c-dcb6d0d828d9" />
<img width="1918" height="906" alt="image" src="https://github.com/user-attachments/assets/99632301-3cab-4599-8bd5-ed4c0a809113" />
<img width="1918" height="906" alt="image" src="https://github.com/user-attachments/assets/75634e27-1f47-4d35-9f71-98455601e9ee" />
