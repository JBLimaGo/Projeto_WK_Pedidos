# Projeto WK - Sistema de Pedidos

## Descrição
Sistema de gerenciamento de pedidos desenvolvido em **Delphi 10.4 Sydney** utilizando boas práticas de programação, incluindo:
- Programação Orientada a Objetos (POO)
- Arquitetura MVC (Model-View-Controller)
- Clean Code
- Padrões de Design (DAO, Singleton)

## 🏗️ Arquitetura

O projeto segue a arquitetura **MVC** com camada de acesso a dados:

```
src/
├── Model/              # Entidades do domínio (POO)
│   ├── Model.Cliente.pas
│   ├── Model.Produto.pas
│   ├── Model.ItemPedido.pas
│   └── Model.Pedido.pas
├── View/               # Interface com usuário
│   └── View.Principal.pas/dfm
├── Controller/         # Lógica de negócio
│   ├── Controller.Cliente.pas
│   ├── Controller.Produto.pas
│   └── Controller.Pedido.pas
└── DAO/               # Acesso a dados
    ├── DAO.Conexao.pas
    ├── DAO.Cliente.pas
    ├── DAO.Produto.pas
    └── DAO.Pedido.pas
```

## 📋 Funcionalidades

- **Cadastro de Clientes**: Gerenciamento completo de clientes
- **Cadastro de Produtos**: Gerenciamento de produtos com preços
- **Pedidos**: Criação, edição e exclusão de pedidos com múltiplos itens

## 🎯 Conceitos de POO Implementados

### 1. Encapsulamento
- Propriedades privadas com getters e setters
- Validações nos setters para garantir integridade
- Ocultação de implementação interna

### 2. Herança
- Todas as classes herdam de TObject
- Uso adequado de construtores e destrutores

### 3. Composição e Agregação
- `TPedido` possui uma lista de `TItemPedido` (composição)
- `TItemPedido` referencia `TProduto` por código (agregação)

### 4. Polimorfismo
- Métodos virtuais podem ser sobrescritos
- Interface uniforme para operações similares

## 🎨 Padrões de Design Implementados

### 1. MVC (Model-View-Controller)
- **Model**: Classes de domínio (Cliente, Produto, Pedido, ItemPedido)
- **View**: Formulários Delphi (View.Principal)
- **Controller**: Lógica de negócio (Controller.Cliente, Controller.Produto, Controller.Pedido)

### 2. DAO (Data Access Object)
- Separação entre lógica de negócio e acesso a dados
- Classes DAO para cada entidade (DAO.Cliente, DAO.Produto, DAO.Pedido)
- Facilita manutenção e testes

### 3. Singleton
- `TConexao` implementa Singleton para gerenciar conexão única com BD
- Garante uma única instância da conexão durante a execução

## 💻 Tecnologias Utilizadas

- **Delphi 10.4 Sydney**
- **MySQL** (banco de dados)
- **FireDAC** (componentes de acesso a dados)
- **VCL** (Visual Component Library)

## 📦 Estrutura do Banco de Dados

### Tabelas:
1. **clientes**: código, nome, cidade, uf
2. **produtos**: código, descrição, preco_venda
3. **pedidos**: numero_pedido, data_emissao, codigo_cliente, valor_total
4. **pedidos_produtos**: id, numero_pedido, id_item, codigo_produto, quantidade, valor_unitario, valor_total

## 🚀 Como Executar

### Pré-requisitos
1. Delphi 10.4 Sydney ou superior
2. MySQL Server instalado
3. Bibliotecas FireDAC configuradas

### Configuração do Banco de Dados
1. Execute o script `database/create_database.sql` no MySQL
2. Configure as credenciais de conexão em `src/DAO/DAO.Conexao.pas`:
   ```pascal
   FConexao.Params.Add('Server=localhost');
   FConexao.Params.Add('Database=pedidos');
   FConexao.Params.Add('User_Name=root');
   FConexao.Params.Add('Password=');
   ```

### Compilação
1. Abra o projeto `ProjetoWKPedidos.dpr` no Delphi
2. Compile o projeto (F9)
3. Execute a aplicação

## 📝 Clean Code

O código segue princípios de Clean Code:

### Nomenclatura Clara
- Classes com prefixo `T` (padrão Delphi)
- Métodos com verbos descritivos
- Variáveis com nomes significativos

### Métodos Pequenos e Coesos
- Cada método tem uma única responsabilidade
- Código bem organizado e legível

### Comentários XML
- Documentação inline com tags `<summary>`
- Descreve o propósito de classes e métodos

### Tratamento de Exceções
- Try-except adequados
- Mensagens de erro descritivas
- Liberação de recursos em finally/destructor

### Validações
- Validações de dados nas entidades
- Mensagens de erro amigáveis
- Prevenção de estados inválidos

## 🔒 Integridade de Dados

- **Transações**: Operações de pedidos usam transações para garantir ACID
- **Foreign Keys**: Relacionamentos com integridade referencial
- **Validações**: Em todos os níveis (Model, Controller, DAO)

## 📖 Documentação Adicional

### Fluxo de Operação (Exemplo: Salvar Pedido)

1. **View** → Usuário preenche dados do pedido
2. **View** → Chama método do **Controller**
3. **Controller** → Valida dados do pedido (Model)
4. **Controller** → Verifica se cliente existe (DAO)
5. **Controller** → Verifica se produtos existem (DAO)
6. **Controller** → Atualiza preços dos itens
7. **Controller** → Chama DAO para persistir
8. **DAO** → Inicia transação
9. **DAO** → Insere pedido no BD
10. **DAO** → Insere itens do pedido
11. **DAO** → Confirma transação
12. **Controller** → Retorna resultado para View
13. **View** → Exibe mensagem ao usuário

## 🎓 Conceitos Aplicados

- **SOLID Principles**
  - Single Responsibility: Cada classe tem uma responsabilidade
  - Open/Closed: Aberto para extensão, fechado para modificação
  - Liskov Substitution: Classes podem ser substituídas por suas bases
  - Interface Segregation: Interfaces específicas
  - Dependency Inversion: Dependência de abstrações

- **DRY** (Don't Repeat Yourself)
  - Reutilização de código
  - Métodos auxiliares para operações comuns

- **KISS** (Keep It Simple, Stupid)
  - Código simples e direto
  - Evita complexidade desnecessária

## 👥 Autor

Desenvolvido como teste técnico para WK Technology

## 📄 Licença

Este projeto é um exemplo educacional para demonstração de técnicas de programação.
