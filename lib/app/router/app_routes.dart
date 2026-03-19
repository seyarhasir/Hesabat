class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/home';
  static const products = '/products';
  static const customers = '/customers';
  static const helpFaq = '/settings/help-faq';

  static const protected = <String>{
    home,
    products,
    customers,
  };
}
