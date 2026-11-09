# ONE STATE RP MARKET — versão PIX R$ 2 e anúncios públicos

## Já configurado
- Taxa de publicação: **R$ 2,00**.
- Chave PIX pública: **02102405206** (confirme a titularidade e o nome exibido pelo banco).
- Formulário de anúncios com status **pendente**; só anúncios **aprovados** são exibidos ao público após conectar o banco.
- Categorias: carros, armas virtuais e serviços exclusivamente fictícios do jogo.

## Ativar anúncios públicos com Supabase (necessário)
1. Crie um projeto em https://supabase.com e abra **SQL Editor**.
2. Cole e execute todo o conteúdo de `supabase.sql`.
3. Em **Project Settings / API** (ou **Connect**), copie a URL do projeto e a chave **publishable/anon**.
4. No `config.js`, preencha `supabaseUrl` e `supabaseAnonKey`. **Nunca coloque `service_role` ou senhas no site.**
5. Publique `index.html` e `config.js` no GitHub Pages: repositório > Settings > Pages > Deploy from a branch > main > / (root).
6. Teste um envio. O registro aparecerá na tabela `public.anuncios` com `status=pendente`.
7. Após verificar manualmente o PIX na sua conta bancária e conferir o anúncio, abra Supabase > Table Editor > anuncios e altere o `status` do registro para `aprovado`. Atualize o site para exibir.
8. Para rejeitar, altere para `rejeitado`. Não marque como aprovado apenas com base em comprovantes enviados por terceiros.

## Pagamentos
A chave PIX é apenas para pagamento manual. **Não existe cobrança automática, QR Code dinâmico, conciliação de pagamento, webhook ou liberação automática** nesta versão. Para isso, integre um provedor de pagamentos compatível com PIX, backend seguro (ex.: Supabase Edge Functions) e webhook validado no servidor. Nunca coloque credenciais secretas de pagamento no JavaScript público. O administrador precisa estabelecer um canal para receber o ID/identificação do anúncio e localizar o pagamento; não foi implementado um canal de comprovantes.

## Segurança e limitações
- GitHub Pages hospeda apenas o frontend; o Supabase hospeda os dados.
- A política RLS permite ao público ler somente aprovados e inserir somente pendentes. Atualizações e exclusões públicas são bloqueadas.
- Antes de divulgação em escala, implemente CAPTCHA, rate limiting, política de privacidade, moderação e mecanismos antifraude/spam.
- Qualquer pessoa com acesso ao site pode enviar anúncios pendentes; não há login de usuários.
- Não é afiliado ao One State RP. Respeite os termos do jogo e não permita itens, armas ou violência do mundo real.
