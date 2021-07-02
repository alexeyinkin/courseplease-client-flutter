String? getLanguageName(String lang) {
  switch (lang) {
    case 'en': return 'English';
    case 'cn': return 'Chinese';
    case 'hi': return 'Hindi';
    case 'es': return 'Spanish';
    case 'ar': return 'Arabic';
    case 'fr': return 'French';
    case 'ms': return 'Malay';
    case 'ru': return 'Русский';

    case 'by': return 'Belarusian';
  }
  return null;
}

String langToCountryCode(String lang) {
  switch (lang) {
    case 'ar': return 'arabic';
    case 'en': return 'GB';   // English      -> Great Britain
    case 'hi': return 'IN';   // Hindi        -> India
    case 'ms': return 'ID';   // Malay        -> Indonesia
    default: return lang.toUpperCase();
  }
}
