import cv2
import serial

# Порт Arduino
arduino = serial.Serial('/dev/ttyUSB0', 9600)
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    for (x, y, w, h) in faces:
        cx = x + w // 2
        cy = y + h // 2
        # Передаємо координати у форматі "X:123,Y:456"
        arduino.write(f"{cx},{cy}\n".encode())
        break

cap.release()
arduino.close()
