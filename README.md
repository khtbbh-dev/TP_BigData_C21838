Ce repos contient les commandes utilisées dans les tps, un rapport de tp ainsi qu'un ensemble de scripts permettant l'automatomatisation des travaux pratiques sur Hadoop:
# RAPPORT GLOBAL DES TRAVAUX PRATIQUES

**Module :** Big Data Technologies  
**Master :** MLDS  
**Auteur :** C21838 El Kheit Mohamed Babaha
**Année Universitaire :** 2025-2026

---

## Introduction

Le module Big Data Technologies a pour objectif d'étudier les architectures distribuées permettant le stockage et le traitement de grands volumes de données.

Dans le cadre de ces travaux pratiques, nous avons mis en place un cluster Hadoop complet à l'aide de Docker puis exploré deux composantes fondamentales de l'écosystème Hadoop :

- HDFS (Hadoop Distributed File System)
- MapReduce (Framework de calcul distribué)

L'ensemble des expérimentations a été réalisé sur un cluster composé d'un NameNode et de deux DataNodes.

---

## TP1 : Administration HDFS et Gestion du Stockage Distribué

### Objectifs

- Comprendre l'architecture HDFS.
- Déployer un cluster Hadoop.
- Manipuler les fichiers distribués.
- Étudier la réplication des données.
- Observer le découpage des fichiers en blocs.
- Tester la tolérance aux pannes.

---

### Architecture du Cluster

| Composant      | Fonction                  |
|----------------|---------------------------|
| NameNode       | Gestion des métadonnées   |
| DataNode1      | Stockage des blocs        |
| DataNode2      | Stockage des blocs        |
| Docker Network | Communication inter-nœuds |

L'ensemble du cluster est déployé à l'aide des images Docker Big Data Europe.

---

### Démarrage du Cluster

Le cluster est lancé avec :

```bash
docker compose up -d
```

Vérification :

```bash
docker ps
```

Les trois conteneurs principaux sont opérationnels :

- `namenode`
- `datanode1`
- `datanode2`

---

### Interface Web du NameNode

L'interface d'administration HDFS est accessible via :

```
http://localhost:9870
```

Cette interface permet :

- la surveillance du cluster ;
- la consultation des DataNodes ;
- l'exploration de l'arborescence HDFS ;
- la visualisation des blocs ;
- le suivi de l'espace disque.

---

### Création de l'Arborescence HDFS

```bash
hdfs dfs -mkdir -p /user/elkheit/data/parquet
```

Vérification :

```bash
hdfs dfs -ls /user/elkheit
```

---

### Importation des Données

Un premier test a été réalisé avec le fichier `yellow_tripdata_2023-01.parquet`. Cependant, ce fichier étant inférieur à la taille d'un bloc HDFS, il ne permettait pas d'observer la distribution des blocs.

Un second fichier a donc été utilisé : `yellow_tripdata_2010-01.parquet` (taille : **plus de 500 Mo**).

```bash
hdfs dfs -put \
  /tmp/yellow_tripdata_2010-01.parquet \
  /user/elkheit/data/parquet/
```

---

### Analyse des Blocs HDFS

```bash
hdfs fsck \
  /user/elkheit/data/parquet/yellow_tripdata_2010-01.parquet \
  -files -blocks -locations
```

| Bloc   | Taille  |
|--------|---------|
| Bloc 1 | 128 Mo  |
| Bloc 2 | 128 Mo  |
| Bloc 3 | 128 Mo  |
| Bloc 4 | ≈116 Mo |

Le fichier est réparti sur quatre blocs, mettant en évidence le principe fondamental du stockage distribué dans Hadoop.

---

### Réplication

```bash
hdfs dfs -stat '%r'
```

Le cluster est configuré avec un **facteur de réplication égal à 2**. Chaque bloc est stocké sur plusieurs DataNodes afin d'assurer :

- la disponibilité des données ;
- la tolérance aux pannes ;
- la haute disponibilité.

---

### Tolérance aux Pannes

Simulation d'arrêt d'un DataNode :

```bash
docker stop datanode1
```

Malgré l'arrêt d'un DataNode, les données restent accessibles grâce à la réplication.

Redémarrage :

```bash
docker start datanode1
```

Le cluster retrouve son fonctionnement normal.

---

## TP2 : Maîtrise du Paradigme MapReduce

### Objectifs

- Comprendre le paradigme MapReduce.
- Étudier le Shuffle.
- Comprendre les Combiners.
- Réaliser des jointures distribuées.
- Manipuler les graphes sociaux.
- Exécuter des jobs Hadoop sur le cluster.

---

### Exercice 1 : Analyse de Logs

**Format :** `DATE | IP | URL | STATUS | SIZE`

**Objectif :** Extraire uniquement les erreurs HTTP 404.

**Mapper :**
```
404 -> 1
```

Le Reducer est facultatif (filtrage uniquement). Pour compter les requêtes par IP :

```
IP -> 1
```

---

### Exercice 2 : Inverted Index

**Objectif :** Construire un moteur de recherche simplifié.

**Entrée :**
```
docA : Hadoop Spark
docB : Hadoop Docker
```

**Sortie :**
```
Hadoop -> [docA, docB]
Spark  -> [docA]
Docker -> [docB]
```

Le Reducer élimine les doublons et construit l'index inversé.

---

### Exercice 3 : Friends in Common

**Entrée :**
```
A -> B, C, D
```

**Mapper :**
```
(B,C) -> A
(B,D) -> A
(C,D) -> A
```

**Reducer :**
```
(B,C) -> [A]
(B,D) -> [A]
(C,D) -> [A]
```

**Complexité :** O(n²)

Pour une célébrité possédant plusieurs millions d'amis, l'étape de Shuffle devient extrêmement coûteuse.

---

### Exercice 4 : Optimisation via le Combiner

**Calcul de la température moyenne.**

**Problème :** Une moyenne n'est pas directement combinable.

**Solution :** Le Combiner transmet `(ville, somme, nombre)`.

**Exemple :**
```
Nouakchott -> (88, 3)
```

Le Reducer calcule ensuite la moyenne finale. Cette approche réduit fortement le trafic réseau.

---

### Exercice 5 : Jointures Distribuées

#### Reduce-Side Join

Toutes les données transitent par le Shuffle.

- **Avantages :** Flexible, applicable à tout type de données.
- **Inconvénient :** Trafic réseau important.

#### Map-Side Join

Utilisation du **Distributed Cache** — la petite table Produits est chargée en mémoire par chaque Mapper.

- **Avantages :** Pas de Shuffle, exécution plus rapide, réduction du trafic réseau.

---

### Travail Pratique sur Cluster

Implémentation d'un job Hadoop Streaming pour compter les erreurs HTTP.

**Résultat :**
```
404 -> N
500 -> M
403 -> P
```

---

### Interface YARN

Accessible à `http://localhost:8088`, elle permet :

- le suivi des applications ;
- la surveillance des tâches Map et Reduce ;
- l'analyse des Counters Hadoop.

---

### Analyse des Counters

Les compteurs Hadoop mesurent :

- les données lues et écrites ;
- les enregistrements traités ;
- les octets transférés durant le Shuffle.

Ces indicateurs sont essentiels pour l'optimisation des performances.

---

## Automatisation des TP

### HDFS Manager

- Upload de fichiers
- Gestion des permissions et de la réplication
- Analyse des blocs
- Utilisation disque
- Safe Mode / gestion des DataNodes

### MapReduce Manager

- WordCount
- Analyse de logs / comptage d'erreurs HTTP
- Inverted Index
- Friends in Common
- Jointures distribuées
- Monitoring YARN / analyse des Counters

### BigDataManager

Gestionnaire global centralisant l'ensemble des fonctionnalités du cluster.

**Modules disponibles :** HDFS · MapReduce · YARN · Spark · Hive · Monitoring · Génération de rapports

---

## Conclusion Générale

Ces travaux pratiques ont permis de maîtriser les principaux composants de l'écosystème Hadoop.

Le **TP HDFS** a mis en évidence les mécanismes de stockage distribué, de réplication et de tolérance aux pannes.

Le **TP MapReduce** a permis de comprendre la décomposition d'un traitement en phases Map, Shuffle et Reduce, ainsi que les problématiques d'optimisation du calcul distribué.

L'ensemble des expérimentations a confirmé l'efficacité des architectures Big Data pour le traitement de volumes importants de données et a permis la mise en œuvre concrète des concepts étudiés dans le module **Big Data Technologies**.

