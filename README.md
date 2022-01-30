# Chess-board-recognition-and-solving

The proposal is for an app which will capture the image of a chessboard and will provide the next best move based on the chess position on the board. The user will open the app to capture the image, next he will choose whether it's white to move or black, and may pass additional parameters such as castling availability and think time/ depth for the chess engine. 

The app shall use TensorFlow Object Detection (TFOD) api and OpenCV to get the relative position of objects from the image and parse it into a FEN encoded string. Forsyth–Edwards Notation (FEN) is a standard notation for describing a particular board position of a chess game. This FEN will further be passed into a chess engine from which the next best move will be inferred and will be provided to the user in the Standard algebraic notation form. For the initial stages of development, the chess engine can be a rule-based system that is available through various libraries but we can train a ML based chess engine in the future as well. The ML model will be trained through a reinforcement learning based policy in an OpenAI Gym based environment. Both the ML model will be accessed through TensorFLow Lite package available for flutter (tflite | Flutter Package (pub.dev)). 

The app shall be written in Dart/Flutter and the Object detection model shall be trained in Python.
