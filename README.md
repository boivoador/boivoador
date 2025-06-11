- 👋 Olá, eu sou o @boivoador
- 👀 Estou interessado em computação de alto desempenho (HPC), clusters, automação e otimização de processos científicos.
- 🌱 Atualmente estou aprendendo mais sobre gerenciamento de clusters, monitoramento de desempenho e segurança em ambientes HPC.
- 💞️ Estou buscando colaborar em projetos relacionados à infraestrutura de TI, computação científica e desenvolvimento de ferramentas para clusters.
- ⚡ Curiosidade: Nosso cluster foi batizado de **Boi Voador** em homenagem ao folclore do boi voador de Pernambuco que remete à história do
- governador Maurício de Nassau, que, durante a ocupação holandesa, teria prometido fazer um boi voar sobre a ponte de Recife para atrair
- visitantes e impulsionar a receita do pedágio.


📞 Contato
Para dúvidas ou suporte técnico, entre em contato com a equipe de administração do cluster:
📧 hpc.propesqi@ufpe.br
<br><br>
<h2>Sistema Operacional</h2>
Ubuntu Server 22.04 LTS

<br>

<h2>Montagem do NFS</h2>
O diretório <strong>/data</strong> é montado em todos os nós do cluster a partir do servidor de controle <strong>boivoador0</strong>.
Estrutura do diretório <strong>/data</strong>:
<br>

![image](https://github.com/user-attachments/assets/224db0ee-039c-4958-98b2-e70a67ebef46)

<br>

<h2>Diretório /data/apps</h2>
Onde estão armazenados as aplicações e ferramentas centralizadas.
<br>
<i><strong>Ex.: /data/apps/spack</strong></i>

<br>

<h2>Diretório /data/home</h2>
<p>Onde estão os home directories dos usuários, centralizados no NFS.</p>

Cada usuário teria algo como:
1. /data/home/usuario1
2. /data/home/usuario2

<br>

<h2>Diretório /data/lost+found</h2>
Esse diretório é criado automaticamente pelo sistema de arquivos (provavelmente ext4, xfs, etc). Ele serve para armazenar fragmentos de arquivos recuperados em caso de falha no disco ou no sistema de arquivos.

<br>

<h2>Configuração Centralizada do Spack no Cluster</h2>

1. Visão Geral <br>
O Spack está configurado de forma centralizada em um diretório NFS montado em todos os nós do cluster. Isso garante que todos os usuários tenham acesso à mesma instalação, facilitando a gestão dos pacotes e módulos.
3. Instalação de pacotes <br>
A atualização do Spack e instalação de pacotes são feitas no diretório central <strong>/data/apps/spack</strong> por usuários autorizados.
<br>
![image](https://github.com/user-attachments/assets/055b0094-3112-4fb9-bae4-5139879897a0)

#################################################################################################################


- 👋 Hi, I'm @boivoador
- 👀 I'm interested in high-performance computing (HPC), clusters, automation, and optimization of scientific processes.
- 🌱 I'm currently learning more about cluster management, performance monitoring, and security in HPC environments.
- 💞️ I'm looking to collaborate on projects related to IT infrastructure, scientific computing, and development of tools for clusters.
- 📫 How to get in touch: hpc.propesqi@ufpe.br
- ⚡ Fun fact: Our cluster was named **Boi Voador** in honor of the folklore of the flying ox of Pernambuco that refers to the story of
- Governor Maurício de Nassau, who, during the Dutch occupation, promised to make an ox fly over the Recife bridge to attract
- visitors and boost toll revenue.


📞 Contact
For questions or technical support, please contact the cluster administration team:
📧 hpc.propesqi@ufpe.br
