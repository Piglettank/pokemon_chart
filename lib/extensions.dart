extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}

extension PokemonDoubleExtensions on double {
  bool get isHyperEffective {
    return this == 4;
  }

  bool get isSuperEffective {
    return this > 1;
  }

  bool get isNotVeryEffective {
    return this > 0 && this < 1;
  }

  bool get isVeryNotEffective {
    return this == 0.25;
  }

  bool get isImmune {
    return this == 0;
  }

  String get asSymbol {
    if (isImmune) {
      return '0';
    }
    if (isHyperEffective) {
      return '4';
    }
    if (isVeryNotEffective) {
      return '¼';
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
