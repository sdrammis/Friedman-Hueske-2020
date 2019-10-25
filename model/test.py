from neuron import (Neuron, InputNeuron)
from network import Network
from run_net import run_net

ws = [0.1, 0.5, 2.0, 0.5, 0.2, 3.0, 0.05, 0.5, 4.0, 4.0, 4.0, 3.0,
      3.0, 3.0, 4.0, 4.0, 4.0, -13.64, -15.09, -17.35, -1.0, -1.0, -1.0]
run_net(ws, 1)

# net = Network()
# net.addInputNeuron(InputNeuron('TONE'))
# net.addInputNeuron(InputNeuron('DISCR'))
# net.addInputNeuron(InputNeuron('ENG'))
# net.addInputNeuron(InputNeuron('NOISE'))

# net.addNeuron(Neuron('MSN', 4))
# net.addNeuron(Neuron('PV', 1))


# net.addConnection('TONE', 'PV', 0.1)
# net.addConnection('TONE', 'MSN', 4)
# net.addConnection('DISCR', 'PV', 2)
# net.addConnection('DISCR', 'MSN', 3)
# net.addConnection('NOISE', 'PV', 0.05)
# net.addConnection('NOISE', 'MSN', 4)
# net.addConnection('ENG', 'PV', 0.2)
# net.addConnection('PV', 'MSN', -10)


# N = 1000
# for i in range(N):
#     net.runRound(i, ['TONE', 'DISCR', 'NOISE', 'ENG'])

# # print(net.activity)
# print('PV', sum(net.activity['PV'])/N)
# print('MSN', sum(net.activity['MSN'])/N)
