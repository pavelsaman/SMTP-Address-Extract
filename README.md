# SMPT::Address::Extract

A simple module for SMTP address and alias extraction.

## Description

**SMPT::Address::Extract** is a simple module for extracting SMTP addresses from the following Outlook format:

```
Pavel Saman <pavelsam@centrum.cz>[; alias <smtp_email_address>; ...]
```

It provides three functions:

### `addresses($str)`

Returns a list of SMTP addresses.

### `aliases($str)`

Returns a list of Outlook aliases.

### `parse($str)`

Returns both addresses and aliases as a list of hash references.

## Instalation

```
$ perl Makefile.PL
$ make
$ make test
# make install
```
