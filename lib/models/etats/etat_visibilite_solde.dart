/// État d'affichage du solde : visible ou masqué.
enum EtatVisibiliteSolde { visible, masque }

extension EtatVisibiliteSoldeTransitions on EtatVisibiliteSolde {
  EtatVisibiliteSolde basculer() => this == EtatVisibiliteSolde.visible
      ? EtatVisibiliteSolde.masque
      : EtatVisibiliteSolde.visible;

  bool get estMasque => this == EtatVisibiliteSolde.masque;
}
