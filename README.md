Spree Group Pricing
===================

[![Build Status](https://secure.travis-ci.org/jdutil/spree_group_pricing.png)](http://travis-ci.org/jdutil/spree_group_pricing)
[![Code Climate](https://codeclimate.com/github/jdutil/spree_group_pricing.png)](https://codeclimate.com/github/jdutil/spree_group_pricing)
[![Coverage Status](https://coveralls.io/repos/jdutil/spree_group_pricing/badge.png?branch=master)](https://coveralls.io/r/jdutil/spree_group_pricing)
[![Dependency Status](https://gemnasium.com/jdutil/spree_group_pricing.png?travis)](https://gemnasium.com/jdutil/spree_group_pricing)

Group Pricing is an extension to Spree that uses predefined ranges of sale quantities to determine the price for a particular product variant.  For instance, this allows you to set a price for group purchases between 1-10, another price for purchases between (10-100) and another for purchases of 100 or more.  If no group price is defined for a variant, then the standard price is used.

This differs from the Spree Volume Pricing extension in that the volume pricing is based upon what quantity of a variant you are currently ordering.  Where as Spree Group Pricing will calculate pricing based upon what quantity of a variant have been sold in all completed orders.

NOTE: If you want all orders of the product to receive the group purchase price then you cannot collect payment for orders until after you have received all orders, updated the price & order totals, and then capture payment.  At the moment it is required for you to implement this within your application yourself.

Each GroupPrice contains the following values:

1. **Variant:** Each GroupPrice is associated with a _Variant_, which is used to link products to particular prices.
1. **Name:** The human readable reprentation of the quantity range (Ex. 10-100).  (Optional)
1. **Discount Type** The type of discount to apply.  **Price:** sets price to the amount specified. **Dollar:** subtracts specified amount from the Variant price.  **Percent:** subtracts the specified amounts percentage from the Variant price.
1. **Range:** The group order range for which the price is valid (See Below for Examples of Valid Ranges.)
1. **Amount:** The price of the product if the ordered quantity falls within the specified range.
1. **Position:** Integer value for `acts_as_list` (Helps keep the group prices in a defined order.)

Installation
------------

Here's how to install spree_group_pricing into your existing spree site:

Add the following to your Gemfile:

    gem 'spree_group_pricing', github: 'jdutil/spree_group_pricing'

Make your bundle happy:

    bundle install

Now run the generator:

    rails g spree_group_pricing:install

Then migrate your database if you did not run during installation generator:

    bundle exec rake db:migrate

And reboot your server:

    rails s

You should be up and running now!

Ranges
------

Ranges are expressed as Strings and are similar to the format of a Range object in Ruby.  The lower number of the range is always inclusive.  If the range is defined with '..' then it also includes the upper end of the range.  If the range is defined with '...' then the upper end of the range is not inclusive.

Ranges can also be defined as "open ended."  Open ended ranges are defined with an integer followed by a '+' character.  These ranges are inclusive of the integer and any value higher then the integer.

All ranges need to be expressed as Strings and must include parentheses.  "(1..10)" is considered to be a valid range. "1..10" is not considered to be a valid range (missing the parentheses.)

Examples
--------

Consider the following examples of group prices:

       Variant                Name               Range        Amount         Position
       -------------------------------------------------------------------------------
       Rails T-Shirt          1-5                (1..5)       19.99          1
       Rails T-Shirt          6-9                (6...10)     18.99          2
       Rails T-Shirt          10 or more         (10+)        17.99          3

## Example 1

Cart Contents:

       Product                Quantity       Price       Total
       ----------------------------------------------------------------
       Rails T-Shirt          1              19.99       19.99

## Example 2

Cart Contents:

       Product                Quantity       Price       Total
       ----------------------------------------------------------------
       Rails T-Shirt          5              19.99       99.95

## Example 3

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          6              18.99       113.94

## Example 4

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          10             17.99       179.90

## Example 5

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          20             17.99       359.80


Additional Notes
----------------

* The group price is applied based on the total quantity ordered for a particular variant across all orders.  It does not apply different prices for the portion of the quantity that falls within a particular range.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

Contributing
------------

In the spirit of [free software][1], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][2]
* by suggesting new features
* by [translating to a new language][3]
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][2]
* by reviewing patches

Donating
--------

Bitcoin donations may be sent to: 1Fuh36ttnERYqsrnLW6NmxE8pXoFDNTSn6

Copyright (c) 2014 [Jeff Dutil][4] and [contributors][5], released under the [New BSD License][6].

[1]: http://www.fsf.org/licensing/essays/free-sw.html
[2]: https://github.com/jdutil/spree_group_pricing/issue
[3]: https://github.com/jdutil/spree_group_pricing/tree/master/config/locale
[4]: https://github.com/jdutil
[5]: https://github.com/jdutil/spree_group_pricing/graphs/contributors
[6]: https://github.com/jdutil/spree_group_pricing/blob/master/LICENSE.md
