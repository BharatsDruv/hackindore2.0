from flask import Flask,request,jsonify
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
import pickle
import requests
from keras.models import load_model
from keras.preprocessing import image
import json 
import base64



app = Flask(__name__)

@app.route('/api',methods=['GET','POST'])


def predict():
	value = request.json['imageb64']
	image_64_decode = base64.decodestring(value)
	image_result = open('test1.jpg','wb')
	image_result.write(image_64_decode)
	# dimensions of our images
	
	# load the model we saved
	file = open('pickleFile', 'rb')
	model = pickle.load(file)
	file.close()

	img_path = 'test1.jpg'
	img = image.load_img(img_path, target_size=(300, 300))
	img = image.img_to_array(img, dtype=np.uint8)
	img=np.array(img)/255.0
	p=model.predict(img[np.newaxis, ...])

	#print("Predicted shape",p.shape)
	print("Maximum Probability: ",np.max(p[0], axis=-1))
	predicted_class = labels[np.argmax(p[0], axis=-1)]
	return("Classified:",predicted_class)

if __name__ =='_main_':
	app.run(port=5000, debug=True)


