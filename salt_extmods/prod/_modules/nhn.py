def test():
    return 'hello world, base prod'

def test_param(a, b, c, d=None):
    return 'hello, a: {}, b: {}, c: {}, d: {}'.format(a,b,c,d)

def salt_module(cmd):
    __salt__['cmd.run_all']('whoami\n{}'.format(cmd), runas='test')
