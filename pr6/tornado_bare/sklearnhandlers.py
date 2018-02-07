#!/usr/bin/python

from pymongo import MongoClient
import tornado.web

from tornado.web import HTTPError
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.options import define, options

from basehandler import BaseHandler

from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC

import pickle
from bson.binary import Binary
import json
import numpy as np

class PrintHandlers(BaseHandler):
    def get(self):
        '''Write out to screen the handlers used
        This is a nice debugging example!
        '''
        self.set_header("Content-Type", "application/json")
        self.write(self.application.handlers_string.replace('),','),\n'))

class UploadLabeledDatapointHandler(BaseHandler):
    def post(self):
        '''Save data point and class label to database
        '''
        data = json.loads(self.request.body.decode("utf-8"))

        vals = data['feature']
        fvals = [float(val) for val in vals]
        label = data['label']
        sess  = data['dsid']
       

        dbid = self.db.labeledinstances.insert(
            {"feature":fvals,"label":label,"dsid":sess}
            );
        self.write_json({"id":str(dbid),
            "feature":[str(len(fvals))+" Points Received",
                    "min of: " +str(min(fvals)),
                    "max of: " +str(max(fvals))],
            "label":label})

class RequestNewDatasetId(BaseHandler):
    def get(self):
        '''Get a new dataset ID for building a new dataset
        '''
        a = self.db.labeledinstances.find_one(sort=[("dsid", -1)])
        if a == None:
            newSessionId = 1
        else:
            newSessionId = float(a['dsid'])+1
        self.write_json({"dsid":newSessionId})

class UpdateModelForDatasetId(BaseHandler):
    def post(self):
        '''Train a new model (or update) for given dataset ID
        '''
        data = json.loads(self.request.body.decode("utf-8")) 
        dsid  = data['dsid']
        knn_pa = data['knn_pa']
        svm_pa = data['svm_pa']

        # create feature vectors from database
        f=[];
        for a in self.db.labeledinstances.find({"dsid":dsid}): 
            f.append([float(val) for val in a['feature']])

        # create label vector from database
        l=[];
        for a in self.db.labeledinstances.find({"dsid":dsid}): 
            l.append(a['label'])

        # fit the model to the data
        c1 = KNeighborsClassifier(n_neighbors=knn_pa);
        c2 = SVC(kernel=svm_pa)
        acc1 = -1;
        acc2 = -1;
        if l:
            c1.fit(f,l) # training
            c2.fit(f,l)
            lstar1 = c1.predict(f)
            lstar2 = c2.predict(f)
            self.clf = c1
            acc1 = sum(lstar1==l)/float(len(l))
            acc2 = sum(lstar2==l)/float(len(l))
            bytes = pickle.dumps(c1)
            self.db.models.update({"dsid":dsid},
                {  "$set": {"model":Binary(bytes),
                "model_id":1}},
                upsert=True)
            bytes = pickle.dumps(c2)
            self.db.models.update({"dsid":dsid},
                {  "$set": {"model":Binary(bytes),
                "model_id":2}},
                upsert=True)

        # send back the resubstitution accuracy
        # if training takes a while, we are blocking tornado!! No!!
        self.write_json({"resubAccuracy_KNN":acc1,
                            "resubAccuracy_SVC":acc2
                            })

class PredictOneFromDatasetId(BaseHandler):
    def post(self):
        '''Predict the class of a sent feature vector
        '''
        data = json.loads(self.request.body.decode("utf-8"))    

        vals = data['feature'];
        fvals = [float(val) for val in vals];
        fvals = np.array(fvals).reshape(1, -1)
        dsid  = data['dsid']

        # load the model from the database (using pickle)
        # we are blocking tornado!! no!!
        if(self.clf == []):
            print('Loading Model From DB')
            tmp = self.db.models.find_one({"model_id":1})
            self.clf = pickle.loads(tmp['model'])
        predLabel_KNN = self.clf.predict(fvals);
        #another model
        tmp = self.db.models.find_one({"model_id":2})
        self.clf = pickle.loads(tmp['model'])
        predLabel_SVC = self.clf.predict(fvals);
        self.write_json({"prediction_SVC":str(predLabel_KNN),
                        "prediction_KNN":str(predLabel_SVC)})