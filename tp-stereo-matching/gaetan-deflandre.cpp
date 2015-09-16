/* --------------------------------------------------------------------------
Mise en correspondance de points d'interet detectes dans deux images
Copyright (C) 2010, 2011  Universite Lille 1

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

/* --------------------------------------------------------------------------
Inclure les fichiers d'entete
-------------------------------------------------------------------------- */
#include <stdio.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
using namespace cv;
#include "glue.hpp"
#include "gaetan-deflandre.hpp"

// -----------------------------------------------------------------------
/// \brief Detecte les coins.
///
/// @param mImage: pointeur vers la structure image openCV
/// @param iMaxCorners: nombre maximum de coins detectes
/// @return matrice des coins
// -----------------------------------------------------------------------
Mat iviDetectCorners(const Mat& mImage,
                     int iMaxCorners) {
    // A modifier !
    double tx = mImage.cols, ty = mImage.rows;

    vector<Point> corners = vector<Point>();

    goodFeaturesToTrack(mImage, corners, iMaxCorners, 0.01, 10);

    unsigned int nbPoint = corners.size();
    Mat mCorners = Mat(3, nbPoint, CV_64F);

    for (int i=0; i<nbPoint; i++){
        mCorners.at<double>(0,i) = corners[i].x;
        mCorners.at<double>(1,i) = corners[i].y;
        mCorners.at<double>(2,i) = 1;
    }

    std::cout << mCorners << std::endl;

    // Retour de la matrice
    return mCorners;
}

// -----------------------------------------------------------------------
/// \brief Initialise une matrice de produit vectoriel.
///
/// @param v: vecteur colonne (3 coordonnees)
/// @return matrice de produit vectoriel
// -----------------------------------------------------------------------
Mat iviVectorProductMatrix(const Mat& v) {
    // A modifier !
    Mat mVectorProduct = Mat::eye(3, 3, CV_64F);

    mVectorProduct.at<double>(Point(0,0)) = 0.0;
    mVectorProduct.at<double>(Point(0,1)) = -v.at<double>(Point(2,0));
    mVectorProduct.at<double>(Point(0,2)) = v.at<double>(Point(1,0));
    mVectorProduct.at<double>(Point(1,0)) = v.at<double>(Point(2,0));
    mVectorProduct.at<double>(Point(1,1)) = 0.0;
    mVectorProduct.at<double>(Point(1,2)) = -v.at<double>(Point(0,0));
    mVectorProduct.at<double>(Point(2,0)) = -v.at<double>(Point(1,0));
    mVectorProduct.at<double>(Point(2,1)) = v.at<double>(Point(0,0));
    mVectorProduct.at<double>(Point(2,2)) = 0.0;

    // Retour de la matrice
    return mVectorProduct;
}

// -----------------------------------------------------------------------
/// \brief Initialise et calcule la matrice fondamentale.
///
/// @param mLeftIntrinsic: matrice intrinseque de la camera gauche
/// @param mLeftExtrinsic: matrice extrinseque de la camera gauche
/// @param mRightIntrinsic: matrice intrinseque de la camera droite
/// @param mRightExtrinsic: matrice extrinseque de la camera droite
/// @return matrice fondamentale
// -----------------------------------------------------------------------
Mat iviFundamentalMatrix(const Mat& mLeftIntrinsic,
                         const Mat& mLeftExtrinsic,
                         const Mat& mRightIntrinsic,
                         const Mat& mRightExtrinsic) {

    // Doit utiliser la fonction iviVectorProductMatrix
    Mat mFundamental = Mat::eye(3, 3, CV_64F);

    Mat reduc = (Mat_<double>(3,4) <<
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0
        );
    Mat p1 = mLeftIntrinsic * reduc * mLeftExtrinsic;
    Mat p2 = mRightIntrinsic * reduc * mRightExtrinsic;

    Mat iE1 = mLeftExtrinsic.inv();
    Mat o1 = iE1.col(3);

    mFundamental = iviVectorProductMatrix(p2 * o1) * p2 * p1.inv(DECOMP_SVD);

    // Retour de la matrice fondamentale
    return mFundamental;
}

// -----------------------------------------------------------------------
/// \brief Initialise et calcule la matrice des distances entres les
/// points de paires candidates a la correspondance.
///
/// @param mLeftCorners: liste des points 2D image gauche
/// @param mRightCorners: liste des points 2D image droite
/// @param mFundamental: matrice fondamentale
/// @return matrice des distances entre points des paires
// -----------------------------------------------------------------------
Mat iviDistancesMatrix(const Mat& m2DLeftCorners,
                       const Mat& m2DRightCorners,
                       const Mat& mFundamental) {
    // A modifier !
    Mat mDistances = Mat();
    // Retour de la matrice fondamentale
    return mDistances;
}

// -----------------------------------------------------------------------
/// \brief Initialise et calcule les indices des points homologues.
///
/// @param mDistances: matrice des distances
/// @param fMaxDistance: distance maximale autorisant une association
/// @param mRightHomologous: liste des correspondants des points gauche
/// @param mLeftHomologous: liste des correspondants des points droite
/// @return rien
// -----------------------------------------------------------------------
void iviMarkAssociations(const Mat& mDistances,
                         double dMaxDistance,
                         Mat& mRightHomologous,
                         Mat& mLeftHomologous) {
    // A modifier !
}
