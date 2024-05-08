import numpy as np


def anova(adj_matrix:np.ndarray) -> np.ndarray:
    total_mean = np.mean(adj_matrix)
    a = list()
    b = list()
    for i in range(np.shape(adj_matrix)[0]):
        a.append(total_mean - np.mean(adj_matrix[i]))
    for j in range(np.shape(adj_matrix)[1]):
        b.append(total_mean - np.mean(adj_matrix[:,j]))
    return total_mean,np.array(a),np.array(b)

def likelihood(adj_matrix:np.ndarray):
    mu,a,b = anova(adj_matrix)
    likelihood = 1.0
    for i in range(np.shape(adj_matrix)[0]):
        for j in range(np.shape(adj_matrix)[1]):
            likelihood *= (np.exp(mu + a[i] + b[j]) ** adj_matrix[i,j]) / np.exp(mu + a[i] + b[j])
    return likelihood

arr = np.array([[1, 1, 1],
                [1, 1, 0],
                [0, 1, 1]])
print(likelihood(np.eye(9)))

