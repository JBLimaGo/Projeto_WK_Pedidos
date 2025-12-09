# Projeto WK Pedidos - Estrutura de Diretórios

```
Projeto_WK_Pedidos/
│
├── ProjetoWKPedidos.dpr         # Arquivo principal do projeto Delphi
│
├── src/                          # Código fonte
│   ├── Model/                    # Camada Model (Entidades de Domínio)
│   │   ├── Model.Cliente.pas     # Entidade Cliente com validações
│   │   ├── Model.Produto.pas     # Entidade Produto com validações
│   │   ├── Model.ItemPedido.pas  # Entidade ItemPedido (composição)
│   │   └── Model.Pedido.pas      # Entidade Pedido (agregação)
│   │
│   ├── View/                     # Camada View (Interface com usuário)
│   │   ├── View.Principal.pas    # Form principal da aplicação
│   │   └── View.Principal.dfm    # Layout do form principal
│   │
│   ├── Controller/               # Camada Controller (Lógica de negócio)
│   │   ├── Controller.Cliente.pas   # Controller de Cliente
│   │   ├── Controller.Produto.pas   # Controller de Produto
│   │   └── Controller.Pedido.pas    # Controller de Pedido
│   │
│   ├── DAO/                      # Data Access Object (Acesso a dados)
│   │   ├── DAO.Conexao.pas       # Singleton para conexão BD
│   │   ├── DAO.Cliente.pas       # DAO de Cliente
│   │   ├── DAO.Produto.pas       # DAO de Produto
│   │   └── DAO.Pedido.pas        # DAO de Pedido (com transações)
│   │
│   └── Utils/                    # Utilitários (reservado para futuro)
│
├── database/                     # Scripts de banco de dados
│   └── create_database.sql       # Script de criação e dados iniciais
│
├── docs/                         # Documentação
│   └── ARCHITECTURE.md           # Documentação da arquitetura
│
├── README.md                     # Documentação principal
└── .gitignore                    # Arquivos ignorados pelo Git
```

## Descrição dos Diretórios

### `/src/Model/`
Contém as classes de domínio (entidades) do sistema:
- Implementam encapsulamento (private fields, public properties)
- Validações de negócio
- Lógica inerente à entidade
- Independentes de UI e persistência

### `/src/View/`
Contém os formulários VCL (interface com usuário):
- Formulários Delphi (.pas e .dfm)
- Lógica de apresentação
- Captura de eventos do usuário
- Delegam processamento para Controllers

### `/src/Controller/`
Contém a lógica de negócio da aplicação:
- Coordena Models e DAOs
- Aplica regras de negócio complexas
- Valida operações
- Intermedia View e DAO

### `/src/DAO/`
Contém acesso a dados:
- Isola SQL e operações de BD
- Implementa CRUD
- Gerencia transações
- Converte entre entidades e tabelas

### `/database/`
Scripts SQL para o banco de dados:
- Criação de tabelas
- Constraints e índices
- Dados iniciais para testes
- Documentação do schema

### `/docs/`
Documentação técnica do projeto:
- Arquitetura detalhada
- Diagramas (se houver)
- Guias de desenvolvimento

## Convenções de Nomenclatura

### Arquivos
- `Model.*.pas` - Classes de domínio
- `View.*.pas` - Formulários
- `Controller.*.pas` - Controllers
- `DAO.*.pas` - Data Access Objects

### Classes
- Prefixo `T` para classes (padrão Delphi)
- Nomes descritivos: `TCliente`, `TPedido`, `TClienteDAO`

### Units
- Namespace por camada: `Model.Cliente`, `DAO.Cliente`
- Facilita organização e identificação

## Fluxo de Dados

```
┌──────────┐
│   View   │ ← Interface com usuário
└─────┬────┘
      │
      ▼
┌──────────┐
│Controller│ ← Lógica de negócio
└─────┬────┘
      │
      ▼
┌──────────┐
│   DAO    │ ← Acesso a dados
└─────┬────┘
      │
      ▼
┌──────────┐
│ Database │ ← Persistência
└──────────┘
```

## Dependências

### Model
- Não depende de nenhuma outra camada
- Apenas classes do sistema (System.SysUtils, etc)

### View
- Depende de Controller
- Não acessa diretamente Model ou DAO

### Controller
- Depende de Model e DAO
- Não depende de View

### DAO
- Depende de Model
- Acessa FireDAC para BD
- Não depende de View ou Controller

## Benefícios da Estrutura

1. **Separação de Responsabilidades**: Cada camada tem papel definido
2. **Manutenibilidade**: Fácil localizar e modificar código
3. **Testabilidade**: Camadas podem ser testadas independentemente
4. **Escalabilidade**: Fácil adicionar novas funcionalidades
5. **Reutilização**: Components podem ser reutilizados
6. **Clareza**: Estrutura clara facilita onboarding

## Extensões Futuras

Para expandir o projeto, considere adicionar:

```
├── src/
│   ├── Interfaces/           # Interfaces para abstrações
│   ├── Services/             # Serviços de negócio complexos
│   ├── Reports/              # Relatórios
│   ├── Utils/                # Utilitários gerais
│   └── Exceptions/           # Exceções customizadas
│
├── tests/                    # Testes unitários
│   ├── Model/
│   ├── Controller/
│   └── DAO/
│
└── resources/                # Recursos (imagens, ícones)
```

## Notas Importantes

- Sempre compile com warnings habilitados
- Mantenha a separação de camadas rigorosa
- Documente classes e métodos públicos
- Use construtores e destrutores adequadamente
- Libere recursos em finally ou destructor
- Valide dados em múltiplas camadas
- Use transações para operações críticas
