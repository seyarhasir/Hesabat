class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/home';
  static const products = '/products';
  static const customers = '/customers';

  static const protected = <String>{
    home,
    products,
    customers,
  };
}
