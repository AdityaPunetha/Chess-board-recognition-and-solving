# Chess-board-recognition-and-solving

The proposal is for an app which will capture the image of a chessboard and will provide the next best move based on the chess position on the board. The user will open the app to capture the image, next he will choose whether it's white to move or black, and may pass additional parameters such as castling availability and think time/ depth for the chess engine.

The app shall use TensorFlow Object Detection (TFOD) api and OpenCV to get the relative position of objects from the image and parse it into a FEN encoded string. Forsyth–Edwards Notation (FEN) is a standard notation for describing a particular board position of a chess game. This FEN will further be passed into a chess engine from which the next best move will be inferred and will be provided to the user in the Standard algebraic notation form. For the initial stages of development, the chess engine can be a rule-based system that is available through various libraries but we can train a ML based chess engine in the future as well. The ML model will be trained through a reinforcement learning based policy in an OpenAI Gym based environment. Both the ML model will be accessed through TensorFLow Lite package available for flutter (tflite | Flutter Package (pub.dev)).

The app shall be written in Dart/Flutter and the Object detection model shall be trained in Python.

<br/>

# How it works

In order to suggest the next best move, we should first know the current position on the chessboard. To do that first we extract the chess board from the image, divide it into 8x8 cells and then run our classifier on each cell. After that based on the classification we encode this data in a FEN notation which the chess engine is able to understand. Then based on the position the engine is able to recommend the next best move.

We use the app to capture a picture of the chessboard and select whether it's white's turn or black's and send it to our backend and receive the next best move.

The image is received by the backend which looks something like this.

<img src="https://raw.githubusercontent.com/AdityaPunetha/AdityaPunetha/main/assets/chess/chessboard_captured.png" alt="captured" height="304" width="227"/>

<br/>

## Preprocessing

First we will make a copy of the image and convert it into gray scale, apply gaussian blur and apply adaptive threshold. This turns colors above a certain threshold to white and those below to black and we can easily decipher all the edges present in the image.

After treating the above image with the following process it looks like this.

<img src="https://raw.githubusercontent.com/AdityaPunetha/AdityaPunetha/main/assets/chess/chessboard_preprocessed.png" alt="preprocessed" height="304" width="227"/>

<br/>

## Contours

Next we convert all the edges(datapoints) from the above image to OpenCV contours. In OpenCV, contours are defined as curve joining all the continuous points (along the boundary), having the same color or intensity.

<img src="https://raw.githubusercontent.com/AdityaPunetha/AdityaPunetha/main/assets/chess/chessboard_contours.png" alt="contours" height="304" width="227"/>

<br/>

## Getting the chessboard's corners

The above process converts the image to an array from which we can sort the biggest contour and get its corners.

We have drawn a polygon from the corners we got from the biggest contour.

<img src="https://raw.githubusercontent.com/AdityaPunetha/AdityaPunetha/main/assets/chess/chessboard_poly.png" alt="poly" height="304" width="227"/>

<br/>

## Extracting the chessboard

We now perform perspective warping and transform and extract the chessboard into square image of equal size without any distortion and apply grayscale to it.

<img src="https://raw.githubusercontent.com/AdityaPunetha/AdityaPunetha/main/assets/chess/chessboard_warp.png" alt="warp" height="200" width="200"/>

<br/>

## Isolating Squares and classify

Next we split the image into 8 equal parts both vertically and horizontally to get each individual cell. Our ML model then classifies them into the their respective piece classes and returns the predictions.

<br/>

## FEN encoding and chess engine

Next we parse the predictions into a FEN string along with whose turn it it and send it to the engine for analyses and it suggests us the strongest move available.
