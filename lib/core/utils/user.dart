class User {
  // Normally, you get the customerId by creating a customer in Stripe.
  // This is done via a POST request to https://api.stripe.com/v1/customers
  // using `Content-Type: application/x-www-form-urlencoded` and your Stripe secret key as Bearer token.
  // When you create a user account in your app, you should also create a Stripe customer at that point
  // and store the returned customerId to associate it with your user.
  // More details:
  // https://docs.stripe.com/api/customers/create
  // https://docs.page/flutter-stripe/flutter_stripe/sheet
  static const stripeCustomerId = 'cus_Sg5ipHCE1QWTqY';
}
