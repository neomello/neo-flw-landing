---
description: Deploy Seguro da Landing Page
---

# Fluxo de Atualização - FlowOFF Landing

Use este workflow para garantir que a landing page seja atualizada sem erros visuais.

## Passos

1. **Verificação Visual** (Opcional)
   - Rodar `npm run dev` para abrir uma prévia local se as mudanças forem grandes.

2. **Sanidade de Código**
// turbo
   - Rodar `npx -y htmlhint *.html` para garantir que as tags estão fechadas.
   - Rodar `npx -y stylelint *.css` (opcional) para evitar erros de sintaxe no CSS.

3. **Check de Assets**
   - Garantir que todas as imagens em `public/` estão carregando (verificar se o arquivo existe se o caminho foi mudado).

4. **Commit e Push**
// turbo
   - `git add .`
   - `git commit -m "feat/fix: descrição da mudança"` seguindo Conventional Commits.
   - `git push origin main`

## Regras
- Nunca quebrar o caminho das imagens da `public/`.
- Sempre manter o design responsivo (Mobile First).
- Priorizar a performance de carregamento.
