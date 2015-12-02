import matplotlib.pyplot as plt

# The min included and max included temperature
minT = 0
maxT = 40
step = 1

# The range of temperature
temp = range(minT, maxT+1, step)



def low(t):
    """
    Fonction qui descrit les températures basses.
    @return facteur de température basse en fonction de la température t.
    """
    if (t <= 10):
        # low
        return 1.0
    elif (t > 10 and t < 20):
        # transition
        return 1.0 - (t-10)/10
    else:
        # not low
        return 0.0

def medium(t):
    """
    Fonction qui descrit les températures moyennes.
    @return facteur de température moyenne en fonction de la température t.
    """
    if (t <= 10 or t >= 30):
        # not medium
        return 0.0
    elif (t > 10 and t < 20):
        return (t-10)/10
    elif (t==20):
        return 1.0
    elif (t > 20 and t < 30):
        return 1.0 - (t-20)/10


def high(t):
    """
    Fonction qui descrit les températures hautes.
    @return facteur de température haute en fonction de la température t.
    """
    if (t <= 20):
        # not high
        return 0.0
    elif (t > 20 and t < 30):
        # transition
        return (t-20)/10
    else:
        # high
        return 1.0

def heatStrongly(p):
    """
    Fonction qui descrit si nous devons chauffer fort.
    @return facteur de "chauffer fort" en fonction de la puissance p.
    """
    if (p <= 8):
        # not strongly
        return 0.0
    elif (p > 8 and p < 10):
        # transition
        return (p-8)/2
    else:
        # strongly
        return 1.0

def solveHeatStrongly(y):
    """
    Resolution de la fonction affine heatStrongly(p).
    @return puissance chauffe (KW) en fonction du facteur de "chauffer fort" y.
    """
    if (y<0.0 or y>1.0):
        raise ValueError("La fonction ne peut varier que entre 0.0 et 1.0 sur l'axe des y.")
    return (y+4) * 2

def mmin(f1, f2, t):
    """
    Fonction min entre deux fonctions
    """
    return min(f1(t), f2(t))

def mmax(f1, f2, t):
    """
    Fonction max entre deux fonctions
    """
    return max(f1(t), f2(t))

def mamdani(t, p):
    """
    @param t temperature doit être fix lors des itération
    @param p puissance varie entre 0 et 15
    """
    factor = low(t)
    powerMax = solveHeatStrongly(factor)
    if (p >= powerMax):
        return factor
    else:
        return heatStrongly(p)




# MAIN
# ====

def main():
    lowArray = []
    mediumArray = []
    highArray = []
    mminLM = []
    mmaxMH = []

    heatArray = []
    mamdaniArray = []

    print(low(16))
    print(medium(16))
    print(high(16))

    for t in temp:
        lowArray.append(low(t))
        mediumArray.append(medium(t))
        highArray.append(high(t))
        mminLM.append(mmin(low, medium, t))
        mmaxMH.append(mmax(medium, high, t))

    for p in range(0, 16, 1):
        heatArray.append(heatStrongly(p))
        mamdaniArray.append(mamdani(12,p));

    plt.plot(lowArray, marker=".", label="Basse")
    #plt.plot(mediumArray, marker=".", label="Moyenne")
    #plt.plot(highArray, marker=".", label="Elevée")
    #plt.plot(mminLM, marker=".", label="Min", color="cyan")
    #plt.plot(mmaxMH, marker=".", label="Max", color="magenta")
    plt.xlabel('Température')
    plt.ylabel('Facteur')
    plt.axis([0, 40, -0.1, 1.1])
    plt.legend()
    plt.show()

    plt.plot(heatArray, marker=".", label="Chauffer fort", color="red")
    plt.xlabel('Puissance chauffe (KW)')
    plt.ylabel('Chauffe fort')
    plt.axis([0, 15, -0.1, 1.1])
    plt.legend()
    plt.show()



if __name__ == "__main__":
    main()
