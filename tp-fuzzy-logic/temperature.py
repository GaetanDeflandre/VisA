# The min included and max included temperature
minT = 0
maxT = 40
step = 1

# The range of temperature
temp = range(minT, maxT+1, step)



def low(t):
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
    if (t <= 10 or t >= 30):
        # not medium
        return 0.0
    elif (t > 10 or t < 20):
        # TODO
        pass
    elif (t==20):
        # TODO
        pass
    elif (t > 20 or t < 30):
        # TODO
        pass

def high(t):
    if (t <= 20):
        # not high
        return 0.0
    elif (t > 20 and t < 30):
        # transition
        return (t-20)/10
    else:
        # high
        return 1.0


def main():
    for t in temp:
        print(str(t) + " : " + str(low(t)))

if __name__ == "__main__":
    main()
