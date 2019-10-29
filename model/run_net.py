import random
import numpy as np

from neuron import (Neuron, InputNeuron)
from network import Network


def run_net(weights, eng=True, p_noise=0.95):
    net = make_net(weights)
    inputsT1 = ['TONE']
    inputsT2 = ['TONE', 'DISCRM']
    if (eng):
        inputsT1.append('ENG')
        inputsT2.append('ENG')
    (activityT1, numEventsT1) = run_tone(net, inputsT1, p_noise)
    net.reset()
    (activityT2, numEventsT2) = run_tone(net, inputsT2, p_noise)
    return (activityT1, activityT2, numEventsT1, numEventsT2)


def run_noise(weights, eng=True):
    net = make_net(weights)
    inputs = ['ENG'] if eng else []
    return run_tone(net, inputs, 1)


def run_tone(net, inputs_, p_noise=0.95):
    BIN_SIZE = 100

    for i in range(BIN_SIZE):
        inp = inputs_ + ['NOISE'] if (random.random() < p_noise) else inputs_
        net.runRound(i, inp)

    indvActivityMSN = [net.activity['MSN_1'], net.activity['MSN_2'],
                       net.activity['MSN_3']]
    activityMSN = np.sum(indvActivityMSN, axis=0)
    avgActivityMSN = np.mean(activityMSN)
    numEventsMSN = (activityMSN >= 2).sum() * 1.0 / BIN_SIZE

    return (avgActivityMSN, numEventsMSN)


def make_net(ws):
    net = Network()

    net.addInputNeuron(InputNeuron('TONE'))
    net.addInputNeuron(InputNeuron('DISCRM'))
    net.addInputNeuron(InputNeuron('ENG'))
    net.addInputNeuron(InputNeuron('NOISE'))

    net.addNeuron(Neuron('MSN_1', 4))
    net.addNeuron(Neuron('MSN_2', 4))
    net.addNeuron(Neuron('MSN_3', 4))
    net.addNeuron(Neuron('PV_1', 1))
    net.addNeuron(Neuron('PV_2', 1))

    net.addConnection('TONE', 'PV_1',   ws[0])
    net.addConnection('TONE', 'PV_2',   ws[1])
    net.addConnection('DISCRM', 'PV_1', ws[2])
    net.addConnection('DISCRM', 'PV_2', ws[3])
    net.addConnection('ENG', 'PV_1',    ws[4])
    net.addConnection('ENG', 'PV_2',    ws[5])
    net.addConnection('NOISE', 'PV_1',  ws[6])
    net.addConnection('NOISE', 'PV_2',  ws[7])

    net.addConnection('TONE',   'MSN_1', ws[8])
    net.addConnection('TONE',   'MSN_2', ws[9])
    net.addConnection('TONE',   'MSN_3', ws[10])
    net.addConnection('DISCRM', 'MSN_1', ws[11])
    net.addConnection('DISCRM', 'MSN_2', ws[12])
    net.addConnection('DISCRM', 'MSN_3', ws[13])
    net.addConnection('NOISE',  'MSN_1', ws[14])
    net.addConnection('NOISE',  'MSN_2', ws[15])
    net.addConnection('NOISE',  'MSN_3', ws[16])

    net.addConnection('PV_1', 'MSN_1', ws[17])
    net.addConnection('PV_1', 'MSN_2', ws[18])
    net.addConnection('PV_1', 'MSN_3', ws[19])
    net.addConnection('PV_2', 'MSN_1', ws[20])
    net.addConnection('PV_2', 'MSN_2', ws[21])
    net.addConnection('PV_2', 'MSN_3', ws[22])

    return net
