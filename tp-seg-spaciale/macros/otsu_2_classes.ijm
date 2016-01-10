// Une macro-squelette calculer OTSU.
// Version: 0.1
// Date: sept 2015
// Author: L. Macaire
// par calcul de chaque intervalle
// otsu 2 classes par minimisation intra classes
macro "otsu2class" {

	image = getImageID();

	W = getWidth();
	H = getHeight();

	run("Duplicate...", "title=binarisee");
	image_binaire = getImageID();

	// Obtenir l'histogramme des niveaux de gris dans la variable histo
	getHistogram(level, histo, 256);


	// <!--
	// Initialisation des valeurs utiles pour la méthode.

	// Soit omegai la probabilite qu'a un pixel
	// d'etre dans la classe Ci
	// Soit, omega1 + omega2 = 1
	omega1 = 0;
	omega2 = 0;

	// Sommes qui interviennent dans le calcul des mus
	somme1 = 0;
	somme2 = 0;

	// Moyennes des classes
	mu1 = 0;
	mu2 = 0;

	// Sommes qui interviennent dans le calcul des sigmas
	sSomme1 = 0;
	sSomme2 = 0;

	// sigmai est la variance de la classe Ci
	sigma1 = 0;
	sigma2 = 0;

	min_val = 99999999999999999999999;
	i_max = 255;
	intra = 0;
	// -->


	// DEBUT DU BATCH
	setBatchMode(true);


	for( k =2; k <255; k++)
	{

		omega1=0;
		somme1=0;
		omega2 = 0;
		somme2 = 0;

		for(t=0; t<k; t++)
		{
			omega1= omega1 + histo[t];
		}

		for(t=k; t<255; t++)
		{
			omega2= omega2 + histo[t];
		}


		///////MU

		for(t=0; t<k; t++)
		{
			somme1= somme1 +histo[t]*t;
		}

		for(t=k; t<255; t++)
		{
			somme2= somme2 + histo[t]*t;
		}


		if (omega1 * omega2 !=0)
		{

			mu1 = somme1 / omega1;
			mu2 = somme2 / omega2;


			///////Sigma

			sSomme1=0;
			sSomme2=0;

			for(t=0; t<k; t++)
			{
				sSomme1= sSomme1 +(t-mu1)*(t-mu1)*histo[t];
			}

			for(t=k; t<255; t++)
			{
				sSomme2= sSomme2 +(t-mu2)*(t-mu2)*histo[t];
			}

			sigma1 = sSomme1 / omega1;
			sigma2 = sSomme2 / omega2;


			intra = omega1*sigma1 + omega2*sigma2 ;


			if(min_val > intra)
			{
				k_min = k;
				min_val = intra;
			}

		} // if


	} // for t

	setBatchMode(false);

	selectImage(image_binaire);

	setThreshold(0,k_min);
	setOption("BlackBackground", false);
	run("Convert to Mask");

}
