String getLanguageName(String lang) { // Return nullable
  switch (lang) {
    case 'en': return 'English';
    case 'cn': return 'Chinese';
    case 'hi': return 'Hindi';
    case 'es': return 'Spanish';
    case 'ar': return 'Arabic';
    case 'fr': return 'French';
    case 'ms': return 'Malay';
    case 'ru': return 'Русский';
    default: return null;
  }
}

String langToCountryCode(String lang) {
  switch (lang) {
    case 'en': return 'US';
    default: return lang.toUpperCase();
  }
}
