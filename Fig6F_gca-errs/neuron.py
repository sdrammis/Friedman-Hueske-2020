import math
import random


class Neuron:
    def __init__(self, name, bias, temp=1):
        self.name = name
        self.bias = bias
        self.temp = temp

    def fire(self, inputs, weights):
        incoming = sum(map(lambda x: x[0]*x[1], zip(inputs, weights)))
        potential = incoming - self.bias

        prob = 1 / (1 + math.exp(-potential/self.temp))
        return (random.uniform(0, 1) <= prob) * 1


class InputNeuron(Neuron):
    def __init__(self, name):
        Neuron.__init__(self, name, None)

    def fire(self, bool):
        return bool
