## Comando obrigatório
## Baixa a imagem do node com versão alpine (versão mais simplificada e leve)
FROM node:alpine


# instala um servidor http simples para servir conteúdo estático
# RUN npm install -g http-server

RUN yarn global add @vue/cli

# faz da pasta 'app' o diretório atual de trabalho
WORKDIR /var/www

# copia os arquivos 'package.json' e 'package-lock.json' (se disponível)
COPY package*.json ./

# instala dependências do projeto
RUN yarn install

# copia arquivos e pastas para o diretório atual de trabalho (pasta 'app')
COPY . .

# compila a aplicação de produção com minificação
RUN yarn run build

EXPOSE 8080

# CMD [ "http-server", "dist" ]
CMD [ "yarn", "serve" ]