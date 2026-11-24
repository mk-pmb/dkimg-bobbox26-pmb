
<!--#echo json="package.json" key="name" underline="=" -->
dkimg-bobbox26-pmb
==================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
A kitchen sink docker image.
<!--/#echo -->



What's in the box?
------------------

* Node.js (our base image)
  * You project should live in `/app`, even if you don't use node.js.
* A default non-root user "bob".
* A default hostname. "box".
* Repos pre-cloned into `/usr/lib`:
  * https://github.com/mk-pmb/github-ci-util-2405-pmb/
  * https://github.com/mk-pmb/text-util-pmb/
  * `dkimg-bobbox26-pmb` – self-insert so we can easily use all our scripts,
    especially `src/entrypoint.sh`.
* npm packages pre-installed into `/usr/lib/node_modules`:
  * enveval2401-pmb
  * inetd-util-pmb
* Python 3
  * pip3 upgraded to latest
  * uv
* Perl 5
* Busybox: On standby, in case you want it.
  * Don't worry, we keep and embrace the proper GNU coreutils
    from the node.js image.
  * If a directory `/var/www/htdocs` exists at container start
    (e.g. because you mounted a docker volume), busybox httpd is auto-started.
    CGIs go in `/var/www/htdocs/cgi-bin`.



Usage
-----

```bash
docker run --interactive --tty ghcr.io/mk-pmb/dkimg-bobbox26-pmb:latest
```




Known issues
------------

* Vaporware.





<!--#toc stop="scan" -->

&nbsp;


License
-------
<!--#echo json="package.json" key="license" -->
ISC
<!--/#echo -->
