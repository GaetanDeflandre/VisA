// Une macro-squelette calculer OTSU.
// Version: 0.1
// Date: sept 2015
// Author: L. Macaire
// par calcul de chaque intervalle
macro "otsu" {

	image = getImageID();

	W = getWidth();
	H = getHeight();

	run("Duplicate...", "title=class1");
	image_class12 = getImageID();
	run("Duplicate...", "title=class3");
	image_class23 = getImageID();

	getHistogram (level,histo,256);

	// affichage de l'histogramme
	for ( i =0 ; i<= 255; i++)
	{
		print ("histo[",level[i],"] =", histo[i]);
	}


	// valeur initiale de omega1 mu1 omega2 mu2
	omega1=0;
	somme1=0;
	omega2 = 0;
	somme2 = 0;
	omega3 = 0;
	somme3 = 0;

	mu1 = 0;
	mu2 = 0;
	mu3 = 0

	sSomme1 = 0;
	sSomme2 = 0;
	sSomme3 = 0;

	sigma1 = 0;
	sigma2 = 0;
	sigma3 = 0;

	min_val = 99999999999999999999999;
	i_max = 255;
	intra=0;

	sum =0;

	for(t=0; t<255; t++){
		sum = sum + histo[t];
	}

	for(k1=2; k1<253; k1++){

		for(k2=4; k2<255; k2++){
			omega1 = 0;
			somme1 = 0;
			omega2 = 0;
			somme2 = 0;
			omega3 = 0;
			somme3 = 0;

			for(t=0; t<k1; t++){
				omega1 = omega1 + histo[t];
			}

			for(t=k1; t<k2; t++){
				omega2 = omega2 + histo[t];
			}

			for(t=k2; t<255; t++){
				omega3 = omega3 + histo[t];
			}


			///////MU

			for(t=0; t<k1; t++)
			{
				somme1 = somme1 +histo[t]*t;
			}min_val1 = 99999999999999999999999;

			for(t=k1; t<k2; t++)
			{
				somme2 = somme2 + histo[t]*t;
			}

			for(t=k2; t<255; t++)
			{
				somme3 = somme3 + histo[t]*t;
			}


			if (omega1 * omega2 * omega3 != 0)
			{

				mu1 = somme1 / omega1;
				mu2 = somme2 / omega2;
				mu3 = somme3 / omega3;

				print("k1=",k1);
				print("k2=",k2);
				print("mu1=",mu1);
				print("mu2=",mu2);
				print("mu3=",mu3);


				///////Sigma

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

				print ("sigma1=",sigma1);
				print ("sigma2=",sigma2);
				print ("sigma3=",sigma3);

				intra = omega1*sigma1 + omega2*sigma2 + omega3*sigma3;

				if(min_val > intra){
					k1_min = k1;
					k2_min = k2;
					min_val = intra;
				}


			} // end if

		} // end for k2

	} // end for k1

	print("seuil k1=",k1_min);
	print("seuil k2=",k2_min);

	// segmentation de la class 1 et 2
	selectImage(image_class12);
	setThreshold(0,k1_min);
	run("Convert to Mask");

	// segmentation de la class 2 et 3
	selectImage(image_class23);
	setThreshold(0,k2_min);
	run("Convert to Mask");

	// assemblage des masques 1/2 et 2/3 en image RGB
	run("Merge Channels...", "c1=class3 c2=class1 c3=class1");

	Dialog.create("Fin");
	Dialog.addMessage(" Cliquer sur OK pour terminer le traitement sur la saturation");
	Dialog.show();


}
