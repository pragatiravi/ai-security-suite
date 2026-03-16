from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
import joblib

X, y = load_iris(return_X_y=True)
clf = LogisticRegression(max_iter=200)
clf.fit(X, y)

joblib.dump(clf, "iris_model.pkl")
print("Model saved: iris_model.pkl")
