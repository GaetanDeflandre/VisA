// Une macro-squelette calculer OTSU.
// Version: 0.1
// Date: sept 2015
// Author: L. Macaire
 // par calcul de chaque intervalle
macro "otsu" {

image = getImageID();

W = getWidth();
H = getHeight();

run("Duplicate...", "title=binarisee");
image_binaire = getImageID();

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

mu1 =0;
mu2 =0;

sSomme1=0;
sSomme2=0;

sigma1=0;
sigma2=0;

min_val = 99999999999999999999999;
i_max = 255;
intra=0;

sum =0;

for(t=0; t<255; t++){
		sum= sum + histo[t];
		}

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

print ("k=",k);
print ("mu1=",mu1);
print ("mu2=",mu2);


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

				print ("sigma1=",sigma1);
				print ("sigma2=",sigma2);

				intra = omega1*sigma1 + omega2*sigma2 ;


				if(min_val > intra)
				{
					k_min = k;
					min_val = intra;
				}

			} // if


		} // for t

selectImage(image_binaire);
print ("seuil k=",k_min);
setThreshold(0,k_min);
run("Convert to Mask");



Dialog.create("Fin");
Dialog.addMessage(" Cliquer sur OK pour terminer le traitement sur la saturation");
Dialog.show();


}
