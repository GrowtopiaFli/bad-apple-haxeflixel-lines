import json
from json import JSONEncoder
import cv2
from array import *
import colorsys
import numpy as np

class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)

cap = cv2.VideoCapture("./videos/badapple.mp4")

frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
font = cv2.FONT_HERSHEY_COMPLEX

binData = bytearray()
frameMap = []

i = 1

while True:
    res, frame = cap.read()
    if res:
        mask = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
        # mask = cv2.inRange(frame, np.array([20, 20, 20]), np.array([255, 255, 255]))
        
        (thres, mask) = cv2.threshold(mask, 50, 255, 0)
        contours, hierarchy = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        # frame = np.zeros((720,960,3), np.uint8)

        contourArr = bytearray()

        for cnt in contours:
            #approx = cv2.approxPolyDP(cnt, 0.009 * cv2.arcLength(cnt, True), True)
            approx = cv2.approxPolyDP(cnt, 0.001 * cv2.arcLength(cnt, True), True)
            cv2.drawContours(frame, [approx], 0, [0, 0, 255], 4) 
            #cv2.drawContours(frame, contours, -1, [col[2], col[1], col[0]], 4)

            n = approx.ravel() 
            k = 0
        
            coordArray = bytearray()

            for j in n:
                if k % 2 == 0:
                    x = int(n[k])
                    y = int(n[k + 1])
                    coordArray.append(x >> 8)
                    coordArray.append(x & 255)
                    coordArray.append(y >> 8)
                    coordArray.append(y & 255)
                k += 1
            
            cntFinal = bytearray()
            coordLength = len(coordArray)
            cntFinal.append(coordLength >> 8)
            cntFinal.append(coordLength & 255)
            cntFinal += coordArray
            contourArr += cntFinal
        cntLength = len(contourArr)
        frameMap.append(len(binData))
        binData.append(cntLength >> 8)
        binData.append(cntLength & 255)
        binData += contourArr
        
        cv2.imshow("Video", frame)
        i += 1
        print(str(i) + " / " + str(frames))
    else:
        break
    if cv2.waitKey(10) == 27:
        break

f = open("frames.map", "w")
f.write("\n".join(str(x) for x in frameMap))
f.close()
f = open("video.bin", "wb")
f.write(binData)
f.close()

cap.release()
cv2.destroyAllWindows()