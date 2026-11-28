# Runs in CT103. Builds the patched code-server page from the saved original.
d = '/opt/code/patch/'
o = open(d + 'workbench.html.orig').read()
js = open(d + 'keyboard-fix.js').read()
assert '</script' not in js.lower()
assert o.count('</body>') == 1
tag = '<script nonce="{{WORKBENCH_SCRIPT_NONCE}}">\n' + js + '\n</script>\n'
open(d + 'workbench.html', 'w').write(o.replace('</body>', tag + '</body>'))
print('built, bytes:', len(o) + len(tag))
