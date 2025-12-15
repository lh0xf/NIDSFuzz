
# <div align="center">NIDSFuzz </div>

**A fuzzing framework for rule-driven Network Intrusion Detection Systems (NIDS)**, providing automated environment for discovering rule enforcement inconsistencies in **Snort2**, **Snort3**, and **Suricata**.  



---

## Prerequisites

<ul>
  <li><span style="color: #007ACC; font-size: 1.2em;">●</span> <strong>Docker</strong> & Docker-Compose</li>
  <li><span style="color: #4CAF50; font-size: 1.2em;">●</span> <strong>Python</strong>: >= 3.11</li>
</ul>

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## Network Topology

```text
+----------------+        +------------------+        +-------------------+
| NIDS Initiator | <----> | Gateway & Mirror | <----> | Tunable Responder |
+----------------+        +------------------+        +-------------------+
                             /     |      \ 
                            +      +       +
                   +--------+  +--------+  +----------+  
                   | Snort3 |  | Snort2 |  | Suricata | 
                   +--------+  +--------+  +----------+
                           (Promiscuous Mode)
```

---

## Quick Start

### 1. Prepare Rules
Move your rules into the benchmark folder:

```bash
./benchmark/rules/
```

Update rule configuration in:

```text
docker-compose/variables.env
```

- `SNORT2_RULE_FILE=...`
- `SNORT3_RULE_FILE=...`

---

### 2. Start Fuzzing

Run fuzzing with:

```bash
bash ./benchmark/start.sh --fuzzing
```

> ⚠️ **Note:** The **biggest bottleneck** during setup may be your **network speed**.

---

### 3. Stop & Clean up

Stop fuzzing and gather results:

```bash
bash ./benchmark/clean.sh --fuzzing
```

This will:
- Save all generated logs (`alerts`, `packets`, `discrepancies`, etc.)
- Clean up all containers, networks, and volumes.

---

### 4. Replay Abnormal Cases

You can reproduce abnormal cases:

```bash
bash ./benchmark/start.sh --replay -packets fuzzing-results/initiator/log
bash ./benchmark/clean.sh --replay
```

---

## Output Structure

After running `clean.sh`, results are organized like this:

```text
fuzzing-results/
│
├── initiator/
│   └── log/
│       ├── fuzzing.log
│       ├── discrepancies.txt
│       └── packets.bin
│
├── responder/
│   └── log/
│       └── server.log
│ 
├── snort2/
│   └── log/
│       └── snort2.log
│
├── snort3/
│   └── log/
│       └── snort3.log
│
├── suricata/
│   └── log/
│       ├── eve.json
│       ├── fast.log
│       ├── stats.log
│       └── suricata.log
```


