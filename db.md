# SocialStream Firebase Firestore Structure Design Plan

## Overview
This document outlines the design plan for the Firebase Firestore database structure for the SocialStream app. The app will include categories of Telegram and WhatsApp channels, a feature for users to request channel promotions, and user management.

## Collections and Documents

### 1. Categories
This collection stores the different categories available in the app.

#### Document Fields
- **category_id (document ID)**
  - `name: string` - The name of the category (e.g., Productivity, Health, Science).

#### Example
```json
{
  "category_id": "category_1",
  "name": "Productivity"
}
```

### 2. Channels
This collection stores information about the channels available under each category.

Document Fields
#### Example
```json
{
  "channel_id": "channel_1",
  "name": "Productivity Tips",
  "description": "Best productivity hacks and tips",
  "link": "https://t.me/productivitytips",
  "type": "telegram",
  "category_id": "category_1"
}
```

### 3. Promotions
This collection handles the requests from users to promote their channels.

Document Fields
#### Example
```json
{
  "promotion_id": "promotion_1",
  "channel_id": "channel_1",
  "user_id": "user_1",
  "status": "pending",
  "request_date": "2024-06-16T00:00:00Z"
}
```

### 4. Users
This collection stores information about the users of the app.

Document Fields
#### Example
```json
{
  "user_id": "user_1",
  "name": "John Doe",
  "email": "johndoe@example.com",
  "profile_picture": "https://example.com/johndoe.jpg",
  "created_at": "2024-06-16T00:00:00Z"
}

```