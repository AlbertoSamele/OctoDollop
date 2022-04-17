from typing import Final


class Canvas:

    def __init__(self, width: float, height: float):
        """
        Parameters:
        -----------
        width : float
            The canvas width
        height : float
            The canvas height
        """
        self.width: Final[float] = width
        self.height: Final[float] = height
        self.aspect_ratio: Final[float] = width / height
        self.x_midpoint: Final[float] = width / 2
        self.y_midpoint: Final[float] = height / 2

    @classmethod
    def from_json(cls, json):
        """ Instantiates object from json dictionary """
        return cls(**json)


class Element:

    def __init__(self, x: float, y: float, width: float, height: float):
        """
        Parameters:
        -----------
        x : float
            The element relative x position on the canvas
        y : float
            The element relative y position on the canvas
        width : float
            The element width as a proportion of the canvas width
        height : float
            The element height as a proportion of the canvas height
        """
        self.x: Final[float] = x
        self.y: Final[float] = y
        self.width: Final[float] = width
        self.height: Final[float] = height

    @classmethod
    def from_json(cls, json):
        """ Instantiates object from json dictionary """
        return cls(**json)

    def absolute_x(self, canvas: Canvas) -> float:
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's absolute x coordinate
        """
        return self.x * canvas.width

    def absolute_y(self, canvas: Canvas) -> float:
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's absolute y coordinate
        """
        return self.y * canvas.height

    def absolute_width(self, canvas: Canvas) -> float:
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's absolute width
        """
        return self.width * canvas.width

    def absolute_height(self, canvas: Canvas) -> float:
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's absolute height
        """
        return self.height * canvas.height

    def x_midpoint(self, canvas: Canvas):
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's midpoint absolute x coordinate
        """
        return self.absolute_x(canvas) + self.absolute_width(canvas) / 2

    def y_midpoint(self, canvas: Canvas):
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's midpoint absolute y coordinate
        """
        return self.absolute_y(canvas) + self.absolute_height(canvas) / 2

    def area(self, canvas: Canvas):
        """
        Parameters:
        -----------
        canvas : Canvas
            The element's enclosing canvas

        Returns:
        --------
        float
            The element's area
        """
        return self.absolute_width(canvas) * self.absolute_height(canvas)


class Rating:

    def __init__(self, id_: str, rating: int, comment: str):
        """
        Parameters:
        -----------
        id_ : str
            The id of the rater that generated this rating
        rating : int
            The rating, ranging from 0 to 1
        comment : str
            A meaningful comment explaining the rating
        """
        self.id_: Final[str] = id_
        self.rating: Final[int] = rating
        self.comment: Final[str] = comment

    def serialize(self) -> dict:
        """
        Returns:
        --------
        dict
            The JSON serialized object
        """
        return {
            'type': self.id_,
            'score': self.rating,
            'comment': self.comment
        }
