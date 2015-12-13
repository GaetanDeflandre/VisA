import ij.IJ;
import ij.ImagePlus;
import ij.WindowManager;
import ij.gui.NewImage;
import ij.gui.Plot;
import ij.plugin.PlugIn;
import ij.process.ImageProcessor;

import java.awt.Color;
import java.util.Random;

import javax.swing.JOptionPane;

public class HCM_Visa_ implements PlugIn {

	class Vec {
		int[] data = new int[3]; // *pointeur sur les composantes*/
	}

	// //////////////////////////////////////////////////
	Random r = new Random();

	public int rand(int min, int max) {
		return min + (int) (r.nextDouble() * (max - min));
	}

	// //////////////////////////////////////////////////////////////////////////////////////////
	public void run(String arg) {

		// LES PARAMETRES

		ImageProcessor ip;
		ImageProcessor ipseg;
		ImageProcessor ipJ;
		ImagePlus imp;
		ImagePlus impseg;
		ImagePlus impJ;
		IJ.showMessage("Algorithme HCM", "If ready, Press OK");
		ImagePlus cw;

		imp = WindowManager.getCurrentImage();
		ip = imp.getProcessor();

		int width = ip.getWidth();
		int height = ip.getHeight();

		impseg = NewImage.createImage("Image segmentee par HCM", width, height,
				1, 24, 0);
		ipseg = impseg.getProcessor();
		impseg.show();

		int nbclasses, nbpixels, iter;
		double stab, seuil, valeurSeuil;
		int i, j, k, l, imax, jmax, kmax;

		String demande = JOptionPane.showInputDialog("Nombre de classes : ");
		nbclasses = Integer.parseInt(demande);
		nbpixels = width * height; // taille de l'image en pixels

		demande = JOptionPane.showInputDialog("Valeur de m : ");
		double m = Double.parseDouble(demande);

		demande = JOptionPane.showInputDialog("Nombre iteration max : ");
		int itermax = Integer.parseInt(demande);

		demande = JOptionPane
				.showInputDialog("Valeur du seuil de stabilite : ");
		valeurSeuil = Double.parseDouble(demande);

		demande = JOptionPane.showInputDialog("Randomisation amelioree ? ");
		int valeurRand = Integer.parseInt(demande);

		double c[][] = new double[nbclasses][3];
		double cprev[][] = new double[nbclasses][3];
		int cidx[] = new int[nbclasses];
		// double m;
		double Dmat[][] = new double[nbclasses][nbpixels];
		double Dprev[][] = new double[nbclasses][nbpixels];
		double Umat[][] = new double[nbclasses][nbpixels];
		double Uprev[][] = new double[nbclasses][nbpixels];
		double red[] = new double[nbpixels];
		double green[] = new double[nbpixels];
		double blue[] = new double[nbpixels];
		int[] colorarray = new int[3];
		int[] init = new int[3];
		double figJ[] = new double[itermax];

		for (i = 0; i < itermax; i++) {
			figJ[i] = 0;
		}

		// Recuperation des donnees images
		l = 0;
		for (i = 0; i < width; i++) {
			for (j = 0; j < height; j++) {
				ip.getPixel(i, j, colorarray);
				red[l] = (double) colorarray[0];
				green[l] = (double) colorarray[1];
				blue[l] = (double) colorarray[2];
				l++;
			}
		}

		// //////////////////////////////
		// HCM
		// /////////////////////////////

		imax = nbpixels; // nombre de pixels dans l'image
		jmax = 3; // nombre de composantes couleur
		kmax = nbclasses;
		double data[][] = new double[nbclasses][3];
		int[] fixe = new int[3];
		int xmin = 0;
		int xmax = width;
		int ymin = 0;
		int ymax = height;
		int rx, ry;
		int x, y;
		int epsilonx, epsilony;

		// Initialisation des centroides (aleatoirement)

		for (i = 0; i < nbclasses; i++) {
			if (valeurRand == 1) {
				epsilonx = rand((int) (width / (i + 2)), (int) (width / 2));
				epsilony = rand((int) (height / (4)), (int) (height / 2));
			} else {
				epsilonx = 0;
				epsilony = 0;
			}
			rx = rand(xmin + epsilonx, xmax - epsilonx);
			ry = rand(ymin + epsilony, ymax - epsilony);
			ip.getPixel(rx, ry, init);
			c[i][0] = init[0];
			c[i][1] = init[1];
			c[i][2] = init[2];
		}

		// Calcul de distance entre data et centroides
		for (j = 0; j < nbpixels; j++) {
			for (k = 0; k < kmax; k++) {
				double r2 = Math.pow(red[j] - c[k][0], 2);
				double g2 = Math.pow(green[j] - c[k][1], 2);
				double b2 = Math.pow(blue[j] - c[k][2], 2);

				// Pourquoi distance prev
				Dprev[k][j] = r2 + g2 + b2;
			}
		}

		// Initialisation des degres d'appartenance
		// A COMPLETER

		// Voir cours page 23
		for (i = 0; i < nbclasses; i++) {
			for (j = 0; j < nbpixels; j++) {
				Uprev[i][j] = 1;
			}
		}

		for (i = 0; i < nbclasses; i++) {
			for (j = 0; j < nbpixels; j++) {
				double membership = 1;
				for (k = 0; k < nbclasses; k++) {
					if (Dprev[k][j] <= Dprev[i][j] && k != i) {
						membership = 0;
					}
				}
				Uprev[i][j] = membership;
			}
		}

		// //////////////////////////////////////////////////////////
		// FIN INITIALISATION HCM
		// /////////////////////////////////////////////////////////

		// ///////////////////////////////////////////////////////////
		// BOUCLE PRINCIPALE
		// //////////////////////////////////////////////////////////
		iter = 0;
		stab = 2;
		seuil = valeurSeuil;

		// ///////////////// A COMPLETER ///////////////////////////////
		while ((iter < itermax) && (stab > seuil)) {

			// Update the matrix of centroids
			for (k = 0; k < kmax; k++) {
				double[] num = new double[3];
				double den = 0.0;

				num[0] = 0.0;
				num[1] = 0.0;
				num[2] = 0.0;

				for (l = 0; l < nbpixels; l++) {
					num[0] += Math.pow(Uprev[k][l], m) * red[l];
					num[1] += Math.pow(Uprev[k][l], m) * green[l];
					num[2] += Math.pow(Uprev[k][l], m) * blue[l];

					den += Math.pow(Uprev[k][l], m);
				}

				if (den > 0) {
					c[k][0] = num[0] / den;
					c[k][1] = num[1] / den;
					c[k][2] = num[2] / den;
				}
			}

			// Compute Dmat, the matrix of distances (euclidian) with the
			// centroids
			for (j = 0; j < nbpixels; j++) {
				for (k = 0; k < kmax; k++) {
					double r2 = Math.pow(red[j] - c[k][0], 2);
					double g2 = Math.pow(green[j] - c[k][1], 2);
					double b2 = Math.pow(blue[j] - c[k][2], 2);

					Dmat[k][j] = r2 + g2 + b2;
				}
			}

			// < Calcul des degres d'appartenance
			for (i = 0; i < nbclasses; i++) {
				for (j = 0; j < nbpixels; j++) {
					Umat[i][j] = 1;
				}
			}

			for (i = 0; i < nbclasses; i++) {
				for (j = 0; j < nbpixels; j++) {
					double membership = 1;
					for (k = 0; k < nbclasses; k++) {
						if (Dmat[k][j] <= Dmat[i][j] && k != i) {
							membership = 0;
						}
					}
					Umat[i][j] = membership;
				}
			}
			// >

			for (i = 0; i < kmax; i++) {
				for (l = 0; l < nbpixels; l++) {
					Dprev[i][l] = Dmat[i][l];
					Uprev[i][l] = Umat[i][l];
				}
			}

			// Calculate difference between the previous partition and the new
			// partition (performance index)
			for (i = 0; i < kmax; i++) {
				for (l = 0; l < nbpixels; l++) {
					figJ[iter] = Math.pow(Umat[i][l], m)
							* Math.pow(Dmat[i][l], 2);
				}
			}

			if (iter > 0)
				stab = figJ[iter] - figJ[iter - 1];

			iter++;
			// //////////////////////////////////////////////////////

			// Affichage de l'image segmentee
			double[] mat_array = new double[nbclasses];
			l = 0;
			for (i = 0; i < width; i++) {
				for (j = 0; j < height; j++) {
					for (k = 0; k < nbclasses; k++) {
						mat_array[k] = Umat[k][l];
					}
					int indice = IndiceMaxOfArray(mat_array, nbclasses);
					int array[] = new int[3];
					array[0] = (int) c[indice][0];
					array[1] = (int) c[indice][1];
					array[2] = (int) c[indice][2];
					ipseg.putPixel(i, j, array);
					l++;
				}
			}
			impseg.updateAndDraw();
			// ////////////////////////////////
		} // Fin boucle

		double[] xplot = new double[itermax];
		double[] yplot = new double[itermax];
		for (int w = 0; w < itermax; w++) {
			xplot[w] = (double) w;
			yplot[w] = (double) figJ[w];
		}
		Plot plot = new Plot("Performance Index (HCM)", "iterations",
				"J(P) value", xplot, yplot);
		plot.setLineWidth(2);
		plot.setColor(Color.blue);
		plot.show();
	} // Fin HCM

	int indice;
	double min, max;

	// Returns the maximum of the array

	public int IndiceMaxOfArray(double[] array, int val) {
		max = 0;
		for (int i = 0; i < val; i++) {
			if (array[i] > max) {
				max = array[i];
				indice = i;
			}
		}
		return indice;
	}

}
