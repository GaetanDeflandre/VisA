// @athour Gaetan DEFLANDRE
macro "multi_seuillage_couleur" {

  image = getImageID();

  // Recuperer nom et dossier de l'image
  name = getTitle();
  dir = getInfo("image.directory");

  // Split
  run("Split Channels");

  // Otsu 2 classes
  selectWindow(name + " (red)");
  runMacro(dir + "macros/otsu_2_classes.ijm");

  // Otsu 3 classes
  selectWindow(name + " (green)");
  runMacro(dir + "macros/otsu_3_classes.ijm");

  // Merge
  run("Merge Channels...", "c1=binarisee c2=RGB c3=[" + name + " (blue)]");

  // Fermeture des fenetres inutiles
  selectWindow(name + " (green)");
  close();
  selectWindow(name + " (red)");
  close();
}
