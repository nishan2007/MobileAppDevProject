# MobileAppDevProject
Original App Design Project - README Template
SimpleSocial

Table of Contents
Overview
Product Spec
Wireframes
Schema

Overview

Description
SimpleSocial is a basic social media application that allows users to create accounts, log in, and share posts with captions. Users can view a feed of posts from all users and interact by liking posts. The app focuses on core social media functionality with a clean and simple user experience.

App Evaluation

Category: Social

Mobile: Yes, mobile-only application

Story:
This app allows users to share moments from their daily lives through posts and view what others are sharing in a simple feed-based interface.

Market:
Students and casual users who want a lightweight social media experience without complex features.

Habit:
Can be used daily to check posts and share updates.

Scope:
Narrow scope focusing only on essential social media features like posting, viewing, and liking content.

Product Spec
	1.	User Stories (Required and Optional)

Required Must-have Stories
User can register an account
User can log in and log out
User can create a post with an image and caption
User can view a feed of posts
User can like posts
User can view their own profile
User can see their posts on their profile

Optional Nice-to-have Stories
User stays logged in across sessions
User can edit or delete their posts
User can comment on posts
User can view other user profiles
User can pull to refresh the feed
	2.	Screen Archetypes

Login Screen
User can log in
User can navigate to sign up

Sign Up Screen
User can create a new account

Home Feed Screen
User can scroll through posts
User can like posts

Create Post Screen
User can upload an image
User can add a caption
User can submit a post

Profile Screen
User can view their posts
User can see their username
	3.	Navigation

Tab Navigation (Tab to Screen)
Home Feed
Create Post
Profile

Flow Navigation (Screen to Screen)

Login Screen leads to Home Feed
Login Screen leads to Sign Up Screen
Sign Up Screen leads to Home Feed

Home Feed leads to Create Post
Home Feed leads to Profile

Profile leads to Post Details (optional)

Wireframes

Add hand-drawn wireframes here

BONUS Digital Wireframes and Mockups
Optional

BONUS Interactive Prototype
Optional

Schema

Models

User
username: String, unique username
password: String, user password
createdAt: DateTime, account creation date

Post
postId: String, unique post ID
userId: String, ID of user who created post
image: File, uploaded image
caption: String, post caption
likesCount: Number, number of likes
createdAt: DateTime, time post was created

Like
likeId: String, unique like ID
userId: String, user who liked
postId: String, post that was liked

Networking

List of Network Requests by Screen

Login Screen
POST /login to authenticate user

Sign Up Screen
POST /register to create new user

Home Feed Screen
GET /posts to retrieve all posts
POST /like to like a post

Create Post Screen
POST /posts to create a new post

Profile Screen
GET /users/{id}/posts to retrieve user posts

Example Request Snippets

Login Request
POST /login
username: user1
password: password123

Create Post
POST /posts
userId: 123
caption: My first post
image: file_url
