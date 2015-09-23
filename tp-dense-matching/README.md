***
# Compte-rendu TP3 VisA: Stéréovision dense
**Gaëtan Deflandre**
***

## 1. Introduction


## 2. Similarité par SSD

### 2.1. Description de la fonction iviDisparityMap

La premier double boucle de la fonction initialise la matrice
*mMinSSD* avec la valeur de *dMinSSD = (2 \* iWindowHalfSize + 1)^^2^^ \* 512.0*

    // Initialisation de l'image du minimum de SSD
    dMinSSD = pow((double)(2 * iWindowHalfSize + 1), 2.0) * 512.0;
    for (iRow = iWindowHalfSize;
            iRow < mMinSSD.size().height - iWindowHalfSize;
            iRow++)
    {
        // Pointeur sur le debut de la ligne
        pdPtr1 = mMinSSD.ptr<double>(iRow);
        // Sauter la demi fenetre non utilisee
        pdPtr1 += iWindowHalfSize;
        // Remplir le reste de la ligne
        for (iCol = iWindowHalfSize;
                iCol < mMinSSD.size().width - iWindowHalfSize;
                iCol++)
            *pdPtr1++ = dMinSSD;
    }

Les boucle qui suivent recherche pour chaque pixel de l'image de
gauche le décalage qui minimise la dissimilarité SSD. Les valeurs
des décalages sont stocké dans *mLeftDisparityMap*.
