# MobileAppDevProject
# SimpleSocial

Team members: Nishan narain, Sebastian Rodriguez,and Sabrina Valdivia

SimpleSocial is a basic social media application that allows users to create accounts, log in, and share posts with captions. Users can view a feed of posts and interact with content in a clean and simple interface.

---

## Table of Contents
1. Overview  
2. App Evaluation  
3. Product Spec  
   - User Stories  
   - Screen Archetypes  
   - Navigation  
4. Wireframes  
5. Schema  
6. Networking  
7. Video Walkthrough  
8. Notes  
9. License  

---

## Overview

### Description
SimpleSocial is a lightweight social media app focused on core features such as authentication, posting, and feed interaction.

---

## App Evaluation

- **Category:** Social  
- **Mobile:** Yes, mobile-only application  
- **Story:** Users share moments and view others’ posts in a simple feed  
- **Market:** Students and casual users  
- **Habit:** Daily usage for checking and posting updates  
- **Scope:** Narrow, focused on core functionality  

---

## Product Spec

### User Stories

#### ✅ Required (Completed)
- [x] User can register an account  
- [x] User can log in and log out  
- [x] User can create a post with image and caption  
- [x] User can view a feed of posts  
- [x] User can like posts  
- [x] User can stay logged in across sessions  
- [x] User can comment on posts  
- [x] User can view their profile  
- [x] User can see their posts on profile
      
#### 🔄 In Progress
- [ ] User can view other user profiles  
- [ ] User can pull to refresh feed  
- [ ] Infinite scrolling for feed 

#### ⏳ Planned (Next Sprint)
- [ ] User can edit or delete posts  
- [ ] Notifications system  

---

### Screen Archetypes

- **Login Screen**
  - User logs in
  - Navigate to sign up

- **Sign Up Screen**
  - User creates account

- **Home Feed Screen**
  - View posts
  - Like posts

- **Create Post Screen**
  - Upload image
  - Add caption
  - Submit post

- **Profile Screen**
  - View user posts
  - Display username

---

### Navigation

#### Tab Navigation
- Home Feed  
- Create Post  
- Profile  

#### Flow Navigation
- Login → Home Feed  
- Login → Sign Up  
- Sign Up → Home Feed  
- Home Feed → Create Post  
- Home Feed → Profile  

---

## Wireframes

*(Add your wireframe image here if required)*

---

## Schema

### Models

**User**
- username: String  
- password: String  
- createdAt: DateTime  

**Post**
- postId: String  
- userId: String  
- image: File  
- caption: String  
- likesCount: Number  
- createdAt: DateTime  

**Like**
- likeId: String  
- userId: String  
- postId: String  

---

## Networking

### Requests by Screen

**Login**
- POST /login  

**Sign Up**
- POST /register  

**Home Feed**
- GET /posts  
- POST /like  

**Create Post**
- POST /posts  

**Profile**
- GET /users/{id}/posts  

---

## Video Walkthrough

Here's a walkthrough of implemented user stories:

https://www.loom.com/share/46c5b7ac10f94fd39ca34a9268120a6d

---

## Notes

- Built using SwiftUI  
- Backend powered by Parse (Back4App)  
- Focused on clean UI and core features  

---

## License

Copyright 2026 Nishan Narain

Licensed under the Apache License, Version 2.0
