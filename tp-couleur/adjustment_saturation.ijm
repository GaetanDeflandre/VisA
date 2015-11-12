// Demande la saisie d'une valeur
// et multiplie la saturation avec cette valeur.
macro "adjustment_saturation" {

  // Convertir en HSB
	run("Color Space Converter", "from=RGB to=HSB white=D65");

  run("Split Channels");

  // Multiplier la saturation
	selectWindow("it3_72pp_saturation_faible.bmp (HSB) (green)");
  // Demande un nombre 
  mult = getNumber ("Multiplier la saturation par:", mult);
	run("Multiply...", "value=" + mult);
	run("Merge Channels...", "c1=[it3_72pp_saturation_faible.bmp (HSB) (red)] c2=[it3_72pp_saturation_faible.bmp (HSB) (green)] c3=[it3_72pp_saturation_faible.bmp (HSB) (blue)]");
	run("Color Space Converter", "from=HSB to=RGB white=D65");

}
