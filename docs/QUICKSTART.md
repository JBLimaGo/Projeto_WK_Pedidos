# Quick Start Guide - Projeto WK Pedidos

## 📋 Pré-requisitos

1. **Delphi 10.4 Sydney** ou superior instalado
2. **MySQL Server 5.7+** ou **MariaDB 10.x**
3. **Driver MySQL** para FireDAC configurado

## 🚀 Instalação e Configuração

### Passo 1: Clonar o Repositório

```bash
git clone https://github.com/JBLimaGo/Projeto_WK_Pedidos.git
cd Projeto_WK_Pedidos
```

### Passo 2: Configurar o Banco de Dados

1. Inicie o MySQL Server
2. Execute o script de criação do banco:

```bash
mysql -u root -p < database/create_database.sql
```

Ou manualmente no MySQL Workbench:
- Abra o arquivo `database/create_database.sql`
- Execute todas as queries

Isso irá:
- ✅ Criar o banco de dados `pedidos`
- ✅ Criar as tabelas (clientes, produtos, pedidos, pedidos_produtos)
- ✅ Inserir dados de exemplo para testes

### Passo 3: Configurar a Conexão

Edite o arquivo `src/DAO/DAO.Conexao.pas` e ajuste os parâmetros de conexão:

```pascal
procedure TConexao.ConfigurarConexao;
begin
  FConexao.Params.Clear;
  FConexao.Params.Add('DriverID=MySQL');
  FConexao.Params.Add('Server=localhost');      // Seu servidor MySQL
  FConexao.Params.Add('Port=3306');             // Porta do MySQL
  FConexao.Params.Add('Database=pedidos');      // Nome do banco
  FConexao.Params.Add('User_Name=root');        // Seu usuário
  FConexao.Params.Add('Password=');             // Sua senha
  FConexao.Params.Add('CharacterSet=utf8mb4');
  
  FConexao.LoginPrompt := False;
end;
```

### Passo 4: Compilar e Executar

1. Abra o Delphi 10.4 Sydney
2. Abra o projeto: `ProjetoWKPedidos.dproj`
3. Compile: **Project → Build ProjetoWKPedidos** (ou `Shift+F9`)
4. Execute: **Run → Run** (ou `F9`)

## ✅ Verificação

Ao executar a aplicação:

1. Uma janela principal será exibida
2. Um teste de conexão será executado automaticamente
3. Se conectado com sucesso, aparecerá a mensagem: **"Conexão com banco de dados estabelecida com sucesso!"**

### Menu Principal

- **Cadastros**
  - Clientes (em desenvolvimento)
  - Produtos (em desenvolvimento)
  
- **Movimentos**
  - Pedidos (em desenvolvimento)
  
- **Sair**

## 🔍 Verificar Dados de Teste

Para verificar se os dados foram inseridos corretamente:

```sql
-- Ver clientes cadastrados
SELECT * FROM pedidos.clientes;

-- Ver produtos cadastrados
SELECT * FROM pedidos.produtos;

-- Ver pedidos existentes
SELECT * FROM pedidos.pedidos;

-- Ver itens dos pedidos
SELECT * FROM pedidos.pedidos_produtos;
```

## 📂 Estrutura do Projeto

```
Projeto_WK_Pedidos/
├── ProjetoWKPedidos.dpr        # Projeto principal
├── ProjetoWKPedidos.dproj      # Arquivo de projeto Delphi
├── src/
│   ├── Model/                  # Entidades de domínio
│   ├── View/                   # Interface com usuário
│   ├── Controller/             # Lógica de negócio
│   └── DAO/                    # Acesso a dados
├── database/                   # Scripts SQL
└── docs/                       # Documentação
```

## 🎯 Funcionalidades Implementadas

### Classes de Modelo (POO)
- ✅ `TCliente` - Entidade cliente com validações
- ✅ `TProduto` - Entidade produto com validações
- ✅ `TPedido` - Entidade pedido (agregação)
- ✅ `TItemPedido` - Item de pedido (composição)

### Data Access Objects (DAO)
- ✅ `TConexao` - Singleton para gerenciar conexão
- ✅ `TClienteDAO` - CRUD de clientes
- ✅ `TProdutoDAO` - CRUD de produtos
- ✅ `TPedidoDAO` - CRUD de pedidos com transações

### Controllers
- ✅ `TClienteController` - Lógica de negócio de clientes
- ✅ `TProdutoController` - Lógica de negócio de produtos
- ✅ `TPedidoController` - Lógica de negócio de pedidos

### Views
- ✅ `TFormPrincipal` - Tela principal da aplicação

## 🐛 Solução de Problemas

### Erro: "Cannot connect to MySQL server"

**Solução:**
1. Verifique se o MySQL está rodando
2. Confira usuário e senha em `DAO.Conexao.pas`
3. Teste a conexão manualmente com MySQL Workbench

### Erro: "Table doesn't exist"

**Solução:**
1. Execute novamente o script `database/create_database.sql`
2. Verifique se o banco `pedidos` foi criado
3. Confirme que está conectando ao banco correto

### Erro: "Access denied for user"

**Solução:**
1. Verifique as credenciais em `DAO.Conexao.pas`
2. Garanta que o usuário tem permissões no banco `pedidos`
3. Execute no MySQL:
   ```sql
   GRANT ALL PRIVILEGES ON pedidos.* TO 'root'@'localhost';
   FLUSH PRIVILEGES;
   ```

### Erro de Compilação: "Unit not found"

**Solução:**
1. Verifique se todos os arquivos `.pas` estão no projeto
2. Confira o Search Path do projeto
3. Recompile todo o projeto com **Build All**

## 📚 Próximos Passos

Para expandir o projeto:

1. **Implementar Forms Completos**
   - Formulário de cadastro de clientes
   - Formulário de cadastro de produtos
   - Formulário de criação de pedidos

2. **Adicionar Funcionalidades**
   - Relatórios de pedidos
   - Busca avançada
   - Exportação de dados

3. **Melhorias**
   - Testes unitários
   - Logs de sistema
   - Backup automático

## 📖 Documentação Adicional

- [README.md](../README.md) - Documentação completa do projeto
- [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - Detalhes da arquitetura
- [STRUCTURE.md](../docs/STRUCTURE.md) - Estrutura de diretórios

## 💡 Dicas

- Use `Ctrl+F9` para compilar rapidamente
- Use `F9` para executar
- Configure breakpoints para debug
- Mantenha sempre backup do banco de dados
- Teste as validações inserindo dados inválidos

## 🆘 Suporte

Em caso de dúvidas:
1. Consulte a documentação no diretório `/docs`
2. Verifique os comentários no código
3. Revise os exemplos de dados de teste no banco

## ✨ Recursos Demonstrados

✅ Programação Orientada a Objetos (POO)
✅ Padrão MVC completo
✅ Clean Code e boas práticas
✅ Padrão DAO para acesso a dados
✅ Padrão Singleton
✅ Validações em múltiplas camadas
✅ Transações de banco de dados
✅ Tratamento de exceções
✅ Documentação XML

---

**Desenvolvido como Teste Técnico - WK Technology**
