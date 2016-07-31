vinefeed
========

Simple Express app which gets an RSS/Atom feed for a particular vine.co user.

Setting up
----------

1. Clone repository
2. Install dependencies with `npm install`
3. Start server with `bin/www` (or use Forever or similar), or [configure systemd to start it automatically](#Usage-with-systemd)
4. Go to `localhost:3000/users/<vine-user-id>/atom` or 
   `localhost:3000/users/<vine-user-id>/rss`

Usage with systemd
------------------

1. Globally install vinefeed with `npm install -g`
2. Copy or link `vinefeed.service` and `vinefeed.socket`
   to a systemd units directory,
    e.g. `/usr/lib/systemd/system` or `~/.config/systemd/user`
3. Start them via `systemctl start vinefeed.socket`
4. Go to `localhost:3000/users/<vine-user-id>/atom` or
   `localhost:3000/users/<vine-user-id>/rss`
5. To permanently enable the service, execute `systemctl enable vinefeed.socket`

To do
-----

- Caching
- Front page

Licence
-------

Assume GPL3 but ask.
