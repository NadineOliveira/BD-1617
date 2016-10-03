import re
import random
import glob


def eliminarepetidos(fich):
    f1 = open('datasets\\' + fich + '.txt', 'r')
    f2 = open('datasets\\' + fich + '_sem_repetidos.txt', 'w+')

    nomes = []

    for line in f1:
        if line not in nomes:
            nomes.append(line)
            f2.write(line)

    f1.close()
    f2.close()


def corrige_nomes():
    f1 = open('datasets\autores_sem_repetidos.txt', 'r')
    f2 = open('datasets\autores_final.txt', 'w')

    for line in f1:
        m = re.match(r"(?P<first_name>.*) (?P<last_name>.*$)", line)
        fname = m.group('first_name')
        lname = m.group('last_name')
        f2.write(lname + '\t' + fname + '\n')

    f1.close()
    f2.close()


def gera_ccs():
    f1 = open('datasets\ccs.txt', 'w+')
    count = 0
    ccs = []

    while count < 3000:
        n = random.randint(100000000, 999999999)
        if n not in ccs:
            count += 1
            ccs.append(n)
            f1.write(str(n) + '\n')

    f1.close()


def gera_telefones():
    f1 = open('datasets\telefones.txt', 'w+')
    count = 0
    telefs = []

    while count < 3000:
        telef = random.randint(210000000, 299999999)
        if telef not in telefs:
            count += 1
            telefs.append(telef)
            f1.write(str(telef) + '\n')

    f1.close()


def gera_issn():
    f1 = open('datasets\issn.txt', 'w+')
    count = 0
    issns = []

    while count < 5000:
        issn = random.randint(10000000, 99999999)
        if issn not in issns:
            count += 1
            issns.append(issn)
            f1.write(str(issn)[0:4] + '-' + str(issn)[4:] + '\n')

    f1.close()


def gera_codbarras():
    f1 = open('datasets\codBarras.txt', 'w+')
    count = 0
    cods_barras = []

    while count < 5000:
        cod_barras = random.randint(10000000000, 99999999999)
        if cod_barras not in cods_barras:
            count += 1
            cods_barras.append(cod_barras)
            f1.write(str(cod_barras) + '\n')

    f1.close()


def gera_localizacoes():
    f1 = open('datasets\localizacoes.txt', 'w+')
    idlocalizacao = 1
    piso = 1
    while piso <= 3:
        estante = 1
        while estante <= 130:
            prateleira = 1
            while prateleira <= 5:
                f1.write(str(idlocalizacao) + '\t' + str(piso) + '\t' + str(estante) + '\t' + str(prateleira) + '\n')
                idlocalizacao += 1
                prateleira += 1
            estante += 1
        piso += 1
    f1.close()


def gera_exemplares():
    f1 = open('datasets\exemplares.txt', 'w+')

    condicoes = ['Capa com bordas dobradas',
                 'Folhas em falta',
                 'Folhas dobradas',
                 'Plastico da capa a sair',
                 'Folhas detrioradas',
                 'Normal', 'Normal', 'Normal', 'Normal',
                 'Normal', 'Normal', 'Normal', 'Normal',
                 'Normal', 'Normal', 'Normal', 'Normal']
    disponibilidade = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0]
    idexemplar = 1
    idlivro = 1

    while idlivro <= 5000:
        numexemplares = random.randint(2, 6)
        localizacao = random.randint(1, 1950)

        for i in range(0, numexemplares):
            f1.write(str(idexemplar) + '\t\'' + random.choice(condicoes) + '\'\t' +
                     str(random.choice(disponibilidade)) + '\t' + str(localizacao) + '\t' + str(idlivro) + '\n')
            idexemplar += 1

        idlivro += 1

    f1.close()

def gera_publicacoes():
    f1 = open('datasets\publicacoes.txt', 'w+')
    idlivro=1

    while idlivro <= 5000:
        nedicoes = random.randint(1, 3)
        edicao = 1
        editora = random.randint(1, 1083)
        ano = random.randint(1990, 2015)

        for i in range(0, nedicoes):
            f1.write(str(idlivro) + '\t' + str(editora) + '\t' + str(edicao+i) + '\t' + str(ano+i) + '\n')

        idlivro += 1

    f1.close()

def cria_povoamento_geral():
    filenames = ['01_coleccao.sql',
                 '02_autor.sql',
                 '03_editora.sql',
                 '04_utilizador.sql',
                 '05_livro.sql',
                 '06_cdu.sql',
                 '07_localizacao.sql',
                 '08_exemplares.sql',
                 '09_livro_editora.sql',
                 '10_autor_livro.sql']

    with open('scripts/00_geral.sql', 'w', encoding="utf8") as outfile:
        for fname in filenames:
            with open('scripts/' + fname, 'r', encoding="utf8") as infile:
                for line in infile:
                    outfile.write(line)
                    outfile.flush()

def maior_linha():
    maior = -1
    with open('titulos.txt', 'r', encoding="utf8") as infile:
        for line in infile:
            tamlinha = len(line)
            if tamlinha > maior:
                maior = tamlinha

    print(maior)




