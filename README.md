# Music-X-Ray
===
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Have you ever wondered how Spotify recommends music for you so well? This Music X-Ray app allows you to access everything Spotify uses to evaluate tracks and artists. You can view your own genres and top artists and tracks, see the audio features of individual songs, and see the genre profile of your own spotify playlists. 

### App Evaluation
- **Category: Entertainment**
- **Mobile: Could be used on desktop, but mobile experience and portability are important aspects of this app**
- **Story:**
- **Market:Anyone with a Spotify account who wants to access the more in-depth information about their listening habits**
- **Habit: not very habit forming; however, may be used frequently to create new playlists based on genres**
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* ability to login via spotify and integrate with Spotify API/SDK
* ability to create an account and link it to your spotify?
* ability to take a picture with the camera and make it the playlist cover image or user profile picture
* search for artists and tracks
* view stats for artists
    * name
    * popularity
    * genres
    * top tracks
* view audio features for tracks
    * key signature
    * mode
    * time signature
    * acousticness
    * danceability
    * energy
    * instrumentalness
    * liveness
    * loudness
    * speechiness
    * valence
    * tempo
* view your playlists and track information
    * genres
    * average popularity of your songs
* view your top tracks and artists
* option to play tracks from linked spotify

**Optional Nice-to-have Stories**

* search for albums, playlists of other users, genres
* view a master genre list
* ability to view playlists based on genres according to http://everynoise.com/everynoise1d.cgi?root=oklahoma%20country&scope=all
* be able to use app as a guest
* on search screen, display randomly fetched artist
* artist of the day? on a home tab
* different time frame for personalized top tracks and artists -- long term, medium, short

### 2. Screen Archetypes

* create account/login
    * ability to create an account and link it to your spotify?
* link spotify account
    * ability to login via spotify and integrate with Spotify API/SDK
* view personal user information
    * view your top tracks and artists
    * view your playlists and their track information
        * genres
        * average popularity of your songs
* search screen
    * search for artists and tracks
    * view stats for artists
        * name
        * popularity
        * genres
        * top tracks
    * view audio features for tracks
        * key signature
        * mode
        * time signature
        * acousticness
        * danceability
        * energy
        * instrumentalness
        * liveness
        * loudness
        * speechiness
        * valence
        * tempo

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* search tab
* personal profile tab


**Flow Navigation** (Screen to Screen)

* create account/login
    * -> link spotify account
* link spotify account
    * -> view user information tab / home
* view user information tab / home
    * -> view individual track info
    * -> view individual artist info
    * -> search tab
    * -> view personal playlists
* search screen
    * -> view individual artist info
    * -> view individual track info
* view personal playlists
    * -> view individual personal playlists info
* view individual artist info
    * -> view individual track info
* view individual track info
    * -> view individual artist info



## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
