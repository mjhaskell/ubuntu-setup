import numpy as np


def hello():
    print("hello")
    return


def some_really_long_function_name(
    long_arg_1: np.ndarray,
    long_arg_2: np.ndarray,
    long_arg_3: np.ndarray,
    long_arg_4: np.ndarray,
):
    """
    Test function.

    Args:
        long_arg_1: argument 1
        long_arg_2: argument 2
        long_arg_3: argument 3
        long_arg_4: argument 4

    Returns:
        out: None
    """
    pass


blah = np.array([[1, 2, 3], [4, 5, 6]])

some_really_long_function_name(
    blah,
)
