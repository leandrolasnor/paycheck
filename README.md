# Paycheck Deliver
> ruby:3.2.2-alpine3.18

_Um "relatório de holerite" geralmente se refere a um documento que detalha os ganhos e deduções de um funcionário em um determinado período de pagamento. Ele é comumente emitido pelas empresas para os funcionários como comprovante de pagamento e para fins de prestação de contas. O relatório de holerite normalmente inclui informações como salário bruto, descontos de impostos, contribuições para a previdência social, horas trabalhadas, entre outros._

Dado um arquivo .pdf com `n` páginas, contendo em cada uma das páginas o relatório de holerite de um funcionário, desejamos separá-lo em `n` arquivos .pdf independentes, para posteriormente enviá-lo por email de forma individual a cada um dos funcinários.

> O projeto desenvolvido nesse repositório foi escrito em Ruby3 e faz a divisão das páginas de um único relatório de holerite em pdf, correlacionando o conteúdo da página do holerite ao email do funcionário. Por fim, envia o email individualmente para o endereço eletrônico do funcionário anexando o holerite.

# Arquivos
Coloque os dois arquivos no mesmo nível de diretório do arquivo `cli.rb`

O primeiro arquivo será o `paycheck.pdf` (Arquivo com todos os holerites)

O Segundo arquivo será o `people.tab` (Arquivo `csv` separado por tabulações que deverá ter três colunas [name, email, position])

_Esses dois arquivos serão usados para realizar o processo de correlação usando o email da pessoa, a função da pessoa e o conteúdo do holerite_

# Configurações

## Visualize as configurações com o comando
`ruby cli.rb config`

```
> ruby cli.rb config

paycheck:
  paycheck_file_path: paycheck.pdf
  people_file_path: test.tab
action_mailer:
  raise_delivery_errors: true
  delivery_method: :smtp
  smtp_settings:
    address: smtp.gmail.com
    domain: gmail.com
    port: 465
    authentication: :login
    ssl: true
    user_name: onetwothree@uol.com
    password: 123
```

## Coloque sua configurações

`ruby cli.rb config -m [PATH] [VALUE]`

```
> ruby cli.rb config -m  action_mailer.smtp_settings.user_name 'meu_email@meu_provedor.com'

action_mailer.smtp_settings.user_name
meu_email@meu_provedor.com

> ruby cli.rb config

paycheck:
  paycheck_file_path: paycheck.pdf
  people_file_path: test.tab
action_mailer:
  raise_delivery_errors: true
  delivery_method: :smtp
  smtp_settings:
    address: smtp.gmail.com
    domain: gmail.com
    port: 465
    authentication: :login
    ssl: true
    user_name: meu_email@meu_provedor.com
    password: 123
```

_Não se esqueça de configurar uma senha nas configurações da sua conta do google para usar o serviço de smtp. Uma senha especial deverá ser gerada no menu **Google Contas > Senhas de app**_

## Rode o script

_Com todas as configurações feitas, rode:_

```
> ruby cli.rb deliver

┌ Paycheck Deliver  [===] 100%                                           
└── Separando os arquivos [=] 100%
└── Anexando os arquivos [=] 100%
└── Enviando os e-mails [=] 100%
Processo concluído
```
