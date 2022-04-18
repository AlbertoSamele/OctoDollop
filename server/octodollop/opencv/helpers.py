import cv2
import numpy as np


def get_bb(path: str) -> list[dict[str, float]]:
    """
    Finds the bounding boxes of UI elements in a screenshot

    Parameters:
    -----------
    path : str
        The path to the image to be analyzed

    Returns:
    --------
    dict[str, float]
        The normalized coordinates of the discovered UI elements, in a dict with keys 'x', 'y', 'w', 'h'
    """
    # Load image, convert to grayscale, and Otsu's threshold
    image = cv2.imread(path)
    original_width, original_height, _ = image.shape
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    thresh = np.ones_like(gray) * 255
    t = cv2.threshold(gray, 0, 255, cv2.THRESH_OTSU)[0]

    if t < 128:
        thresh[gray < t] = 0
    else:
        thresh[gray > t] = 0
    # Find contours and extract the bounding rectangle coordinates
    contours = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    contours = contours[0] if len(contours) == 2 else contours[1]
    for contour in contours:
        # Obtain bounding box coordinates and draw rectangle
        x, y, w, h = cv2.boundingRect(contour)
        cv2.rectangle(thresh, (x, y), (x + w, y + h), (36, 255, 12), 5)

    # Blur image with bounding rectangles to blend text letters borders together
    blur_image = cv2.GaussianBlur(thresh, (15, 15), 0)
    final_height, final_width = blur_image.shape
    print(f'{final_width}, {final_height}')

    # Re-run find contours to aggregate letters regions into text regions
    contours = cv2.findContours(blur_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    contours = contours[0] if len(contours) == 2 else contours[1]
    normalized_contours = list()
    for contour in contours:
        # Obtain bounding box coordinates
        x, y, w, h = cv2.boundingRect(contour)
        normalized_coords = {
            'x': x / final_width,
            'y': y / final_height,
            'width': w / final_width,
            'height': h / final_height,
        }
        normalized_contours.append(normalized_coords)

    return normalized_contours
