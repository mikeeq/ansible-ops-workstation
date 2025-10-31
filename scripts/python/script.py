import pyautogui
import time

def mouse_jiggle(duration=10, interval=0.5):
    """
    Moves mouse slightly back and forth for the given duration (in seconds).
    """
    start_time = time.time()
    original_pos = pyautogui.position()
    while time.time() - start_time < duration:
        pyautogui.move(5, 0)   # Move right
        time.sleep(interval)
        pyautogui.move(-5, 0)  # Move left
        time.sleep(interval)
    #pyautogui.displayMousePosition()
    pyautogui.moveTo(original_pos)  # Return to original position

def left_click_at(x, y):
    """
    Moves to (x, y) and performs left mouse click.
    """
    pyautogui.moveTo(x, y)
    pyautogui.click()

if __name__ == "__main__":
    try:
        while True:

            mouse_jiggle(duration=5, interval=0.3)
            left_click_at(85, 95)  # Replace with desired coordinates
            left_click_at(85, 150)  # Replace with desired coordinates
            time.sleep(2)  # Delay between cycles to avoid excessive activity
    except KeyboardInterrupt:
        print("Script terminated by user.")
