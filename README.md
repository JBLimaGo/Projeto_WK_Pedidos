\# Projeto\_WK\_Pedidos



Tecnologias Utilizadas



Delphi (RAD Studio) — VCL



MySQL



FireDAC (com libmysql.dll)



POO / MVC / Clean Code



TDD parcial (models validados)



Arquitetura em camadas (Models, DAO, Services, UI)







Estrutura do Projeto



Projeto\_WK\_Pedidos/

│

├── src/                     → Código-fonte (.pas, .dfm)

│   ├── uModels.pas

│   ├── uDAOs.pas

│   ├── uServices.pas

│   ├── uConnectionFactory.pas

│   ├── uConfig.pas

│   └── FrmPedidos.\*

│

├── bin/                     → Executável + DLL + INI

│   ├── wk\_pedidos.exe

│   ├── libmysql.dll

│   ├── libssl-1\_1.dll            (se necessário no MySQL 8.x)

│   ├── libcrypto-1\_1.dll         (se necessário no MySQL 8.x)

│   └── db\_connection.ini

│

├── database/                → Dump completo do banco

│   └── dump\_wktech\_pedidos.sql

│

├── README.md                → Este arquivo

└── .gitignore               → Padrões Delphi + binários

