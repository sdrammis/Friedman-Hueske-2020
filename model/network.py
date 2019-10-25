class Network:
    def __init__(self):
        self.inputNeurons = {}
        self.neurons = {}
        self.conns = {}
        self.activity = {}

    def reset(self):
        for name, _ in self.activity.items():
            self.activity[name] = []

    def addInputNeuron(self, neuron):
        self.inputNeurons[neuron.name] = neuron
        self.conns[neuron.name] = []

    def addNeuron(self, neuron):
        self.neurons[neuron.name] = NetworkNeuron(neuron, [])
        self.activity[neuron.name] = []
        self.conns[neuron.name] = []

    def addConnection(self, neuronFromName, neuronToName, weight):
        self.neurons[neuronToName].addDep(neuronFromName)
        if neuronFromName in self.conns:
            self.conns[neuronFromName].append((neuronToName, weight))
        else:
            self.conns[neuronFromName] = [(neuronToName, weight)]

    def runRound(self, round_, inputs):
        for _, neuron in self.inputNeurons.items():
            children = self.conns[neuron.name]
            fired = 1 if neuron.name in inputs else 0

            for (childName, weight) in children:
                self.fire(round_, fired, weight, childName)

    def fire(self, round_, input_, weightIn, neuronName):
        networkNeuron = self.neurons[neuronName]
        fired = networkNeuron.fire(round_, input_, weightIn)
        if fired == None:
            return

        self.activity[neuronName].append(fired)
        children = self.conns[neuronName]
        for (child, weightOut) in children:
            self.fire(round_, fired, weightOut, child)


class NetworkNeuron:
    def __init__(self, neuron, deps):
        self.neuron = neuron
        self.deps = deps
        self.round = 0
        self.inputs = []
        self.weights = []

    def addDep(self, dep):
        self.deps.append(dep)

    def fire(self, round_, input_, weight):
        if self.round != round_:
            self.round = round_
            self.inputs = []
            self.weights = []

        self.inputs.append(input_)
        self.weights.append(weight)

        if len(self.inputs) == len(self.deps):
            return self.neuron.fire(self.inputs, self.weights)
