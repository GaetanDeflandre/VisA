// Une macro qui calcul trois classes avec la méthode d'Otsu.
// Nous nommons ces trois classes C1, C2, C3.
//
// Version: 0.2
// Date: nov 2015
// Author: L. Macaire, G. Deflandre
// par calcul de chaque intervalle
macro "otsu" {

	image = getImageID();

	// Largeur et hauteur de l'image
	W = getWidth();
	H = getHeight();

	// Creation de l'image utile pour la segmentation
	// de la classe C1 et des classes C2, C3
	run("Duplicate...", "title=mask1_23");
	seg_class1_class23 = getImageID();

	// Creation de l'image utile pour la segmentation
	// des la classes C1, C2 et de la classe C3
	run("Duplicate...", "title=mask12_3");
	seg_class12_class3 = getImageID();

	getHistogram (level,histo,256);

	// <!--
	// Initialisation des valeurs utiles pour la méthode.

	// Soit omegai la probabilite qu'a un pixel
	// d'etre dans la classe Ci
	// Soit, omega1 + omega2 + omega3 = 1
	omega1 = 0;
	omega2 = 0;
	omega3 = 0;

	// Sommes qui interviennent dans le calcul des mus
	somme1 = 0;
	somme2 = 0;
	somme3 = 0;

	// Moyennes des classes
	mu1 = 0;
	mu2 = 0;
	mu3 = 0;

	// Sommes qui interviennent dans le calcul des sigmas
	sSomme1 = 0;
	sSomme2 = 0;
	sSomme3 = 0;

	// sigmai est la variance de la classe Ci
	sigma1 = 0;
	sigma2 = 0;
	sigma3 = 0;

	min_val = 99999999999999999999999;
	i_max = 255;
	intra = 0;
	// -->

	setBatchMode(true);

	// Dans le cas de la segmentation en 3 classes, nous
	// cherchons 2 niveaux k1 et k2. Le niveau k1 permet
	// la separation de la classe C1 des classes C2, C3.
	// Le niveau k2 permet la separation des classes C1, C2
	// de la classe C3.

	// Les pixels de la classe C1 sont entre 0 et k1.
	// Les pixels de la classe C2 sont entre k1 et k2.
	// Les pixels de la classe C3 sont entre k2 et 255.

	for(k1=2; k1<253; k1++){

		for(k2=4; k2<255; k2++){

			// Reinitialisation des omegas et des sommes
			omega1 = 0;
			omega2 = 0;
			omega3 = 0;

			somme1 = 0;
			somme2 = 0;
			somme3 = 0;

			// <!--
			// Calcul des omegas, voir equation (2), [Otsu, 1979]

			// Calcul de la probabilite pour la classe C1
			for(t=0; t<k1; t++){
				omega1 = omega1 + histo[t];
			}

			// Calcul de la probabilite pour la classe C2
			for(t=k1; t<k2; t++){
				omega2 = omega2 + histo[t];
			}

			// Calcul de la probabilite pour la classe C3
			for(t=k2; t<255; t++){
				omega3 = omega3 + histo[t];
			}
			// -->


			// <!--
			// Calcul des sommes utiles aux calculs des mus
			for(t=0; t<k1; t++)
			{
				somme1 = somme1 +histo[t]*t;
			}

			for(t=k1; t<k2; t++)
			{
				somme2 = somme2 + histo[t]*t;
			}

			for(t=k2; t<255; t++)
			{
				somme3 = somme3 + histo[t]*t;
			}
			// -->


			if (omega1 * omega2 * omega3 != 0)
			{

				// <!--
				// Calcul des mus, voir equation (4, 5), [Otsu, 1979]
				mu1 = somme1 / omega1;
				mu2 = somme2 / omega2;
				mu3 = somme3 / omega3;
				// -->

				// <!--
				// Calcul des sigmas, les variances des classes.
				// Voir equation (10, 11), [Otsu, 1979]
				sSomme1 = 0;
				sSomme2 = 0;
				sSomme3 = 0;

				for(t=0; t<k1; t++)
				{
					sSomme1 = sSomme1 +(t-mu1)*(t-mu1)*histo[t];
				}

				for(t=k1; t<k2; t++)
				{
					sSomme2= sSomme2 +(t-mu2)*(t-mu2)*histo[t];
				}

				for(t=k2; t<255; t++)
				{
					sSomme3= sSomme3 +(t-mu3)*(t-mu3)*histo[t];
				}

				sigma1 = sSomme1 / omega1;
				sigma2 = sSomme2 / omega2;
				sigma3 = sSomme3 / omega3;
				// -->

				// <!--
				// Pour toutes les iterations (tous les seuils possibles),
				// on cherche les seuils qui minimisent les variances
				// intra-classe, pour les classes C1, C2 et C3.

				// Calcul de la variance intra-classe
				intra = omega1*sigma1 + omega2*sigma2 + omega3*sigma3;

				// Minimisation
				if(min_val > intra){
					// seuil minimisant la variance intra C1 C2
					k1_min = k1;
					// seuil minimisant la variance intra C2 C3
					k2_min = k2;
					min_val = intra;
				}
				// -->

			} // end if

		} // end for k2

	} // end for k1

	setBatchMode(false);

	// Segmentation de la classe C1 et des classes C2, C3
	selectImage(seg_class1_class23);
	setThreshold(0,k1_min);
	run("Convert to Mask");

	// Segmentation des classes C1, C2 et de la classe C3
	selectImage(seg_class12_class3);
	setThreshold(0,k2_min);
	run("Convert to Mask");

	// Assemblage des classes C1, C2 et C2 en image RGB
	// afin de distinguer les trois classes
	run("Merge Channels...", "c1=mask12_3 c2=mask1_23 c3=mask1_23");

}
