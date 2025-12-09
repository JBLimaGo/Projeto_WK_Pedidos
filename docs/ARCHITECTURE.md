# Implementação de POO, MVC e Clean Code

## Programação Orientada a Objetos (POO)

### Encapsulamento
Todas as classes do Model implementam encapsulamento adequado:

```pascal
// Exemplo em Model.Cliente.pas
private
  FCodigo: Integer;
  FNome: string;
  
  procedure SetCodigo(const Value: Integer);
  procedure SetNome(const Value: string);
  
public
  property Codigo: Integer read FCodigo write SetCodigo;
  property Nome: string read FNome write SetNome;
```

**Benefícios:**
- Proteção dos dados internos
- Validações centralizadas nos setters
- Controle sobre como os dados são acessados e modificados

### Herança
Todas as classes herdam de `TObject` e implementam construtores/destrutores adequados:

```pascal
constructor TCliente.Create;
begin
  inherited Create;  // Chama construtor da classe pai
  // Inicializa atributos
end;

destructor TCliente.Destroy;
begin
  // Libera recursos se necessário
  inherited;  // Chama destrutor da classe pai
end;
```

### Composição e Agregação

**Composição (TPedido possui TItemPedido):**
```pascal
// TPedido é responsável pelo ciclo de vida dos TItemPedido
FItens: TObjectList<TItemPedido>.Create(True); // True = possui os objetos
```

**Agregação (TItemPedido referencia TProduto):**
```pascal
// TItemPedido apenas referencia o código do produto
FCodigoProduto: Integer;  // Não possui o objeto TProduto
```

### Polimorfismo
Métodos podem ser sobrescritos em classes derivadas:

```pascal
destructor Destroy; override;  // Sobrescreve método da classe base
```

## Padrão MVC (Model-View-Controller)

### Model (Camada de Domínio)
- **Responsabilidade**: Representa as entidades de negócio
- **Localização**: `src/Model/`
- **Características**:
  - Contém apenas lógica de domínio
  - Validações de dados
  - Regras de negócio da entidade
  - Independente de UI e banco de dados

**Exemplo:**
```pascal
// Model.Pedido.pas
function TPedido.Validar(out Mensagem: string): Boolean;
begin
  if FCodigoCliente <= 0 then
  begin
    Mensagem := 'Cliente não informado';
    Result := False;
    Exit;
  end;
  // Mais validações...
end;
```

### View (Camada de Apresentação)
- **Responsabilidade**: Interface com o usuário
- **Localização**: `src/View/`
- **Características**:
  - Formulários VCL
  - Exibe dados ao usuário
  - Captura eventos do usuário
  - Delega lógica para Controller
  - Não contém regras de negócio

**Exemplo:**
```pascal
// View.Principal.pas
procedure TFormPrincipal.MenuClientesClick(Sender: TObject);
begin
  // View apenas exibe/chama, não implementa lógica
  ShowMessage('Módulo de Clientes');
end;
```

### Controller (Camada de Lógica de Negócio)
- **Responsabilidade**: Coordena Model e View
- **Localização**: `src/Controller/`
- **Características**:
  - Processa requisições da View
  - Aplica regras de negócio complexas
  - Coordena múltiplos DAOs
  - Retorna resultados para View

**Exemplo:**
```pascal
// Controller.Pedido.pas
function TPedidoController.Salvar(Pedido: TPedido; out Mensagem: string): Boolean;
begin
  // Valida o pedido
  if not Pedido.Validar(Mensagem) then
    Exit;
  
  // Valida se o cliente existe
  if not ValidarCliente(Pedido.CodigoCliente) then
  begin
    Mensagem := 'Cliente não encontrado';
    Exit;
  end;
  
  // Valida produtos e atualiza preços
  // Salva no banco através do DAO
end;
```

### DAO (Data Access Object)
- **Responsabilidade**: Acesso a dados
- **Localização**: `src/DAO/`
- **Características**:
  - Isola SQL e acesso ao BD
  - CRUD operations
  - Gerencia transações
  - Converte entre Model e BD

**Exemplo:**
```pascal
// DAO.Cliente.pas
function TClienteDAO.Inserir(Cliente: TCliente): Boolean;
begin
  FQuery.SQL.Add('INSERT INTO clientes (nome, cidade, uf)');
  FQuery.SQL.Add('VALUES (:nome, :cidade, :uf)');
  // Executa e retorna resultado
end;
```

## Clean Code

### Nomenclatura Significativa

**Classes:**
- Prefixo `T`: `TCliente`, `TPedido`, `TProduto`
- Nomes descritivos do domínio

**Métodos:**
- Verbos que descrevem ação: `Salvar()`, `Excluir()`, `Validar()`
- Nomes auto-explicativos

**Variáveis:**
- Prefixo indica escopo: `F` para fields (private), `A` para parâmetros
- Nomes descritivos: `FNome`, `FPrecoVenda`

### Métodos Pequenos e Coesos

Cada método tem uma única responsabilidade:

```pascal
// Método focado apenas em calcular o total
procedure TPedido.CalcularValorTotal;
var
  Item: TItemPedido;
begin
  FValorTotal := 0;
  for Item in FItens do
    FValorTotal := FValorTotal + Item.ValorTotal;
end;
```

### Comentários XML

Documentação inline para classes e métodos principais:

```pascal
/// <summary>
/// Valida os dados do cliente
/// </summary>
function Validar(out Mensagem: string): Boolean;
```

### Tratamento de Exceções

Tratamento adequado com mensagens descritivas:

```pascal
try
  Result := FDAO.Inserir(Cliente);
except
  on E: Exception do
  begin
    Mensagem := 'Erro ao salvar cliente: ' + E.Message;
    Result := False;
  end;
end;
```

### Princípios SOLID

**Single Responsibility:**
- Cada classe tem uma única razão para mudar
- `TClienteDAO` apenas acessa dados de cliente
- `TClienteController` apenas lógica de negócio de cliente

**Open/Closed:**
- Classes abertas para extensão via herança
- Fechadas para modificação através de encapsulamento

**Liskov Substitution:**
- Subclasses podem substituir classes base sem quebrar código

**Interface Segregation:**
- Interfaces pequenas e específicas
- Clientes não dependem de métodos que não usam

**Dependency Inversion:**
- Controller depende de abstrações (DAO interface)
- Não depende de implementações concretas diretamente

### Princípios DRY e KISS

**DRY (Don't Repeat Yourself):**
- Singleton para conexão evita código repetido
- Métodos auxiliares reutilizáveis

**KISS (Keep It Simple):**
- Código direto e simples
- Evita complexidade desnecessária
- Fácil de entender e manter

## Padrões de Design

### Singleton (DAO.Conexao)

Garante uma única instância da conexão:

```pascal
class function TConexao.GetInstancia: TConexao;
begin
  if not Assigned(FInstancia) then
    FInstancia := TConexao.CreatePrivate;
  Result := FInstancia;
end;
```

**Benefícios:**
- Uma única conexão com BD
- Economia de recursos
- Controle centralizado

### DAO Pattern

Separa lógica de negócio do acesso a dados:

```
Controller → DAO → Database
```

**Benefícios:**
- Fácil manutenção
- Possibilidade de trocar BD
- Testabilidade melhorada
- Código mais limpo

## Transações e Integridade

Operações complexas usam transações:

```pascal
Conexao.StartTransaction;
try
  // Insere pedido
  // Insere itens
  Conexao.Commit;
except
  Conexao.Rollback;
  raise;
end;
```

**Garante:**
- ACID properties
- Consistência dos dados
- Rollback em caso de erro

## Validações em Múltiplas Camadas

### Camada Model
```pascal
if Trim(FNome) = '' then
begin
  Mensagem := 'Nome é obrigatório';
  Result := False;
end;
```

### Camada Controller
```pascal
if not ValidarCliente(Pedido.CodigoCliente) then
begin
  Mensagem := 'Cliente não encontrado';
  Exit;
end;
```

### Camada DAO
```pascal
if not Cliente.Validar(Mensagem) then
  raise Exception.Create('Erro ao validar: ' + Mensagem);
```

## Conclusão

Este projeto demonstra a aplicação prática de:
- ✅ Programação Orientada a Objetos (POO)
- ✅ Padrão MVC completo
- ✅ Clean Code e boas práticas
- ✅ Padrões de Design (DAO, Singleton)
- ✅ SOLID Principles
- ✅ Validações robustas
- ✅ Tratamento de exceções
- ✅ Documentação clara

Resultado: Código **manutenível**, **testável**, **escalável** e **profissional**.
