extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}

extension PokemonDoubleExtensions on double {
  bool get isSuperEffective {
    return this > 1;
  }

  bool get isNotVeryEffective {
    return this < 1;
  }

  bool get isImmune {
    return this == 0;
  }

  String get asSymbol {
    if (isImmune) {
      return '0';
    }
    if (isSuperEffective) {
      return '2';
    }
    if (isNotVeryEffective) {
      return '½';
    }
    return '';
  }
}
