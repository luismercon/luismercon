---
title: "Sobre Refatorar Sistemas que Herdamos"
date: 2026-06-10T09:00:00+01:00
description: "A maior parte do código que alguma vez vais tocar foi escrito por outra pessoa, por razões que nunca vais conhecer por completo. A paciência é uma competência técnica."
tags: ["legacy", "craft"]
draft: false
canonicalURL: ""
images: []
---

## A herança

Há uma sensação particular que surge na primeira semana numa base de código madura. Abres um ficheiro à espera de uma função e encontras uma pequena civilização: convenções que não reconheces, nomes que significavam algo para alguém, um comentário de 2014 que diz simplesmente `// não remover`. O instinto é recuar, declarar que aquilo é uma confusão, e querer reescrever tudo. Resiste a essa vontade. A confusão é informação.

Cada linha que achas difícil foi, em algum momento, uma resposta razoável a uma pergunta que ainda não te foi feita. O trabalho de modernização começa não pelo julgamento, mas pela arqueologia.

> O código legado não é uma falha das pessoas que vieram antes. É o sedimento de cada decisão que o negócio sobreviveu.

## Ler antes de escrever

Somos treinados para escrever e deixados a descobrir como ler sozinhos — mas num sistema herdado vais ler durante semanas antes de mudares uma linha que importa. Lê primeiro os testes; são a única documentação que foi forçada a ser verdadeira. Lê o histórico de commits do ficheiro que mais temes. Lê os issues que ninguém fechou.

Só depois de teres a forma da coisa nas mãos é que a deves tocar. E quando o fizeres, muda uma coisa de cada vez, e deixa que o sistema te diga se entendeste mesmo.

<div class="callout">
<span class="callout__label">Uma regra que mantenho</span>
<p>Nunca refatores e mudes comportamento no mesmo commit. Um dos dois vai estar errado, e vais querer saber qual.</p>
</div>

## Seams e figueiras estranguladoras

A figueira estranguladora cresce à volta de uma árvore hospedeira, puxando a sua própria estrutura para cima até que o tronco original apodrece lá dentro, já não sendo necessário. É a metáfora mais gentil que temos para migrações. Raramente tens oportunidade de reescrever. Tens oportunidade de fazer crescer um novo sistema à volta do antigo até que, numa tarde tranquila qualquer, o antigo deixa de ser estrutural — e apagá-lo passa a ser uma formalidade.

Encontra os *seams*: os pontos onde podes intercetar uma chamada, encaminhar uma fração do tráfego, comparar a nova resposta com a antiga. Um seam é permissão para mudares de ideias mais tarde.

## Onde o modelo ajuda

Um modelo de linguagem é um júnior rápido e confiante que leu tudo e não se lembra de nada entre frases. Em trabalho de legado isto é, surpreendentemente, um presente. Vai resumir um ficheiro de mil linhas mais depressa do que o consegues percorrer. Vai esboçar o teste de caracterização que tens andado a evitar. Vai propor cinco nomes para o conceito que não conseguias nomear.

O que não vai fazer é assumir a responsabilidade. O julgamento sobre se uma mudança é segura continua a ser teu, porque és tu que vais estar lá às 2 da manhã quando não for. Usa o modelo para ires mais depressa pelas partes que já entendes — nunca para saltar o entendimento.

## Deixar melhor do que encontraste

Não vais terminar. Sistemas herdados não são projetos com data de fim; são jardins. A medida do teu trabalho não é que o código fique perfeito, mas que a próxima pessoa a abrir este ficheiro sinta, por um momento, que esteve aqui alguém que se importou. Deixa os seams visíveis. Deixa os testes honestos. Deixa um comentário que diz a verdade.

Esse é todo o ofício, no fundo: entregar a coisa em condição ligeiramente melhor do que a encontraste, e resistir à vaidade da reescrita por mais um ano.
