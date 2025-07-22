# pip3 install pyautogui
# python3 mouse_jiggler_macos.py
# This script randomly moves the mouse cursor every 10 seconds to prevent the system from going idle
# Ensure you have the necessary permissions to control the mouse in System Preferences > Security & Privacy > Accessibility

import pyautogui
import time
import random

while True:
  x = random.randint(0,1000)
  y = random.randint(0,1000)

  pyautogui.moveTo(x,y)
  localtime = time.localtime()
  result = time.strftime("%I:%M:%S %p", localtime)
  print('Moved at ' + str(result) + ' ('  + str(x) + ', ' + str(y) + ')')

  time.sleep(10)
