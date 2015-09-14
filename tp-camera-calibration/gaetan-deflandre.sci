// -----------------------------------------------------------------------
/// \brief Calcule un terme de contrainte a partir d'une homographie.
///
/// \param H: matrice 3*3 définissant l'homographie.
/// \param i: premiere colonne.
/// \param j: deuxieme colonne.
/// \return vecteur definissant le terme de contrainte.
// -----------------------------------------------------------------------
function v = ZhangConstraintTerm(H, i, j)
  
  // /!\ matrice scilab: M(y,x), soit M(row,col)
  
  // La matrice non transposer
  w = [];
  w(1) = H(1,i) * H(1,j);
  w(2) = (H(1,i) * H(2,j)) + (H(2,i) * H(1,j));
  w(3) = H(2,i) * H(2,j);
  w(4) = (H(3,i) * H(1,j)) + (H(1,i) * H(3,j));
  w(5) = (H(3,i) * H(2,j)) + (H(2,i) * H(3,j));
  w(6) = H(3,i) * H(3,j);
  
  // Transposée de w
  v = w';
endfunction

// -----------------------------------------------------------------------
/// \brief Calcule deux equations de contrainte a partir d'une homographie
///
/// \param H: matrice 3*3 définissant l'homographie.
/// \return matrice 2*6 definissant les deux contraintes.
// -----------------------------------------------------------------------
function v = ZhangConstraints(H)
  v = [ZhangConstraintTerm(H, 1, 2); ...
    ZhangConstraintTerm(H, 1, 1) - ZhangConstraintTerm(H, 2, 2)];
endfunction

// -----------------------------------------------------------------------
/// \brief Calcule la matrice des parametres intrinseques.
///
/// \param b: vecteur resultant de l'optimisation de Zhang.
/// \return matrice 3*3 des parametres intrinseques.
// -----------------------------------------------------------------------
function A = IntrinsicMatrix(b)
  A = zeros(3, 3);
  
  A(3,3) = 1;
  
  v0 = (b(2)*b(4) - b(1)*b(5)) / (b(1)*b(3) - b(2)*b(2));
  lambda = b(6) - ( (b(4)*b(4) + v0*(b(2)*b(4) - b(1)*b(5))) / b(1) );
  alpha = sqrt(lambda/b(1));
  mybeta = sqrt((lambda*b(1)) / (b(1)*b(3) - b(2)*b(2)))
  mygamma = ((-b(2)) * alpha * alpha * mybeta) / lambda;
  u0 = (mygamma*v0)/mybeta -(b(4)*alpha*alpha)/lambda;
  
  A(1,1) = alpha;
  A(1,2) = mygamma;
  A(1,3) = u0;
  A(2,2) = mybeta;
  A(2,3) = v0;
endfunction

// -----------------------------------------------------------------------
/// \brief Calcule la matrice des parametres extrinseques.
///
/// \param iA: inverse de la matrice intrinseque.
/// \param H: matrice 3*3 definissant l'homographie.
/// \return matrice 3*4 des parametres extrinseques.
// -----------------------------------------------------------------------
function E = ExtrinsicMatrix(iA, H)
  
  lambda = 1 / norm(iA*H(:,1));
  
  r1 = lambda * iA * H(:,1);
  r2 = lambda * iA * H(:,2);
  r3 = r1 .* r2;
  t = lambda * iA * H(:,3);
  
  E = [r1,r2,r3,t];
  disp(E);
endfunction

