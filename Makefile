COFFEE = $(shell find src -name "*.coffee")
JS = $(COFFEE:src%.coffee=lib%.js)

all: bin/wach-watchdir $(JS)

lib/%.js : src/%.coffee
	./node_modules/.bin/coffee \
		--compile \
		--lint \
		--output lib $<

bin/wach-watchdir: src/watchdir.c
	clang \
		-Wall \
		-framework CoreServices \
		-o $@ $<

test : test-support

test-support :
	./node_modules/.bin/mocha test/support_test --ui qunit --bail --colors

tag:
	git tag `coffee -e "pkg = JSON.parse require('fs').readFileSync('package.json'); console.log 'v' + pkg.version"`

.PHONY: test tag
