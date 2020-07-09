# Bounce
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
- **Story: Have you ever wondered how Spotify recommends music for you so well? This Music X-Ray app allows you to access everything Spotify uses to evaluate tracks and artists. You can view your own genres and top artists and tracks, see the audio features of individual songs, and see the genre profile of your own spotify playlists. **
- **Market:Anyone with a Spotify account who wants to access the more in-depth information about their listening habits**
- **Habit: not very habit forming; however, may be used frequently to create new playlists based on genres**
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* ability to login via spotify and integrate with Spotify API/SDK
* ability to create an account and link it to your spotify?
* ability to take a picture with the camera and make it your user profile picture
* search for artists/tracks
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
    * change profile picture
    * view your top tracks and artists
    * view your playlists and their track information
        * genres
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
* recommended screen
     * view genre affinities (complex algorithm requirement)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* search tab
* personal profile tab
* Browse/Recommended tab


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
    * -> edit and add user profile picture
* search screen
    * -> view individual artist info
    * -> view individual track info
* view personal playlists
    * -> view individual personal playlists info
* view individual artist info
    * -> view individual track info
* view individual track info
    * -> view individual artist info
* recommended screen


## Wireframes

<img src="https://scontent-ort2-1.xx.fbcdn.net/v/wl/t1.15752-9/107094331_1002959833495379_3397724779095505049_n.jpg?_nc_cat=105&_nc_sid=b96e70&_nc_ohc=8ytaKEDZrlsAX_I_ghb&_nc_ht=scontent-ort2-1.xx&_nc_rmd=260&_nc_log=1&oh=26fa9f76177602503558b295bf31442c&oe=5F2C1BF8" width=1000>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
#### Track

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Album         | Album Object  | The album on which the track appears.  |
   | Artists       | Array of Artist Objects| The artists who performed the track. |
   | id            | String   | 	The Spotify ID for the track. |
   | Name          | String   | The name of the track. |
   | Type        | String   |The object type: "track" |
   
#### Artist

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Images         | Array of Image objects  | Images of the artist in various sizes, widest first.  |
   | Genres       | Array of strings| A list of the genres the artist is associated with.|
   | id            | String   | 	The Spotify ID for the track. |
   | Name          | String   | The name of the artist. |
   | Type        | String   |The object type: "artist" |
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Images         | Array of Image objects  | Profile image of the user  |
   | id            | String   | 	The Spotify ID for the user. |
   | Diaplay_Name          | String   | The name of the user. |
   | Type        | String   |The object type: "user" |
#### Image

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Height        | Integer  | 	The image height in pixels. If unknown: null or not returned.  |
   | url           | String   | 		The source URL of the image.|
   | Width         | Integer  | 	The image width in pixels. If unknown: null or not returned.|
   | Type        | String   |The object type: "image" |
#### Playlist
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | id	   | string	   | The Spotify ID for the playlist. |
   | images	   | an array of image objects   | 	Images for the playlist. The array may be empty or contain up to three images. The images are returned by size in descending order. See Working with Playlists.|
Note: If returned, the source URL for the image ( url ) is temporary and will expire in less than a day.
   | name	   | string	   | The name of the playlist.|
   | owner	   | a user object	   | The user who owns the playlist|
   | public	   | Boolean or null	   | The playlist’s public/private status: true the playlist is public, false the playlist is private, null the playlist status is not relevant. For more about public/private status, see Working with Playlists.|
   | tracks	   | array of playlist track objects inside a paging object	| Information about the tracks of the playlist.|
   | type	   | string   | 	The object type: “playlist”|
   
#### Audio Features

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | acousticness	   | float	   | A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.   | 
   | danceability	   | float	   | Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.   | 
   | energy	   | float   | 	Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.   | 
   | id	   | string	   | The Spotify ID for the track.   | 
   | instrumentalness	   | float   | 	Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.   | 
   | key	   | int   | 	The key the track is in. Integers map to pitches using standard Pitch Class notation. E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on.   | 
   | liveness	   | float	   | Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.   | 
   | loudness   | 	float   | 	The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typical range between -60 and 0 db.   | 
   | mode	   | int   | 	Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.   | 
   | speechiness	   | float   | 	Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.   | 
   | tempo	   | float   | 	The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.   | 
   | time_signature	   | int	   | An estimated overall time signature of a track. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure).   | 
   | valence   | 	float   | 	A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).    | 
### Networking
#### Albums
Base URL: https://api.spotify.com/v1

 | METHOD	 | ENDPOINT	 | USAGE	 | RETURNS |
 | --------- | --------- | -------|-------- |
 | GET	 | /v1/albums/{id}	 | Get an Album | 	album | 
 | GET | 	/v1/albums/{id}/tracks | 	Get an Album's Tracks | 	tracks | 
 | GET | 	/v1/albums | 	Get Several Albums | 	albums | 
#### Artists
Base URL: https://api.spotify.com/v1

 | METHOD	 | ENDPOINT | 	USAGE	 | RETURNS | 
  | --------- | --------- | -------|-------- |
 | GET	 | /v1/artists/{id}	 | Get an Artist	 | artist | 
 | GET	 | /v1/artists/{id}/albums	 | Get an Artist's Albums | 	albums | 
 | GET	 | /v1/artists/{id}/top-tracks	 | Get an Artist's Top Tracks | 	tracks | 
 | GET	 | /v1/artists/{id}/related-artists | 	Get an Artist's Related Artists	 | artists | 
 | GET	 | /v1/artists	Get Several Artists	 | artists | 
#### User Profile
Base URL: https://api.spotify.com/v1

 | METHOD	 | ENDPOINT	 | USAGE	 | RETURNS | 
  | --------- | --------- | -------|-------- |
 | GET	 | /v1/me	 | Get Current User's Profile	 | user | 
 | GET	 | /v1/users/{user_id}	 | Get a User's Profile	 | user | 
#### Tracks
Base URL: https://api.spotify.com/v1


 | GET	 | /v1/audio-analysis/{id}	 | Get Audio Analysis for a Track	 | audio analysis object | 
 | GET	 | /v1/audio-features/{id}	 | Get Audio Features for a Track	 | audio features | 
 | GET	 | /v1/audio-features	 | Get Audio Features for Several Tracks	 | audio features | 
 | GET	 | /v1/tracks	 | Get Several Tracks	 | tracks | 
 | GET	 | /v1/tracks/{id}	 | Get a Track	 | track | 
 
#### Playlists 
Base URL: https://api.spotify.com/v1

 | METHOD	 | ENDPOINT	 | USAGE	 | RETURNS | 
  | --------- | --------- | -------|-------- |
 | POST	 | /v1/playlists/{playlist_id}/tracks	 | Add Items to a Playlist	 | - | 
 | PUT	 | /v1/playlists/{playlist_id}	 | Change a Playlist's Details	 | - | 
 | POST	 | /v1/users/{user_id}/playlists	 | Create a Playlist	 | - | 
 | GET	 | /v1/me/playlists	 | Get a List of Current User's Playlists	 | playlists | 
 | GET	 | /v1/users/{user_id}/playlists	 | Get a List of a User's Playlists	 | playlists | 
 | GET	 | /v1/playlists/{playlist_id}/images	 | Get a Playlist Cover Image	 | list of image objects | 
 | GET	 | /v1/playlists/{playlist_id}	 | Get a Playlist	 | playlist | 
 | GET	 | /v1/playlists/{playlist_id}/tracks	 | Get a Playlist's Items	 | tracks | 
 | DELETE	 | /v1/playlists/{playlist_id}/tracks	 | Remove Items from a Playlist	 | - | 
 | PUT	 | /v1/playlists/{playlist_id}/tracks	 | Reorder a Playlist's Items	 | - | 
 | PUT	 | /v1/playlists/{playlist_id}/tracks	 | Replace a Playlist's Items	 | - | 
 | PUT	 | /v1/playlists/{playlist_id}/images	 | Upload a Custom Playlist Cover Image | 	- | 
#### Personalization
Base URL: https://api.spotify.com/v1
 | METHOD	 | ENDPOINT	 | USAGE	 | RETURNS | 
  | --------- | --------- | -------|-------- |
 |GET |	/v1/me/top/{type}	 |Get a User's Top Artists and Tracks	 |artists or tracks |
#### List of network requests by screen
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
