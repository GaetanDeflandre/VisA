// Une macro-squelette calculer OTSU.
// Version: 0.1
// Date: sept 2010
// Author: L. Macaire
 
macro "modification_saturation" {

// récupération du ID de l'image
image = getImageID();

// récupération de la taille W x H 
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
for ( i =0 ; i< 255; i++)
	{
	omega1=histo[i]+ omega1;
	somme1=i*histo[i]+ somme1;
	}

mu1 = somme1/omega1;

somme2 = 0;
omega2= histo[255];
mu2=255;


max_sigma_between = omega1 * omega2 * ( mu1 - mu2) * (mu1 - mu2);
i_max = 255;

for (val = 1; val <255;val++)

	{

	i = 255 -val;	

	omega1 = omega1 - histo[i];
	omega2 = omega2 + histo[i];

	somme1 = somme1 -  histo[i] * i;
	somme2 = somme2 +  histo[i] * i;

	print ("i=",i,"omega1=",omega1,"somme1=",somme1,"omega2=",omega2,"somme2=",somme2);

	
	if (omega1 * omega2 !=0)
		{
		
		print ("cond verifiee");
	
		mu1 = somme1/omega1;
		mu2 = somme2/omega2;
	
		sigma_between = omega1 * omega2 * ( mu1 - mu2) * (mu1 - mu2);
	
		if (sigma_between > max_sigma_between)
			{
			i_max = i;
			max_sigma_between = sigma_between;
			}

		}
	}

selectImage(image_binaire);
print ("seuil i_max=",i_max);
setThreshold(0,i_max);
run("Convert to Mask");

}

Dialog.create("Fin");
Dialog.addMessage(" Cliquer sur OK pour terminer le traitement sur la saturation");
Dialog.show();


}
