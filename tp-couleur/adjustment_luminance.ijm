// Demande la saisie d'une valeur
// et ajout cette valeur aux pixel de l'image
macro "adjustment_luminance" {

  // recuperation du ID de l'image
  image = getImageID();

  phi = getNumber ("Quelle augmentation (absolue) de luminance", phi);

  // Creation d'une image avec le niveau de gris phi
  newImage("phi_img", "8-bit black", 264, 264, 1);
  setForegroundColor(phi, phi, phi);
  run("Select All");
  run("Fill", "slice");
  run("Select None");

  // Addition de l'image sombre et de l'image créer
  imageCalculator("Add create", image,"phi_img");

  // On forme la fenetre inutile
  selectWindow("phi_img");
  close();

}
