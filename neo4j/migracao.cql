// Criar clientes
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/cliente.csv" AS row
CREATE (:Cliente {idCliente: toInt(row.idCliente) , Nome: row.Nome
, NroDocIdentif: row.NroDocIdentif , Rua: row.Rua , Local: row.Local
, CodPostal: row.CodPostal , Pais: row.Pais});

// Criar comboios
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboio.csv" AS row
CREATE (:Comboio {NroComboio: toInt(row.NroComboio), Marca: row.Marca, Modelo:
row.Modelo});

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/percurso.csv" AS row
CREATE (:Percurso {idPercurso: toInt(row.idPercurso), LocalPartida:
row.LocalPartida , LocalChegada: row.LocalChegada , Preco: toFloat(row.Preco)
, Comboio: toInt(row.Comboio)});


// Criar itinerarios
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/itinerario.csv" AS row
CREATE (:Itinerario {idItinerario: toInt(row.idItinerario) , DataHoraPartida:
row.DataHoraPartida , DataHoraChegada: row.DataHoraChegada , Percurso:
toInt(row.Percurso)});

// Criar reservas
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reserva.csv" AS row CREATE
(:Reserva {idReserva: toInt(row.idReserva) ,  DataReserva: row.DataReserva
, TotalReserva: toFloat(row.TotalReserva) , TotalBilhetes:
toInt(row.TotalBilhetes), Cliente: toInt(row.Cliente), Itinerario:
toInt(row.Itinerario)});

// Criar lugares do comboio
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboiolugar.csv" AS row
CREATE (:ComboioLugar {NroLugar: toInt(row.NroLugar) ,NroCarruagem:
toInt(row.NroCarruagem) , TipoLugar: row.TipoLugar , Comboio:
toInt(row.Comboio)});

// Criar lugares reservados
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reservabilhete.csv" AS row 
CREATE (:ReservaBilhete {Reserva: toInt(row.Reserva),  NroCarruagem:
toInt(row.NroCarruagem),  TipoLugar: row.TipoLugar,  NroBilhete:
toInt(row.NroBilhete),  NroLugar: toInt(row.NroLugar),  Comboio:
toInt(row.Comboio)});

CREATE CONSTRAINT ON (a:Cliente) assert a.NroDocIdentif IS UNIQUE;
CREATE CONSTRAINT ON (a:Cliente) assert a.idCliente IS UNIQUE;
CREATE CONSTRAINT ON (a:Comboio) assert a.NroComboio IS UNIQUE;
CREATE CONSTRAINT ON (a:Itinerario) assert a.idItinerario IS UNIQUE;
CREATE CONSTRAINT ON (a:Percurso) assert a.idPercurso IS UNIQUE;
CREATE CONSTRAINT ON (a:Reserva) assert a.idReserva IS UNIQUE;

CREATE INDEX ON :ComboioLugar(NroComboio);
CREATE INDEX ON :ComboioLugar(Comboio);
CREATE INDEX ON :ReservaBilhete(Reserva);
CREATE INDEX ON :ReservaBilhete(NroLugar);
CREATE INDEX ON :Itinerario(DataHoraPartida);
CREATE INDEX ON :Itinerario(DataHoraChegada);
CREATE INDEX ON :Reserva(DataReserva);

//relacionamento cliente reserva
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/cliente.csv" AS row
MATCH (cliente:Cliente {idCliente: toInt(row.idCliente)})
MATCH (reserva:Reserva {idReserva: toInt(row.idReserva)})
MERGE (cliente)-[:EFETUA]->(reserva);


//relacionamento comboio percurso
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/percurso.csv" AS row
MATCH (percurso :Percurso {idPercurso: toInt(row.idPercurso)})
MATCH (comboio :Comboio {NroComboio: toInt(row.Comboio)})
MERGE (comboio)-[:PERCORRE]->(percurso);


//relacionamento percurso itinerario
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/itinerario.csv" AS row
MATCH (itinerario :Itinerario {idItinerario: toInt(row.idItinerario)})
MATCH (percurso :Percurso {idPercurso: toInt(row.Percurso)})
MERGE (percurso)-[:CORRESPONDE]->(itinerario);

//relacionamento reserva itinerario
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reserva.csv" AS row
MATCH (itinerario :Itinerario {idItinerario: toInt(row.Itinerario)})
MATCH (reserva :Reserva {idReserva: toInt(row.idReserva)})
MERGE (reserva)-[:CONTEM]->(itinerario);


//relacionamento reserva reservabilhete
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reservabilhete.csv" AS row
MATCH (bilhete :ReservaBilhete {Reserva: toInt(row.Reserva)})
MATCH (reserva :Reserva {idReserva: toInt(row.Reserva)})
MERGE (reserva)-[:INCLUI]->(bilhete);

//relacionamento comboio comboiolugar
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboiolugar.csv" AS row
MATCH (lugar :ComboioLugar {Comboio: toInt(row.Comboio)})
MATCH (comboio :Comboio {NroComboio: toInt(row.Comboio)})
MERGE (comboio)-[:POSSUI]->(lugar);

