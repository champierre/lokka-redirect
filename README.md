# Lokka "Redirect" Plugin

This plugin is for the website using Lokka deployed on Heroku. The plugin can create any redirect rule. For example, this is useful for migrating from WordPress to Lokka, in case that you want to redirect URLs of WP style to those of Lokka style.

## Installation

    $ cd LOKKA_ROOT/public/plugin
    $ git clone git@github.com:champierre/lokka-redirect.git
    $ rm -rf lokka-redirect/.git

## Usage

If you want to redirect

http://example.com/archives/date/2007/11/

to

http://example.com/2007/11/

create the following rule from "rewrite" plugin admin page.

<table>
  <tr>
    <th>Pattern</th>
    <th>Substitution</th>
  </tr>
  <tr>
    <td>^/archives/date/(\d{4})/(\d{2})/*$</td>
    <td>/\1/\2/</td>
  </tr>
</table>

## Examples of Redirect Rules

<table>
  <tr>
    <th>Pattern</th>
    <th>Substitution</th>
  </tr>
  <tr>
    <td>^/archives/(\d+)/*$</td>
    <td>/\1</td>
  </tr>
  <tr>
    <td>^/archives/date/(\d{4})/(\d{2})/*$</td>
    <td>/\1/\2/</td>
  </tr>
  <tr>
    <td>^/archives/date/(\d{4})/*$</td>
    <td>/\1/</td>
  </tr>
</table>
