// Demande la saisie d'une valeur en degré
// et ajout cette valeur au canal teinte
macro "change_hue" {

  // get image ID
  image = getImageID();

  // get number to add
  x = getNumber ("Valeur de teinte a ajouter (degre)", x);
  y = (x*256) / 360;

  // from RBG to HSB
  run("Color Space Converter", "from=RGB to=HSB white=D65");
  run("Split Channels");

  // add to hue channel
  selectWindow("it3_72pp.bmp (HSB) (red)");
  run("Add...", "value=" + y);

  // rebuild RGB image
  run("Merge Channels...", "c1=[it3_72pp.bmp (HSB) (red)] c2=[it3_72pp.bmp (HSB) (green)] c3=[it3_72pp.bmp (HSB) (blue)]");
  run("Color Space Converter", "from=HSB to=RGB white=D65");
}
