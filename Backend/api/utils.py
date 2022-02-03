import cv2
import numpy as np
from sklearn.preprocessing import LabelEncoder


def pre_process(img):
    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # CONVERT IMAGE TO GRAY SCALE
    img_blur = cv2.GaussianBlur(img_gray, (5, 5), 1)  # ADD GAUSSIAN BLUR
    img_threshold = cv2.adaptiveThreshold(
        img_blur, 255, 1, 1, 11, 2
    )  # APPLY ADAPTIVE THRESHOLD
    return img_threshold


def biggest_contour(contours):
    biggest = np.array([])
    max_area = 0
    for i in contours:
        area = cv2.contourArea(i)
        if area > 50:
            peri = cv2.arcLength(i, True)
            approx = cv2.approxPolyDP(i, 0.02 * peri, True)
            if area > max_area and len(approx) == 4:
                biggest = approx
                max_area = area
    return biggest, max_area


def reorder(my_points):
    my_points = my_points.reshape((4, 2))
    my_points_new = np.zeros((4, 1, 2), dtype=np.int32)
    add = my_points.sum(1)
    my_points_new[0] = my_points[np.argmin(add)]
    my_points_new[3] = my_points[np.argmax(add)]
    diff = np.diff(my_points, axis=1)
    my_points_new[1] = my_points[np.argmin(diff)]
    my_points_new[2] = my_points[np.argmax(diff)]
    return my_points_new


def get_corners(pre_processed_img):
    contours, hierarchy = cv2.findContours(
        pre_processed_img, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE
    )
    biggest, max_area = biggest_contour(contours)
    biggest = reorder(biggest)
    return biggest


def perspective_wrapping(img, biggest):
    height_img = 800
    width_img = 800
    img_big_contour = img.copy()
    if biggest.size != 0:
        biggest = reorder(biggest)
        # print(biggest)
        cv2.drawContours(
            img_big_contour, biggest, -1, (0, 0, 255), 25
        )  # DRAW THE BIGGEST CONTOUR
        pts1 = np.float32(biggest)  # PREPARE POINTS FOR WARP
        pts2 = np.float32(
            [[0, 0], [width_img, 0], [0, height_img], [width_img, height_img]]
        )  # PREPARE POINTS FOR WARP
        matrix = cv2.getPerspectiveTransform(pts1, pts2)  # GER
        img_warp_colored = cv2.warpPerspective(img, matrix, (width_img, height_img))
        img_warp_colored = cv2.cvtColor(img_warp_colored, cv2.COLOR_BGR2GRAY)
        return img_warp_colored
    else:
        print("No Chessboard Found")


def extract_chessboard(img_path):
    img = img_path
    pre_processed_image = pre_process(img)
    corners = get_corners(pre_processed_image)
    extracted_chessboard = perspective_wrapping(img, corners)
    return extracted_chessboard


def extract_cells(img):
    rows = np.vsplit(img, 8)
    boxes = []
    for r in rows:
        cols = np.hsplit(r, 8)
        for box in cols:
            boxes.append(box)
    return np.array(boxes)


def predict_cells(model, cells):
    pred = model.predict(cells)
    y_classes = [np.argmax(element) for element in pred]
    return y_classes


def prep_encoder():
    label_encoder = LabelEncoder()
    classes = [
        "Black Bishop",
        "Black King",
        "Black Knight",
        "Black Pawn",
        "Black Queen",
        "Black Rook",
        "Blank",
        "White Bishop",
        "White King",
        "White Knight",
        "White Pawn",
        "White Queen",
        "White Rook",
    ]
    label_encoder.fit_transform(classes)
    return label_encoder


def get_chess_matrix(enc, pred):
    arr = []
    for i in pred:
        arr.append(enc.classes_[i])
    arr = np.array(arr).reshape(8, 8)
    return arr


def to_fen(mat):
    fen_dict = {
        "Black Bishop": "b",
        "Black King": "k",
        "Black Knight": "n",
        "Black Pawn": "p",
        "Black Queen": "q",
        "Black Rook": "r",
        "Blank": "0",
        "White Bishop": "B",
        "White King": "K",
        "White Knight": "N",
        "White Pawn": "P",
        "White Queen": "Q",
        "White Rook": "R",
    }
    fen = ""
    for row in mat:
        count = 0
        for cell in row:
            fen_letter = fen_dict[cell]
            if fen_letter != "0":
                if count:
                    fen += str(count)
                    fen += fen_letter
                else:
                    fen += fen_letter
                count = 0
            else:
                count += 1
        if count:
            fen += str(count)
        fen += "/"

    return fen


def convert_image(image):
    nparr = np.fromstring(image, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return img


def get_squares(raw_image):
    img = convert_image(raw_image)
    chessboard = extract_chessboard(img)
    squares = extract_cells(chessboard)
    return squares


def get_fen(preds, next):
    enc = prep_encoder()
    fen = to_fen(get_chess_matrix(enc, preds)) + " {} - 1 0".format(next)
    return fen
