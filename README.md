# Projeto_WK_Pedidos

Estrutura do Projeto

Projeto_WK_Pedidos/
│      
├── src/                     → Código-fonte (.pas, .dfm)
│   ├── uModels.pas
│   ├── uDAOs.pas
│   ├── uServices.pas
│   ├── uConnectionFactory.pas
│   ├── uConfig.pas
│   └── FrmPedidos.*
│
├── bin/                     → Executável + DLL + INI
│   ├── wk_pedidos.exe
│   ├── libmysql.dll
│   ├── libssl-1_1.dll            (se necessário no MySQL 8.x)
│   ├── libcrypto-1_1.dll         (se necessário no MySQL 8.x)
│   └── db_connection.ini
│
├── database/                → Dump completo do banco
│   └── dump_wktech_pedidos.sql
│
├── README.md                → Este arquivo
└── .gitignore               → Padrões Delphi + binários
