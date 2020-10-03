module.exports = {
  extends: 'standard',
  rules: {
    'no-undef': 'off',
    'space-before-function-paren': ['error', 'never'],
    'arrow-parens': ['error', 'always'],
    'max-len': ['warn', { code: 120 }],
    'no-unused-vars': 'warn',
    curly: ['error', 'all']
  }
}
